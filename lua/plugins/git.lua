return {
    -- git
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            {
                "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit"
            }
        }
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            -- Only one of these is needed.
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua",              -- optional
            "echasnovski/mini.pick",         -- optional
            'lewis6991/gitsigns.nvim'
        },
        config = function ()
            require('gitsigns').setup({
                on_attach = function (bufnr)
                    local gitsigns = require("gitsigns")
                    vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk)
                    vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk)
                end
            })
            require("neogit").setup({
                integrations = {
                    diffview = true
                }
            })
            require("diffview").setup({
                view = {
                    merge_tool = {
                        layout = "diff3_mixed",
                    }
                }
            })
            vim.keymap.set('n', '<leader>gg', "<cmd>Neogit<cr>", {})
            vim.keymap.set('n', '<leader>gl', function ()
                require("neogit").action("log", "log_current", {})()
            end, {})
            vim.keymap.set('n', '<leader>gdd', "<cmd>DiffviewOpen --range origin/dev..HEAD<cr>", {})
            vim.keymap.set('n', '<leader>gdm', "<cmd>DiffviewOpen --range origin/main..HEAD<cr>", {})
            vim.keymap.set('n', '<leader>gdc', "<cmd>DiffviewClose<cr>", {})
        end
    }
}
