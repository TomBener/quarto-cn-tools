function Div(el)
    if el.classes:includes("right") then
        if FORMAT == "docx" then
            return pandoc.RawBlock("openxml",
                '<w:p><w:pPr><w:jc w:val="right"/></w:pPr><w:r><w:t>' ..
                pandoc.utils.stringify(el.content) ..
                '</w:t></w:r></w:p>')
        elseif FORMAT == "latex" then
            return pandoc.RawBlock("latex",
                "\\begin{flushright}\n" ..
                pandoc.utils.stringify(el.content) ..
                "\n\\end{flushright}")
        elseif FORMAT == "html" or FORMAT == "epub" then
            return pandoc.Div(el.content, { style = "text-align: right;" })
        else
            return el
        end
    end
end
