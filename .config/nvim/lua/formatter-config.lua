require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
        -- prettier
       function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
            stdin = true
          }
        end
    },
    json = {
        -- prettier
       function()
          return {
            exe = "jq",
            args = {".", vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
    },
    rust = {
      -- Rustfmt
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    },
    lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
    },
    cpp = {
        -- clang-format
       function()
          return {
            exe = "clang-format",
            args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
            stdin = true,
            cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
          }
        end
    },
    gdscript = {
      function()
        return {
          exe = "gdformat",
          args = {vim.api.nvim_buf_get_name(0)},
          stdin = false
        }
      end
    },
  }
})

