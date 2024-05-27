function Str(el)
    local replacements = {
        ['「'] = '«',
        ['」'] = '»',
        ['『'] = '‹',
        ['』'] = '›'
    }

    if FORMAT:match 'latex' then
        for original, replacement in pairs(replacements) do
            el.text = el.text:gsub(original, replacement)
        end
    end

    return el
end
