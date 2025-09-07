# Neovim Config

A modular Neovim configuration using **lazy.nvim** with focus on **C/C++ development**, LSP, autocompletion, file navigation, and productivity tools.

---

## ✨ Plugins

### UI & Appearance
- **[nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)**  
  Colorscheme (default: `nightfox`).
- **[indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)**  
  Indentation guides using `│`.
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**  
  Statusline with git integration via gitsigns.

---

### Editing & Completion
- **[nvim-autopairs](https://github.com/windwp/nvim-autopairs)**  
  Auto-close brackets, integrates with `nvim-cmp`.
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** + extensions:
  - LSP completions
  - Buffer, Path, Cmdline
  - Signature help
  - Snippets with **LuaSnip** + friendly-snippets
  - Icons via **lspkind**

**Keybindings:**
- `<C-b>` / `<C-f>` → Scroll docs
- `<C-Space>` → Trigger completion
- `<C-e>` → Abort completion
- `<CR>` → Confirm selection
- `<Tab>` / `<S-Tab>` → Navigate completions & snippets

---

### LSP
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**  
  Configured for:
  - **clangd** (C/C++) with advanced flags
  - **lua_ls** (Lua, tuned for Neovim config)

**Keybindings (normal mode):**
- `gd` → Go to definition  
- `gD` → Go to declaration  
- `gi` → Go to implementation  
- `gr` → Find references  
- `K` → Hover documentation  
- `<C-k>` → Signature help  
- `<leader>rn` → Rename symbol  
- `<leader>ca` → Code action  
- `<leader>e` → Show diagnostics (float)  
- `[d` / `]d` → Prev/next diagnostic  
- `<leader>q` → Add diagnostics to loclist  
- `<leader>f` → Format buffer  

Diagnostics have custom gutter icons:  
`` error, `` warning, `󰠠` hint, `` info

---

### File Navigation
- **[oil.nvim](https://github.com/stevearc/oil.nvim)**  
  Replaces netrw with modern file explorer.

**Keybindings:**
- `<leader>-` → Open parent directory in Oil
- `-` → Toggle Oil (float mode)
- Inside Oil:
  - `q` → Close
  - `<M-h>` → Open split
  - Hidden files are shown

Oil auto-updates Neovim’s working directory.

---

### Productivity
- **[snacks.nvim](https://github.com/folke/snacks.nvim)**  
  Lazygit integration, pickers, and utilities.

**Keybindings:**
- `<leader>lg` → Lazygit in repo root
- `<leader>gl` → Lazygit logs
- `<leader>rN` → Rename current file
- `<leader>dB` → Delete/close buffer (confirm)
- **Pickers:**
  - `<leader>pf` → Find files
  - `<leader>pc` → Find config files
  - `<leader>ps` → Grep word
  - `<leader>pws` → Grep word/selection
  - `<leader>pk` → Search keymaps

---

## 🛠️ Notes
- Requires **lazy.nvim** for plugin management.  
- External dependencies:
  - `trash-cli` (for Oil delete-to-trash)
  - `lazygit` (for Snacks integration)
- Snippets: extend with your own via `LuaSnip`.
