require('telescope').setup{
  defaults = {
    file_ignore_patterns = {".git/", "node_modules/"},
    mappings = {
      n = {
        ["q"] = "close"
      }
    }
  },
  pickers = {
    find_files = {
      hidden = true,
    }
  }
}
