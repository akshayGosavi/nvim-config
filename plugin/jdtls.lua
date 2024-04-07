local java_cmds = vim.api.nvim_create_augroup('java_cmds', {clear = true})
local cache_vars = {}

-- nvim-jdtls will look for these files/folders to determine the root directory of your project
local root_files = {
  '.git',
  'mvnw',
  'pom.xml',
}

local features = {
  codelens = false,
  debugger = false,
}

local function get_jdtls_paths()
  if cache_vars.paths then
    return cache_vars.paths
  end

  local path = {}
  path.data_dir = vim.fn.stdpath('cache')..'/nvim-jdtls'

  local jdtls_install = require('mason-registry').get_package('jdtls'):get_install_path()
  path.java_agent = jdtls_install..'/lombok.jar'
  path.launcher_jar = vim.fn.glob(jdtls_install..'/plugins/org.eclipse.equinox.launcher_*.jar')

  if vim.fn.has('mac') == 1 then
    path.platform_config = jdtls_install..'/config_mac'
  end

  path.bundles = {}

  -- add java-test bundle if present
  local java_test_path = require('mason-registry').get_package('java-test'):get_install_path()
  local java_test_bundle = vim.split(vim.fn.glob(java_test_path..'/extension/server/*.jar'), '\n')

  if java_test_bundle[1] ~= '' then
    vim.list_extend(path.bundles, java_test_bundle)
  end

  -- add java-debug-adaptor if present

  local java_debug_path = require('mason-registry').get_package('java-debug-adapter'):get_install_path()
  local java_debug_bundle = vim.split(vim.fn.glob(java_debug_path..'/extension/server/com.microsoft.java.debug.plugin-*.jar'), '\n')

  if java_debug_bundle[1] ~= '' then
    vim.list_extend(path.bundles, java_debug_bundle)
  end

  -- if you are starting jdtls with different java version than one that project uses
  path.runtimes = {
    --{
    --  name = 'JavaSE-17',
    --  path = vim.fn.expand('~/.sdkman/candidates/java/17.0.6-tem')
    --}
  }
  cache_vars.path = path

  return path
end

-- this function will get executed everytime jdtls gets attached to a file
local function jdtls_on_attach(client, bufnr)
  if features.debugger then 
    enable_debugger(bufnr)
  end

  if features.codelens then
    enable_codelenses(bufnr)
  end

  vim.keymap.set('n', '<A-o>', "<cmd>lua require('jdtls').organize_imports()<CR>", { noremap = true, silent = true, buffer = bufnr })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true, buffer = bufnr, desc = 'Hover' })
  vim.keymap.set('n', '<space>K', vim.lsp.buf.signature_help, { noremap = true, silent = true, buffer = bufnr, desc = 'Signature Help' })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { noremap = true, silent = true, buffer = bufnr, desc = 'Goto [D]eclaration' })
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { noremap = true, silent = true, buffer = bufnr, desc = 'Rename' })
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { noremap = true, silent = true, buffer = bufnr, desc = '[R]ename' })
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, buffer = bufnr, desc = '[C]ode [A]ctions' })
  vim.keymap.set('n', '<space>fm', vim.lsp.buf.format, { noremap = true, silent = true, buffer = bufnr, desc = '[F]ormat' })
  --vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, {buffer = bufnr, desc = 'Open diagnostics'})
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = bufnr, desc = 'Previous diagnostic'})
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = bufnr, desc = 'Next diagnostic'})
  vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { noremap = true, silent = true, buffer = bufnr, desc = '[D]ocument [S]ymbol' })
  vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { noremap = true, silent = true, buffer = bufnr, desc = '[W]orkspace [S]ymbol' })
  -- using vim's builtin lsp
  --vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true, buffer = bufnr, desc = '[D]efinition' })
  --vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true, buffer = bufnr, desc = '[R]eference' })
  --vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap = true, silent = true, buffer = bufnr, desc = '[I]mplementation' })
  --vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { noremap = true, silent = true, buffer = bufnr, desc = '[T]ype Definition' })
  -- same keymaps but with telescope
  vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { noremap = true, silent = true, buffer = bufnr, desc = '[D]efinition' })
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references , { noremap = true, silent = true, buffer = bufnr, desc = '[R]eference' })
  vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, { noremap = true, silent = true, buffer = bufnr, desc = '[I]mplementation' })
  vim.keymap.set('n', 'gt', require('telescope.builtin').lsp_type_definitions, { noremap = true, silent = true, buffer = bufnr, desc = '[T]ype Definition' })
end

-- this function will execute everytime you open a Java file
local function jdtls_setup(event)
  local jdtls = require('jdtls')
  local path = get_jdtls_paths()
  local data_dir = path.data_dir..'/'..vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

  local cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:'..path.java_agent,
    '-Xmx1G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    path.launcher_jar,
    '-configuration',
    path.platform_config,
    '-data',
    data_dir,
  }

  local lsp_settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = path.runtimes,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      format = {
        enabled = true,
      }
    },
    signatureHelp = {
      enabled = true
    },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
      filteredTypes = {
        'com.sun.*',
        'java.awt.*',
        'jdk.*',
        'sun.*',
      }
    },
    contentProvider = {
      preferred = 'fernflower',
    },
    extendedClientCapabilitites = jdtls.extendedClientCapabilties,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      }
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    }
  }

  local config = {
    cmd = cmd,
    settings = lsp_settings,
    root_dir = jdtls.setup.find_root(root_files),
    on_attach = jdtls_on_attach,
    capabilities = cache_vars.capabilities,
    flags = {
      allow_incemental_sync = true ,
    },
    init_options = {
      bundles = path.bundles,
    }
  }

  jdtls.setup.add_commands();
  jdtls.start_or_attach(config)
end

vim.api.nvim_create_autocmd('FileType', {
  group = java_cmds,
  pattern = {'java'},
  desc = 'Setup jdtls',
  callback = jdtls_setup,
})

