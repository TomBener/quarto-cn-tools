function Div(div)
    if div.classes:includes("right") and FORMAT == "docx" then
        div.attributes['custom-style'] = 'right'
        return div
    end
end

function Span(span)
    if span.classes:includes("right") and FORMAT == "docx" then
        return pandoc.Div({ span }, { class = "right" })
    end
end
