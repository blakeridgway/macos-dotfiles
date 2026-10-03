require "nvchad.mappings"

local map = vim.keymap.set

-- Quick command mode
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- Save with Ctrl+S
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- ── Git ──────────────────────────────────────────────────────────────────────
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open LazyGit" })

-- ── Diagnostics (Trouble) ────────────────────────────────────────────────────
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                         { desc = "Workspace diagnostics" })
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",            { desc = "Buffer diagnostics" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                 { desc = "Document symbols" })
map("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",  { desc = "LSP references" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                              { desc = "Quickfix list" })

-- ── DAP ──────────────────────────────────────────────────────────────────────
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>",           { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input "Condition: ")
end, { desc = "Conditional breakpoint" })
map("n", "<leader>dc", "<cmd>DapContinue<cr>",                   { desc = "Continue" })
map("n", "<leader>di", "<cmd>DapStepInto<cr>",                   { desc = "Step into" })
map("n", "<leader>do", "<cmd>DapStepOver<cr>",                   { desc = "Step over" })
map("n", "<leader>dO", "<cmd>DapStepOut<cr>",                    { desc = "Step out" })
map("n", "<leader>dt", "<cmd>DapTerminate<cr>",                  { desc = "Terminate" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })
map("n", "<leader>dr", function() require("dap").repl.open() end,{ desc = "Open REPL" })
map("n", "<leader>dgt", function() require("dap-go").debug_test() end,       { desc = "Debug Go test" })
map("n", "<leader>dgl", function() require("dap-go").debug_last_test() end,  { desc = "Debug last Go test" })

-- ── Terminal ──────────────────────────────────────────────────────────────────
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",      { desc = "Float terminal" })
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",   { desc = "Vertical terminal" })

-- ── TODO comments ─────────────────────────────────────────────────────────────
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>",                             { desc = "Find TODOs" })
map("n", "]t", function() require("todo-comments").jump_next() end,          { desc = "Next TODO" })
map("n", "[t", function() require("todo-comments").jump_prev() end,          { desc = "Prev TODO" })

-- ── Harpoon ───────────────────────────────────────────────────────────────────
map("n", "<leader>ha", function() require("harpoon"):list():add() end,       { desc = "Add file" })
map("n", "<leader>hh", function()
  local h = require "harpoon"
  h.ui:toggle_quick_menu(h:list())
end, { desc = "Toggle menu" })
map("n", "<leader>h1", function() require("harpoon"):list():select(1) end,   { desc = "File 1" })
map("n", "<leader>h2", function() require("harpoon"):list():select(2) end,   { desc = "File 2" })
map("n", "<leader>h3", function() require("harpoon"):list():select(3) end,   { desc = "File 3" })
map("n", "<leader>h4", function() require("harpoon"):list():select(4) end,   { desc = "File 4" })
-- cycle through harpoon list
map("n", "<leader>hp", function() require("harpoon"):list():prev() end,      { desc = "Prev file" })
map("n", "<leader>hn", function() require("harpoon"):list():next() end,      { desc = "Next file" })

-- ── Oil ───────────────────────────────────────────────────────────────────────
map("n", "-",           "<cmd>Oil<cr>",              { desc = "Open parent dir (Oil)" })
map("n", "<leader>oo",  "<cmd>Oil --float<cr>",      { desc = "Oil (float)" })

-- ── AI (Minuet inline completions) ───────────────────────────────────────────
map("i", "<A-m>", function() require("minuet").make_cmp_map() end, { desc = "Minuet: trigger completion" })
map("n", "<A-m>", function() require("minuet").complete_with_minuet() end, { desc = "Minuet: inline suggestion" })

-- ── which-key group labels ────────────────────────────────────────────────────
vim.schedule(function()
  local ok, wk = pcall(require, "which-key")
  if not ok then return end
  wk.add {
    { "<leader>a",  group = "AI" },
    { "<leader>d",  group = "Debug" },
    { "<leader>dg", group = "Go" },
    { "<leader>x",  group = "Diagnostics" },
    { "<leader>t",  group = "Terminal" },
    { "<leader>g",  group = "Git" },
    { "<leader>h",  group = "Harpoon" },
    { "<leader>o",  group = "Oil" },
    { "<leader>f",  group = "Find" },
  }
end)
