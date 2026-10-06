--- Palette loader: read a color file, decode every value, derive UI colors.
---
--- The file lists two families of colors, any number of each:
---   p1, p2, ... - primary colors
---   c1, c2, ... - complementary colors
---
--- At least MIN_COLORS colors are required in total. Each family is ranked
--- (most contrasting first, near-neutral pastels last) and spread over
--- SLOTS_PER_FAMILY syntax slots (primary_1.., complement_1..). Fewer colors
--- repeat across slots; a missing family borrows from the other one.
---
--- The background is always black. A near-white pastel, when present, tints
--- the foreground. The file is reread on every load(); nothing is cached.
local color = require("dynamic_colors.color")

local M = {}

local MIN_COLORS = 4
local SLOTS_PER_FAMILY = 6

--- Minimum WCAG contrast for colors used as text on the background.
local TEXT_CONTRAST = 4.5

--- Colors below this chroma count as near-neutral (greys, pastels, near-white).
local NEUTRAL_CHROMA = 0.15

--- A near-neutral color needs this contrast against the background to become the foreground.
local FOREGROUND_CONTRAST = 12

--- Turn a raw value from the color file into a "#rrggbb" color.
---
--- The extractor writes each channel in hex without zero padding, so a value
--- has 3 to 6 digits. With fewer than 6 the split is ambiguous; it is resolved
--- by giving the leading channels two digits and the trailing ones one:
---
---   #B9895C -> B9 89 5C      #E8D8E -> E8 D8 0E
---   #A1B2   -> A1 0B 02      #ABC   -> 0A 0B 0C
---@param value string raw, already trimmed value from the file
---@return string
function M.decode_color(value)
    local digits = value:match("^#(%x+)$")
    if not digits or #digits < 3 or #digits > 6 then
        error(string.format("expected '#' followed by 3 to 6 hex digits, got %q", value), 0)
    end

    local two_digit_channels = #digits - 3
    local channels = {}
    local position = 1

    for index = 1, 3 do
        local width = index <= two_digit_channels and 2 or 1
        channels[index] = tonumber(digits:sub(position, position + width - 1), 16)
        position = position + width
    end

    return string.format("#%02x%02x%02x", channels[1], channels[2], channels[3])
end

--- Parse `name value` (or `name = value`) lines into an ordered list of { name, value }.
local function read_entries(path, given_path)
    local file, open_err = io.open(path, "r")
    if not file then
        error(string.format(
            "DynamicColors: cannot open color file\npath: %s\nresolved: %s\nreason: %s",
            given_path,
            path,
            open_err or "unknown"
        ), 0)
    end

    local entries = {}
    local line_number = 0

    for line in file:lines() do
        line_number = line_number + 1

        -- Skip blanks, comments and section headers (sections are not meaningful here).
        local is_skipped = line:match("^%s*$") or line:match("^%s*#") or line:match("^%s*%[.*%]%s*$")
        if not is_skipped then
            local name, value = line:match("^%s*([%w_%-]+)%s*[=%s]%s*(.-)%s*$")
            if not name then
                file:close()
                error(string.format(
                    "DynamicColors: malformed line %d (expected 'name value')\nline: %s\nfile: %s",
                    line_number,
                    line,
                    path
                ), 0)
            end

            table.insert(entries, { name = name, value = value })
        end
    end

    file:close()
    return entries
end

local function decode_entry(name, value, path)
    local ok, decoded = pcall(M.decode_color, value)
    if not ok then
        error(string.format(
            "DynamicColors: failed to decode color '%s'\nvalue: %s\nfile: %s\nreason: %s",
            name,
            value,
            path,
            tostring(decoded)
        ), 0)
    end

    local _, err = color.try_parse(decoded)
    if err then
        error(string.format(
            "DynamicColors: decode_color() returned an unusable color for '%s'\nvalue: %s\nfile: %s\nreason: %s",
            name,
            value,
            path,
            err
        ), 0)
    end

    return decoded
end

--- Read and decode the file into { raw = { name = color }, primary = {...}, complement = {...} }.
---
--- Family lists are in file order (p1, p2, ...); unknown names are kept in `raw` only.
local function load_base(path, given_path)
    local raw = {}
    local families = { p = {}, c = {} }

    for _, entry in ipairs(read_entries(path, given_path)) do
        local decoded = decode_entry(entry.name, entry.value, path)
        raw[entry.name] = decoded

        local family, index = entry.name:match("^([pc])(%d+)$")
        if family then
            table.insert(families[family], { index = tonumber(index), value = decoded })
        end
    end

    local total = #families.p + #families.c
    if total < MIN_COLORS then
        error(string.format(
            "DynamicColors: need at least %d colors (p1.., c1..), found %d\nfile: %s",
            MIN_COLORS,
            total,
            path
        ), 0)
    end

    local function in_file_order(family)
        table.sort(family, function(a, b)
            return a.index < b.index
        end)

        local values = {}
        for _, item in ipairs(family) do
            table.insert(values, item.value)
        end
        return values
    end

    return {
        raw = raw,
        primary = in_file_order(families.p),
        complement = in_file_order(families.c),
    }
end

local function is_neutral(value)
    return color.chroma(value) < NEUTRAL_CHROMA
