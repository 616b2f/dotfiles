--- Zen Browser-styled floating search bar widget for Luakit.
--
-- Presents a sleek, centered 70%-width floating omnibox overlay for URL/search
-- input with live history and bookmark completions. Styled with a clean Zen-like
-- aesthetic and native Luakit theme integration.
--
-- ## Usage
--
-- local search_bar = require "search_bar"
-- search_bar.show(w)                          -- open (current tab)
-- search_bar.show(w, { new_tab = true })       -- open (new tab)
-- search_bar.show(w, { text = w.view.uri })    -- prefill current URI
--
-- @module search_bar
-- luacheck: globals widget

local lousy     = require("lousy")
local modes     = require("modes")
local settings  = require("settings")
local history   = require("history")
local bookmarks = require("bookmarks")

local _M = {}

-- Per-window private state (weak keys so windows can be GC'd)
local data = setmetatable({}, { __mode = "k" })

local function parse_engine(text)
    local engines = settings.get_setting("window.search_engines") or {}
    local word, rest = text:match("^@(%S+)%s*(.*)")
    if word and engines[word] then return word, rest end
    return nil, text
end

local function escape(s)
    if not s then return "" end
    return s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

local function make_row(col1, col2, extra)
    local r = { col1, col2 }
    if extra then for k, v in pairs(extra) do r[k] = v end end
    return r
end

local function make_title(label)
    return { label, "", title = true }
end

local function update_width(w)
    local d = data[w]
    if not d or not d.container then return end

    local win_width = 1000
    if w.win and w.win.allocation and w.win.allocation.width and w.win.allocation.width > 0 then
        win_width = w.win.allocation.width
    end

    local target_width = math.floor(win_width * 0.7)
    d.container.width_request = target_width

    d.container.css = string.format([[
        background-color: %s;
        color: %s;
        border: 1px solid %s;
        border-radius: 6px;
        padding: 6px 10px;
        margin-top: 40px;
        min-width: %dpx;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.25);
    ]], d.bg, d.fg, d.border_color, target_width)
end

local function update_completions(w, text)
    local d = data[w]
    if not d then return end

    if text == "" or not text then
        d.lock = true
        d.menu:build({})
        d.menu:hide()
        d.lock = false
        return
    end

    local rows           = {}
    local default_engine = settings.get_setting("window.default_search_engine") or "google"
    local engine, query  = parse_engine(text)
    local engine_name    = engine or default_engine

    -- Row 1: Search engine action
    table.insert(rows, make_row(
        "Search with <b>" .. escape(engine_name) .. "</b>",
        escape(query),
        { text = text, is_search = true }
    ))

    -- History matches
    if history.db then
        local sql = [[
            SELECT uri, title, lower(uri||ifnull(title,'')) AS search_text
            FROM history WHERE search_text LIKE ? ESCAPE '\'
            ORDER BY visits DESC LIMIT 5
        ]]
        local term = "%" .. query:gsub("%%", "\\%"):gsub("_", "\\_") .. "%"
        local rows_db = history.db:exec(sql, { term })
        if rows_db and rows_db[1] then
            table.insert(rows, make_title("History"))
            for _, r in ipairs(rows_db) do
                local title = (r.title and r.title ~= "") and r.title or r.uri
                table.insert(rows, make_row(
                    escape(title),
                    escape(r.uri),
                    { text = r.uri }
                ))
            end
        end
    end

    -- Bookmark matches
    if bookmarks.db then
        local sql = [[
            SELECT uri, title, lower(uri||ifnull(title,'')||ifnull(tags,'')) AS search_text
            FROM bookmarks WHERE search_text LIKE ? ESCAPE '\'
            ORDER BY title DESC LIMIT 5
        ]]
        local term = "%" .. query:gsub("%%", "\\%"):gsub("_", "\\_") .. "%"
        local rows_db = bookmarks.db:exec(sql, { term })
        if rows_db and rows_db[1] then
            table.insert(rows, make_title("Bookmarks"))
            for _, r in ipairs(rows_db) do
                local title = (r.title and r.title ~= "") and r.title or r.uri
                table.insert(rows, make_row(
                    escape(title),
                    escape(r.uri),
                    { text = r.uri }
                ))
            end
        end
    end

    -- Rebuild completion menu
    d.lock = true
    d.menu:build(rows)
    if #rows > 1 then
        d.menu:show()
        d.menu:move_down() -- Select first non-title item (Row 1)

        -- Enforce text ellipsizing so long items never stretch the box
        local menu_data = data[d.menu]
        if menu_data and menu_data.table then
            for _, rw in ipairs(menu_data.table) do
                if rw.cols then
                    for _, cell in ipairs(rw.cols) do
                        if cell then cell.ellipsize = "end" end
                    end
                end
            end
        end
    else
        d.menu:hide()
    end
    d.lock = false
end

