------------------------------------------------------------------------------
-- luakit configuration file, more information at https://luakit.github.io/ --
------------------------------------------------------------------------------

require "lfs"
require "luakit"

-- Check for lua configuration files that will never be loaded because they are
-- shadowed by builtin modules.
table.insert(package.loaders, 2, function (modname)
    if not package.searchpath then return end
    local f = package.searchpath(modname, package.path)
    if not f or f:find(luakit.install_paths.install_dir .. "/", 0, true) ~= 1 then
        return
    end
    local lf = luakit.config_dir .. "/" .. modname:gsub("%.","/") .. ".lua"
    if f == lf then
        msg.warn("Loading local version of '" .. modname .. "' module: " .. lf)
    elseif lfs.attributes(lf) then
        msg.warn("Found local version " .. lf
            .. " for core module '" .. modname
            .. "', but it won't be used, unless you update 'package.path' accordingly.")
    end
end)

require "unique_instance"

-- Set the cookie storage location
soup.cookies_storage = luakit.data_dir .. "/cookies.db"

-- Load library of useful functions for luakit
local lousy = require "lousy"

-- Load users theme
-- ("$XDG_CONFIG_HOME/luakit/theme.lua" or "/etc/xdg/luakit/theme.lua")
lousy.theme.init(lousy.util.find_config("theme.lua"))
assert(lousy.theme.get(), "failed to load theme")

-- Load users window class
-- ("$XDG_CONFIG_HOME/luakit/window.lua" or "/etc/xdg/luakit/window.lua")
local window = require "window"

-- Load users webview class
-- ("$XDG_CONFIG_HOME/luakit/webview.lua" or "/etc/xdg/luakit/webview.lua")
local webview = require "webview"

-- Add luakit://log/ chrome page
local log_chrome = require "log_chrome"

window.add_signal("build", function (w)
    local widgets, l, r = require "lousy.widget", w.sbar.l, w.sbar.r

    -- Left-aligned status bar widgets
    l.layout:pack(widgets.uri())
    l.layout:pack(widgets.hist())
    l.layout:pack(widgets.progress())

    -- Right-aligned status bar widgets
    r.layout:pack(widgets.buf())
    r.layout:pack(log_chrome.widget())
    r.layout:pack(widgets.ssl())
    r.layout:pack(widgets.tabi())
    r.layout:pack(widgets.scroll())
end)

-- Load luakit binds and modes
local modes = require "modes"

-- modes.add_binds("command",
-- {
--     { ":q[uit]", "Close current tab.", function (w) w:close_tab() end },
--     { ":qa", "Close all tabs and close window.", function (w, o) w:close_win(o.bang) end },
-- })

local settings = require "settings"

require "settings_chrome"

local engines = {}
--     g = "https://google.com?q=%s",
--     gh = "https://github.com/search?q=%s&type=repositories"
-- }

engines.g = "https://google.com/search?q=%s"
engines.gh = "https://github.com/search?q=%s&type=repositories"
settings.window.search_engines = engines
settings.window.default_search_engine = "g"

settings.window.new_window_size = "maximized"
-- settings.set_setting("window.new_window_size", "maximized")

-- 1. Hardware Acceleration: "on-demand" reduces VRAM pressure on older Intel GPUs
settings.webview.hardware_acceleration_policy = "on-demand"
---- needed sometimes when run inside toolbox
-- settings.webview.hardware_acceleration_policy = "never"

-- 2. Smooth Scrolling: enables fluid animated scrolling instead of discrete jumps
settings.webview.enable_smooth_scrolling = true

-- 3. DNS Prefetching: resolves domain names in the background to speed up link clicks
settings.webview.enable_dns_prefetching = true

-- 4. WebGL: enables 3D graphics support (Google Maps 3D, Figma, etc.)
settings.webview.enable_webgl = true

----------------------------------
-- Optional user script loading --
----------------------------------
require("plugins")

