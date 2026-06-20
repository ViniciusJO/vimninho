---@type PackitElement
return {
  {src = vim.pack.gh("kevinhwang91/promise-async") },
  {
    src = vim.pack.gh("kevinhwang91/nvim-ufo"),
    config = function()
      local isWhitespace = function(s) return s:match("[^%s]") == nil end
      local hasPragma = function(s) return s:match("#pragma") ~= nil end
      local hasEndregion = function(s) return s:match("endregion") ~= nil end
      local trim = function(s) return s:gsub("^%s+", ""):gsub("%s+$", "") end

      require("ufo").setup({
        enable_get_fold_virt_text = true,
        provider_selector = function(bufnr, filetype, buftype)
          _, _, _ = bufnr, filetype, buftype; return { 'treesitter', 'indent' }
        end,                                                                                                                            --maybe not use this?
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate, ctx)
          local newVirtText = {}
          local suffix = (' \\\\--- %d ---// '):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0

          for _, chunk in ipairs(virtText) do
            chunk[1] = chunk[1]:gsub("#pragma ", "")
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              -- str width returned from truncate() may less than 2nd argument, need padding
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end

          table.insert(newVirtText, { suffix, 'MoreMsg' }) --middle

          local begin = false
          for _, v in ipairs(ctx.get_fold_virt_text(endLnum)) do
            v[1] = trim(v[1])
            if begin or (not isWhitespace(v[1]) and not hasPragma(v[1]) and not hasEndregion(v[1])) then
              begin = true
              table.insert(newVirtText, v)
            end
          end

          return newVirtText
        end,
        preview = { win_config = { border = "single" } }
      });
    end
  }
}
