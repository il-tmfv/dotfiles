return {
  'Olical/conjure',
  config = function()
    vim.g['conjure#completion#omnifunc'] = nil
    -- let clojure-lsp do the work here
    vim.g['conjure#mapping#doc_word'] = false
    vim.g['conjure#mapping#def_word'] = false
  end
}
