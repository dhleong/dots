dots
====

*My dots.*

## What

These are my dotfiles, mostly for making Vim work the way I like it.

## How

I don't recommend you install these. I like the way they make my system
work, but you'd be better off just looking through them and trying things
you find interesting rather than copying everything verbatim.

However, if you're actually me on a new computer, or if you just insist
on using my config files, I use [doteur][1] to install them right now.
It looks like this:

```bash
$ brew install babashka/brew/bbin
$ bbin install io.github.dhleong/doteur

$ doteur add git@github.com:dhleong/dots.git
$ doteur update
```

### Full automated setup

```bash
bash -c "$(curl -fsSL https://raw.github.com/dhleong/dots/master/.config/dhleong/setup)"
```

[1]: https://github.com/dhleong/doteur
