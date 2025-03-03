return {
    -- DAP
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python",
            "nvim-neotest/nvim-nio",
            "leoluz/nvim-dap-go",
        },
        config = function()
            require('dap.ext.vscode').load_launchjs()
            -- require('dap.ext.vscode').json_decode = require'json5'.parse
            --[[
            dap.adapters.java = function(callback)
                -- FIXME:
                -- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
                -- The response to the command must be the `port` used below
                callback({
                    type = 'server';
                    host = '127.0.0.1';
                    port = port;
                })
            end
            ]]

            local dap = require('dap')

            local debugpy_python_path = os.getenv("HOME") .. '/.local/share/nvim/mason/packages/debugpy/venv/bin/python'

            require("dap-python").setup(debugpy_python_path)

            require('dap-go').setup {
                -- Additional dap configurations can be added.
                -- dap_configurations accepts a list of tables where each entry
                -- represents a dap configuration. For more details do:
                -- :help dap-configuration
                dap_configurations = {
                    {
                        -- Must be "go" or it will be ignored by the plugin
                        type = "go",
                        name = "Attach remote",
                        mode = "remote",
                        request = "attach",
                    },
                },
                -- delve configurations
                delve = {
                    -- the path to the executable dlv which will be used for debugging.
                    -- by default, this is the "dlv" executable on your PATH.
                    path = "dlv",
                    -- time to wait for delve to initialize the debug session.
                    -- default to 20 seconds
                    initialize_timeout_sec = 20,
                    -- a string that defines the port to start delve debugger.
                    -- default to string "${port}" which instructs nvim-dap
                    -- to start the process in a random available port
                    port = "${port}",
                    -- additional args to pass to dlv
                    args = {},
                    -- the build flags that are passed to delve.
                    -- defaults to empty string, but can be used to provide flags
                    -- such as "-tags=unit" to make sure the test suite is
                    -- compiled during debugging, for example.
                    -- passing build flags using args is ineffective, as those are
                    -- ignored by delve in dap mode.
                    build_flags = "",
                    -- whether the dlv process to be created detached or not. there is
                    -- an issue on Windows where this needs to be set to false
                    -- otherwise the dlv server creation will fail.
                    detached = true,
                    -- the current working directory to run dlv from, if other than
                    -- the current working directory.
                    cwd = nil,
                },
            }

            vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
            vim.keymap.set('n', '<F6>', function() require('dap').step_over() end)
            vim.keymap.set('n', '<F7>', function() require('dap').step_into() end)
            vim.keymap.set('n', '<F8>', function() require('dap').step_out() end)
            vim.keymap.set('n', '<F9>', function() require('dap').terminate() end)
            vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
            vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
            vim.keymap.set('n', '<Leader>lp',
                function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
            vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
            vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
            vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
                require('dap.ui.widgets').hover()
            end)
            vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
                require('dap.ui.widgets').preview()
            end)
            vim.keymap.set('n', '<Leader>df', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.frames)
            end)
            vim.keymap.set('n', '<Leader>ds', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.scopes)
            end)

            local dapui = require "dapui"
            dapui.setup()

            local function open_in_tab(element)
                local buffer = dapui.elements[element].buffer()
                vim.cmd("tabnew")
                vim.api.nvim_win_set_buf(0, buffer)
            end

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
                -- open_in_tab("console")
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
                -- open_in_tab("console")
            end

            vim.keymap.set({ 'n', 'v' }, '<Leader>du', function()
                dapui.close()
            end)
            -- dap.listeners.before.event_terminated.dapui_config = function()
            --     ui.close()
            -- end
            -- dap.listeners.before.event_exited.dapui_config = function()
            --     ui.close()
            -- end
        end
    },
}
