--- Remove local links but keep the link text as normal citations
--- Reference: https://stackoverflow.com/a/75559075/19418090

--- Copyright: © 2023 Albert Krewinkel, 2024–Present Albert Krewinkel, Tom Ben
--- License: MIT License

function Link(link)
  if not link.target:match '^https?://' then
    local linkstring = pandoc.utils.stringify(link.content)
    local citationmd = string.format('[%s]', linkstring)
    return pandoc.utils.blocks_to_inlines(
      pandoc.read(citationmd, 'markdown').blocks
    )
  end
end