-- Widget construction (done once per window, lazily)
local function build_widgets(w)
    local theme = lousy.theme.get() or {}
    local bg = theme.menu_bg or theme.bg or "#1e1e2e"
    local fg = theme.menu_fg or theme.fg or "#cdd6f4"
    local font = theme.font or "12px monospace"
    local border_color = theme.menu_selected_bg or theme.sbar_fg or "#444444"
    local prompt_fg = theme.menu_secondary_title_fg or theme.tab_fg or "#888888"

    -- Centered floating container
    local container = widget{ type = "vbox" }

    -- Header row (prompt label + search entry)
    local header = widget{ type = "hbox" }
    header.homogeneous = false

    local prompt = widget{ type = "label" }
    prompt.font = font
    prompt.text = " Search: "
    prompt.fg   = prompt_fg
    prompt.bg   = bg

    local input = widget{ type = "entry" }
    input.font = font
    input.css  = string.format([[
        background-color: %s;
        color: %s;
        border: none;
        border-radius: 0px;
        padding: 2px 6px;
        margin: 0px;
        outline: none;
        caret-color: %s;
    ]], bg, fg, fg)

    header:pack(prompt, { expand = false, fill = false })
    header:pack(input, { expand = true, fill = true })

    -- Completion menu widget using Luakit's built-in lousy.widget.menu
    local menu = lousy.widget.menu{ max_rows = 10 }
    menu.widget.css = string.format([[
        background-color: transparent;
        border: none;
        border-top: 1px solid %s;
        margin-top: 6px;
        padding-top: 4px;
    ]], border_color)

    container:pack(header, { expand = false, fill = true })
    container:pack(menu.widget, { expand = true, fill = true })

    -- Attach to window overlay container (centered horizontally near top)
    w.menu_tabs:pack(container, { halign = "center", valign = "start" })
    container:hide()

    local d = {
        container    = container,
        prompt       = prompt,
        input        = input,
        menu         = menu,
        bg           = bg,
        fg           = fg,
        border_color = border_color,
        lock         = false,
        orig_text    = "",
        opts         = {},
    }
    data[w] = d

    -- Update container width dynamically when window is resized
    if w.win then
        w.win:add_signal("size-allocate", function ()
            update_width(w)
        end)
    end
    update_width(w)

    -- Text change in input entry -> rebuild completions
    input:add_signal("changed", function ()
        if d.lock then return end
        d.orig_text = input.text
        update_completions(w, input.text)
    end)

    -- Menu row selection -> update entry text
    menu:add_signal("changed", function (_, row)
        if d.lock then return end
        d.lock = true
        if row and not row.title then
            local text = row.text or row.uri or row[1]
            input.text = text
            input.position = #text
        else
            input.text = d.orig_text
            input.position = #d.orig_text
        end
        d.lock = false
    end)

    -- Key handling inside the entry widget
    input:add_signal("key-press", function (_, mods, key)
        local has_ctrl = lousy.util.table.hasitem(mods, "Control")
            or lousy.util.table.hasitem(mods, "Control_L")
            or lousy.util.table.hasitem(mods, "Control_R")
        local has_shift = lousy.util.table.hasitem(mods, "Shift")
            or lousy.util.table.hasitem(mods, "Shift_L")
            or lousy.util.table.hasitem(mods, "Shift_R")

        if key == "Escape" or (has_ctrl and (key == "c" or key == "g" or key == "bracketleft")) then
            w:set_mode()
            return true
        elseif key == "Return" or key == "KP_Enter" then
            local row  = d.menu:get()
            local text = (row and not row.title) and (row.text or row.uri or row[1]) or input.text
            local open_in_new_tab = d.opts.new_tab or has_shift or has_ctrl
            w:set_mode()
            if text and text ~= "" then
                if open_in_new_tab then
                    w:new_tab(text)
                else
                    w:search_open_navigate(w.view, text)
                end
            end
            return true
        elseif key == "Tab" or key == "Down" or key == "KP_Down" or (has_ctrl and (key == "j" or key == "n")) then
            d.menu:move_down()
            return true
        elseif key == "ISO_Left_Tab" or key == "Up" or key == "KP_Up" or (has_ctrl and (key == "k" or key == "p")) then
            d.menu:move_up()
            return true
        elseif has_ctrl and key == "t" then
            d.opts.new_tab = not d.opts.new_tab
            d.prompt.text = d.opts.new_tab and " Search (tab): " or " Search: "
            return true
        end
    end)
end

-- Mode definition
modes.new_mode("search_bar", {
    reset_on_focus      = false,
    reset_on_navigation = false,

    enter = function (w)
        local d = data[w]
        if not d then build_widgets(w) end
        d = data[w]

        -- Prevent webview from stealing keyboard focus on click
        if w.view then w.view.can_focus = false end

        update_width(w)
        d.prompt.text = d.opts.new_tab and " Search (tab): " or " Search: "
        d.container:show()
        d.input:focus()
    end,

    leave = function (w)
        local d = data[w]
        if not d then return end

        d.container:hide()
        d.menu:build({})
        d.menu:hide()

        -- Restore normal webview focus behaviour
        if w.view then
            w.view.can_focus = true
            w.view:focus()
        end
    end,
})

--- Show the search bar.
-- @tparam table w The window table.
-- @tparam[opt] table opts Options: `new_tab` (boolean) opens in a new tab;
-- `text` (string) prefills the entry with this text.
function _M.show(w, opts)
    opts = opts or {}

    if not data[w] then build_widgets(w) end
    local d = data[w]

    d.opts = opts
    d.lock = true
    d.input.text = opts.text or ""
    d.orig_text  = opts.text or ""
    d.lock = false

    update_width(w)

    if opts.text and opts.text ~= "" then
        update_completions(w, opts.text)
        d.input:select_region(0, -1)
    else
        d.menu:build({})
        d.menu:hide()
    end

    w:set_mode("search_bar")
end

package.loaded["search_bar"] = _M
package.loaded["plugins.search_bar"] = _M

return _M

-- vim: et:sw=4:ts=8:sts=4:tw=80
