-- lazy.nvim
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
  {
  "j-hui/fidget.nvim",
    opts = {
    },
  },
  "ConradIrwin/vim-bracketed-paste",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- Mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
        },
        automatic_installation = true,
      })
    end,
  },
  -- LSP設定
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- LSPサーバーが起動したときのキーバインド設定
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        
        -- LSP機能のキーマップ
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<Leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
        
        -- シグネチャヘルプを自動表示
        if client.server_capabilities.signatureHelpProvider then
          vim.api.nvim_create_autocmd("CursorHoldI", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.signature_help()
            end,
          })
        end
      end

      -- Mason-lspconfigで自動的にLSPサーバーを設定
      require("mason-lspconfig").setup()
    end,
  },
  -- 補完プラグイン
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- nvim-cmp と nvim-autopairs の連携
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  "simeji/winresizer",
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
})

-- カラースキーム
vim.cmd.colorscheme "catppuccin-mocha"

-- mpc.vim キーマップ
vim.keymap.set("n", "<Leader>m", ":MpcPlaylist<CR>", { silent = true })
vim.keymap.set("n", "<Leader>l", ":MpcLibrary<CR>", { silent = true })
vim.keymap.set("n", "<Leader>>", ":MpcPlayNext<CR>", { silent = true })
vim.keymap.set("n", "<Leader><", ":MpcPlayPrev<CR>", { silent = true })

-- nvim-tree
require("nvim-tree").setup()
vim.keymap.set("n", "<Leader>e", ":NvimTreeToggle<CR>", { silent = true })

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

-- 追加の Neovim 推奨設定
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.termguicolors = true
