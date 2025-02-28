return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = {},
      tsserver = {
        enabled = false,
      },
      ts_ls = { enabled = false, },
    },
    setup = {
      eslint = function()
        require("lazyvim.util").lsp.on_attach(function(client)
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "vtsls" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,
    },
  },
}
