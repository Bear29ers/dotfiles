local status, ts = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

ts.setup {
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = 'all', -- one of 'all', or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "phpdoc", "tree-sitter-phpdoc" }, -- List of parsers to ignore installing
  autotag = {
    enable = true,
  },
}
