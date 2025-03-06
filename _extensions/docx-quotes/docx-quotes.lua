--- Convert Right-Angle Quotes to Curly Quotes in DOCX

--- Copyright: © 2025–Present Tom Ben
--- License: MIT License

function Str(el)
    -- If not DOCX output, return element unchanged
    if FORMAT ~= 'docx' then
        return el
    end

    local replacements = {
        ['「'] = '“',
        ['」'] = '”',
        ['『'] = '‘',
        ['』'] = '’'
    }

    for original, replacement in pairs(replacements) do
        el.text = el.text:gsub(original, replacement)
    end

    return el
end
