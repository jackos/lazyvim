-- Defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local map = vim.keymap.set
local all_modes = { "n", "t", "v", "i" }
local sn = { silent = true, noremap = true }

local keybindings_all_modes = {
  { "<A-h>", "<C-w>h", "Focus window left" },
  { "<A-j>", "<C-w>j", "Focus window below" },
  { "<M-k>", "<C-w>k", "Focus window above" },
  { "<A-l>", "<C-w>l", "Focus window right" },
  { "<A-S-l>", ":vsplit<CR>", "Split window right" },
  { "<A-S-j>", ":split<CR>", "Split window below" },
  { "<A-f>", "<leader>wm", "Maximize window toggle" },
  { "<C-h>", ":bprevious<CR>", "Previous Buffer" },
  { "<C-l>", ":bnext<CR>", "Next buffer" },
}
map("n", "<A-w>", ":q<CR>", { desc = "Close window", unpack(sn) })
map("t", "<A-w>", "exit<CR>", { desc = "Close termanal" })
map("n", "<A-k>", "<C-w>k", { desc = "Focus window above" })
map("n", "<A-i>", vim.lsp.buf.hover, { desc = "Hover Documentation" })

for _, binding in ipairs(keybindings_all_modes) do
  map(all_modes, binding[1], binding[2], { desc = binding[3], unpack(sn) })
end

map("n", "<S-u>", "<C-r>", { desc = "Redo", unpack(sn) })

-- snacks
Snacks.toggle.zoom():map("<A-f>")
map("t", "<A-f>", "<C-\\><C-n>", { desc = "Exit terminal to normal mode" })
map("t", "<A-k>", "<C-\\><C-n><C-w>k", { desc = "Exit terminal to normal mode" })

map(all_modes, "<A-t>", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal" })

map(all_modes, "<C-w>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer", nowait = true })

map("n", "<leader>gf", function()
  Snacks.picker("git_log_file_diff")
end, { desc = "Diff file history" })

-- which-key
local wk = require("which-key")

wk.add({
  { "<leader>m", group = "Modify Config Files" }, -- Group for config files
  { "<leader>mm", ":edit ~/.config/nvim/lua/config/keymaps.lua<CR>", desc = "Neovim Keymaps" },
  { "<leader>mf", ":edit ~/.config/fish/config.fish<CR>", desc = "Fish" },
  { "<leader>ma", ":edit ~/.config/alacritty/alacritty.toml<CR>", desc = "Alacritty" },
  { "<leader>ml", ":edit ~/.config/lazygit/config.yml<CR>", desc = "Lazygit" },
  { "<leader>mg", ":edit ~/.gitconfig<CR>", desc = "Git" },
  {
    "<leader>mn",
    function()
      require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
    end,
    desc = "Neovim",
  },
}, { mode = "n" })

local mc = require("multicursor-nvim")

-- Add or skip cursor above/below the main cursor.
map({ "n", "x" }, "<up>", function()
  mc.lineAddCursor(-1)
end, { desc = "Add cursor above" })

map({ "n", "x" }, "<down>", function()
  mc.lineAddCursor(1)
end, { desc = "Add cursor below" })

map({ "n", "x" }, "<leader><C-k>", function()
  mc.lineSkipCursor(-1)
end)

map({ "n", "x" }, "<leader><C-j>", function()
  mc.lineSkipCursor(1)
end)

-- Add or skip adding a new cursor by matching word/selection
map({ "n", "x" }, "<A-n>", function()
  mc.matchAddCursor(1)
end, { desc = "Add cursor matching word next" })

map({ "n", "x" }, "<A-b>", function()
  mc.matchAddCursor(-1)
end, { desc = "Add cursor matching word back" })

map({ "n", "x" }, "<leader>C-m", function()
  mc.matchSkipCursor(1)
end)

map({ "n", "x" }, "<leader>C-n", function()
  mc.matchSkipCursor(-1)
end)

-- Add and remove cursors with control + left click.
map("n", "<c-leftmouse>", mc.handleMouse)
map("n", "<c-leftdrag>", mc.handleMouseDrag)
map("n", "<c-leftrelease>", mc.handleMouseRelease)

-- Disable and enable cursors.
map({ "n" }, "<Esc>", mc.disableCursors)

-- Mappings defined in a keymap layer only apply when there are
-- multiple cursors. This lets you have overlapping mappings.
mc.addKeymapLayer(function(layerSet)
  -- Select a different cursor as the main one.
  layerSet({ "n", "x" }, "<left>", mc.prevCursor)
  layerSet({ "n", "x" }, "<right>", mc.nextCursor)

  -- Delete the main cursor.
  layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

  -- Enable and clear cursors using escape.
  layerSet("n", "<esc>", function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
end)
