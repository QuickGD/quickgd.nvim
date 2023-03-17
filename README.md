# quickgd.nvim
Tools for neovim that comes with helpfull godot / tscn launch commands, setup for treesitter and auto-completion for gdshader.

https://user-images.githubusercontent.com/6450181/224002487-bc639c89-3bbe-4937-9d88-9e08daaffc1e.mp4

## ✨ Features
- Dynamic auto-completion for gdshaders including all shader types.
- Use GLSL to setup up treesitter in gdshaders.
- Quick launch commands.

## ⛑  Requirements
- [nvim-telescope](https://github.com/nvim-telescope/telescope.nvim) needed to use telescope else disable in settings.
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) needed for auto completion make sure you have GLTF parser installed.
- nvim >= 0.8

---

## 📜 Commands
- `GodotRun` - Opens a selecter where you can pick a tscn to run.
- `GodotRunLast` - Runs the last chosen tscn from `GodotRun`.
- `GodotStart` - Opens your current Godot project located in your working directory.

---

## 🔌 Install

### 💤 Lazy
```lua
{
  "QuickGD/quickgd.nvim",
  cmd = {"GodotRun","GodotRunLast","GodotStart"},
  -- Use opts if passing in settings else use config
  opts = {},
  config = function()
  local quickgd = require "quickgd"
    quickgd.setup() -- don't need if using opts
    quickgd.treesitter() -- optional: needed for cmp
    quickgd.cmp() -- optional
  end,
}
```

### 📦 Packer
```lua
{
  "QuickGD/quickgd.nvim",
  config = function()
  local quickgd = require "quickgd"
    quickgd.setup() {
      -- options
    } 
    quickgd.treesitter() -- optional: needed for cmp
    quickgd.cmp() -- optional
  end,
  end,
}
```

### 📝 CMP

```lua
    sources = {
      { name = "nvim_lsp", priority = 1000 },
      { name = "quickgd", priority = 750 }, -- make sure to add quickgd to your source list
      { name = "luasnip", priority = 700 },
      { name = "path", priority = 650 },
      { name = "buffer", priority = 400 },
    },
```


---

## ⚙  Settings
```lua
   {
    -- Sets the path of your Godot executable.    
    -- Will look for path in GODOT environment variable if not set.
    godot_path = "/path/to/godot"
    -- If opened in project root folder path will already be set.
    project_path = "path/to"
    -- If set to false will use internal selector.
    telescope = true
  }

```
