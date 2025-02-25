local function fzf_hl(color, text)
  return require("fzf-lua.utils").ansi_codes[color](text)
end

local function dirname(dir)
  if not dir then
    return ""
  end

  local mod = ":t"
  if vim.endswith(dir, "/") then
    mod = ":h:t"
  end
  return " " .. vim.fn.fnamemodify(dir, mod) .. " "
end

local function make_dirname_prompt(dir)
  return dirname(dir) .. "❯ "
end

local function enrich(base, perform_search, opts)
  local fzf_lua = require("fzf-lua")

  -- Apply common options:
  base.fzf_opts = {
    ["--layout"] = "default",
    ["--style"] = "minimal",
  }

  -- Support "widening" as appropriate
  if opts.monorepo_root then
    local non_monorepo = base
    return vim.tbl_deep_extend("force", base, {
      header = {
        fzf_hl("magenta", "ctrl-o") .. " switch to monorepo-wide search",
      },
      actions = {
        ["ctrl-o"] = {
          fn = function()
            perform_search(non_monorepo, {
              prompt = base.prompt and make_dirname_prompt(opts.monorepo_root),
              winopts = {
                title = dirname(opts.monorepo_root),
              },
              cwd = opts.monorepo_root,
              query = fzf_lua.get_last_query(),
            })
          end,
          noclose = true,
          reuse = true,
        },
      },
    })
  else
    return base
  end
end

local M = {}

function M.in_project(project_dir, sink, opts)
  local o = opts or {}
  local cwd = project_dir or vim.g.otsukare_default_project_root

  local fzf_lua = require("fzf-lua")

  local base = {
    winopts = {
      width = 0.6,
      height = 0.8,
      row = 0.2,
      col = 0.9,
      backdrop = 100,
    },

    previewer = false,
    file_icons = false,

    -- Provide context in the prompt IF in a monorepo
    prompt = o.monorepo_root and make_dirname_prompt(cwd),

    actions = {
      ["default"] = function(selected, local_opts)
        vim.cmd[sink](local_opts.cwd .. "/" .. selected[1])
      end,
    },
  }

  local function perform_search(base_opts, extra_opts)
    fzf_lua.fzf_exec(vim.env.HOME .. "/bin/list-repo-files", vim.tbl_extend("force", base_opts, extra_opts))
  end

  base = enrich(base, perform_search, o)

  perform_search(base, {
    cwd = cwd,
    query = o.query,
  })
end

function M.by_text(project_dir, sink, opts)
  local o = opts or {}

  local fzf_lua = require("fzf-lua")

  local base = {
    winopts = {
      title = dirname(project_dir),
      preview = {
        flip_columns = 150,
        vertical = "up:35%",
      },
    },
    header = {}, -- Disable the default header; it's very messy
    actions = {
      ["default"] = {
        fn = function(output, local_opts)
          M._open_text_result(sink, local_opts.cwd .. output[1])
        end,
      },
      ["ctrl-f"] = { fzf_lua.actions.grep_lgrep },
    },
  }

  local function perform_search(base_opts, extra_opts)
    fzf_lua.live_grep_native(vim.tbl_extend("force", base_opts, extra_opts))
  end

  base = enrich(base, perform_search, o)

  perform_search(base, {
    cwd = project_dir,
    query = o.query,
  })
end

return M
