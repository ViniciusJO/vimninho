--- Generic color utilities.
---
--- Pure Lua, no Neovim API usage: safe to require from anywhere.
---
--- Accepted color inputs:
---   "#RGB", "#RGBA", "#RRGGBB", "#RRGGBBAA"   hex strings (case-insensitive)
---   0xRRGGBB                                  integers, e.g. from nvim_get_hl()
---   { r = 0-255, g = 0-255, b = 0-255, a = 0-255? }  rgb tables
---
--- Alpha is carried along by parse()/to_rgb() but ignored by every RGB-only
--- operation (luminance, contrast, blend, lighten, darken).
local M = {}

---@class dynamic_colors.Rgb
---@field r integer
---@field g integer
---@field b integer
---@field a integer|nil alpha 0-255, only present when the input had it

---@alias dynamic_colors.ColorInput string|integer|dynamic_colors.Rgb

local function is_byte(value)
    return type(value) == "number" and value >= 0 and value <= 255 and value == math.floor(value)
end

local function clamp_byte(value)
    return math.max(0, math.min(255, math.floor(value + 0.5)))
end

local function check_amount(amount, fn_name)
    if type(amount) ~= "number" or amount < 0 or amount > 1 then
        error(string.format("color.%s: amount must be a number in [0, 1], got %s", fn_name, tostring(amount)), 3)
    end
end

local function parse_hex(value)
    local digits = value:match("^#(%x+)$")
    if not digits then
        return nil, string.format("invalid hex color %q (expected #RGB, #RGBA, #RRGGBB or #RRGGBBAA)", value)
    end

    local len = #digits
    if len == 3 or len == 4 then
        -- Short form: each digit is doubled ("#f80" -> "#ff8800").
        local function short(i)
            return tonumber(digits:sub(i, i), 16) * 17
        end

        return {
            r = short(1),
            g = short(2),
            b = short(3),
            a = len == 4 and short(4) or nil,
        }
    end

    if len == 6 or len == 8 then
        local function long(i)
            return tonumber(digits:sub(i, i + 1), 16)
        end

        return {
            r = long(1),
            g = long(3),
            b = long(5),
            a = len == 8 and long(7) or nil,
        }
    end

    return nil, string.format("invalid hex color %q: expected 3, 4, 6 or 8 hex digits, got %d", value, len)
end

local function parse_integer(value)
    if value ~= math.floor(value) or value < 0 or value > 0xFFFFFF then
        return nil, string.format("invalid integer color %s: expected an integer in [0, 0xFFFFFF]", tostring(value))
    end

    return {
        r = math.floor(value / 0x10000) % 0x100,
        g = math.floor(value / 0x100) % 0x100,
        b = value % 0x100,
    }
end

local function parse_table(value)
    if not (is_byte(value.r) and is_byte(value.g) and is_byte(value.b)) then
        return nil, "invalid rgb table: r, g and b must be integers in [0, 255]"
    end
    if value.a ~= nil and not is_byte(value.a) then
        return nil, "invalid rgb table: a must be an integer in [0, 255]"
    end

    return { r = value.r, g = value.g, b = value.b, a = value.a }
end

--- Parse a color into its components without raising.
---@param value any
---@return dynamic_colors.Rgb|nil rgb
---@return string|nil err
function M.try_parse(value)
    local kind = type(value)
    if kind == "string" then
        return parse_hex(value)
    end
    if kind == "number" then
        return parse_integer(value)
    end
    if kind == "table" then
        return parse_table(value)
    end

    return nil, string.format("unsupported color value %s (%s)", tostring(value), kind)
end

--- Parse a color into its components. Raises on invalid input.
---@param value dynamic_colors.ColorInput
---@return dynamic_colors.Rgb
function M.parse(value)
    local rgb, err = M.try_parse(value)
    if not rgb then
        error("color.parse: " .. err, 2)
    end

    return rgb
end

--- Check whether a value is a color this library understands.
---@param value any
---@return boolean
function M.is_valid(value)
    return M.try_parse(value) ~= nil
end

--- Return a fresh { r, g, b, a? } table (alpha only if the input had it).
---@param value dynamic_colors.ColorInput
---@return dynamic_colors.Rgb
function M.to_rgb(value)
    return M.parse(value)
end

--- Return "#rrggbb". Alpha is dropped; use with_alpha() to keep it.
---@param value dynamic_colors.ColorInput
---@return string
function M.to_hex(value)
    local rgb = M.parse(value)
    return string.format("#%02x%02x%02x", rgb.r, rgb.g, rgb.b)
end

