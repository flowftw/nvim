return {
    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v4.x',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            {
                'L3MON4D3/LuaSnip',
                version = "v2.*",
                dependencies = {
                    "rafamadriz/friendly-snippets"
                }
            }
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
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                    { name = 'path' },
                }),
            })

            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })

            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
                { border = 'rounded' })

            vim.diagnostic.config { float = { border = 'rounded' } }

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
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                end,
            })

            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig({})
            lsp_zero.format_mapping('<F3>', {
                servers = {
                    ['ruff'] = { 'python' },
                }
            })


            -- to learn how to use mason.nvim with lsp-zero
            -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
            require('mason').setup({})

            require('mason-lspconfig').setup({
                ensure_installed = { 'jdtls' },
                handlers = {
                    lsp_zero.default_setup,
                    jdtls = lsp_zero.noop,
                    lua_ls = function()
                        require('lspconfig').lua_ls.setup({
                            on_init = function(client)
                                lsp_zero.nvim_lua_settings(client, {})
                            end,
                        })
                    end,
                    gopls = function()
                        require 'lspconfig'.gopls.setup({
                            settings = {
                                gopls = {
                                    buildFlags = { "-tags=pki" }
                                },
                            }
                        })
                    end,
                    -- pyright = function()
                    --     require 'lspconfig'.pyright.setup({
                    --         settings = {
                    --             python = {
                    --                 analysis = {
                    --                     typeCheckingMode = "off",
                    --                     autoSearchPaths = true,
                    --                     diagnosticMode = "workspace",
                    --                     useLibraryCodeForTypes = true
                    --                 }
                    --             }
                    --         }
                    --     })
                    -- end,
                    basedpyright = function()
                        require 'lspconfig'.basedpyright.setup({
                            settings = {
                                python = {
                                    analysis = {
                                        typeCheckingMode = "off",
                                        autoSearchPaths = true,
                                        diagnosticMode = "workspace",
                                        useLibraryCodeForTypes = true
                                    }
                                }
                            }
                        })
                    end,
                    ruff = function()
                        require 'lspconfig'.ruff.setup({})
                    end
                }
            })
        end
    },
}
