return {
    -- LSP
    {
        'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
            'mfussenegger/nvim-ansible',
            'mfussenegger/nvim-jdtls',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            {
                'L3MON4D3/LuaSnip',
                version = "v2.*",
                dependencies = {
                    "rafamadriz/friendly-snippets"
                }
            },
            'rcarriga/cmp-dap'
        },
        config = function()
            local cmp = require('cmp')
            require('luasnip')
            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
                    end,
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-x><C-o>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                    { name = 'path' },
                }),
                enabled = function()
                    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
                        or require("cmp_dap").is_dap_buffer()
                end
            })

            require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
                sources = {
                    { name = "dap" },
                },
            })

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            local lspconfig_defaults = require('lspconfig').util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lspconfig_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )

            -- This is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'grr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
                    vim.keymap.set('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({ 'n', 'x' }, 'grf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                end,
            })

            -- to learn how to use mason.nvim with lsp-zero
            -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
            require('mason').setup({})

            require('mason-lspconfig').setup({
                ensure_installed = { 'jdtls' },
                automatic_enable = {
                    exclude = {
                        "jdtls"
                    }
                }
            })

            vim.lsp.config('lua_ls', {})

            vim.lsp.config('basedpyright', {
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "off",
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            useLibraryCodeForTypes = true
                        }
                    }
                }
            })

            vim.lsp.config('ruff', {})

            vim.lsp.config('gopls', {
                settings = {
                    gopls = {
                        buildFlags = { "-tags=pki" }
                    },
                }
            })

            -- TODO: maybe 
            -- local root_dir = vim.fs.root(0, { '.git', { 'build.gradle.kts', 'build.gradle', '.gradlew', '.mvnw' } })
            -- local home = os.getenv('HOME')
            -- local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
            -- local install_path = home .. "/.local/share/nvim/mason/packages/jdtls/"
            -- vim.lsp.config("jdtls", {
            --     settings = {
            --         java = {
            --             -- Custom eclipse.jdt.ls options go here
            --             cmd = {
            --                 -- 💀
            --                 '/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/bin/java', -- or '/path/to/java21_or_newer/bin/java'
            --                 -- depends on if `java` is in your $PATH env variable and if it points to the right version.
            --
            --                 '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            --                 '-Dosgi.bundles.defaultStartLevel=4',
            --                 '-Declipse.product=org.eclipse.jdt.ls.core.product',
            --                 '-Dlog.protocol=true',
            --                 '-Dlog.level=ALL',
            --                 '-Xmx1g',
            --                 '--add-modules=ALL-SYSTEM',
            --                 '--add-opens', 'java.base/java.util=ALL-UNNAMED',
            --                 '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
            --                 "-javaagent:" .. install_path .. "lombok.jar",
            --
            --                 -- 💀
            --                 '-jar', vim.fn.glob(install_path .. 'plugins/org.eclipse.equinox.launcher_*.jar'),
            --                 -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
            --                 -- Must point to the                                                     Change this to
            --                 -- eclipse.jdt.ls installation                                           the actual version
            --
            --
            --                 -- 💀
            --                 '-configuration', vim.fn.glob(install_path .. 'config_mac_arm'),
            --                 -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
            --                 -- Must point to the                      Change to one of `linux`, `win` or `mac`
            --                 -- eclipse.jdt.ls installation            Depending on your system.
            --
            --
            --                 -- 💀
            --                 -- See `data directory configuration` section in the README
            --                 '-data', workspace_folder,
            --             },
            --             root_dir = vim.fs.root(0, { '.git', { 'build.gradle.kts', 'build.gradle', '.gradlew', '.mvnw' } }),
            --         },
            --     },
            -- })
            -- vim.lsp.enable("jdtls")
            --
        end
    },
}
