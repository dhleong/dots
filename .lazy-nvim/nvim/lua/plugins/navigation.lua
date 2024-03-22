return {
  { 'tpope/vim-vinegar' },
  {
    'junegunn/fzf',
    build = './install --bin',
  },
  { 'junegunn/fzf.vim' },
  {
    dir = '.',
    event = 'VeryLazy',
    name = 'My projects',
    config = function()
      require('dhleong.projects').init()
    end
  },
}
