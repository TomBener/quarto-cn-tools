"""
Citation Tools for Academic Writing

This script provides utilities for managing citations in academic writing:
1. Extract citation keys from Markdown files and create a filtered bibliography
2. Copy cited reference files to a specified directory for backup or sharing

Typical usage:
    python citation-tools.py --extract
    python citation-tools.py --copy

Copyright: © 2025–Present Tom Ben
License: MIT License
"""

import os
import re
import shutil
import argparse
from pathlib import Path


def extract_citation_keys(markdown_file):
    """Extract citation keys from a markdown file."""
    with open(markdown_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Pattern 1: [@key] or [@key1; @key2] format
    pattern1 = r'\[@([a-zA-Z0-9\-]+)(?:[\s\]\;\,]|$)'

    # Pattern 2: standalone @key format
    pattern2 = r'(?<![a-zA-Z0-9])@([a-zA-Z0-9\-]+)(?:[\s\.\,\;\:\)\]\}]|$)'

    keys1 = re.findall(pattern1, content)
    keys2 = re.findall(pattern2, content)

    # Combine keys and filter out figure and table references
    all_keys = set(keys1 + keys2)
    return {key for key in all_keys if not (
        key.startswith('fig-') or key.startswith('tbl-'))}


def parse_bibtex_file(bibtex_file):
    """Parse BibLaTeX file and extract citation keys with file paths."""
    with open(bibtex_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Dictionary to store citation key -> file path mappings
    citations = {}

    # Find all BibLaTeX entries
    entries = re.findall(
        r'@\w+\{([^,]+),\s*(?:[^@]+?file\s*=\s*\{([^}]+)\}[^@]*?)?(?=@|\Z)', content, re.DOTALL)

    for key, file_path in entries:
        key = key.strip()
        if file_path:
            # Extract the file path from the file field
            file_path = file_path.strip()
            paths = re.findall(r'(/[^:;]+\.[a-zA-Z0-9]+)', file_path)
            if paths:
                citations[key] = paths[0]

    return citations


def extract_full_bibtex_entries(bibtex_file, citation_keys, remove_fields=None):
    """Extract full BibLaTeX entries for the given citation keys."""
    if remove_fields is None:
        remove_fields = ['file']

    with open(bibtex_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Dictionary to store entries by citation key for sorting
    entry_dict = {}

    # This regex captures the entire BibLaTeX entry
    pattern = r'(@\w+\{([^,]+),[\s\S]*?)((?=@\w+\{)|$)'
    matches = re.finditer(pattern, content)

    for match in matches:
        entry = match.group(1)
        key = match.group(2).strip()

        if key in citation_keys:
            # Remove specified fields
            for field in remove_fields:
                # This regex removes the field and its value
                entry = re.sub(r'\s*' + field +
                               r'\s*=\s*\{[^}]*\},?', '', entry)

            # Clean up any trailing commas before the closing brace
            entry = re.sub(r',\s*\}$', '\n}', entry)

            # Ensure entry ends with exactly one newline
            entry = entry.rstrip('\n') + '\n'

            # Store in dictionary with key for sorting
            entry_dict[key] = entry

    # Sort entries by citation key and join with a single newline
    sorted_entries = [entry_dict[key] for key in sorted(entry_dict.keys())]
    return '\n'.join(sorted_entries)


def copy_cited_files(args):
    """Copy cited files from bibliography to a new folder."""
    # Clean output directory if requested
    if args.clean and os.path.exists(args.output_dir):
        print(f"Cleaning output directory: {args.output_dir}")
        shutil.rmtree(args.output_dir)

    # Create output directory if it doesn't exist
    os.makedirs(args.output_dir, exist_ok=True)

    # Parse bibliography (silently)
    citations = parse_bibtex_file(args.bib)

    # Find all Markdown files in content directory
    markdown_files = list(Path(args.content_dir).glob('[0-9]*.md'))

    # Extract all citation keys from Markdown files
    all_keys = set()
    for md_file in markdown_files:
        all_keys.update(extract_citation_keys(md_file))

    # Copy files to output directory
    copied_count = 0
    missing_count = 0
    file_not_found_count = 0
    missing_keys = []
    not_found_pairs = []

    for key in all_keys:
        if key in citations:
            source_path = citations[key]
            _, file_extension = os.path.splitext(source_path)
            dest_path = os.path.join(args.output_dir, f"{key}{file_extension}")

            try:
                if os.path.exists(source_path):
                    shutil.copy2(source_path, dest_path)
                    copied_count += 1
                else:
                    file_not_found_count += 1
                    not_found_pairs.append((key, source_path))
            except Exception as e:
                print(f"Error copying {key}: {e}")
        else:
            missing_count += 1
            missing_keys.append(key)

    # Print simplified summary
    print(f"Markdown files in content directory: {len(markdown_files)}")
    print(f"Total unique citation keys found: {len(all_keys)}")
    print(f"Files successfully copied: {copied_count}")
    print(f"Citation keys without file paths: {missing_count}")
    print(
        f"Files not found (path exists in bibliography but file missing): {file_not_found_count}")

    if missing_keys:
        print("\nCitation keys without file paths:")
        for key in sorted(missing_keys):
            print(f"  - {key}")

    if not_found_pairs:
        print("\nCitation keys where file wasn't found:")
        for key, path in sorted(not_found_pairs):
            print(f"  - {key}: {path}")

    return all_keys


def extract_citations(args):
    """Extract citations from Markdown files and save them to a BibLaTeX file."""
    # Find all Markdown files in content directory
    markdown_files = list(Path(args.content_dir).glob('[0-9]*.md'))

    # Extract all citation keys from Markdown files
    all_keys = set()
    for md_file in markdown_files:
        all_keys.update(extract_citation_keys(md_file))

    # Extract full BibLaTeX entries
    bibtex_content = extract_full_bibtex_entries(
        args.bib, all_keys, args.remove_fields)

    # Write to output file
    with open(args.output_bib, 'w', encoding='utf-8') as f:
        f.write(bibtex_content)

    # Print simplified summary
    print(f"Markdown files in content directory: {len(markdown_files)}")
    print(f"Total unique citation keys found: {len(all_keys)}")
    print(f"Extracted citations to `{args.output_bib}`")

    return all_keys


def main():
    """Parse command line arguments and execute the appropriate function."""
    # Get script location and project root
    script_dir = Path(__file__).parent.resolve()
    project_root = script_dir.parent if script_dir.name == "_extensions" else script_dir

    parser = argparse.ArgumentParser(
        description='Citation tools for extracting and copying cited references')

    # Common arguments
    default_bib = os.path.expanduser(
        "~/Library/CloudStorage/Dropbox/pkm/bibliography.bib")
    default_content_dir = str(project_root / "contents")

    # Add command flags instead of subcommands
    parser.add_argument('--extract', action='store_true',
                        help='Extract citations to a BibLaTeX file')
    parser.add_argument('--copy', action='store_true',
                        help='Copy cited files to a directory')

    # Common arguments for both commands
    parser.add_argument('--bib',
                        default=default_bib,
                        help=f'Path to bibliography.bib file (default: {default_bib})')
    parser.add_argument('--content_dir',
                        default=default_content_dir,
                        help=f'Path to content directory with Markdown files (default: {default_content_dir})')

    # Arguments specific to extract
    parser.add_argument('--output_bib',
                        default=str(project_root / "citebib.bib"),
                        help=f'Path to output BibLaTeX file (default: {project_root}/citebib.bib)')
    parser.add_argument('--remove_fields',
                        nargs='+',
                        default=['file'],
                        help='Fields to remove from BibLaTeX entries (default: file)')

    # Arguments specific to copy
    parser.add_argument('--output_dir',
                        default=os.path.expanduser(
                            "~/Downloads/cited-docs"),
                        help='Path to output directory for copied files (default: ~/Downloads/cited-docs)')
    parser.add_argument('--clean',
                        action='store_true',
                        help='Clean the output directory before copying files')

    args = parser.parse_args()

    if args.extract:
        extract_citations(args)
    elif args.copy:
        copy_cited_files(args)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
