-- NvChad sets default capabilities (nvim-cmp) and on_attach via vim.lsp.config("*", ...)
require("nvchad.configs.lspconfig").defaults()

-- Go
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      usePlaceholders = true,
      staticcheck = true,
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

-- YAML
vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      validate = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
    },
  },
})

-- C# / OmniSharp
vim.lsp.config("omnisharp", {
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = true,
})

-- Enable all servers (Mason puts their binaries on PATH automatically)
vim.lsp.enable({ "gopls", "yamlls", "bashls", "omnisharp" })
