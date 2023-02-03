local dap = require('dap')
local reg = require('mason-registry')
local api = vim.api

-- setup icons
-- vim.fn.sign_define('DapBreakpoint', {text='', texthl='', linehl='', numhl=''})
vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg='#3d59a1' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { fg='#3d59a1' })
vim.api.nvim_set_hl(0, 'DapStopped', { fg='#9ece6a' })

vim.fn.sign_define('DapBreakpoint', {text='', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='󰣕', texthl='DapLogPoint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='DapStopped', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='', linehl='', numhl=''})

-- C#
if (reg.is_installed('netcoredbg')) then
    local netcoredbg = reg.get_package('netcoredbg')

    local adapter_config = {
        type = 'executable',
        command = netcoredbg:get_install_path() .. '/netcoredbg',
        args = {'--interpreter=vscode'}
    }
    -- neotest-dotnet needs 'netcoredbg'
    dap.adapters.netcoredbg = adapter_config
    dap.adapters.coreclr = adapter_config

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
        },
        {
            name = "debug unittests - netcoredbg",
            type = "coreclr",
            request = "attach",
            processId  = require('dap.utils').pick_process,
            justMyCode = true, -- set to `true` in debug configuration and `false` in release configuration
        },
        {
            name = "attach - netcoredbg",
            type = "coreclr",
            request = "attach",
            processId  = function()
                return vim.fn.input('Process ID: ')
            end,
            justMyCode = true, -- set to `true` in debug configuration and `false` in release configuration
        }
    }
end

local keymap_restore = {}
dap.listeners.after['event_initialized']['me'] = function()
  for _, buf in pairs(api.nvim_list_bufs()) do
    local keymaps = api.nvim_buf_get_keymap(buf, 'n')
    for _, keymap in pairs(keymaps) do
      if keymap.lhs == "K" then
        table.insert(keymap_restore, keymap)
        api.nvim_buf_del_keymap(buf, 'n', 'K')
      end
    end
  end
  api.nvim_set_keymap(
    'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
end

dap.listeners.after['event_terminated']['me'] = function()
  for _, keymap in pairs(keymap_restore) do
    api.nvim_buf_set_keymap(
      keymap.buffer,
      keymap.mode,
      keymap.lhs,
      keymap.rhs,
      { silent = keymap.silent == 1 }
    )
  end
  keymap_restore = {}
end

-- C++
if (reg.is_installed('cpptools')) then
    local cpptools = reg.get_package('cpptools')

    dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = cpptools:get_install_path() .. '/extension/debugAdapters/bin/OpenDebugAD7',
    }
    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = true,
        },
        {
            name = 'Attach to gdbserver :1234',
            type = 'cppdbg',
            request = 'launch',
            MIMode = 'gdb',
            miDebuggerServerAddress = 'localhost:1234',
            miDebuggerPath = '/usr/bin/gdb',
            cwd = '${workspaceFolder}',
            program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
        },
    }
end

require("dapui").setup()

-- local dap_install = require("dap-install")
-- local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

-- for _, debugger in ipairs(dbg_list) do
--     if debugger == "dnetcs" then
--         dap_install.config(
--             "dnetcs",
--             {
--                 adapters = {
--                     type = 'executable',
--                     command = '~/.local/bin/netcoredbg',
--                     args = {'--interpreter=vscode'}
--                 },
--                 configurations = {
--                     {
--                         name = "launch - netcoredbg",
--                         type = "netcoredbg",
--                         request = "launch",
--                         program = function()
--                             return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
--                         end,
--                     },
--                     {
--                         name = "Skaffold Debug",
--                         type = "netcoredbg",
--                         request = "attach",
--                         processId  = 1,
--                         justMyCode = true, -- set to `true` in debug configuration and `false` in release configuration
--                         pipeTransport = {
--                             pipeProgram = "kubectl",
--                             pipeArgs = {
--                                 "exec",
--                                 "-i",
--                                 "<NAME OF YOUR POD>", -- name of the pod you debug.
--                                 "--"
--                             },
--                             pipeCwd = "${workspaceFolder}",
--                             debuggerPath = "/dbg/netcore/vsdbg", -- location where vsdbg binary installed.
--                             quoteArgs = false
--                         },
--                         sourceFileMap = {
--                             -- Change this mapping if your app in not deployed in /src or /app in your docker image
--                             ["/src"] = "${workspaceFolder}",
--                             ["/app"] = "${workspaceFolder}"
--                             -- May also be like this, depending of your repository layout
--                             -- "/src" = "${workspaceFolder}/src",
--                             -- "/app" = "${workspaceFolder}/src/<YOUR PROJECT TO DEBUG>"
--                         }
--                     }
--                           -- {
--                           --       type = "dnetcs",
--                           --       request = "attach",
--                           --       mode = "remote",
--                           --       name = "Remote Attached Debugger: Skaffold",
--                           --       dlvToolPath = os.getenv('HOME') .. "/go/bin/dlv",  -- Or wherever your local delve lives.
--                           --       remotePath = ${where_your_local_copy_of_the_code_in_your_container_lives},
--                           --       port = ${your_exposed_container_port},
--                           --       cwd = vim.fn.getcwd(),
--                           -- }
--                 }
--             }
--         )
--     else
--         dap_install.config(debugger)
--     end
-- end
--

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
