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

local function install_last_query(base, params)
  local fzf_lua = require("fzf-lua")

  -- Things that use no_esc need `search` for that to
  -- work properly. This API is silly but...
  if base.no_esc then
    params.search = fzf_lua.get_last_query()
  else
    params.query = fzf_lua.get_last_query()
  end
end

local function enrich(base, perform_search, opts)
  local fzf_lua = require("fzf-lua")

  -- Apply common options:
  base.fzf_opts = {
    ["--layout"] = "default",
    ["--style"] = "minimal",
  }

  local base_header = ""
  if base.header and base.header[1] then
    base_header = base.header[1]
  end

  -- Support "widening" as appropriate
  if opts.monorepo_root then
    local non_monorepo = base
    return vim.tbl_deep_extend("force", base, {
      header = {
        fzf_hl("magenta", "ctrl-o") .. " switch to monorepo-wide search" .. "  " .. base_header,
      },
      actions = {
        ["ctrl-o"] = {
          fn = function()
            local monorepo_params = {
              prompt = base.prompt and make_dirname_prompt(opts.monorepo_root),
              winopts = {
                title = dirname(opts.monorepo_root),
              },
              cwd = opts.monorepo_root,
            }

            install_last_query(non_monorepo, monorepo_params)
            perform_search(non_monorepo, monorepo_params)
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
        local entry = selected[1]
        if entry then
          vim.cmd[sink](local_opts.cwd .. "/" .. entry)
        end
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

  local source_only_header = fzf_hl("magenta", "ctrl-s") .. " remove test files"
  local base = {
    winopts = {
      title = dirname(project_dir),
      preview = {
        flip_columns = 150,
        vertical = "up:35%",
      },
    },
    hls = {
      -- When using brackets in the query, we get errors about vim.regexp
      -- if we don't disable this highlight group:
      search = false,
    },
    header = {
      -- NOTE: Replace the default header; it's very messy
      source_only_header,
    },
    no_esc = true,
    -- I tend not to want regex when using text search (I like using brackets!)
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --fixed-strings -- ",
    actions = {
      ["default"] = {
        fn = function(output, local_opts)
          require("dhleong.nav")._open_text_result(sink, local_opts.cwd .. output[1])
        end,
      },
      ["ctrl-f"] = { fzf_lua.actions.grep_lgrep },
    },
  }

  local function perform_search(base_opts, extra_opts)
    fzf_lua.live_grep_native(vim.tbl_extend("force", base_opts, extra_opts))
  end

  base = enrich(base, perform_search, o)

  local source_only_globs = {
    "!**/tests/**",
    "!**/test/**",
    "!test_*",
  }
  base.actions["ctrl-s"] = {
    fn = function()
      local glob_opts = "--glob '" .. table.concat(source_only_globs, "' --glob '") .. "'"
      local source_only_params = {
        header = {
          vim.fn.substitute(base.header[1], source_only_header, "", ""),
        },
        rg_opts = glob_opts .. " " .. base.rg_opts,
        actions = {
          -- make this into a no-op
          ["ctrl-s"] = { fn = function() end },
        },
        cwd = project_dir,
      }

      install_last_query(base, source_only_params)
      perform_search(base, source_only_params)
    end,
    noclose = true,
    reuse = true,
  }

  perform_search(base, {
    cwd = project_dir,
    search = o.query,
  })
end

return M
