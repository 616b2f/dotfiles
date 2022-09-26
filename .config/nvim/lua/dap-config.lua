local dap = require('dap')
local reg = require('mason-registry')

local netcoredbg = reg.get_package('netcoredbg')

dap.adapters.coreclr = {
  type = 'executable',
  command = netcoredbg:get_install_path(), --'/path/to/dotnet/netcoredbg/netcoredbg',
  args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}

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
