--- Floating search bar widget for Luakit.
--
-- Presents a centered spotlight-style overlay for URL/search input with
-- live history and bookmark completions. Implemented as a proper Luakit
-- mode so the window's existing focus and key-routing infrastructure
-- handles everything correctly -- no timers or manual focus juggling.
--
-- ## Usage
--
-- local search_bar = require "search_bar"
-- search_bar.show(w)                          -- open (current tab)
-- search_bar.show(w, { new_tab = true })       -- open (new tab)
-- search_bar.show(w, { text = w.view.uri })    -- prefill current URI
--
-- @module search_bar
-- luacheck: globals widget timer

local lousy    = require("lousy")
local modes    = require("modes")
local settings = require("settings")
local history  = require("history")
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
    local r = { col1, col2,
        bg          = "#1e1e2e",
        fg          = "#cdd6f4",
        selected_bg = "#313244",
        selected_fg = "#f5c2e7",
    }
    if extra then for k, v in pairs(extra) do r[k] = v end end
    return r
end

local function make_title(label)
    return { label, "", title = true, bg = "#1e1e2e", fg = "#89b4fa" }
end

local function update_completions(w, text)
    local d = data[w]
    if not d then return end

    if text == "" then
        d.menu:build({})
        d.menu:hide()
        return
    end

    local rows          = {}
    local default_engine = settings.get_setting("window.default_search_engine") or "google"
    local engine, query = parse_engine(text)
    local engine_name   = engine or default_engine

    -- Row 1: "Search with <engine>"
    table.insert(rows, make_row(
        "Search with <b>" .. escape(engine_name) .. "</b>",
        escape(query),
        { text = text }
    ))

    -- History matches
    local history_rows = {}
    if history.db then
        local sql = [[
            SELECT uri, title, lower(uri||ifnull(title,'')) AS search_text
            FROM history WHERE search_text LIKE ? ESCAPE '\'
            ORDER BY visits DESC LIMIT 5
        ]]
        local term = "%" .. query:gsub("%%", "\\%"):gsub("_", "\\_") .. "%"
        local rows_db = history.db:exec(sql, { term })
        if rows_db and rows_db[1] then
            table.insert(history_rows, make_title("History"))
            for _, r in ipairs(rows_db) do
                table.insert(history_rows, make_row(
                    escape(r.title ~= "" and r.title or r.uri),
                    escape(r.uri),
                    { text = r.uri }
                ))
            end
        end
    end

    -- Bookmark matches
    local bookmark_rows = {}
    if bookmarks.db then
        local sql = [[
            SELECT uri, title, lower(uri||ifnull(title,'')||ifnull(tags,'')) AS search_text
            FROM bookmarks WHERE search_text LIKE ? ESCAPE '\'
            ORDER BY title DESC LIMIT 5
        ]]
        local term = "%" .. query:gsub("%%", "\\%"):gsub("_", "\\_") .. "%"
        local rows_db = bookmarks.db:exec(sql, { term })
        if rows_db and rows_db[1] then
            table.insert(bookmark_rows, make_title("Bookmarks"))
            for _, r in ipairs(rows_db) do
                table.insert(bookmark_rows, make_row(
                    escape(r.title ~= "" and r.title or r.uri),
                    escape(r.uri),
                    { text = r.uri }
                ))
            end
        end
    end

    for _, r in ipairs(history_rows)  do table.insert(rows, r) end
    for _, r in ipairs(bookmark_rows) do table.insert(rows, r) end

    -- Prevent the "changed" signal from triggering a recursive update
    d.lock = true
    d.menu:build(rows)
    if #rows > 1 then
        d.menu:show()
        d.menu:move_down()   -- pre-select first non-title row
    else
        d.menu:hide()
    end
    d.lock = false
end

-- Widget construction (done once per window, lazily)
local function build_widgets(w)
    -- Floating container
    local container = widget{ type = "vbox" }
    container.css = [[
        background-color: #1e1e2e;
        border: 1px solid #313244;
        border-radius: 12px;
        padding: 12px;
        margin-top: 100px;
        width: 600px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.6);
    ]]

    -- Search entry
    local input = widget{ type = "entry" }
    input.css = [[
        background-color: #313244;
        color: #cdd6f4;
        border: none;
        border-radius: 8px;
        padding: 12px;
        font-size: 16px;
        caret-color: #f5c2e7;
    ]]

    -- Completion menu
    local menu = lousy.widget.menu{ max_rows = 11 }
    menu.widget.css = [[
        background-color: transparent;
        border: none;
        margin-top: 8px;
    ]]

    container:pack(input)
    container:pack(menu.widget)

    -- Attach to the window overlay; hidden by default
    w.menu_tabs:pack(container, { halign = "center", valign = "start" })
    container:hide()

    local d = {
        container = container,
        input     = input,
        menu      = menu,
        lock      = false,
        orig_text = "",
        opts      = {},
    }
    data[w] = d

    -- Text change → rebuild completions
    input:add_signal("changed", function ()
        if d.lock then return end
        d.orig_text = input.text
        update_completions(w, input.text)
    end)

    -- Menu row selection → update entry text
    menu:add_signal("changed", function (_, row)
        if d.lock then return end
        d.lock = true
        if row and not row.title then
            input.text = row.text or row[1]
            input.position = #input.text
        else
            input.text = d.orig_text
            input.position = #input.text
        end
        d.lock = false
    end)

    -- Key handling inside the entry widget
    input:add_signal("key-press", function (_, _mods, key)
        if key == "Escape" then
            w:set_mode()         -- triggers mode leave → hide + restore focus
            return true
        elseif key == "Return" then
            local row  = d.menu:get()
            local text = (row and not row.title) and row.text or input.text
            w:set_mode()
            if d.opts.new_tab then
                w:new_tab(text)
            else
                w:search_open_navigate(w.view, text)
            end
            return true
        elseif key == "Tab" or key == "Down" then
            d.menu:move_down()
            return true
        elseif key == "ISO_Left_Tab" or key == "Up" then
            d.menu:move_up()
            return true
        end
    end)
end

-- Mode definition
-- "reset_on_focus = false" is the key property: it prevents webview.lua's
-- "root-active" signal handler from calling w:set_mode() (resetting to
-- normal) when the user clicks on web content while the bar is open.
-- "can_focus = false" on the view prevents WebKit from grabbing keyboard
-- focus via a click before that signal even fires.
modes.new_mode("search_bar", {
    reset_on_focus     = false,
    reset_on_navigation = false,

    enter = function (w)
        local d = data[w]
        if not d then build_widgets(w) end
        d = data[w]

        -- Prevent the webview from stealing keyboard focus on click
        if w.view then w.view.can_focus = false end

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

    -- Build widgets on first use
    if not data[w] then build_widgets(w) end
    local d = data[w]

    -- Reset state for this invocation
    d.opts = opts
    d.lock = true
    d.input.text = opts.text or ""
    d.orig_text  = opts.text or ""
    d.lock = false

    if opts.text and opts.text ~= "" then
        update_completions(w, opts.text)
        d.input:select_region(0)
    else
        d.menu:build({})
        d.menu:hide()
    end

    -- Entering the mode calls mode.enter which shows the container and
    -- focuses the entry
    w:set_mode("search_bar")
end

return _M

-- vim: et:sw=4:ts=8:sts=4:tw=80
