-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Focus split navigation with Alt + h/j/k/l
map("n", "<A-h>", "<C-w>h", { desc = "Focus left split" })
map("n", "<A-j>", "<C-w>j", { desc = "Focus split below" })
map("n", "<A-k>", "<C-w>k", { desc = "Focus split above" })
map("n", "<A-l>", "<C-w>l", { desc = "Focus right split" })

-- Buffer navigation with Ctrl + h/l
map("n", "<C-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<C-l>", ":bnext<CR>", { desc = "Next buffer" })

map({ "t", "n" }, "<A-t>", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })

-- Function to create a menu for editing config files
local function open_config_menu()
  local configs = {
    { path = "~/.config/nvim/lua/config/keymaps.lua", name = "Neovim Keymaps" },
    { path = "~/.config/fish/config.fish", name = "Fish Config" },
    { path = "~/.config/ghostty/config", name = "Ghostty Config" },
  }

  -- Use vim.ui.select to create an interactive menu
  vim.ui.select(configs, {
    prompt = "Select config file to edit:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      vim.cmd("edit " .. vim.fn.expand(choice.path))
    end
  end)
end

-- Set <leader>h to open the config menu
map("n", "<leader>h", open_config_menu, { desc = "Open config file menu" })
