function Span(span)
  if span.classes:includes("fangsong") then
    local text = pandoc.utils.stringify(span.content)
    local openxml = string.format(
      '<w:r><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:eastAsia="方正仿宋_GBK" w:cs="Times New Roman" w:hint="eastAsia"/></w:rPr><w:t>%s</w:t></w:r>',
      text
    )
    return pandoc.RawInline("openxml", openxml)
  end
end
