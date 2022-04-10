local dap_install = require("dap-install")
local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

for _, debugger in ipairs(dbg_list) do
    -- if debugger == "dnetcs" then
    --     dap_install.config(
    --         "dnetcs",
    --         {
    --             adapters = {
    --                 type = 'executable',
    --                 command = '~/.local/bin/netcoredbg',
    --                 args = {'--interpreter=vscode'}
    --             },
    --             configurations = {
    --                 {
    --                     type = "netcoredbg",
    --                     name = "launch - netcoredbg",
    --                     request = "launch",
    --                     program = function()
    --                         return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    --                     end,
    --                 }
    --             }
    --         }
    --     )
    -- else
        dap_install.config(debugger)
    -- end
end

require("dapui").setup()

-- local dap_install = require("dap-install")
-- dap_install.config(
-- 	"python",
--     {
--         adapters = {
--             type = "executable",
--             command = "python3.9",
--             args = {"-m", "debugpy.adapter"}
--         },
--         configurations = {
--             {
--                 type = "python",
--                 request = "launch",
--                 name = "Launch file",
--                 program = "${file}",
--                 pythonPath = function()
--                     local cwd = vim.fn.getcwd()
--                     if vim.fn.executable(cwd .. "/usr/bin/python3.9") == 1 then
--                         return cwd .. "/usr/bin/python3.9"
--                     elseif vim.fn.executable(cwd .. "/usr/bin/python3.9") == 1 then
--                         return cwd .. "/usr/bin/python3.9"
--                     else
--                         return "/usr/bin/python3.9"
--                     end
--                 end
--             }
--         }
--     },
--     "dnetcs",
--     {
--         adapters = {
--             type = 'executable',
--             command = '~/.local/bin/netcoredbg',
--             args = {'--interpreter=vscode'}
--         },
--         configurations = {
--             {
--                 type = "netcoredbg",
--                 name = "launch - netcoredbg",
--                 request = "launch",
--                 program = function()
--                     return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
--                 end,
--             }
--         }
--     }
-- )
