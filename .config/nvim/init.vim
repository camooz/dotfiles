set number
set nowrap
set nohlsearch
set relativenumber
set ruler

call plug#begin()

" greeter
Plug 'echasnovski/mini.starter'

" bar at bottom of nvim
Plug 'itchyny/lightline.vim'

" colorscheme
Plug 'rebelot/kanagawa.nvim'

" highlight colors
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" dependency for telescope
Plug 'nvim-lua/plenary.nvim'

" fuzzy finder
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

" package manager for lsp, dap, formatters, linters etc.
Plug 'williamboman/mason.nvim'

" integration with lspconfig
Plug 'williamboman/mason-lspconfig.nvim'

" support for lsp servers
Plug 'neovim/nvim-lspconfig'

" support for linters
Plug 'mfussenegger/nvim-lint'

" support for formatters
Plug 'stevearc/conform.nvim'

" support for debuggers
Plug 'mfussenegger/nvim-dap'

" extension for nvim-dap
Plug 'leoluz/nvim-dap-go'

Plug 'nvim-neotest/nvim-nio'

Plug 'rcarriga/nvim-dap-ui'

" completion plugin based on lsp servers
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'rafamadriz/friendly-snippets'

" snippets for pop-ups
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}

" integrate completions with snippets
Plug 'saadparwaiz1/cmp_luasnip'

" autoclosing of brackets, braces etc.
Plug 'm4xshen/autoclose.nvim'

Plug 'kylechui/nvim-surround'

Plug 'nvim-tree/nvim-tree.lua'

Plug 'nvim-tree/nvim-web-devicons'

Plug 'roobert/search-replace.nvim'

Plug 'lewis6991/gitsigns.nvim' " OPTIONAL: for git status

Plug 'romgrk/barbar.nvim'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

Plug 'kdheepak/lazygit.nvim'

Plug 'm4xshen/hardtime.nvim'

Plug 'folke/trouble.nvim'

Plug 'rcarriga/nvim-notify'

Plug 'renerocksai/telekasten.nvim'

Plug 'MeanderingProgrammer/render-markdown.nvim'

call plug#end()

set termguicolors
colorscheme kanagawa

lua << EOF

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set leader to space
vim.g.mapleader = ' '

local function map(m, k, v)
	vim.keymap.set(m, k, v, { noremap = true, silent = true })
end

-- exit insert mode faster
map('i', 'jk', '<ESC>')
map('i', 'kj', '<ESC>')

-- maintain cursor in the center while ctrl + u/d
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- search text
map('n', '<leader>s', '/')

-- save current buffer
map('n', '<leader>w', '<CMD>update<CR>')

-- quit
map('n', '<leader>q', '<CMD>q<CR>')

-- quit and save
map('n', '<leader>wq', '<CMD>wq<CR>')

-- better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- vertical split
map("n", "<leader>vs", "<C-w>v")
vim.notify = require("notify")

-- keybindings for telescope
require('telescope').setup({
	pickers = {
		find_files = {
			no_ignore = true,
			no_ignore_parent = true,
			follow = true,
		}
	}
})

local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files)
map('n', '<leader>fs', builtin.current_buffer_fuzzy_find)
map('n', '<leader>fg', builtin.live_grep)
map('n', '<leader>fb', builtin.buffers)
map('n', '<leader>fh', builtin.help_tags)
map('n', '<leader>ld', builtin.diagnostics)

-- lazygit
map('n', '<leader>gg', ':LazyGit<CR>')

require('mini.starter').setup()

-- treesitter minimal config
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "python", "lua", "vim", "vimdoc", "query", "typescript", "yaml", "bash", "vala", "ron", "proto" },

  highlight = {
    enable = true,
  },
}

local opts = {
	ensure_installed = {
		-- Go
		'gopls',
		'gofumpt',
		'goimports',
		'golangci-lint',
		-- Lua
		'lua-language-server',
		'luacheck',
		'stylua',
		-- Python
		'ruff',
		'pyright',
		-- Bash
		'shellharden',
		'shfmt',
		-- YAML
		'yamlfmt',
		'yamllint',
	},
}
-- mason and masonlspconfig plugin
require("mason").setup(opts)

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    source = true,
  },
  severity_sort = true,
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- map('n', '<leader>vd', vim.diagnostic.open_float)
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<leader>ad', ':lua vim.diagnostic.setqflist()<CR>')

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
	expand = function(args)
	require('luasnip').lsp_expand(args.body)
	end,
	},
