# Write Chinese Academic Papers with Quarto

[![Publish](https://github.com/TomBener/quarto-cn-tools/actions/workflows/quarto-publish.yml/badge.svg)](https://github.com/TomBener/quarto-cn-tools/actions/workflows/quarto-publish.yml)

This repository provides a comprehensive guide and toolset for writing academic
papers in Chinese, such as the localization and sorting of Chinese
bibliographies, conversion of quotes, and adding space between Chinese and
English Characters. With the help of these templates and scripts, you can write
your academic papers in Markdown, and convert them into various formats like
Word, HTML, LaTeX, PDF, and EPUB via Quarto.

## Prerequisites

- [Quarto](https://quarto.org), with [Pandoc](https://pandoc.org) included, and you can install TinyTeX via `quarto install tinytex --update-path`.
- Python, and the following packages:
  - [autocorrect_py](https://github.com/huacnlee/autocorrect/tree/main/autocorrect-py)
  - [pypinyin](https://github.com/mozillazg/python-pinyin)
  - [panflute](https://github.com/sergiocorreia/panflute)
- R, and the following packages:
  - [rmarkdown](https://github.com/rstudio/rmarkdown)
  - [knitr](https://github.com/yihui/knitr)
  - [ggplot2](https://github.com/tidyverse/ggplot2)

## Usage

This project uses a Makefile to manage the build process. Here are the available commands:

- `make citebib`: Extract all bibliographies cited as BibLaTeX file `citebib.bib`.
- `make docx`: Render DOCX.
- `make html`: Render HTML.
- `make pdf`: Render PDF.
- `make slides`: Render Reveal.js slides.
- `make` or `make all`: Render DOCX, HTML, PDF and Reveal.js slides at once.
- `make print`: Render PDF for print.
- `make watermark`: Render PDF with watermark.
- `make clean`: Remove auxiliary and output files.

## License

This project is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.
