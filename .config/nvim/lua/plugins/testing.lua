return {
  { 'vim-test/vim-test' },
  {
    dir = '~/git/neo-latte',
    keys = {
      { '<leader>tt',  function() require 'neo-latte'.toggle_auto_test() end },
      { '<leader>tn',  function() require 'neo-latte'.toggle_auto_test('nearest') end },
      { '<leader>tq',  function() require 'neo-latte'.stop() end },
      { '<leader>trn', function() require 'neo-latte'.run('nearest') end },
      { '<leader>trf', function() require 'neo-latte'.run('file') end },
    }
  },
}
