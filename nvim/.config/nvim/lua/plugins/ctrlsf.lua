return {
  'dyng/ctrlsf.vim',
  keys = {
    { "<leader>S", "<Plug>CtrlSFPrompt", noremap = false },
    -- search current word
    { "<leader>sw", "<Plug>CtrlSFCwordPath", noremap = false },
    { "<leader>sw", "<Plug>CtrlSFVwordPath", mode = 'v', noremap = false },

    -- close panel as window on the left
    { "<leader>sq", ":CtrlSFToggle<CR>", noremap = true },
  },
}
