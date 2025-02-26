return {
    -- disable which key for now
    -- {
    --     "folke/which-key.nvim",
    --     event = "VeryLazy",
    --     keys = {
    --         {
    --             "<leader>?",
    --             function()
    --                 require("which-key").show({ global = false })
    --             end,
    --             desc = "Buffer Local Keymaps (which-key)",
    --         },
    --     },
    --     -- opts = {
    --     --     triggers = {
    --     --         { "<leader>", mode = { "n", "v" } },
    --     --     }
    --     -- }
    -- },
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    "folke/neodev.nvim",
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            local telescope = require('telescope')
            local builtin = require('telescope.builtin')
            telescope.setup {
                defaults = {
                    layout_strategy = 'vertical',
                    layout_config = { height = 0.95 },
                    file_ignore_patterns = {
                        "node_modules", "build", "dist", "yarn.lock"
                    }
                },
                -- pickers = {
                --     find_files = {
                --         find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob", "!**/.git/*" },
                --     },
                -- },
            }
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
            vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})
            vim.keymap.set('n', '<leader>fr', builtin.resume, {})
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require 'nvim-treesitter.configs'.setup {
                -- A list of parser names, or "all"
                ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "java", "python", "go", "yaml" },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            require('lualine').setup({
                options = {
                    icons_enabled = true,
                    theme = 'auto',
                    component_separators = { left = '|', right = '|' },
                    section_separators = { left = '', right = '' },
                }
            })
        end
    },
    {
        "mbbill/undotree",

        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        config = function()
            require("oil").setup({
                default_file_explorer = true
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    }
}
