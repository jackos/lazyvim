-- ~/.congif/nvim/lua/plugins/mojo-conf.lua

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      mojo = {
        on_new_config = function(config)
          if vim.fn.executable("mojo-lsp-server") == 0 then
            vim.notify(
              "(mojo-lsp-server not on path)",
              vim.log.levels.WARN,
              { title = "MOJO LSP NOT STARTED", icon = "X", timeout = 10000 }
            )
            -- avoid trying to run mojo-lsp-server
            config.cmd = { "echo", "" }
            return
          end
        end,
      },
    },
  },
}
