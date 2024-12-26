# **nvim-spacecraft**  
A modular Neovim configuration for modern development.  

---

## **Features**  
- **Leader Key**: Space (`<Leader>`) for custom commands.  
- **LSP Ready**: Preconfigured for Python, JavaScript, TypeScript, TailwindCSS, HTML, and CSS.  
- **Autocompletion**: Context-aware completion using `nvim-cmp` and `LuaSnip`.  
- **Syntax Highlighting**: Powered by `nvim-treesitter`.  
- **File Navigation**: Fast file and buffer searching with `telescope.nvim` and `nvim-tree.lua`.  
- **Custom UI**: Sleek design with `tokyonight.nvim` theme and buffer tabs.  

---

## **Installation**  
1. Clone the repo:  
   ```bash
   git clone https://github.com/Armaan-z3r0/nvim-spacecraft.git ~/.config/nvim
2. Launch Neovim to install packer.nvim.
3. Run :PackerSync to install plugins.
   ```nvim
   :PackerSync
   ```
   
---

## **Key Bindings**
|Key Binding | Action |
| --- | --- |
| `<Leader>w` | Save file |
| `<Leader>q` | Quit Neovim |
| `<Leader>ff` | Find files |
| `<Leader>fg` | Search text |
| `<Leader>e` | Toggle file explorer |

---

## **Core Plugins**
* `packer.nvim`: Plugin manager.
* `nvim-lspconfig`: LSP setup.
* `mason.nvim`: Manage LSP servers.
* `nvim-cmp`: Autocompletion.
* `nvim-treesitter`: Syntax highlighting.
* `telescope.nvim`: File searching.
* `nvim-tree.lua`: File explorer.
* `tokyonight.nvim`: Theme.
* `bufferline.nvim`: Buffer tabs.

---

## **LSP Setup**
Preinstalled servers:
*Python: pyright
*JavaScript/TypeScript: tsserver
*TailwindCSS: tailwindcss
*HTML/CSS: html, cssls

Add more servers in mason-lspconfig like this:
```lua
   require('mason-lspconfig').setup({
  ensure_installed = { "server_name" }
})
```

