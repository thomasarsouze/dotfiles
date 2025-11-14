return {
  'vim-test/vim-test',
  dependencies = {
    'preservim/vimux',
  },
  config = function()
    vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>', { desc = '[T]est [n]earest' })
    vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { desc = '[T]est [f]ile' })
    vim.keymap.set('n', '<leader>ta', ':TestSuite<CR>', { desc = '[T]est [a]ll / suite' })
    vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { desc = '[T]est [l]ast' })
    vim.keymap.set('n', '<leader>tg', ':TestVisit<CR>', { desc = '[T]est [g]o to' })
    vim.cmd "let test#strategy = 'vimux'"
  end,
}
