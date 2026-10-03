require "nvchad.options"

local o = vim.opt

o.relativenumber = true   -- relative line numbers for fast navigation
o.scrolloff = 8           -- keep 8 lines visible above/below cursor
o.sidescrolloff = 8
o.wrap = false            -- no line wrapping
o.undofile = true         -- persist undo history across sessions
o.splitbelow = true       -- horizontal splits open below
o.splitright = true       -- vertical splits open to the right
o.colorcolumn = "120"     -- column ruler at 120 chars
o.cursorline = true       -- highlight current line

-- Go uses real tabs; everything else uses 4-space soft tabs
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