window = {
	completion = cmp.config.window.bordered(),
	documentation = cmp.config.window.bordered(),
	},
mapping = cmp.mapping.preset.insert({
['<C-b>'] = cmp.mapping.scroll_docs(-4),
['<C-f>'] = cmp.mapping.scroll_docs(4),
['<C-Space>'] = cmp.mapping.complete(),
['<C-e>'] = cmp.mapping.abort(),
['<Tab>'] = cmp.mapping.confirm({ select = true }),
}),
sources = cmp.config.sources({
{ name = 'nvim_lsp' },
{ name = 'luasnip' },
}, {
	{ name = 'buffer' },
})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('gopls', { capabilities = capabilities }) 
vim.lsp.config('lua_ls', { capabilities = capabilities }) 
vim.lsp.config('ts_ls', { capabilities = capabilities }) 
vim.lsp.config('ruff', { capabilities = capabilities }) 
vim.lsp.config('pyright', { capabilities = capabilities }) 

vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('ruff')
vim.lsp.enable('pyright')

require("luasnip.loaders.from_vscode").lazy_load()

-- autoclose plugin
require("autoclose").setup({
   keys = {
      ["("] = { escape = false, close = true, pair = "()" },
      ["["] = { escape = false, close = true, pair = "[]" },
      ["{"] = { escape = false, close = true, pair = "{}" },

      [">"] = { escape = true, close = false, pair = "<>" },
      [")"] = { escape = true, close = false, pair = "()" },
      ["]"] = { escape = true, close = false, pair = "[]" },
      ["}"] = { escape = true, close = false, pair = "{}" },

      ['"'] = { escape = true, close = true, pair = '""' },
      ["'"] = { escape = true, close = true, pair = "''" },
      ["`"] = { escape = true, close = true, pair = "``" },
   },
   options = {
      disabled_filetypes = { "text" },
      disable_when_touch = false,
      touch_regex = "[%w(%[{]",
      pair_spaces = true,
      auto_indent = true,
      disable_command_mode = false,
   },
})

-- Linter configuration
require('lint').linters_by_ft = {
	go = {'golangcilint',},
	python = {'ruff',},
	shell = {'shellcheck',},
	lua = {'luacheck',},
	yaml = {'yamllint',},
}

local golangcilint = require("lint.linters.golangcilint")
golangcilint.args = (function()
  local ok, value = pcall(vim.fn.system, { 'golangci-lint', 'version' })
  if ok and (string.find(value, 'version v2') or string.find(value, 'version 2')) then
    return {
      'run',
      '--output.json.path=stdout',
      '--issues-exit-code=0',
      '--show-stats=false',
      function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
      end,
    }
  else
    return {
      'run',
      '--out-format',
      'json',
      '--issues-exit-code=0',
      '--show-stats=false',
      '--print-issued-lines=false',
      '--print-linter-name=false',
      function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
      end,
    }
  end
end)(),

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})

-- Formatter configuration
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff", },
    go = { "gofumpt", "goimports" },
    sh = { "shellharden", "shfmt" },
    yaml = { "yamlfmt" },
  },
   format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- Debugger configuration
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
    -- to start the process in a random available port.
    -- if you set a port in your debug configuration, its value will be
    -- assigned dynamically.
    port = "${port}",
    -- additional args to pass to dlv
    args = {},
    -- the build flags that are passed to delve.
    -- defaults to empty string, but can be used to provide flags
    -- such as "-tags=unit" to make sure the test suite is
    -- compiled during debugging, for example.
    -- passing build flags using args is ineffective, as those are
    -- ignored by delve in dap mode.
    -- avaliable ui interactive function to prompt for arguments get_arguments
    build_flags = {},
    -- whether the dlv process to be created detached or not. there is
    -- an issue on delve versions < 1.24.0 for Windows where this needs to be
    -- set to false, otherwise the dlv server creation will fail.
    -- avaliable ui interactive function to prompt for build flags: get_build_flags
    detached = vim.fn.has("win32") == 0,
    -- the current working directory to run dlv from, if other than
    -- the current working directory.
    cwd = nil,
  },
  -- options related to running closest test
  tests = {
    -- enables verbosity when running the test.
    verbose = false,
  },
}