--- Return the 0xRRGGBB integer form (the representation nvim_get_hl() uses).
---@param value dynamic_colors.ColorInput
---@return integer
function M.to_integer(value)
    local rgb = M.parse(value)
    return rgb.r * 0x10000 + rgb.g * 0x100 + rgb.b
end

--- Return "#rrggbbaa" with the given alpha in [0, 1].
---@param value dynamic_colors.ColorInput
---@param alpha number
---@return string
function M.with_alpha(value, alpha)
    check_amount(alpha, "with_alpha")

    local rgb = M.parse(value)
    return string.format("#%02x%02x%02x%02x", rgb.r, rgb.g, rgb.b, clamp_byte(alpha * 255))
end

local function linear_channel(byte)
    local c = byte / 255
    if c <= 0.04045 then
        return c / 12.92
    end

    return ((c + 0.055) / 1.055) ^ 2.4
end

--- WCAG relative luminance in [0, 1]. Alpha is ignored.
---@param value dynamic_colors.ColorInput
---@return number
function M.luminance(value)
    local rgb = M.parse(value)
    return 0.2126 * linear_channel(rgb.r) + 0.7152 * linear_channel(rgb.g) + 0.0722 * linear_channel(rgb.b)
end

--- WCAG contrast ratio between two colors, in [1, 21].
---@param a dynamic_colors.ColorInput
---@param b dynamic_colors.ColorInput
---@return number
function M.contrast_ratio(a, b)
    local la = M.luminance(a)
    local lb = M.luminance(b)

    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05)
end

--- Colorfulness in [0, 1]: 0 for greys (including black and white), 1 for pure hues.
---@param value dynamic_colors.ColorInput
---@return number
function M.chroma(value)
    local rgb = M.parse(value)
    return (math.max(rgb.r, rgb.g, rgb.b) - math.min(rgb.r, rgb.g, rgb.b)) / 255
end

--- Pick "#000000" or "#ffffff", whichever has higher WCAG contrast against `value`.
---@param value dynamic_colors.ColorInput
---@return string
function M.contrast_color(value)
    local lum = M.luminance(value)
    local against_black = (lum + 0.05) / 0.05
    local against_white = 1.05 / (lum + 0.05)

    return against_black >= against_white and "#000000" or "#ffffff"
end

--- True when black text reads better than white on this color.
---@param value dynamic_colors.ColorInput
---@return boolean
function M.is_light(value)
    return M.contrast_color(value) == "#000000"
end

--- Linear RGB mix: amount 0 returns `a`, 1 returns `b`. Result is "#rrggbb".
---@param a dynamic_colors.ColorInput
---@param b dynamic_colors.ColorInput
---@param amount number
---@return string
function M.blend(a, b, amount)
    check_amount(amount, "blend")

    local from = M.parse(a)
    local to = M.parse(b)

    local function mix(x, y)
        return clamp_byte(x + (y - x) * amount)
    end

    return string.format("#%02x%02x%02x", mix(from.r, to.r), mix(from.g, to.g), mix(from.b, to.b))
end

--- Return `fg` adjusted just enough to reach `min_ratio` contrast against `bg`.
---
--- The color is blended toward black or white (whichever contrasts more with
--- `bg`), keeping as much of its hue as possible. Colors that already pass are
--- returned unchanged (as "#rrggbb").
---@param fg dynamic_colors.ColorInput
---@param bg dynamic_colors.ColorInput
---@param min_ratio number WCAG contrast ratio, e.g. 4.5 for body text
---@return string
function M.ensure_contrast(fg, bg, min_ratio)
    if M.contrast_ratio(fg, bg) >= min_ratio then
        return M.to_hex(fg)
    end

    local target = M.contrast_color(bg)
    if M.contrast_ratio(target, bg) <= min_ratio then
        return target
    end

    -- Binary search for the smallest blend amount that passes.
    local low, high = 0, 1
    for _ = 1, 16 do
        local middle = (low + high) / 2
        if M.contrast_ratio(M.blend(fg, target, middle), bg) >= min_ratio then
            high = middle
        else
            low = middle
        end
    end

    return M.blend(fg, target, high)
end

--- Move a color toward white by `amount` in [0, 1].
---@param value dynamic_colors.ColorInput
---@param amount number
---@return string
function M.lighten(value, amount)
    check_amount(amount, "lighten")
    return M.blend(value, 0xFFFFFF, amount)
end

--- Move a color toward black by `amount` in [0, 1].
---@param value dynamic_colors.ColorInput
---@param amount number
---@return string
function M.darken(value, amount)
    check_amount(amount, "darken")
    return M.blend(value, 0x000000, amount)
end

return M
