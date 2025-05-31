# 段落右对齐

一般而言，段落是左对齐的，但有时我们希望某些段落右对齐。本项目提供了一个
Lua filter `right-align.lua`，可以实现段落右对齐，例如：

```markdown
::: {.right}
这段文字会右对齐

支持 DOCX、HTML、PDF 和 EPUB 格式。

::: {.content-visible when-format="html"}
{{</* meta date-modified */>}}
:::

::: {.content-visible unless-format="html"}
{{</* meta date */>}}
:::
:::
```

生成的效果如下：

::: {.right}
这段文字会右对齐

支持 DOCX、HTML、PDF 和 EPUB 格式。

::: {.content-visible when-format="html"}
{{< meta date-modified >}}
:::

::: {.content-visible unless-format="html"}
{{< meta date >}}
:::
:::
