# A simple UI library written in Lua for the LÖVE2D framework

:warning: It's raw, not tested, not polished. There are gaps to be filled :warning:

## Give it a taste

```
local ui = require('ui')

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
```

## Feature list

- Basic elements are :
    - `Layout`
    - `Stack`
    - `Image`
    - `Label`
- Declarative approach. Similar to QML.
- Grid layout. Nested layouts are possible.
- Auto alignment. Alignment hints : `center`, `top`, `bottom`, `left` or
  combination.
- Each element inside the layout can be set to fill `width`, `height`, both or
  none.
- Communication with the external logic through the signals "attached" to the
  elements

## Examples

### Layout

This example is just a demo of the layouting system (code
[here](/examples/layout.lua)):

![layout example](/gifs/layout.gif)

### Signals

This is the simplest game ever written with LÖVE2D (code
[here](/examples/o.lua)):

![signals example](/gifs/o.gif)

## Acknowledgements and similar projects

I had seen several ui libs before I decided to write my own. Though I didn't
find the one which would have everything I needed I've learned a lot from them.

- More or less the list of those can be found
here [love2d ui libs](https://www.love2d.org/wiki/Graphical_User_Interface).
- Also see [yui](https://codeberg.org/1414codeforge/yui)


