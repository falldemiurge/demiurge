vim.cmd([[  
  set termguicolors
  set showmatch               " show matching 
  set ignorecase              " case insensitive 
  set mouse=v                 " middle-click paste with 
  set hlsearch                " highlight search 
  set incsearch               " incremental search
  set tabstop=2               " number of columns occupied by a tab 
  set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
  set expandtab               " converts tabs to white space
  set shiftwidth=2            " width for autoindents
  set autoindent              " indent a new line the same amount as the line just typed
  set number                  " add line numbers
  set wildmode=longest,list   " get bash-like tab completions
  set cc=80                  " set an 80 column border for good coding style
  filetype plugin indent on   "allow auto-indenting depending on file type
  syntax on                   " syntax highlighting
  set mouse=a                 " enable mouse click
  set clipboard=unnamedplus   " using system clipboard
  filetype plugin on
  set cursorline              " highlight current cursorline
  set ttyfast                 " Speed up scrolling in Vim
  set autoindent
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

require("lazy").setup({
  "folke/which-key.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
  { "savq/melange-nvim" },
  { "NvChad/nvim-colorizer.lua" },
})

vim.cmd.colorscheme 'melange'

require("colorizer").setup {
    filetypes = { "*" },
    user_default_options = {
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = true, -- "Name" codes like Blue or blue
      RRGGBBAA = false, -- #RRGGBBAA hex codes
      AARRGGBB = false, -- 0xAARRGGBB hex codes
      rgb_fn = false, -- CSS rgb() and rgba() functions
      hsl_fn = false, -- CSS hsl() and hsla() functions
      css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      -- Available modes for `mode`: foreground, background,  virtualtext
      mode = "background", -- Set the display mode.
      -- Available methods are false / true / "normal" / "lsp" / "both"
      -- True is same as normal
      tailwind = false, -- Enable tailwind colors
      -- parsers can contain values used in |user_default_options|
      sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
      virtualtext = "■",
      -- update color values even if buffer is not focused
      -- example use: cmp_menu, cmp_docs
      always_update = false
    },
    -- all the sub-options of filetypes apply to buftypes
    buftypes = {},
}
