# 中文引号的处理

中文排版之难，引号为首。
引号的处理，是中文排版非常tricky 的问题，
「万恶之源」在于是简体中文和西文的引号相同，
但却要求呈现出不同的效果。
具体来说，简体中文使用的引号 `“`、`”`、`‘`、`’` 和
英语使用的蝌蚪引号是完全一样的，
但由于中文字符较宽，所以在排版时需要让包裹中文的引号看上去更宽一些，
而包裹英文的引号看上去更窄一些，特别是在 Word 中。

正是由于这个原因，不少网友会使用繁体中文的
直角引号 `「`、`」`、`『`、`』` 来替代简体中文的引号，
然而中华人民共和国的国家标准规定了使用简体中文的引号，
在正式的学术论文这种做法是不被推荐的。

为了解决这个问题，本项目提供了一套完整的引号处理方案，
具体来说，在 Markdown 中使用直角引号 `「`、`」`、`『`、`』`，
借助以下这几个 Lua filters，可以实现引号的自动转换：

- `docx-quotes.lua`：处理 Word 正文中的引号，使包裹中文的引号看上去更宽。
- `cnbib-quotes.lua`：处理 Word 和 HTML 参考文献中的引号，使 Word 包裹中文的引号看上去更宽，HTML 将蝌蚪引号转换为直角引号。
- `latex-quotes.lua`：处理 LaTeX 中的引号，将中文直角引号转换为德语引号（其他东欧语系也有类似的引号），然后通过 [newunicodechar][1] 宏包将其转换为蝌蚪引号，并对标题中的中文引号进行特别处理。

[1]: https://ctan.org/pkg/newunicodechar

这样，无论是在 Word 中还是在 LaTeX 中，都可以得到符合规范的引号效果，
而对于 HTML 来说，则做「反向处理」，将包裹中文的蝌蚪引号转换为直角引号。