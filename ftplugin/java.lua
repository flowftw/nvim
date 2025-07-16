-- print("hello from java")
--
-- local jdtls = require('jdtls')
-- local root_markers = { 'gradlew', '.git' }
-- local root_dir = require('jdtls.setup').find_root(root_markers)
-- local home = os.getenv('HOME')
-- local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
-- local config = {
--     settings = {
--         java = {
--             signatureHelp = { enabled = true },
--             contentProvider = { preferred = 'fernflower' },
--             completion = {
--                 favoriteStaticMembers = {
--                     "org.hamcrest.MatcherAssert.assertThat",
--                     "org.hamcrest.Matchers.*",
--                     "org.hamcrest.CoreMatchers.*",
--                     "org.junit.jupiter.api.Assertions.*",
--                     "java.util.Objects.requireNonNull",
--                     "java.util.Objects.requireNonNullElse",
--                     "org.mockito.Mockito.*"
--                 },
--                 filteredTypes = {
--                     "com.sun.*",
--                     "io.micrometer.shaded.*",
--                     "java.awt.*",
--                     "jdk.*",
--                     "sun.*",
--                 },
--             },
--             sources = {
--                 organizeImports = {
--                     starThreshold = 9999,
--                     staticStarThreshold = 9999,
--                 },
--             },
--             codeGeneration = {
--                 toString = {
--                     template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
--                 },
--                 hashCodeEquals = {
--                     useJava7Objects = true,
--                 },
--                 useBlocks = true,
--             },
--             configuration = {
--                 runtimes = {
--                     {
--                         name = "java-21",
--                         path = "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/",
--                     },
--                 }
--             },
--         },
--     }
-- }
-- config.cmd = {
--     "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/bin/java",
--     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
--     '-Dosgi.bundles.defaultStartLevel=4',
--     '-Declipse.product=org.eclipse.jdt.ls.core.product',
--     '-Dlog.protocol=true',
--     '-Dlog.level=ALL',
--     '-Xmx4g',
--     '--add-modules=ALL-SYSTEM',
--     '--add-opens', 'java.base/java.util=ALL-UNNAMED',
--     '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
--     '-jar', vim.fn.glob(home ..
--     '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
--     '-configuration', home .. '/.local/share/nvim/mason/packages/jdtls/config_mac_arm',
--     '-data', workspace_folder,
-- }
-- config.on_attach = function(client, bufnr)
--     jdtls.setup_dap({ hotcodereplace = 'auto' })
--     jdtls.setup.add_commands()
--     local opts = { silent = true, buffer = bufnr }
--     vim.keymap.set('n', "<A-o>", jdtls.organize_imports, opts)
--     vim.keymap.set('n', "<leader>df", jdtls.test_class, opts)
--     vim.keymap.set('n', "<leader>dn", jdtls.test_nearest_method, opts)
--     vim.keymap.set('n', "crv", jdtls.extract_variable, opts)
--     vim.keymap.set('v', 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
--     vim.keymap.set('n', "crc", jdtls.extract_constant, opts)
-- end
--
-- local jar_patterns = {
--     home .. '/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar',
--     -- not used for now?
--     -- '/dev/dgileadi/vscode-java-decompiler/server/*.jar',
--     home .. '/.local/share/nvim/mason/packages/java-test/extension/server/com.microsoft.java.test.plugin-*.jar',
--     home ..
--     '/.local/share/nvim/mason/packages/java-test/extension/server/com.microsoft.java.test.runner-jar-with-dependencies.jar',
--     -- '/.local/share/nvim/mason/packages/java-test/extension/server/com.microsoft.java.test.runner/lib/*.jar',
--     -- '/dev/testforstephen/vscode-pde/server/*.jar'
-- }
-- -- npm install broke for me: https://github.com/npm/cli/issues/2508
-- -- So gather the required jars manually; this is based on the gulpfile.js in the vscode-java-test repo
-- -- local plugin_path =
-- -- '/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.plugin.site/target/repository/plugins/'
-- local plugin_path = home .. "/.local/share/nvim/mason/packages/java-test/extension/server/"
-- local bundle_list = vim.tbl_map(
--     function(x) return require('jdtls.path').join(plugin_path, x) end,
--     {
--         'org.eclipse.jdt.junit4.runtime_*.jar',
--         'org.eclipse.jdt.junit5.runtime_*.jar',
--         'junit-jupiter-api*.jar',
--         'junit-jupiter-engine*.jar',
--         'junit-jupiter-migrationsupport*.jar',
--         'junit-jupiter-params*.jar',
--         'junit-vintage-engine*.jar',
--         'org.opentest4j*.jar',
--         'junit-platform-commons*.jar',
--         'junit-platform-engine*.jar',
--         'junit-platform-launcher*.jar',
--         'junit-platform-runner*.jar',
--         'junit-platform-suite-api*.jar',
--         'org.apiguardian*.jar'
--     }
-- )
-- vim.list_extend(jar_patterns, bundle_list)
-- local bundles = {}
-- for _, jar_pattern in ipairs(jar_patterns) do
--     for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), '\n')) do
--         if not vim.endswith(bundle, 'com.microsoft.java.test.runner-jar-with-dependencies.jar')
--             and not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
--             table.insert(bundles, bundle)
--         end
--     end
-- end
-- local extendedClientCapabilities = jdtls.extendedClientCapabilities;
-- extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;
-- config.init_options = {
--     bundles = bundles,
--     extendedClientCapabilities = extendedClientCapabilities,
-- }
-- -- mute; having progress reports is enough
-- config.handlers['language/status'] = function() end
-- jdtls.start_or_attach(config)
--

local home = os.getenv('HOME')
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local install_path = home .. "/.local/share/nvim/mason/packages/jdtls/"

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {

        -- 💀
        '/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/bin/java', -- or '/path/to/java21_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        "-javaagent:" .. install_path .. "lombok.jar",

        -- 💀
        '-jar', vim.fn.glob(install_path .. 'plugins/org.eclipse.equinox.launcher_*.jar'),
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
        -- Must point to the                                                     Change this to
        -- eclipse.jdt.ls installation                                           the actual version


        -- 💀
        '-configuration', vim.fn.glob(install_path .. 'config_mac_arm'),
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        -- Must point to the                      Change to one of `linux`, `win` or `mac`
        -- eclipse.jdt.ls installation            Depending on your system.


        -- 💀
        -- See `data directory configuration` section in the README
        '-data', workspace_folder,
    },

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    --
    -- vim.fs.root requires Neovim 0.10.
    -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
    root_dir = vim.fs.root(0, { "gradlew", ".mvnw", ".git" }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
        }
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = {}
    },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
