return {
  "superDross/ticket.vim",
  lazy = false,
  config = function()
    vim.g.auto_ticket_save = 1
    vim.g.ticket_black_list = {"master"}
    vim.g.default_session_name = "master"
  end,
  keys = {
    { "<F5>", "<cmd>SaveSession<cr>", noremap = false, desc = "Save session" },
    { "<F6>", "<cmd>OpenSession<cr>", noremap = false, desc = "Restore session" },
  },
}
