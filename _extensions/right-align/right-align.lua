function Div(el)
    if el.classes:includes("right") then
        if FORMAT == "docx" then
            -- For DOCX, use custom-style attribute on the div itself
            el.attributes['custom-style'] = 'Right Align'
            return el
        elseif FORMAT == "latex" then
            -- Use flushright environment for LaTeX format, but keep the content structure
            local content = {}
            table.insert(content, pandoc.RawBlock("latex", "\\begin{flushright}"))
            for i, block in ipairs(el.content) do
                table.insert(content, block)
            end
            table.insert(content, pandoc.RawBlock("latex", "\\end{flushright}"))
            return content
        elseif FORMAT == "html" or FORMAT == "epub" then
            return pandoc.Div(el.content, { style = "text-align: right;" })
        else
            return el
        end
    end
end
