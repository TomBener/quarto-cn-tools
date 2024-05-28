--- Replaces Straight quotes with German quotes for intermediate in LaTeX output

--- Copyright: © 2024 Tom Ben
--- License: MIT License

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
