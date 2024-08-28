# Write Chinese Academic Papers with Quarto

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

## License

This project is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.
