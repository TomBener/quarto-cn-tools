--- Replaces Straight quotes with German quotes for intermediate in LaTeX output
--- Specific processing for headers to avoid issues in PDF bookmarks
--- Quarto cannot disable `smart` extension for LaTeX, so English quotes in headers are not correct at the moment
--- Tracking issue: https://github.com/quarto-dev/quarto-cli/issues/7966

--- Copyright: © 2024–2025 Tom Ben
--- License: MIT License

function Str(el)
    -- If not LaTeX output, return element unchanged
    if FORMAT ~= 'latex' then
        return el
    end

    local replacements = {
        ['「'] = '«',
        ['」'] = '»',
        ['『'] = '‹',
        ['』'] = '›'
    }

    for original, replacement in pairs(replacements) do
        el.text = el.text:gsub(original, replacement)
    end

    return el
end

function Header(header)
    if FORMAT ~= 'latex' then
        return header
    end

    local text = pandoc.utils.stringify(header.content)

    -- Only proceed if header contains specific quotation marks
    if text:find('«') or text:find('‹') then
        local replacements = {
            ['«(.-)»'] = '“%1”',
            ['‹(.-)›'] = '‘%1’'
        }

        for original, replacement in pairs(replacements) do
            text = text:gsub(original, replacement)
        end

        header.content = { pandoc.RawInline('latex', text .. '}{' .. text) }
    end

    return header
end
