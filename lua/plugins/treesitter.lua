---@type PackitElement
return {
  src = vim.pack.gh("nvim-treesitter/nvim-treesitter"),
  branch = "main",
  build = ":TSUpdate",
  config = function()
    vim.keymap.set("n", "<leader>i", vim.treesitter.inspect_tree, { desc = "Inspect TreeSitter tree" })

    local treesitter = require("nvim-treesitter")
    treesitter.setup({})

    local ensure_installed = {
      "vim", "vimdoc",
      "lua", "luadoc",
      "asm", "nasm",
      'vhdl', 'systemverilog',
      "c", "cpp", "zig",
      "go", "rust",
      "llvm",
      "make",
      "markdown", 'markdown_inline',
      "html", "css",
      "javascript", "json",
      "typescript", "vue", "svelte",
      "bash", "zsh", "awk",
      'matlab',
      "python",
      "ini", "yaml", "xml", "csv", 'properties', 'proto', 'query', 'regex',
      "http", 'nginx',
      "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
      'pem',
      'tmux',
      'udev', 'devicetree'
    }

    local config = require("nvim-treesitter.config")

    local already_installed = config.get_installed()
    -- vim.print(already_installed)

    local parsers_to_install = {}

    for _, parser in ipairs(ensure_installed) do
      if not vim.tbl_contains(already_installed, parser) then
        table.insert(parsers_to_install, parser)
      end
    end
    -- vim.print(parsers_to_install, #parsers_to_install)

    if #parsers_to_install > 0 then
      treesitter.install(parsers_to_install, { force = true, summary = true }):wait(30000000000)
    end

    local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
          vim.treesitter.start(args.buf)
        end
      end,
    })
  end,
}
