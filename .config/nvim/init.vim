set number
set nowrap

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

" completion plugin based on lsp servers
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" snippets for pop-ups
Plug 'L3MON4D3/LuaSnip'

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


call plug#end()

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
  ensure_installed = { "go", "python", "lua", "vim", "vimdoc", "query", "typescript", "yaml", "bash" },

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
require("mason-lspconfig").setup()

-- Setup language servers.
local lspconfig = require('lspconfig')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map('n', '<leader>vd', vim.diagnostic.open_float)
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
	-- REQUIRED - you must specify a snippet engine
	expand = function(args)
	require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
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
['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
{ name = 'nvim_lsp' },
{ name = 'luasnip' }, -- For luasnip users.
}, {
	{ name = 'buffer' },
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
	{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = 'buffer' },
	})
	})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
	})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
	{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
	})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['gopls'].setup {
	capabilities = capabilities
}
require('lspconfig')['lua_ls'].setup {
	capabilities = capabilities
}
require('lspconfig')['ts_ls'].setup {
	capabilities = capabilities
}
require('lspconfig')['ruff'].setup {
	capabilities = capabilities
}
require('lspconfig')['pyright'].setup {
	capabilities = capabilities
}
require('lspconfig')['html'].setup {
	capabilities = capabilities
}
require('lspconfig').gopls.setup({
    settings = {
        gopls = {
            gofumpt = true
        }
    }
})


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

require('lint').linters_by_ft = {
	go = {'golangcilint',},
	python = {'flake8',},
	bash = {'shellcheck',},
	shell = {'shellcheck',},
	lua = {'luacheck',},
}

local golint = require('lint').linters.golangcilint
golint.args = {
	'--timeout=10m', '--disable-all', '-E=misspell',
        '-E=govet', '-E=revive', '-E=gofumpt', '-E=gosec', '-E=unparam',
        '-E=goconst', '-E=prealloc', '-E=stylecheck', '-E=unconvert',
        '-E=errcheck', '-E=ineffassign', '-E=unused', '-E=tparallel',
        '-E=whitespace', '-E=staticcheck', '-E=gosimple', '-E=gocritic',
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black", "autoflake" },
    go = { "gofumpt", "goimports" },
    bash = { "shellharden" },
    shell = { "shellharden" },
  },
   format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

require("nvim-surround").setup()

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

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
			[vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'ﬀ'},
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

EOF