map("n", "<leader>db", "<CMD>DapToggleBreakpoint<CR>")

map("n", "<leader>dt", function()
	require('dap-go').debug_test()
end)

map("n", "<leader>dgl", function()
	require('dap-go').debug_last()
end)

-- continue until next breaking point
map("n", "<leader>dc", function()
	require('dap-go').debug_continue()
end)

-- go one step further on execution [d(ebugger)n(ext)]
map("n", "<leader>dn", function()
	require('dap-go').debug_step_over()
end)

-- go one step back on execution [d(ebugger)p(revious)]
map("n", "<leader>dp", function()
	require('dap-go').debug_step_back()
end)

require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

require("nvim-surround").setup()

require("nvim-tree").setup()

map("n", "<leader>e", ":NvimTreeToggle<cr>")

require("search-replace").setup({
  default_replace_single_buffer_options = "gcI",
  default_replace_multi_buffer_options = "egcI",
})

map("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>")
map("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>")
map("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>")

map("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>")
map("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>")
map("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>")
map("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>")
map("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>")
map("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>")

map("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>")
map("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>")
map("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>")
map("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>")
map("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>")
map("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>")

-- show the effects of a search / replace in a live preview window
vim.o.inccommand = "split"

require("barbar").setup({
	animation = false,
	tabpages = true,
	icons = {
		-- Configure the base icons on the bufferline.
		-- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
		buffer_index = false,
		buffer_number = false,
		button = '',
		-- Enables / disables diagnostic symbols
		diagnostics = {
			[vim.diagnostic.severity.ERROR] = {enabled = true, icon = '!'},
			[vim.diagnostic.severity.WARN] = {enabled = false},
			[vim.diagnostic.severity.INFO] = {enabled = false},
			[vim.diagnostic.severity.HINT] = {enabled = true},
		},
		gitsigns = {
			added = {enabled = true, icon = '+'},
			changed = {enabled = true, icon = '~'},
			deleted = {enabled = true, icon = '-'},
		},
		filetype = {
			-- Sets the icon's highlight group.
			-- If false, will use nvim-web-devicons colors
			custom_colors = false,

			-- Requires `nvim-web-devicons` if `true`
			enabled = true,
		},
		separator = {left = '▎', right = ''},

		-- If true, add an additional separator at the end of the buffer list
		separator_at_end = true,

		-- Configure the icons on the bufferline when modified or pinned.
		-- Supports all the base icon options.
		modified = {button = '●'},
		pinned = {button = '', filename = true},

		-- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
		preset = 'default',

		-- Configure the icons on the bufferline based on the visibility of a buffer.
		-- Supports all the base icon options, plus `modified` and `pinned`.
		alternate = {filetype = {enabled = false}},
		current = {buffer_index = true},
		inactive = {button = '×'},
		visible = {modified = {buffer_number = false}},
		},
})

map('n', '<A-h', '<Cmd>BufferPrevious<CR>')
map('n', '<A-l', '<Cmd>BufferNext<CR>')
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>')
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>')
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>')
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
map('n', '<A-0>', '<Cmd>BufferLast<CR>')
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>')
-- Close buffer
map('n', '<A-q>', '<Cmd>BufferClose<CR>')
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>')
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>')
map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>')
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>')
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>')
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>')

require('hardtime').setup()

require('trouble').setup()
map('n', '<leader>vd', '<cmd>Trouble diagnostics toggle<cr>')

require('telekasten').setup({
  home = vim.fn.expand("~/personal/zk"), -- Put the name of your notes directory here
})

-- Launch panel if nothing is typed after <leader>z
vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")

-- Most used functions
vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")

-- Call insert link automatically when we start typing a link
vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")

EOF
