--- 1. Convert straight Chinese quotes to Pandoc's Quoted elements (DoubleQuote and SingleQuote)
--- 2. Change Quoted elements to the Chinese style by adding XML tags in the docx output

--- Copyright: © 2024 Tom Ben
--- License: MIT License

-- Check if the text contains Chinese characters
function is_chinese(text)
    return text:find("[\228-\233][\128-\191][\128-\191]")
end

-- Parse quotes in the text, handling nested quotes
function parse_quotes(text)
    local elements = {}
    local pos = 1

    while pos <= #text do
        local double_start, double_end, double_quoted = text:find("「(.-)」", pos)
        local single_start, single_end, single_quoted = text:find("『(.-)』", pos)

        if double_start and (not single_start or double_start < single_start) then
            if double_start > pos then
                table.insert(elements, pandoc.Str(text:sub(pos, double_start - 1)))
            end
            table.insert(elements, pandoc.Quoted(pandoc.DoubleQuote, parse_quotes(double_quoted)))
            pos = double_end + 1
        elseif single_start then
            if single_start > pos then
                table.insert(elements, pandoc.Str(text:sub(pos, single_start - 1)))
            end
            table.insert(elements, pandoc.Quoted(pandoc.SingleQuote, parse_quotes(single_quoted)))
            pos = single_end + 1
        else
            table.insert(elements, pandoc.Str(text:sub(pos)))
            break
        end
    end

    return elements
end

-- Apply custom XML tags to quotes, including nested quotes
function apply_custom_tags(element)
    if element.t == "Quoted" then
        local has_chinese = false
        for _, inner_element in ipairs(element.content) do
            if inner_element.t == "Str" and is_chinese(inner_element.text) then
                has_chinese = true
                break
            end
        end

        if has_chinese then
            local quote_type = element.quotetype == pandoc.DoubleQuote and "“" or "‘"
            local closing_quote = element.quotetype == pandoc.DoubleQuote and "”" or "’"
            local result = pandoc.List({
                pandoc.RawInline("openxml",
                    string.format(
                        '<w:r><w:rPr><w:rFonts w:hint="eastAsia"/><w:lang w:eastAsia="zh-CN"/></w:rPr><w:t>%s</w:t></w:r>',
                        quote_type))
            })
            for _, inner_element in ipairs(element.content) do
                local nested_elements = apply_custom_tags(inner_element)
                for _, nested_element in ipairs(nested_elements) do
                    result:insert(nested_element)
                end
            end
            result:insert(pandoc.RawInline("openxml",
                string.format(
                    '<w:r><w:rPr><w:rFonts w:hint="eastAsia"/><w:lang w:eastAsia="zh-CN"/></w:rPr><w:t>%s</w:t></w:r>',
                    closing_quote)))
            return result
        end
    end
    return pandoc.List({ element })
end

-- Process each paragraph to convert quotes and apply custom XML tags
function Para(para)
    local new_elements = pandoc.List({})
    for _, element in ipairs(para.content) do
        if element.t == 'Str' then
            local parsed_elements = parse_quotes(element.text)
            for _, parsed_element in ipairs(parsed_elements) do
                new_elements:insert(parsed_element)
            end
        else
            new_elements:insert(element)
        end
    end

    local result = pandoc.List({})
    for _, element in ipairs(new_elements) do
        local processed_elements = apply_custom_tags(element)
        for _, processed_element in ipairs(processed_elements) do
            result:insert(processed_element)
        end
    end

    return pandoc.Para(result)
end
