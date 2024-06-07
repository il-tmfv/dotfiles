return {
  'Exafunction/codeium.vim',
  config = function ()
    vim.keymap.set(
      'n',
      '<F12>',
      function() return vim.fn['codeium#Chat']() end,
      { expr = true, silent = true, desc = 'Start Codeium chat' }
    )
    vim.keymap.set(
      'i',
      '<F9>',
      function() return vim.fn['codeium#CycleCompletions'](1) end,
      { expr = true, silent = true, desc = 'Next Codeium completion' }
    )
    vim.keymap.set(
      'i',
      '<F10>',
      function() return vim.fn['codeium#Clear']() end,
      { expr = true, silent = true, desc = 'Clear Codeium suggestion' }
    )
  end
}
