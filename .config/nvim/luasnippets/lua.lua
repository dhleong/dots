return {
  s(
    "M",
    fmt(
      [[
        local M = {{}}

        {}

        return M
      ]],
      {
        i(0),
      }
    )
  ),

  s(
    "Mdot",
    fmt(
      [[
        function M.{f}({params})
          {}
        end
      ]],
      {
        i(0),
        f = i(1, "f"),
        params = i(2, "params"),
      }
    )
  ),
}
