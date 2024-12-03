# Writing Chinese Academic Papers with Quarto

[![Publish](https://github.com/TomBener/quarto-cn-tools/actions/workflows/quarto-publish.yml/badge.svg)](https://github.com/TomBener/quarto-cn-tools/actions/workflows/quarto-publish.yml)

This repository provides a comprehensive guide and toolset for writing academic
papers in Chinese, such as the localization and sorting of Chinese
bibliographies, conversion of Chinese quotes, and correcting spaces between
Chinese and English characters. With the help of these templates and scripts,
you can write your academic papers in Markdown, and convert them into various
formats like Word, HTML, LaTeX, PDF, and ePub via Quarto with ease.

## Features

- **Render Multiple Formats**: Render DOCX, HTML, PDF, ePub, and Reveal.js slides at once with the same source file, and PDF can be customized for print or with watermark.
- **Localize Chinese Bibliographies**: Change `et al.` to `等` and other English localization strings to Chinese in citations and references, both author-date and numeric styles are supported.
- **Sort Chinese Bibliographies**: Sort Chinese bibliographies by Pinyin, and can be customized to sort Chinese entries first or last.
- **Correct Chinese Quotes**: Tweak Chinese quotes for sophisticated typesetting.
- **Correct Spaces**: Improve copywriting, correct spaces, words, and punctuations between CJK (Chinese, Japanese, Korean).
- **Extract Bibliographies**: Extract all bibliographies cited in the document as a BibLaTeX file.
- **Generate Backlinks**: Generate backlinks for bibliography entries to the corresponding citations.
- **Remove DOI Hyperlinks**: Remove DOI hyperlinks if they are not needed in the bibliography.

## Prerequisites

- [Quarto](https://quarto.org), with [Pandoc](https://pandoc.org) included, and
  you can install TinyTeX via `quarto install tinytex --update-path`.
- Python, and the following packages:
  - [autocorrect_py](https://github.com/huacnlee/autocorrect/tree/main/autocorrect-py)
  - [pypinyin](https://github.com/mozillazg/python-pinyin)
  - [panflute](https://github.com/sergiocorreia/panflute)
- R, and the following packages:
  - [rmarkdown](https://github.com/rstudio/rmarkdown)
  - [knitr](https://github.com/yihui/knitr)
  - [ggplot2](https://github.com/tidyverse/ggplot2)

## Usage

> [!NOTE]
> Currently [Lua filters](https://github.com/quarto-dev/quarto-cli/issues/7888) cannot be run after `--citeproc` in Quarto.
> As a workaround, some extensions are run on the command line in the Makefile. This can be improved [in the future](https://github.com/quarto-dev/quarto-cli/milestone/15).

This project uses a Makefile to manage the build process. Here are the available commands:

- `make` or `make all`: Render DOCX, HTML, PDF, ePub and Reveal.js slides at once.
- `make docx`: Render DOCX.
- `make html`: Render HTML.
- `make pdf`: Render PDF.
- `make epub`: Render ePub.
- `make slides`: Render Reveal.js slides.
- `make print`: Render PDF for print.
- `make watermark`: Render PDF with watermark.
- `make citebib`: Extract all bibliographies cited as BibLaTeX file `citebib.bib`.
- `make clean`: Remove auxiliary and output files.

## Tools

> [!TIP]
> These tools can also be used individually in your Pandoc or Quarto project.

- [auto-correct](_extensions/auto-correct.py): Improve copywriting, correct spaces, words, and punctuations between CJK and English with AutoCorrect.
- [citation-backlinks](_extensions/citation-backlinks.lua): Generate backlinks for bibliography entries to the corresponding citations.
- [confetti](_extensions/confetti/): Send some 🎊 in Reveal.js slides.
- [format-md](_extensions/format-md.py): Preprocess Markdown files for conversion with Quarto.
- [get-bib](_extensions/get-bib.lua): Extract all bibliographies cited in the document as a BibLaTeX file.
- [ignore-softbreaks](_extensions/ignore-softbreaks/): Emulate Pandoc’s extension `east_asian_line_breaks` [in Quarto](https://github.com/quarto-dev/quarto-cli/issues/8520).
- [latex-quotes](_extensions/latex-quotes/): Replaces Straight quotes with German quotes for intermediate in LaTeX output, and specific processing for headers to avoid issues in PDF bookmarks.
- [links-to-citations](_extensions/links-to-citations/): Remove local links but keep the link text as normal citations.
- [localize-cnbib](_extensions/localize-cnbib.lua): Localize Chinese bibliographies, change `et al.` to `等` and other English localization strings to Chinese.
- [remove-doi-hyperlinks](_extensions/remove-doi-hyperlinks.lua): Remove [DOI hyperlinks](https://github.com/jgm/pandoc/issues/10393) in the bibliography. Disabled by default. To enable it, add `-L _extensions/remove-doi-hyperlinks.lua` to the `FILTERS` variable in the Makefile, and remove `<text variable="DOI" prefix="DOI: "/>` in the CSL file.
- [remove-spaces](_extensions/remove-spaces/): Remove spaces before or after Chinese characters in DOCX.
- [sort-cnbib](_extensions/sort-cnbib.py): Sort Chinese bibliographies by Pinyin, and can be customized to sort Chinese entries first or last.

## License

This project is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.
