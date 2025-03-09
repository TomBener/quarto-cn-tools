--- Remove spaces around Chinese characters except citations

--- Copyright: © 2024–Present Tom Ben
--- License: MIT License

-- Check if the character is non-ASCII (potentially a Chinese character).
local function is_non_ascii(char)
  return char and string.byte(char) > 127
end

-- Process the paragraph to remove spaces adjacent to non-ASCII characters
local function process_paragraph(para)
  local cs = para.content
  local new_content = {}

  for i, elem in ipairs(cs) do
    -- If the element is not a Space, always keep it
    if elem.t ~= 'Space' then
      table.insert(new_content, elem)
    else
      -- Element is a Space, determine whether to keep it
      local next_elem = cs[i + 1]
      local prev_elem = cs[i - 1]

      -- Check adjacent characters for Chinese text
      local next_char = next_elem and next_elem.t == 'Str' and next_elem.text:sub(1, 1)
      local prev_char = prev_elem and prev_elem.t == 'Str' and prev_elem.text:sub(-1)

      -- Check if adjacent elements are citations or citation-related elements
      local next_is_cite = next_elem and (next_elem.t == 'Cite' or next_elem.t == 'Note')
      local prev_is_cite = prev_elem and (prev_elem.t == 'Cite' or prev_elem.t == 'Note')

      -- Determine if we need to remove this space
      local has_adjacent_chinese = (next_char and is_non_ascii(next_char)) or (prev_char and is_non_ascii(prev_char))
      local is_adjacent_to_cite = (prev_is_cite and next_char and is_non_ascii(next_char)) or
          (next_is_cite and prev_char and is_non_ascii(prev_char))

      -- Keep space if:
      -- 1. It's not adjacent to Chinese characters, OR
      -- 2. It's between a citation and Chinese characters
      if not has_adjacent_chinese or is_adjacent_to_cite then
        table.insert(new_content, elem)
      end
      -- Otherwise, remove the space (by not adding it to new_content)
    end
  end

  para.content = new_content
  return para
end

-- Return the filter for Pandoc
return {
  { Para = process_paragraph }
}
