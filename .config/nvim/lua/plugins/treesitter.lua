return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = function(_, opts)
      -- Reconfigure the [c and ]c navigation mappings to use
      -- [k and ]k instead, to avoid conflicts with our diagnostics maps
      for _, config in pairs(opts.move.keys) do
        if type(config) == "table" then
          config["]k"] = config["]c"]
          config["[k"] = config["[c"]
          config["]c"] = nil
          config["[c"] = nil
        end
      end
    end,
  },
}
