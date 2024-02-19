# around.nvim
Simple lua plugin to to add parenthesis and tags around your visual selection. Just call the function and then decide what you want to add around your selection

## Installation
Use your prefered plugin manager of choice

## Configure
Add a visual keybinding to the around function  

Example:

    vim.keymap.set('x', '<leader>a', require('nvim-around').around, { desc = '[A]dd around' })


