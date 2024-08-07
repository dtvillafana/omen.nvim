# omen.nvim

Omen is a password manager like plugin for Neovim

![pick.gif](https://gist.githubusercontent.com/nacro90/787eb4f98d8c947d100c040997fd9b65/raw/595b1be683e37e2610984f55850bd06faa16144f/pick.gif)


## Why?
I am using `gopasspw` to manage my passwords (works identically with `pass`). I have been using this plugin in my config for months and I
really loved picking my passwords with telescope. So, I want to create a new plugin.


## Features

- Picks your password from your password store directory
- Asks your passphrase but never saves it
- Decrypts the file you picked and copy the first line to clipboard
- Clears the contents of the register after a retention
- Uses the safe passphrase cache of gpg to easily pick multiple passwords without a passphrase


## Requirements

Omen needs some external components to work:
- *gpg* - GnuPG


## Installation

With Lazy:

```lua
{
    "dtvillafana/omen.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
}
```

With packer:

```lua
use {
    "dtvillafana/omen.nvim",
    requires = {
        "nvim-lua/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("omen").setup()
    end
},
```

### Config

`setup` gets a options table that defaults to:

```lua
{
    picker = "telescope", --- Picker type
    title = "Omen", --- Title to be displayed on the picker
    store = vim.env.HOME .. "/.password-store/", --- Password store directory
    passphrase_prompt = "Passphrase: ", --- Prompt when asking the passphrase
    register = "+", --- Which register to fill after decoding a password
    retention = 45, --- How much seconds the life of the decoded passwords in the register
    ignored = { --- Ignored directories or files that are not to be listed in picker
        ".git",
        ".gitattributes",
        ".gpg-id",
        ".stversions",
        "Recycle Bin",
    },
    use_default_keymaps = true, --- Whether display info messages or not
}
```

### Pickers

Omen uses a telescope picker implementation by default. You can change it to `vim.ui.select` to use
it with your favourite picker.

```lua
require("omen").setup{
    picker = "select"
}
```

You can load plugin as a telescope extension using:

```lua
require("telescope").load_extension("omen")
```

Call it as following:

```viml
:Telescope omen pick
```

### Keymaps

Omen sets default keymaps by default.

```lua
vim.keymap.set("n", "<leader>p", omen.pick)
```

You can disable that using:

```lua
require("omen").setup{
    use_default_keymaps = false,
}
```

You can access the `pick` function using:
```lua
require("omen").pick()
```

## TODO

- [X] Copy a password file content to a register with a retention
- [X] OTP support for gopass
- [X] Copy a username to a register
- [ ] Inserting new password to the store
- [ ] Generating new password for the store
- [ ] Callbacks and events
- [ ] More test coverage

## Testing

```
make test
```

or with justfile:

```
just test
```
