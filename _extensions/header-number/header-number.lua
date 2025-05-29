-- 中文标题编号（支持 1-99）
function chinese_number(n)
    local digits = { "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" }

    if n <= 10 then
        return digits[n]
    elseif n < 20 then
        return digits[10] .. digits[n % 10]
    else
        local ten_digit = math.floor(n / 10)
        local unit_digit = n % 10
        if unit_digit == 0 then
            return digits[ten_digit] .. digits[10]
        else
            return digits[ten_digit] .. digits[10] .. digits[unit_digit]
        end
    end
end

local counts = { 0, 0, 0, 0 }

function Header(el)
    -- 只在输出格式为 docx 时处理
    if FORMAT ~= "docx" then
        return nil
    end

    local level = el.level
    if level > 4 then return nil end -- 超过4级的不处理

    -- 检查是否有 unnumbered 类，如果有则跳过编号
    if el.classes and el.classes:includes("unnumbered") then
        return nil
    end

    -- 层级进位重置
    for i = level + 1, 4 do
        counts[i] = 0
    end
    counts[level] = counts[level] + 1

    -- 构造编号
    local prefix = ""
    if level == 1 then
        prefix = chinese_number(counts[1]) .. "、"
    elseif level == 2 then
        prefix = "（" .. chinese_number(counts[2]) .. "）"
    elseif level == 3 then
        prefix = tostring(counts[3]) .. ". "
    elseif level == 4 then
        prefix = "（" .. tostring(counts[4]) .. "）"
    end

    el.content:insert(1, pandoc.Str(prefix))
    return el
end
