# Neovim Development Setup (Flutter / Dart Optimized)

A clean, fast, and modular Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim) and optimized for Flutter and Dart development.

---

## Architecture & Structure

The configuration is completely modularized under `~/.config/nvim/`:

```text
~/.config/nvim/
├── init.lua                          # Entrypoint: loads options, keymaps, and lazy
└── lua/
    ├── config/
    │   ├── options.lua               # Global editor settings (indentation, UI, clipboard)
    │   ├── keymaps.lua               # General navigation & window management shortcuts
    │   ├── lsp_utils.lua             # Shared LSP on_attach keymaps & cmp capabilities
    │   └── lazy.lua                  # lazy.nvim bootstrapper & plugin loader
    └── plugins/
        ├── colorscheme.lua           # Dracula theme configuration
        ├── ui.lua                    # Lualine (statusline), Which-Key, Dressing (dialogs)
        ├── bufferline.lua            # Buffer tabs across top & safe close (bufdelete.nvim)
        ├── explorer.lua              # Nvim-Tree file explorer with Git status
        ├── treesitter.lua            # Syntax highlighting & Dart grammar
        ├── telescope.lua             # Fuzzy finder, buffer search & file picker
        ├── completion.lua            # nvim-cmp, LuaSnip, friendly-snippets & lspkind
        ├── lsp.lua                   # Native Neovim 0.12 LSP client & Mason
        ├── flutter.lua               # flutter-tools.nvim with FVM, closing tags & guides
        ├── formatting.lua            # conform.nvim (dart format on save)
        ├── git.lua                   # gitsigns, vim-fugitive & diffview.nvim
        └── autosave.lua              # auto-save.nvim with 1-second debounce
```

---

## Cheat Sheet

> **Note:** The Leader key is set to **`<Space>`**.

### 1. General & Window Navigation

| Shortcut | Description |
| :--- | :--- |
| `<C-h>` | Move to window on the left |
| `<C-j>` | Move to window below |
| `<C-k>` | Move to window above |
| `<C-l>` | Move to window on the right |
| `<C-Up>` / `<C-Down>` | Resize window vertically (±2) |
| `<C-Left>` / `<C-Right>` | Resize window horizontally (±2) |
| `<Tab>` / `<S-Tab>` (Visual) | Indent / unindent selection (keeps selection) |
| `J` / `K` (Visual) | Move selected lines down / up |
| `<Esc>` | Clear search highlighting |

---

### 2. Buffer Tabs & Workspace Management

| Shortcut | Description |
| :--- | :--- |
| `<leader>,` or `<leader>bb` | **List & fuzzy-find open buffers** (MRU sorted, live preview) |
| `<S-l>` or `]b` | Cycle to **next buffer tab** (Shift + L) |
| `<S-h>` or `[b` | Cycle to **previous buffer tab** (Shift + H) |
| `<leader>bp` | **Visual tab picker** (press letter on tab badge to jump) |
| `<leader>bd` | **Close current buffer** (preserves window splits & tree layout) |
| `<leader>bc` | Close all other buffers except current |
| `<C-d>` or `dd` | Delete highlighted buffer directly inside `<leader>,` search list |

---

### 3. File Explorer (`nvim-tree`)

| Shortcut | Description |
| :--- | :--- |
| `<leader>e` | Toggle file explorer sidebar |
| `<leader>o` | Reveal / focus currently opened file in tree |
| `a` (inside tree) | Create new file or folder (append `/` for directory) |
| `d` (inside tree) | Delete file / folder |
| `r` (inside tree) | Rename file / folder |
| `H` (inside tree) | Toggle hidden dotfiles (`.gitignore`, `.env`, etc.) |
| `<CR>` (inside tree) | Open file |
| `q` (inside tree) | Close file explorer |

---

### 4. Fuzzy Finding & Project Search (`telescope`)

| Shortcut | Description |
| :--- | :--- |
| `<leader>ff` | Find files by name across project |
| `<leader>fg` | Live grep (search text across all project files with ripgrep) |
| `<leader>sb` | Search text **inside open buffers only** |
| `<leader>/` | Fuzzy search text **inside current buffer** |
| `<leader>fo` | Recent files (oldfiles) |
| `<leader>fr` | Resume last Telescope search |
| `<leader>fh` | Neovim help tags |
| `<leader>fd` | Project-wide workspace diagnostics / errors |

---

### 5. Flutter & Dart Development (`flutter-tools.nvim`)

