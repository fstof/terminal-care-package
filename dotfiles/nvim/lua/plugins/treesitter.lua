return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Neovim 0.12+ compatibility shim:
      -- In Neovim 0.12+, matches passed to query directives/predicates are lists of nodes
      -- (table<integer, TSNode[]>) rather than single nodes. We unwrap them so that
      -- master-branch nvim-treesitter query directives (e.g. Markdown code block language injection)
      -- don't fail with "attempt to call method 'range' (a nil value)".
      local query = require("vim.treesitter.query")

      local function unwrap(node)
        if type(node) == "table" and not getmetatable(node) then
          return node[1]
        end
        return node
      end

      -- Compatibility fix for Markdown fenced code block language resolution
      query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local capture_id = pred[2]
        local node = unwrap(match[capture_id])
        if not node then
          return
        end
        local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
        if ok and text then
          metadata["injection.language"] = text:lower()
        end
      end, { force = true })

      query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
        local id = pred[2]
        local node = unwrap(match[id])
        if not node then
          return
        end
        local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr, { metadata = metadata[id] })
        if ok and text then
          if not metadata[id] then
            metadata[id] = {}
          end
          metadata[id].text = text:lower()
        end
      end, { force = true })

      local html_script_type_languages = {
        ["importmap"] = "json",
        ["module"] = "javascript",
        ["application/ecmascript"] = "javascript",
        ["text/ecmascript"] = "javascript",
      }
      query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
        local capture_id = pred[2]
        local node = unwrap(match[capture_id])
        if not node then
          return
        end
        local ok, type_attr_value = pcall(vim.treesitter.get_node_text, node, bufnr)
        if ok and type_attr_value then
          local configured = html_script_type_languages[type_attr_value]
          if configured then
            metadata["injection.language"] = configured
          else
            local parts = vim.split(type_attr_value, "/", {})
            metadata["injection.language"] = parts[#parts]
          end
        end
      end, { force = true })

      query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
        local node = unwrap(match[pred[2]])
        local n = tonumber(pred[3])
        if node and node:parent() and node:parent():named_child_count() > n then
          return node:parent():named_child(n) == node
        end
        return false
      end, { force = true })

      query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
        local node = unwrap(match[pred[2]])
        local types = { unpack(pred, 3) }
        if not node then
          return true
        end
        return vim.tbl_contains(types, node:type())
      end, { force = true })

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "dart",
          "bash",
          "c",
          "diff",
          "html",
          "javascript",
          "json",
          "lua",
          "luadoc",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
}
