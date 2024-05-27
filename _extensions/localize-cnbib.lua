-- Function to check if a string contains Chinese characters
function contains_chinese(text)
    return text and text:find("[\228-\233][\128-\191][\128-\191]") ~= nil
end

-- Function to extract digits from a string
function extract_digits(text)
    return text:match("%d+")
end

-- Function to process `et al.` in citations for author-date style
function process_citation(el)
    local new_inlines = {}
    local i = 1

    while i <= #el.content do
        local current = el.content[i]
        if current.t == "Str" and contains_chinese(current.text) and current.text:sub(-2) == "et" and
            i + 2 <= #el.content and el.content[i + 1].t == "Space" and el.content[i + 2].t == "Str" then
            local modified_text
            if el.content[i + 2].text == "al." then
                modified_text = current.text:sub(1, -3) .. "等"
            elseif el.content[i + 2].text == "al.," then
                modified_text = current.text:sub(1, -3) .. "等,"
            end
            if modified_text then
                table.insert(new_inlines, pandoc.Str(modified_text))
                i = i + 3 -- Skip the next Space and 'al.' or 'al.,'
            else
                table.insert(new_inlines, current)
                i = i + 1
            end
        else
            table.insert(new_inlines, current)
            i = i + 1
        end
    end

    el.content = new_inlines
    return el
end

-- Function to process localizations in bibliography entries
function process_bibliography(elem)
    local new_inlines = {}
    local i = 1

    -- Process `et al.`
    while i <= #elem.content do
        if i <= #elem.content - 2 and elem.content[i].t == "Str" and elem.content[i].text == "et" and
            elem.content[i + 1].t == "Space" and contains_chinese(elem.content[i - 2].text) then
            if elem.content[i + 2].t == "Str" and elem.content[i + 2].text == "al.," then
                table.insert(new_inlines, pandoc.Str("等,")) -- author-date style
                i = i + 3
            elseif elem.content[i + 2].t == "Str" and elem.content[i + 2].text == "al." then
                table.insert(new_inlines, pandoc.Str("等.")) -- numeric style
                i = i + 3
            else
                table.insert(new_inlines, elem.content[i])
                i = i + 1
            end
        else
            table.insert(new_inlines, elem.content[i])
            i = i + 1
        end
    end

    elem.content = new_inlines

    -- Process other localizations
    for i = 1, #elem.content do
        local v = elem.content[i]
        local prev_str = elem.content[i - 2]
        local next_str = elem.content[i + 2]

        if v and v.t == "Str" then
            local text = v.text:lower()

            if text == "vol." and i < #elem.content - 2 then
                if prev_str and prev_str.t == "Str" and contains_chinese(prev_str.text) then
                    if next_str and next_str.t == "Str" then
                        local vol_num, identifier = next_str.text:match("([^%[]+)%[(.+)%]")
                        if vol_num and identifier then
                            elem.content[i] = pandoc.Str("第" .. vol_num .. "卷[" .. identifier .. "].")
                            table.remove(elem.content, i + 2)
                            table.remove(elem.content, i + 1)
                        end
                    end
                end
            elseif (text == "tran." or text == "trans.") and i > 2 then
                if prev_str and prev_str.t == "Str" and contains_chinese(prev_str.text) and prev_str.text:match(",$") then
                    elem.content[i] = pandoc.Str("译.")
                end
            elseif (text == "ed." or text == "eds.") and i > 2 and prev_str and prev_str.t == "Str" then
                if contains_chinese(prev_str.text) and prev_str.text:match(",$") then
                    -- prev_str.text = prev_str.text:gsub(",$", "") -- Remove the last comma
                    elem.content[i] = pandoc.Str("编.")
                else
                    local ed_text = elem.content[i - 2] and elem.content[i - 2].text
                    local ed_num = extract_digits(ed_text)
                    local prev_prev_str = elem.content[i - 4]
                    if ed_num and prev_prev_str and prev_prev_str.t == "Str" and contains_chinese(prev_prev_str.text) then
                        elem.content[i - 2] = pandoc.Str("第" .. ed_num .. "版.")
                        table.remove(elem.content, i)
                        table.remove(elem.content, i - 1)
                    end
                end
            end
        end
    end
    return elem
end

function process_div(el)
    if el.classes:includes("csl-entry") then
        for _, block in ipairs(el.content) do
            if block.t == "Para" then
                process_bibliography(block)
            end
        end
    end
    return el
end

return {
    {
        Cite = process_citation,
        Link = process_citation,
        Div = process_div,
        Span = process_bibliography
    }
}
