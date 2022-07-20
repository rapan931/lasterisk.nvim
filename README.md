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
vim.keymap.set('n', '*',  function() require("lasterisk").search() end)
vim.keymap.set('n', 'g*', function() require("lasterisk").search({ is_whole = false }) end)
vim.keymap.set('x', 'g*', function() require("lasterisk").search({ is_whole = false }) end)

-- not support visual asterisk & is_whole = true
-- vim.keymap.set('n', '*',  function() require("lasterisk").search() end)
```

## Todo

- [x] Stay asterisk(like `*`)
- [x] `is_whole = false` option(like `g*`)
- [x] Visual asterisk(by line)
- [x] Visual asterisk(by character)

## Differences from asterisk.vim

- Not support backward(like `#`)
- Not support jump asterisk(like default `*`)
- Not support visual mode blockwise
- Not support `exclusive` in the selection option
- Not support keep cursor position
