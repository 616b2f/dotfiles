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
    local adapter_config = {
        type = 'executable',
        command = 'netcoredbg',
        args = {'--interpreter=vscode'}
    }
    -- neotest-dotnet needs 'netcoredbg'
    dap.adapters.netcoredbg = adapter_config
    dap.adapters.coreclr = adapter_config

    dap.adapters.skaffold = function(cb, config)
      if config.request == 'attach' then
        -- ---@diagnostic disable-next-line: undefined-field
        -- local port = (config.connect or config).port
        -- ---@diagnostic disable-next-line: undefined-field
        -- local host = (config.connect or config).host or '127.0.0.1'
        -- cb({
        --   type = 'server',
        --   port = assert(port, '`connect.port` is required for a python `attach` configuration'),
        --   host = host,
        --   options = {
        --     source_filetype = 'python',
        --   },
        -- })
      else -- launch part
        local name_of_pod = "<NAME_OF_YOUR_POD>"
        local kube_context = "<my_kube_context>"
        cb({
          type = 'server',
          command = 'kubectl',
          pipeCwd = "${workspaceFolder}",
          debuggerPath = "/dbg/netcore/vsdbg", -- location where vsdbg binary installed.
          args = {
            "--context=" .. kube_context
            "exec",
            "-i",
            name_of_pod, -- name of the pod you debug.
            "--"
          },
          options = {
            source_filetype = 'cs',
          },
        })
      end
    end

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = function()
                return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
            env = {
              ASPNETCORE_ENVIRONMENT = function()
                  return "Development"
              end
            },
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
            -- mode = "local",
            -- cwd = "${workspaceFolder}",
            processId  = require('dap.utils').pick_process,
            args = {}
            -- justMyCode = true, -- set to `true` in debug configuration and `false` in release configuration
        },
        {
            name = "Skaffold Debug",
            type = "skaffold",
            request = "attach",
            processId  = 1,
            justMyCode = true, -- set to `true` in debug configuration and `false` in release configuration
            pipeTransport = function()

            end,
            sourceFileMap = {
                -- Change this mapping if your app in not deployed in /src or /app in your docker image
                ["/src"] = "${workspaceFolder}",
                ["/app"] = "${workspaceFolder}"
                -- May also be like this, depending of your repository layout
                -- "/src" = "${workspaceFolder}/src",
                -- "/app" = "${workspaceFolder}/src/<YOUR PROJECT TO DEBUG>"
            }
        }
    }
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
