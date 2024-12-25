-- Leader Key
vim.g.mapleader = " " -- Set Leader Key to Space

-- Lines Enable
vim.o.number = true

-- Plugins Setup
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  -- Plugin Manager
  use 'wbthomason/packer.nvim'

  -- LSP and Completion
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'

  -- Treesitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- File Navigation
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'

  -- Buffers and Tabs
  use 'akinsho/bufferline.nvim'

  -- Django Utilities
  use 'tweekmonster/django-plus.vim'

  -- Snippets
  use 'saadparwaiz1/cmp_luasnip'
	
  -- Theme 
  use 'folke/tokyonight.nvim'

  -- Automatically set up configuration after cloning Packer
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Mason Configuration
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { "pyright", "html", "cssls", "ts_ls", "tailwindcss" }
})
-- Theme enable
--vim.cmd("colorscheme tokyonight")

-- LSP Configuration
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local capabilities = cmp_nvim_lsp.default_capabilities()

local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Keybindings 
 vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
end

-- LSP Servers
local servers = { "pyright", "html", "cssls", "ts_ls", "tailwindcss" }
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Additional LSP Server Settings
lspconfig.pyright.setup {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
      }
    }
  }
}

-- Treesitter Configuration
require('nvim-treesitter.configs').setup {
  ensure_installed = { "python", "html", "css", "javascript", "json" },
  highlight = { enable = true },
}

-- Snippets
require('luasnip.loaders.from_vscode').lazy_load()

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if require('luasnip').expand_or_jumpable() then
    require('luasnip').expand_or_jump()
  else
    return "<Tab>"
  end
end, { silent = true, expr = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if require('luasnip').jumpable(-1) then
    require('luasnip').jump(-1)
  else
    return "<S-Tab>"
  end
end, { silent = true, expr = true })

-- Telescope Configuration
require('telescope').setup{
  defaults = {
    file_ignore_patterns = { "migrations" },
  },
}

vim.keymap.set('n', '<Leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>fh', ':Telescope help_tags<CR>', { noremap = true, silent = true })

-- Nvim Tree Configuration
require('nvim-tree').setup()

vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Bufferline Configuration
require('bufferline').setup {
  options = {
    diagnostics = "nvim_lsp",
    offsets = {
      { filetype = "NvimTree", text = "File Explorer", text_align = "left" }
    },
  }
}

vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

-- Autocompletion (nvim-cmp)
local cmp = require('cmp')

cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'luasnip' },
  },
}

 vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true })
 vim.keymap.set('n', '<Leader>q', ':q<CR>', { noremap = true, silent = true })
vim.cmd("colorscheme tokyonight")  -- Set the colorscheme
 
