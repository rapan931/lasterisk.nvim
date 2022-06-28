# lasterisk.nvim
The [asterisk.vim](https://github.com/haya14busa/vim-asterisk) is great plugin.  
This is asterisk.vim written in lua

## Install

[vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'rapan931/lasterisk.nvim'
```

[packer.nvim](https://github.com/wbthomason/packer.nvim)  
[vim-jetpack](https://github.com/tani/vim-jetpack)

```lua
use 'rapan931/lasterisk.nvim'
```

## Usage

```lua
vim.api.nvim_set_keymap('n', '*', [[<cmd>lua require("lasterisk").lasterisk_do({})<CR>]], {
  noremap = false
})
vim.api.nvim_set_keymap('n', 'g*', [[<cmd>lua require("lasterisk").lasterisk_do({ is_whole = false })<CR>]], {
  noremap = false
})
```

## Todo

- [x] Stay asterisk(like `*`)
- [x] `is_whole = false` option(like `g*`)
- [ ] Visual asterisk

## Differences from asterisk.vim

- Not support backward(like `#`).
- Not support jump asterisk.
- Not support visual mode blockwise.
- Not support `exclusive` in the selection option
- Not support keep cursor position
