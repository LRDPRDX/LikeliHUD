# A simple UI library written in Lua for the LÖVE2D framework

[![Docs](https://github.com/LRDPRDX/LikeliHUD/actions/workflows/doc.yml/badge.svg)](https://github.com/LRDPRDX/LikeliHUD/actions/workflows/doc.yml)
[![pages-build-deployment](https://github.com/LRDPRDX/LikeliHUD/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/LRDPRDX/LikeliHUD/actions/workflows/pages/pages-build-deployment)

## Disclaimer

_This is not intended to be a universal GUI library - the direction under
this library is being developed mostly follows
the requirements I have while developing my game. As a result this library
might not fit your particular needs. More over, it might be changed
drastically from version to version._

## Give it a taste

```lua
local ui = require('likelihud')

local simple = ui.Layout {
    rows    = 2,
    columns = 2,

    ui.Label { text = 'Hello', },

    ui.Label { text = 'I', },

    ui.Label { text = 'am', },

    ui.Layout {
        rows    = 2,
        columns = 2,

        ui.Label { text = 'Li', },

        ui.Label { text = 'ke', },

        ui.Label { text = 'li', },

        ui.Label { text = 'HUD', },
    }
}

for block in simple:traverse() do
    block.border = true
end
```

![simple](images/simple.png)

## Feature list

- Basic elements are :
    - `ImageButton`
    - `Rectangle`
    - `Layout`
    - `Stack`
    - `Image`
    - `Label`
- Declarative approach. Similar to QML.
- Grid layout. Nested layouts are possible.
- Auto alignment. Alignment hints : `center`, `top`, `bottom`, `left` or a
  combination.
- Each element inside a layout can be set to fill `width`, `height`, both or
  none.
- Communication with the external logic through the signals "attached" to the
  elements

## Dependencies

 - [hump](https://hump.readthedocs.io/en/latest/signal.html) for signals
 - [subclass](https://github.com/LRDPRDX/lua-class) (used internally)

## Installation

```bash
luarocks install likelihud
```

## Examples

Run `main.lua` :

```bash
love path/to/likelihud
```

and press `1`, `2`, `3` to switch between examples. See the code [here](/examples).

### Layout

This is a demo (code [here](/main.lua)):

![demo](/gifs/demo.gif)

### Signals

This is the simplest game ever written with LÖVE2D (code [here](/examples/o.lua)):

![signals example](/gifs/o.gif)

### Documentation

Documentation is available [here](https://lrdprdx.github.io/LikeliHUD/).

## Acknowledgements and similar projects

I had seen several ui libs before I decided to write my own. Though I didn't
find the one which would have everything I needed I've learned a lot from them.

- More or less the list of those can be found
here [love2d ui libs](https://www.love2d.org/wiki/Graphical_User_Interface).
- Also see [yui](https://codeberg.org/1414codeforge/yui)