modes.add_binds("normal", {
    { "o", "Open one or more URLs (search bar).", function (w) require("plugins.search_bar").show(w) end },
    { "t", "Open one or more URLs in a new tab (search bar).",
        function (w) require("plugins.search_bar").show(w, { new_tab = true }) end },
    { "w", "Open one or more URLs in a new window.", function (w) w:enter_cmd(":winopen ") end },
    { "O", "Open one or more URLs based on current location (search bar).",
        function (w) require("plugins.search_bar").show(w, { text = w.view.uri or "" }) end },
    { "T", "Open one or more URLs based on current location in a new tab (search bar).",
        function (w) require("plugins.search_bar").show(w, { new_tab = true, text = w.view.uri or "" }) end },
    { "W", "Open one or more URLs based on current location in a new window.",
        function (w) w:enter_cmd(":winopen " .. (w.view.uri or "")) end },
})

-- Add adblock
local adblock = require "adblock"
local adblock_chrome = require "adblock_chrome"

local webinspector = require "webinspector"

-- Add uzbl-like form filling
local formfiller = require "formfiller"

-- Add proxy support & manager
local proxy = require "proxy"

-- Add cache control (clear-data, clear-favicon-db)
local clear_data = require "clear_data"

-- Add quickmarks support & manager
local quickmarks = require "quickmarks"

-- Add session saving/loading support
local session = require "session"


-- Add command to list closed tabs & bind to open closed tabs
local undoclose = require "undoclose"

-- Add command to list tab history items
local tabhistory = require "tabhistory"

-- Add command to list open tabs
local tabmenu = require "tabmenu"

-- Allow for tabs to be grouped together.
-- One tab group is displayed in a window at any given time.
--local tabgroups = require "tabgroups"

-- Add gopher protocol support (this module needs luasocket)
-- local gopher = require "gopher"

-- Add greasemonkey-like javascript userscript support
local userscripts = require "userscripts"

-- Add bookmarks support
local bookmarks = require "bookmarks"
local bookmarks_chrome = require "bookmarks_chrome"

