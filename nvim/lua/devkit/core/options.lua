-- Shorthands
local o = vim.opt
local g = vim.g

-- UI
o.termguicolors = true          -- enable 24-bit RGB colors
o.number = true                 -- show absolute line number on cursor line
o.relativenumber = true         -- show relative numbers elsewhere
o.signcolumn = "yes"            -- always show sign column (avoid text shift)
o.scrolloff = 8                 -- keep at least 8 lines visible above/below cursor
o.colorcolumn = "80"            -- thin visual guide at 80 columns
o.wrap = false                  -- don't soft-wrap long lines

-- Cursor guides
o.cursorline = false
o.cursorcolumn = false

-- Editing
o.backspace = { "start", "eol", "indent" }  -- behave like modern editors
o.isfname:append("@-@")         -- treat @-@ as part of filenames (useful for some paths)

-- Indentation / Tabs
o.expandtab = true              -- insert spaces instead of tabs
o.tabstop = 2                   -- visual width of a tab
o.softtabstop = 2               -- <Tab>/<BS> insert/delete 2 spaces
o.shiftwidth = 2                -- >> and << shift by 2 spaces
o.autoindent = true             -- copy indent from current line on newline
o.smartindent = true            -- smarter auto-indent for new lines

-- Files
o.swapfile = false              -- disable swap files
o.backup = false                -- disable backup files
o.undofile = true               -- persistent undo across sessions

-- Search
o.ignorecase = true             -- case-insensitive by default…
o.smartcase = true              -- …but case-sensitive if pattern has uppercase
o.incsearch = true              -- show matches as you type
o.hlsearch = true               -- highlight search results
o.inccommand = "split"          -- live preview of :substitute in a split

-- Splits
o.splitright = true             -- vertical splits open to the right
o.splitbelow = true             -- horizontal splits open below

-- System integration
o.clipboard = "unnamedplus"     -- use system clipboard
o.mouse = "a"                   -- enable mouse in all modes

-- Performance
o.updatetime = 50               -- faster CursorHold & swap write (ms)

-- Globals
g.editorconfig = true           -- respect .editorconfig files
g.netrw_banner = 0              -- hide the netrw banner
