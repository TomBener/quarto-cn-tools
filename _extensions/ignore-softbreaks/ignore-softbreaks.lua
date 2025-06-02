--- Emulate Pandoc's extension `east_asian_line_breaks` in Quarto
--- Ignore soft break adjacent to Chinese characters
--- Tracking Quarto issue: https://github.com/quarto-dev/quarto-cli/issues/8520

--- Copyright: © 2024–Present Tom Ben
--- License: MIT License

function is_chinese(text)
  return text:find("[\228-\233][\128-\191][\128-\191]")
end

function is_ascii(char)
  if char == nil then return false end
  local ascii_code = string.byte(char)
  return ascii_code >= 0 and ascii_code <= 127
end

function is_chinese_punctuation(char)
  if char == nil then return false end
  local punctuation_marks = "，。！？；：“”‘’（）【】《》〈〉「」『』、"
  return string.find(punctuation_marks, char, 1, true) ~= nil
end

function is_alphanumeric(char)
  if char == nil then return false end
  return char:match("[%w]") ~= nil
end

return {
  {
    Para = function(para)
      local cs = para.content
      for k, v in ipairs(cs) do
        if v.t == 'SoftBreak' and cs[k - 1] and cs[k + 1] then
          local p_text = cs[k - 1].text
          local n_text = cs[k + 1].text
          -- Ensure p_text and n_text are not nil and not empty strings
          if p_text and n_text and #p_text > 0 and #n_text > 0 then
            local prev_char -- Stores the last UTF-8 character of p_text
            for char_item in p_text:gmatch("([\0-\x7F\xC2-\xF4][\x80-\xBF]*)") do
              prev_char = char_item
            end

            local next_char -- Stores the first UTF-8 character of n_text
            for char_item in n_text:gmatch("([\0-\x7F\xC2-\xF4][\x80-\xBF]*)") do
              next_char = char_item
              break -- Found the first character
            end

            -- Ensure characters were actually extracted
            if prev_char and next_char then
              -- Rule 1: Remove soft break between Chinese characters
              if is_chinese(prev_char) and is_chinese(next_char) then
                para.content[k] = pandoc.Str("")
                -- Rule 2: Remove soft break after Chinese punctuation
              elseif is_chinese_punctuation(prev_char) then
                para.content[k] = pandoc.Str("")
                -- Rule 3: Remove soft break before Chinese punctuation
              elseif is_chinese_punctuation(next_char) then
                para.content[k] = pandoc.Str("")
                -- Rule 4: Keep soft break between Chinese chars and ASCII alphanumeric
                -- This preserves spacing between Chinese and English words
                -- No action needed - soft break remains
              end
            end
          end
        end
      end
      return para
    end
  }
}