-- Automatically sync/export bookmarks in Chromium/Chrome 'Bookmarks' format
do
    local function export_to_chrome()
        local ok, err = pcall(function ()
            if not bookmarks.db then bookmarks.init() end
            if not bookmarks.db then return end
            local rows = bookmarks.db:exec("SELECT * FROM bookmarks ORDER BY id ASC")
            if not rows then return end

            local function escape_json(s)
                if not s then return "" end
                return s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t")
            end

            -- Convert unix epoch to Chrome's timestamp (microseconds since Jan 1, 1601)
            local function chrome_time(t)
                t = t or os.time()
                return string.format("%.0f", (t + 11644473600) * 1000000)
            end

            local folders = {}
            local root_items = {}
            local next_id = 100

            for _, b in ipairs(rows) do
                next_id = next_id + 1
                local item_json = string.format([[
            {
               "date_added": %q,
               "date_last_used": "0",
               "id": %q,
               "name": %q,
               "type": "url",
               "url": %q
            }]],
                    chrome_time(b.created),
                    tostring(next_id),
                    escape_json(#b.title > 0 and b.title or b.uri),
                    escape_json(b.uri)
                )

                local tags = {}
                if b.tags and #b.tags > 0 then
                    for tag in b.tags:gmatch("%S+") do table.insert(tags, tag) end
                end

                if #tags == 0 then
                    table.insert(root_items, item_json)
                else
                    for _, tag in ipairs(tags) do
                        folders[tag] = folders[tag] or {}
                        table.insert(folders[tag], item_json)
                    end
                end
            end

            local children = {}
            for _, item in ipairs(root_items) do table.insert(children, item) end

            for folder_name, items in pairs(folders) do
                next_id = next_id + 1
                table.insert(children, string.format([[
            {
               "children": [%s
               ],
               "date_added": %q,
               "date_modified": %q,
               "id": %q,
               "name": %q,
               "type": "folder"
            }]],
                    table.concat(items, ","),
                    chrome_time(),
                    chrome_time(),
                    tostring(next_id),
                    escape_json(folder_name)
                ))
            end

            local full_json = string.format([[
{
   "checksum": "",
   "roots": {
      "bookmark_bar": {
         "children": [%s
         ],
         "date_added": "13324567890000000",
         "date_modified": %q,
         "id": "1",
         "name": "Bookmarks bar",
         "type": "folder"
      },
      "other": {
         "children": [],
         "date_added": "13324567890000000",
         "date_modified": "0",
         "id": "2",
         "name": "Other bookmarks",
         "type": "folder"
      },
      "synced": {
         "children": [],
         "date_added": "13324567890000000",
         "date_modified": "0",
         "id": "3",
         "name": "Mobile bookmarks",
         "type": "folder"
      }
   },
   "version": 1
}
]], table.concat(children, ","), chrome_time())

            -- Primary target: ~/.local/share/luakit/Bookmarks
            local targets = { luakit.data_dir .. "/Bookmarks" }

            -- Also sync to standard Chromium-based browser profile dirs if installed
            local home = os.getenv("HOME") or ""
            local browser_dirs = {
                home .. "/.config/google-chrome/Default",
                home .. "/.config/chromium/Default",
                home .. "/.config/BraveSoftware/Brave-Browser/Default",
                home .. "/.config/vivaldi/Default",
                home .. "/.config/microsoft-edge/Default",
            }
            for _, dir in ipairs(browser_dirs) do
                if lfs.attributes(dir) then
                    table.insert(targets, dir .. "/Bookmarks")
                end
            end

            for _, path in ipairs(targets) do
                local f = io.open(path, "w")
                if f then
                    f:write(full_json)
                    f:close()
                end
            end
        end)
        if not ok then
            msg.warn("export_to_chrome error: %s", err)
        end
    end

    bookmarks.add_signal("add",    function () export_to_chrome() end)
    bookmarks.add_signal("remove", function () export_to_chrome() end)
    bookmarks.add_signal("update", function () export_to_chrome() end)
    export_to_chrome()
    luakit.idle_add(export_to_chrome)
end

-- Add download support
local downloads = require "downloads"
local downloads_chrome = require "downloads_chrome"

-- Add automatic PDF downloading and opening
local viewpdf = require "viewpdf"

-- Example using xdg-open for opening downloads / showing download folders
downloads.add_signal("open-file", function (file)
    luakit.spawn(string.format("xdg-open %q", file))
    return true
end)

-- Add vimperator-like link hinting & following
local follow = require "follow"
follow.selectors.clickable = 'a, area, textarea, select, input:not([type=hidden]), button, label, summary'
    .. ', [role="button"], [role="link"], [role="menuitem"], [role="tab"], [role="option"], [role="switch"]'
    .. ', [onclick], [onmousedown], [onmouseup]'
follow.selectors.focus = 'a, area, textarea, select, input:not([type=hidden]), button, [tabindex]:not([tabindex="-1"]), body, applet, object'
follow.site_specific_selectors["github.com"] = {
    clickable = "button, [data-hotkey], [data-hydro-click], [data-ga-click], [data-action]"
}

-- Add command history
local cmdhist = require "cmdhist"

-- Add search mode & binds
local search = require "search"

-- Add ordering of new tabs
local taborder = require "taborder"

-- Save web history
local history = require "history"
local history_chrome = require "history_chrome"

local help_chrome = require "help_chrome"
local binds_chrome = require "binds_chrome"

-- Add command completion
local completion = require "completion"

-- Press Control-E while in insert mode to edit the contents of the currently
-- focused <textarea> or <input> element, using `xdg-open`
local open_editor = require "open_editor"

-- NoScript plugin, toggle scripts and or plugins on a per-domain basis.
-- `,ts` to toggle scripts, `,tp` to toggle plugins, `,tr` to reset.
-- If you use this module, don't use any site-specific `enable_scripts` or
-- `enable_plugins` settings, as these will conflict.
--require "noscript"

local follow_selected = require "follow_selected"
local go_input = require "go_input"
local go_next_prev = require "go_next_prev"
local go_up = require "go_up"

-- Filter Referer HTTP header if page domain does not match Referer domain
require_web_module("referer_control_wm")

local error_page = require "error_page"

-- Add userstyles loader
local styles = require "styles"

-- Add a stylesheet when showing images
local image_css = require "image_css"

-- Add a new tab page
local newtab_chrome = require "newtab_chrome"

-- Add tab favicons mod
local tab_favicons = require "tab_favicons"

-- Add :view-source command
local view_source = require "view_source"

-- Visual mode for keyboard text selection
modes.new_mode("visual", {
    enter = function (w)
        w.view.enable_caret_browsing = true
        w:set_prompt("-- VISUAL --")
    end,
})

local function sel_mod(w, action, direction, granularity)
    local js = string.format("window.getSelection().modify(%q, %q, %q)", action, direction, granularity)
    w.view:eval_js(js, { no_return = true })
end

modes.add_binds("normal", {
    { "v", "Enter visual mode to move cursor and select text.", function (w) w:set_mode("visual") end },
})

modes.add_binds("visual", {
    { "<Escape>", "Exit visual mode.", function (w) w:set_mode() end },

    -- Yank & Exit
    { "y", "Yank selected text and exit.", function (w)
        w.view:eval_js("window.getSelection().toString()", {
            callback = function (text)
                if text and #text > 0 then
                    luakit.selection.clipboard = text
                    luakit.selection.primary = text
                    w:notify("Yanked: " .. text:sub(1, 50) .. (#text > 50 and "..." or ""))
                end
                w:set_mode()
            end
        })
    end },
    { "<Return>", "Yank selected text and exit.", function (w)
        w:hit({}, "y")
    end },

    -- Navigation (Move cursor without selecting)
    { "h", "Move cursor left.",          function (w) sel_mod(w, "move", "backward", "character") end },
    { "l", "Move cursor right.",         function (w) sel_mod(w, "move", "forward",  "character") end },
    { "k", "Move cursor up.",            function (w) sel_mod(w, "move", "backward", "line")      end },
    { "j", "Move cursor down.",          function (w) sel_mod(w, "move", "forward",  "line")      end },
    { "<Left>",  "Move cursor left.",    function (w) sel_mod(w, "move", "backward", "character") end },
    { "<Right>", "Move cursor right.",   function (w) sel_mod(w, "move", "forward",  "character") end },
    { "<Up>",    "Move cursor up.",      function (w) sel_mod(w, "move", "backward", "line")      end },
    { "<Down>",  "Move cursor down.",    function (w) sel_mod(w, "move", "forward",  "line")      end },
    { "w", "Jump word forward.",         function (w) sel_mod(w, "move", "forward",  "word")      end },
    { "b", "Jump word backward.",        function (w) sel_mod(w, "move", "backward", "word")      end },
    { "0", "Jump to start of line.",     function (w) sel_mod(w, "move", "backward", "lineboundary") end },
    { "^", "Jump to start of line.",     function (w) sel_mod(w, "move", "backward", "lineboundary") end },

    -- Selection (Extend highlight)
    { "H", "Select left character.",     function (w) sel_mod(w, "extend", "backward", "character") end },
    { "L", "Select right character.",    function (w) sel_mod(w, "extend", "forward",  "character") end },
    { "K", "Select line up.",            function (w) sel_mod(w, "extend", "backward", "line")      end },
    { "J", "Select line down.",          function (w) sel_mod(w, "extend", "forward",  "line")      end },
    { "<Shift-Left>",  "Select left.",   function (w) sel_mod(w, "extend", "backward", "character") end },
    { "<Shift-Right>", "Select right.",  function (w) sel_mod(w, "extend", "forward",  "character") end },
    { "<Shift-Up>",    "Select line up.",function (w) sel_mod(w, "extend", "backward", "line")      end },
    { "<Shift-Down>",  "Select line dn.",function (w) sel_mod(w, "extend", "forward",  "line")      end },
    { "W", "Select word forward.",       function (w) sel_mod(w, "extend", "forward",  "word")      end },
    { "B", "Select word backward.",      function (w) sel_mod(w, "extend", "backward", "word")      end },
    { "$", "Select to end of line.",     function (w) sel_mod(w, "extend", "forward",  "lineboundary") end },
    { ")", "Select sentence forward.",   function (w) sel_mod(w, "extend", "forward",  "sentence") end },
    { "(", "Select sentence backward.",  function (w) sel_mod(w, "extend", "backward", "sentence") end },
})

-----------------------------
-- End user script loading --
-----------------------------

-- Restore last saved session
local w = (not luakit.nounique) and (session and session.restore())
if w then
    for i, uri in ipairs(uris) do
        w:new_tab(uri, { switch = i == 1 })
    end
else
    -- Or open new window
    window.new(uris)
end

-- vim: et:sw=4:ts=8:sts=4:tw=80
