-- パッケージマネージャー: lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader キーの設定
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- プラグイン設定
require("lazy").setup({
  "tpope/vim-commentary",
  "tpope/vim-sensible",
  "dominikduda/vim_current_word",
  "ConradIrwin/vim-bracketed-paste",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
  },
  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  "sirasaki-konoha/mpc.vim",
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  "simeji/winresizer",
  "windwp/nvim-autopairs",
})

-- カラースキーム
vim.cmd.colorscheme("kanagawa-paper-ink")

-- mpc.vim キーマップ
vim.keymap.set("n", "<Leader>m", ":MpcPlaylist<CR>", { silent = true })
vim.keymap.set("n", "<Leader>l", ":MpcLibrary<CR>", { silent = true })
vim.keymap.set("n", "<Leader>>", ":MpcPlayNext<CR>", { silent = true })
vim.keymap.set("n", "<Leader><", ":MpcPlayPrev<CR>", { silent = true })

-- nvim-tree (Fern の代替)
require("nvim-tree").setup()
vim.keymap.set("n", "<Leader>e", ":NvimTreeToggle<CR>", { silent = true })

-- Coc 設定
vim.api.nvim_create_autocmd("CursorHoldI", {
  pattern = "*",
  callback = function()
    vim.fn.CocActionAsync("showSignatureHelp")
  end,
})

-- 補完確定
vim.keymap.set("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<CR>"]], { expr = true, silent = true })

-- Tab で補完候補の移動
vim.keymap.set("i", "<TAB>", [[pumvisible() ? "\<C-n>" : "\<TAB>"]], { expr = true, silent = true })
vim.keymap.set("i", "<S-TAB>", [[pumvisible() ? "\<C-p>" : "\<S-TAB>"]], { expr = true, silent = true })

-- LSP 機能
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

-- ホバーで型情報やドキュメントを表示
vim.keymap.set("n", "K", function()
  vim.fn.CocActionAsync("doHover")
end, { silent = true })

-- hlsearch 設定
vim.opt.hlsearch = true
vim.g.vim_current_word_highlight_current_word = 0
vim.g.vim_current_word_highlight_delay = 500

-- インデント設定
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 0

-- nvim-autopairs 設定
require("nvim-autopairs").setup()

-- 追加の Neovim 推奨設定
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.termguicolors = true

