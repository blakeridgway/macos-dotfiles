return {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "goimports", "gofmt" },
    cs = { "csharpier" },
    yaml = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    sh = { "shfmt" },
    bash = { "shfmt" },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}
