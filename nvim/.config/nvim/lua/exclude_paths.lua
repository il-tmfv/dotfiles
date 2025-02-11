local M = {}

M.exclude_paths = {
	".git",
	".svn",
	".hg",
	"CVS",
	".bzr",
	"vendor",
	"node_modules",
	"dist",
	"venv",
	"elm-stuff",
	"deps",
	"_build",
	".clj-kondo",
	"assets/node_modules",
	".lsp",
	"tmp/*",
	"public/packs/*",
	"public/packs-test/*",
	"public/vite/*",
	"log/*",
}

return M
