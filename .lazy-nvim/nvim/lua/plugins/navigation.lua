return {
  { 'tpope/vim-vinegar', event = 'VeryLazy' },
  {
    'junegunn/fzf',
    build = './install --bin',
    event = 'VeryLazy'
  },
  { 'junegunn/fzf.vim',  lazy = true },
  {
    dir = '.',
    event = 'VeryLazy',
    name = 'My projects',
    config = function()
      require('dhleong.projects').init()
    end
  },
}
