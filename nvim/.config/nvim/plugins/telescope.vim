lua <<EOF
require('telescope').setup{
  defaults = {
    file_ignore_patterns = {".git/", "node_modules/"}
  },
  pickers = {
    find_files = {
      hidden = true
    }
  }
}
EOF
