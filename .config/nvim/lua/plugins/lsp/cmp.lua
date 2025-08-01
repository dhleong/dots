--- Helpers {{{
local function cmp_helpers(cmp_opts)
  local cmp = require("cmp")
  local skip_on_methods = cmp_opts.skip_on_methods

  local function char_after_cursor_is(ch)
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local col = cursor[2]

    local next_ch = string.sub(line, col + 1, col + 1)
    return next_ch == ch
  end

  local function entry_has_key(entry, key)
    if not entry.completion_item then
      return
    end

    if entry.completion_item.textEdit then
      return entry.completion_item.textEdit.newText:find(key, 1, true)
    end

    if entry.completion_item.insertText then
      return entry.completion_item.insertText:find(key, 1, true)
    end
  end

  local function entry_is_kind(entry, kinds)
    return vim.tbl_contains(kinds, entry.completion_item.kind)
  end

  local function should_skip_on_methods()
    local ft = vim.bo.filetype
    if not skip_on_methods or not skip_on_methods[ft] then
      return false
    end

    local config = skip_on_methods[ft]
    if config == true then
      return true
    end

    -- NOTE: This may not work, and was not actually necessary for
    -- rust (why I built this) but keeping around for reference in case
    -- it becomes needed later.
    local lang = require("nvim-treesitter.parsers").ft_to_lang(ft)
    local ts_utils = require("nvim-treesitter.ts_utils")
    local node = ts_utils.get_node_at_cursor()
    if not node then
      return false
    end

    for _, query_str in ipairs(config) do
      local query = vim.treesitter.query.parse(lang, query_str)
      local captures = query:iter_captures(node, 0)
      if captures() then
        return true
      end
    end

    return false
  end

  local function fast_cmp_visible()
    -- NOTE: cmp:visible() is quite slow, and we use it on a fairly
    -- hot path. This hack reaches in to speed up the check
    ---@diagnostic disable-next-line: invisible
    if not (cmp.core.view and cmp.core.view.custom_entries_view) then
      return false
    end
    ---@diagnostic disable-next-line: invisible
    return cmp.core.view.custom_entries_view:visible()
  end

  local M = {}

  ---@param key_or_config string|{ key:string, pair:string|nil, cmdwin: string, on_methods:string|nil }
  function M.try_accept_completion(key_or_config)
    local key = ""
    local pair = nil
    local cmdwin = nil
    local on_methods = nil
    if type(key_or_config) == "table" then
      key = key_or_config.key
      cmdwin = key_or_config.cmdwin
      pair = key_or_config.pair
      on_methods = key_or_config.on_methods
    else
      key = key_or_config
    end

    local Kind = cmp.lsp.CompletionItemKind
    return cmp.mapping(function(fallback)
      if fast_cmp_visible() and cmp.get_active_entry() then
        local entry = cmp.get_active_entry()

        cmp.confirm()

        if key and not entry_has_key(entry, key) then
          local keys = key
          if pair then
            keys = keys .. pair .. "<left>"
          end

          local to_feed = vim.api.nvim_replace_termcodes(keys, true, false, true)
          vim.api.nvim_feedkeys(to_feed, "nt", false)
        elseif
          on_methods
          and entry_is_kind(entry, { Kind.Function, Kind.Method })
          and not entry_has_key(entry, string.sub(on_methods, 0, 1))
          and not char_after_cursor_is(string.sub(on_methods, 0, 1))
          and not should_skip_on_methods()
        then
          -- If we weren't given a pair to complete, we might have some keys
          -- to feed for methods (typically, auto-brackets)
          local to_feed = vim.api.nvim_replace_termcodes(on_methods, true, false, true)
          vim.api.nvim_feedkeys(to_feed, "nt", false)
        end
      elseif cmdwin and vim.fn.getcmdwintype() ~= "" then
        local to_feed = vim.api.nvim_replace_termcodes(cmdwin, true, false, true)
        vim.api.nvim_feedkeys(to_feed, "nt", true)
      else
        fallback()
      end
    end, { "i", "c" })
  end

  function M.create_tab_handler(opts)
    return cmp.mapping(function(fallback)
      local ok, luasnip = pcall(require, "luasnip")
      if vim.fn.pumvisible() ~= 0 or fast_cmp_visible() then
        opts.select_next_fn()
      elseif ok and luasnip.locally_jumpable(opts.jump_direction) then
        luasnip.jump(opts.jump_direction)
      else
        fallback()
      end
    end, { "i", "s" })
  end

  return M
end
-- }}}

return {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      {
        "lukas-reineke/cmp-under-comparator",
      },

      {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
          require("lsp_signature").setup(opts)
        end,
      },
      -- {
      --   "hrsh7th/cmp-nvim-lsp-signature-help",
      --   event = "VeryLazy",
      -- },
    },

    opts = {
      diagnostics = {
        float = {
          -- Show the source of the diagnostic, always
          source = true,
        },
      },
    },

    init = function()
      local Util = require("lazyvim.util")

      -- Setup our handlers
      Util.lsp.on_attach(function(client, _)
        if not client.handlers["textDocument/definition"] then
          local handler = require("dhleong.nav")._handle_lsp_location
          client.handlers["textDocument/declaration"] = handler
          client.handlers["textDocument/definition"] = handler
          client.handlers["textDocument/typeDefinition"] = handler
          client.handlers["textDocument/implementation"] = handler
        end
      end)
    end,
  },

  {
    "hrsh7th/nvim-cmp",

    enabled = true,

    opts = function(_, opts)
      local cmp = require("cmp")
      local helpers = cmp_helpers(opts)

      opts.skip_on_methods = nil
      opts.completion.completeopt = "menu,menuone,noselect"

      opts.mapping = {
        ["<S-Tab>"] = helpers.create_tab_handler({
          select_next_fn = cmp.select_prev_item,
          jump_direction = -1,
        }),
        ["<Tab>"] = helpers.create_tab_handler({
          select_next_fn = cmp.select_next_item,
          jump_direction = 1,
        }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<Space>"] = helpers.try_accept_completion(" "),
        ["("] = helpers.try_accept_completion({ key = "(", pair = ")" }),
        ["."] = helpers.try_accept_completion("."),
        -- NOTE: The enter key is a bit special here; if we use the normal fallback
        -- from the cmdline window, we will end up performing a bunch of edits due to
        -- the fallback mappings from endwise (which would run *after* the cmdline
        -- window gets closed)
        ["<CR>"] = helpers.try_accept_completion({ cmdwin = "<CR>", on_methods = "()<left>" }),
      }
      opts.preselect = cmp.PreselectMode.None
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
      }, {
        { name = "nvim_lsp_signature_help" },
      })

      opts.sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          require("cmp-under-comparator").under,
          cmp.config.compare.recently_used,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,

          -- Prefer local/nearby vars in ties.
          -- NOTE: .scopes is disabled atm because it is SLOW. Esp in elixir,
          -- it causes hangs when entering insert mode, or opening the cmdline
          -- cmp.config.compare.scopes, -- This uses scopes
          cmp.config.compare.locality, -- This uses distance to cursor
        },
      }

      return opts
    end,
  },
}