| Shortcut | Description |
| :--- | :--- |
| `<leader>Fr` or `<F5>` | **Run Flutter App** (`:FlutterRun`) |
| `<leader>fr` or `<F7>` | **Hot Reload** (`:FlutterReload`) |
| `<leader>FR` or `<F6>` | **Hot Restart** (`:FlutterRestart`) |
| `<leader>Fq` | Quit Flutter app (`:FlutterQuit`) |
| `<leader>Fd` | Select target device (floating modal) |
| `<leader>Fe` | Select and launch emulator |
| `<leader>Fo` | Toggle widget tree outline sidebar |
| `<leader>Ft` | Open Flutter DevTools in your browser |
| `<leader>Fp` | Browse all Flutter commands with Telescope |
| `<leader>Fl` | Restart Dart Analysis Server |
| `<leader>Fc` | Clear Flutter dev log buffer |

#### Built-in Flutter Features:
- **FVM Detection**: Automatically discovers and uses Flutter SDK configured in FVM (`/opt/homebrew/bin/fvm`).
- **Closing Tags**: Displays virtual comments at the end of deep widget trees (e.g. `// Scaffold`, `// Padding`, `// Container`).
- **Widget Guides**: Indent guide lines connecting parent and child widgets.
- **Native Color Previews**: Highlights `Colors.amber` and `Color(0xFF...)` with their real color directly in Neovim 0.12.

---

### 6. LSP & Code Intelligence

| Shortcut | Description |
| :--- | :--- |
| `gd` | Go to Definition |
| `gD` | Go to Declaration |
| `gr` | Find References (opens Telescope list) |
| `gi` | Go to Implementation |
| `gt` | Go to Type Definition |
| `K` | Hover documentation popup |
| `<leader>ca` | **Code Action / Widget Wrap** (Wrap with Padding, Center, Container, Remove Widget, etc.) |
| `<leader>cr` | Rename symbol project-wide |
| `<leader>cd` | Show floating error/warning details for current line |
| `[d` / `]d` | Jump to previous / next diagnostic error or warning |

---

### 7. Autocompletion (`nvim-cmp`)

| Shortcut | Description |
| :--- | :--- |
| `<Tab>` | Select next suggestion or jump to next snippet placeholder |
| `<S-Tab>` | Select previous suggestion or jump backwards in snippet |
| `<CR>` | Confirm selection |
| `<C-Space>` | Trigger autocomplete popup manually |
| `<C-e>` | Abort / close autocomplete popup |

---

### 8. Git Integration & Reviewing Changes

| Shortcut | Description |
| :--- | :--- |
| `<leader>gv` | **Open Git Review Panel** (`DiffviewOpen`): Lists all changed/staged files with side-by-side diff |
| `<leader>gV` | **Close Git Review Panel** (`DiffviewClose`) |
| `<leader>gs` | **View Changed / Staged Files** in Telescope with live diff preview |
| `<leader>gg` | **Interactive Git Status** (`:Git` via fugitive): Stage with `-`, commit with `cc` |
| `<leader>gc` | Browse git commit history |
| `<leader>gb` | Browse git branches |
| `<leader>gh` | File git revision history |
| `]c` / `[c` | Jump to next / previous Git change hunk in code |
| `<leader>hp` | Preview hunk diff in floating popup |
| `<leader>hs` | Stage hunk under cursor (Normal & Visual mode) |
| `<leader>hr` | Reset / discard hunk under cursor |
| `<leader>hb` | Git blame popup for current line |
| `<leader>tb` | Toggle inline virtual Git blame (VS Code GitLens style) |

---

### 9. Auto-Save & Formatting

| Shortcut | Description |
| :--- | :--- |
| `<leader>as` | **Toggle Auto-Save on/off** (saves 1s after typing & on focus change) |
| `<leader>cf` | **Format current buffer or selection** (runs `dart format` on Dart files) |

---

## Workflow Examples

### Day-to-Day Flutter Workflow
1. Press `<leader>e` to navigate your project tree, or `<leader>ff` to find a widget file.
2. Select your device using `<leader>Fd`.
3. Start debugging with `<leader>Fr` (or `<F5>`).
4. Edit your widget code. Code automatically formats (`dart format`) and auto-saves.
5. Trigger **Hot Reload** with `<leader>fr` (or `<F7>`), or **Hot Restart** with `<leader>FR` (or `<F6>`).
6. Need to wrap a widget? Put your cursor on the widget name and hit `<leader>ca` to choose "Wrap with Padding", "Wrap with Center", etc.

### Git Review & Staging Workflow
1. Press `<leader>gv` to open Diffview.
2. The left panel shows every changed and staged file.
3. Use `j` / `k` to browse through files. The right pane updates with a side-by-side diff.
4. Press `s` on any file in the list to stage it, or `u` to unstage.
5. Press `<leader>gV` to close the review panel.
6. Press `<leader>gg` -> `cc` to write your commit message.
