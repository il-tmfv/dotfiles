lua <<EOL
local neogit = require("neogit")

neogit.setup {
  disable_commit_confirmation = true
}
EOL

nnoremap <leader>k <cmd>Neogit<cr>
