-- Process quotes for Chinese bibliographies in html and epub outputs

--- Copyright: © 2024 Tom Ben
--- License: MIT License

function is_chinese(text)
    return text:find("[\228-\233][\128-\191][\128-\191]")
end

function quotes_in_bib(block)
    local elements = block.c
    for i, el in ipairs(elements) do
        if el.t == "Str" and (el.text == "“" or el.text == "”") then
            local prev_text = i > 1 and elements[i - 1].t == "Str" and elements[i - 1].text or ""
            local next_text = i < #elements and elements[i + 1].t == "Str" and elements[i + 1].text or ""

            if is_chinese(prev_text) or is_chinese(next_text) then
                if FORMAT:match 'html' or FORMAT:match 'epub' then
                    local replaced_text = el.text
                    if el.text == "“" then
                        replaced_text = "「"
                    elseif el.text == "”" then
                        replaced_text = "」"
                    end
                    elements[i] = pandoc.Str(replaced_text)
                end
            end
        end
    end
    return block
end

function Pandoc(doc)
    for i, block in ipairs(doc.blocks) do
        if block.t == "Div" then
            doc.blocks[i] = pandoc.walk_block(block, { Span = quotes_in_bib })
        end
    end
    return doc
end
