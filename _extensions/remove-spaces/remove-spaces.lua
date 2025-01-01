--- Remove spaces before or after Chinese characters

--- Copyright: © 2024–2025 Tom Ben
--- License: MIT License

-- Check if the character is non-ASCII (potentially a Chinese character).
local function is_non_ascii(char)
  return char and string.byte(char) > 127
end

-- Process the paragraph to remove spaces adjacent to non-ASCII characters.
local function process_paragraph(para)
  local cs = para.content
  local new_content = {}

  for i, elem in ipairs(cs) do
    local is_space = elem.t == 'Space'
    local next_char = cs[i + 1] and cs[i + 1].t == 'Str' and cs[i + 1].text:sub(1, 1)
    local prev_char = cs[i - 1] and cs[i - 1].t == 'Str' and cs[i - 1].text:sub(-1)

    if not (is_space and ((next_char and is_non_ascii(next_char)) or (prev_char and is_non_ascii(prev_char)))) then
      table.insert(new_content, elem)
    end
  end

  para.content = new_content
  return para
end

-- Return the filter for Pandoc
return {
  {
    Para = process_paragraph
  }
}