end

--- Order colors by how well they work as text: colorful ones by contrast
--- against `background` (highest first), near-neutral ones last. Stable.
local function rank(colors, background)
    local items = {}
    for position, value in ipairs(colors) do
        table.insert(items, {
            value = value,
            position = position,
            is_neutral = is_neutral(value),
            contrast = color.contrast_ratio(value, background),
        })
    end

    table.sort(items, function(a, b)
        if a.is_neutral ~= b.is_neutral then
            return not a.is_neutral
        end
        if a.contrast ~= b.contrast then
            return a.contrast > b.contrast
        end
        return a.position < b.position
    end)

    local ranked = {}
    for _, item in ipairs(items) do
        table.insert(ranked, item.value)
    end
    return ranked
end

--- The lightest near-neutral color with enough contrast, preferring the primary family.
local function pick_foreground(base, background)
    for _, family in ipairs({ base.primary, base.complement }) do
        local best = nil
        for _, value in ipairs(family) do
            local is_candidate = is_neutral(value) and color.contrast_ratio(value, background) >= FOREGROUND_CONTRAST
            if is_candidate and (best == nil or color.luminance(value) > color.luminance(best)) then
                best = value
            end
        end
        if best then
            return best
        end
    end

    return color.contrast_color(background)
end

local function without(colors, removed)
    local kept = {}
    for _, value in ipairs(colors) do
        if value ~= removed then
            table.insert(kept, value)
        end
    end
    return kept
end

--- Fill `<prefix>_1 .. <prefix>_N` with readable versions of `ranked`, cycling when short.
local function fill_slots(p, prefix, ranked)
    for slot = 1, SLOTS_PER_FAMILY do
        local value = ranked[(slot - 1) % #ranked + 1]
        p[prefix .. "_" .. slot] = color.ensure_contrast(value, p.background, TEXT_CONTRAST)
    end
end

local function rotate(colors, offset)
    local rotated = {}
    for index = 1, #colors do
        rotated[index] = colors[(index - 1 + offset) % #colors + 1]
    end
    return rotated
end

local function darkest(colors)
    local result = colors[1]
    for _, value in ipairs(colors) do
        if color.luminance(value) < color.luminance(result) then
            result = value
        end
    end
    return result
end

local function lightest(colors)
    local result = colors[1]
    for _, value in ipairs(colors) do
        if color.luminance(value) > color.luminance(result) then
            result = value
        end
    end
    return result
end

--- Build the semantic palette. The raw file colors (p1, c1, ...) are kept as well.
local function derive(base)
    local p = {}
    for name, value in pairs(base.raw) do
        p[name] = value
    end

    p.background = "#000000"
    local foreground = pick_foreground(base, p.background)
    p.foreground = color.to_hex(foreground)

    p.background_alt = color.blend(p.background, p.foreground, 0.06)
    p.surface = color.blend(p.background, p.foreground, 0.14)
    p.foreground_muted = color.blend(p.foreground, p.background, 0.45)
    p.foreground_dim = color.blend(p.foreground, p.background, 0.65)

    -- The foreground color is not reused for syntax unless the family would be left empty.
    local primary = without(base.primary, foreground)
    local complement = without(base.complement, foreground)
    if #primary == 0 then
        primary = base.primary
    end
    if #complement == 0 then
        complement = base.complement
    end

    local ranked_primary = rank(primary, p.background)
    local ranked_complement = rank(complement, p.background)

    -- A missing family borrows the other one, starting halfway so slots still differ.
    if #ranked_primary == 0 then
        ranked_primary = rotate(ranked_complement, math.floor(#ranked_complement / 2))
    end
    if #ranked_complement == 0 then
        ranked_complement = rotate(ranked_primary, math.floor(#ranked_primary / 2))
    end

    fill_slots(p, "primary", ranked_primary)
    fill_slots(p, "complement", ranked_complement)

    -- Fills use the untouched file colors.
    p.accent = ranked_primary[1]
    p.accent_fg = color.contrast_color(p.accent)
    -- p.selection = color.blend(p.background, darkest(ranked_primary), 0.8)
    p.selection = color.blend(p.background, lightest(ranked_primary), 0.5)
    p.border = color.blend(p.background, ranked_primary[1], 0.4)

    p.error = p.complement_1
    p.warning = p.complement_2
    p.info = p.primary_1
    p.hint = p.primary_3
    p.success = p.primary_2

    p.diff_add = color.blend(p.background, p.success, 0.18)
    p.diff_change = color.blend(p.background, p.info, 0.14)
    p.diff_delete = color.blend(p.background, p.error, 0.18)
    p.diff_text = color.blend(p.background, p.info, 0.32)

    return p
end

--- Load the full semantic palette (file colors plus derived ones).
---
--- Rereads the color file on every call. `~` and environment variables in
--- `path` are expanded.
---@param path string color file, e.g. "~/.cache/juiced.color"
---@return table<string, string|integer>
function M.load(path)
    if type(path) ~= "string" or path == "" then
        error(string.format("DynamicColors: palette.load() needs a color file path, got %s", vim.inspect(path)), 2)
    end

    return derive(load_base(vim.fn.expand(path), path))
end

return M
