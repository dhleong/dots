local Util = require("lazyvim.util")

--- Helpers {{{
local function cmp_helpers()
  local cmp = require("cmp")
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

  local function fast_cmp_visible()
    -- NOTE: cmp:visible() is quite slow, and we use it on a fairly
    -- hot path. This hack reaches in to speed up the check
    if not (cmp.core.view and cmp.core.view.custom_entries_view) then
      return false
    end
    return cmp.core.view.custom_entries_view:visible()
  end

  local M = {}

  ---@param key_or_config string|{ key:string, cmdwin: string }
  function M.try_accept_completion(key_or_config)
    local key = ""
    local cmdwin = nil
    if type(key_or_config) == "table" then
      key = key_or_config.key
      cmdwin = key_or_config.cmdwin
    else
      key = key_or_config
    end

    return cmp.mapping(function(fallback)
      if fast_cmp_visible() and cmp.get_active_entry() then
        local entry = cmp.get_active_entry()

        cmp.confirm()

        if key and not entry_has_key(entry, key) then
          vim.api.nvim_feedkeys(key, "nt", false)
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
      elseif ok and luasnip.jumpable(opts.jump_direction) then
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
  { "lukas-reineke/cmp-under-comparator" },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    event = "VeryLazy",
  },

  {
    "neovim/nvim-lspconfig",

    opts = {
      diagnostics = {
        float = {
          -- Show the source of the diagnostic, always
          source = true,
        },
      },
    },

    init = function()
      -- Intercept lazyvim's lsp keymaps and replace them with our own.
      require("plugins.lsp.keymaps").init()

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

    opts = function(_, opts)
      local cmp = require("cmp")
      local helpers = cmp_helpers()

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
        ["("] = helpers.try_accept_completion("("),
        ["."] = helpers.try_accept_completion("."),
        -- NOTE: The enter key is a bit special here; if we use the normal fallback
        -- from the cmdline window, we will end up performing a bunch of edits due to
        -- the fallback mappings from endwise (which would run *after* the cmdline
        -- window gets closed)
        ["<CR>"] = helpers.try_accept_completion({ cmdwin = "<CR>" }),
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

          -- Prefer local vars in ties. Might also try .locality here
          -- (which uses distance to cursor)
          cmp.config.compare.scopes,
        },
      }

      return opts
    end,
  },
}
