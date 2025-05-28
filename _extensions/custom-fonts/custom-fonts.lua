function Span(span)
  if span.classes:includes("fangsong") or span.classes:includes("kaiti") then
    if FORMAT == "docx" then
      local text = pandoc.utils.stringify(span.content)
      local fontName = span.classes:includes("fangsong") and "FZFangSong-Z02" or "FZKai-Z03"
      local openxml = string.format(
        '<w:r><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:eastAsia="%s" w:cs="Times New Roman" w:hint="eastAsia"/></w:rPr><w:t>%s</w:t></w:r>',
        fontName, text
      )
      return pandoc.RawInline("openxml", openxml)
    else
      -- For other formats, preserve the original span
      return span
    end
  end
end
