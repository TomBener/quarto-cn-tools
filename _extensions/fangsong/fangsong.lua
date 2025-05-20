function Span(span)
  if span.classes:includes("fangsong") then
    local text = pandoc.utils.stringify(span.content)
    local openxml = string.format(
      '<w:r><w:rPr><w:rFonts w:ascii="FZFangSong-Z02" w:eastAsia="FZFangSong-Z02" w:hAnsi="FZFangSong-Z02" w:hint="eastAsia"/></w:rPr><w:t>%s</w:t></w:r>',
      text
    )
    return pandoc.RawInline("openxml", openxml)
  end
end
