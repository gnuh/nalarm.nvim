<div align='center'>
  <h1>
    <a href='https://github.com/arctouch-magnochiabai/gnu.vim' target='_blank'>
     <span>NAlarm.<img src='https://user-images.githubusercontent.com/101122677/220782485-0e5ea839-4f00-434d-94af-80d45f209bef.png'/>VIM</span>
    </a>
  </h1>
  <h3 align='center'> <code>NAlarm.Nvim</code> is a <a href='https://github.com/neovim/neovim'>Nvim</a> plugin to help you control the time within Neovim</h3>
  <br/>
</div>
<div align='center'>
  <img src='https://img.shields.io/github/last-commit/gnuh/nalarm.nvim' />
  <img src='https://img.shields.io/github/issues/gnuh/nalarm.nvim' />
  <img src='https://img.shields.io/github/forks/gnuh/nalarm.nvim' />
  <p>
  <br/>
  · <a href='https://github.com/gnuh/nalarm.nvim/issues' target='_blank'>
      Bug Report
    </a>
  · <a href='https://github.com/gnuh/nalarm.nvim/issues' target='_blank'>
      Request Feature
    </a>
  </p>
  <img src='https://user-images.githubusercontent.com/5380037/221726264-33677d3d-9ff5-4d29-a266-de9fbbbad922.png' />
  <br/>
  <img src='https://user-images.githubusercontent.com/5380037/221726303-8da6a86c-3ea8-4235-a22b-8fb8a9642e3f.png' />
  <br/>
</div>
<div align='center'>
  <h3 style='color: red'>WORK IN PROGRESS, DO NOT USE THIS YET, IT MAY CONTAIN SOME BUGS WHICH I'LL BE FIXING SOON</h3>
</div>

# Installation

```lua
use {
  "gnuh/nalarm.nvim",
  config = function()
    require("nalarm").setup()
  end
}
```

### Default Setup Options

```lua
-- Default
require("nalarm").setup({
  auto_cmd = {
    enable = false, -- enable auto command
    which_key = true, -- automatically creates which-key bindings
  }
})
```

<b>You need to call <code>require("nalarm").setup()</code> to make it work</b>

# Keybindings

```lua
local opts = { noremap = true, silent = true }
keymap("n", "<leader>oi", ":NAlarm<CR>", opts)
```

# Todo List

`Comming soon`
