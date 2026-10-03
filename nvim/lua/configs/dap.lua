local dap = require "dap"
local dapui = require "dapui"

-- DAP UI setup
dapui.setup {
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  layouts = {
    {
      elements = {
        { id = "scopes",      size = 0.35 },
        { id = "breakpoints", size = 0.15 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 0.25 },
      },
      size = 45,
      position = "left",
    },
    {
      elements = {
        { id = "repl",    size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 12,
      position = "bottom",
    },
  },
}

-- Auto open/close UI with debug session
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Go: powered by nvim-dap-go (wraps delve)
require("dap-go").setup {
  dap_configurations = {
    {
      type = "go",
      name = "Debug file",
      request = "launch",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug package",
      request = "launch",
      program = "${fileDirname}",
    },
    {
      type = "go",
      name = "Attach to process",
      mode = "local",
      request = "attach",
      processId = require("dap.utils").pick_process,
    },
  },
}

-- C# / .NET: netcoredbg
dap.adapters.coreclr = {
  type = "executable",
  command = vim.fn.stdpath "data" .. "/mason/bin/netcoredbg",
  args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "Launch .NET",
    request = "launch",
    program = function()
      return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
    end,
  },
  {
    type = "coreclr",
    name = "Attach .NET",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
}

-- Signs
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "DapStoppedLine", numhl = "" })
