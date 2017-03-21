# Description

Bare-bones implementation of the puzzle variously called Mystic Square, 15-tile sliding puzzle or Boss Puzzle, the bane of point & click adventure gamers across the globe.

Inspired by Rosetta Code to have a go at it.

# Usage

Clone into your local source repository and load it with ASDF:

```
(asdf:load-system :cl-boss)
```

Start the game:

```
(cl-boss:start-game)
```

It takes an optional argument `size`, the default is 4.

Use the `u`, `d`, `l`, and `r` keys to move any of the active tiles surrounding the empty slot. Press `q` to quit.

Tested with SBCL 1.3.12.

# Todo

- Improve shuffling: currently, it happens via explicitly executed moves. Upside: no solvability validation required. However, the numbers between 0,0 and n,n get "tendentious" if the puzzle is large.