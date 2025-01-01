--- Emulate Pandoc's extension `east_asian_line_breaks` in Quarto
--- Ignore soft break adjacent to Chinese characters
--- Created by ChatGPT based on https://taoshu.in/unix/markdown-soft-break.html
--- Tracking Quarto issue: https://github.com/quarto-dev/quarto-cli/issues/8520

--- Copyright: © 2024–2025 Tom Ben
--- License: MIT License

function is_ascii(char)
  if char == nil then return false end
  local ascii_code = string.byte(char)
  -- Check whether a character is an ASCII character
  return ascii_code >= 0 and ascii_code <= 127
end

return {
  {
    Para = function(para)
      local cs = para.content
      for k, v in ipairs(cs) do
        if v.t == 'SoftBreak' and cs[k - 1] and cs[k + 1] then
          local p = cs[k - 1].text
          local n = cs[k + 1].text
          -- Remove SoftBreak if at least one adjacent character is non-ASCII
          if p and n and (not is_ascii(p:sub(-1)) or not is_ascii(n:sub(1, 1))) then
            para.content[k] = pandoc.Str("")
          end
        end
      end
      return para
    end
  }
}
