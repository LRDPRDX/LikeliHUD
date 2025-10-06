local package_name      = 'likelihud'
local package_version   = '1.0'
local rockspec_revision = '1'

rockspec_format = '3.0'

package = package_name
version = package_version .. '-' .. rockspec_revision

source = {
   url = 'git+https://github.com/LRDPRDX/LikeliHUD.git',
   tag = 'v' .. package_version,
}

description = {
   summary = 'A simple UI library for LOVE2D',
   detailed = [[
    A simple UI library for the LOVE2D framework with basic types:
        * Image
        * Label
        * Layout
        * Rectangle
        * Stack
   ]],
   homepage = 'https://lrdprdx.github.io/LikeliHUD',
   license  = 'MIT <http://opensource.org/licenses/MIT>',
}

dependencies = {
   'lua      >= 5.1',
   'subclass >= 1.0',
   'hump     >= 0.4',
}

build = {
   type = 'builtin',
   modules = {
      ['likelihud']           = 'ui/init.lua',
      ['likelihud.Block']     = 'ui/Block.lua',
      ['likelihud.Image']     = 'ui/Image.lua',
      ['likelihud.Label']     = 'ui/Label.lua',
      ['likelihud.Layout']    = 'ui/Layout.lua',
      ['likelihud.Rectangle'] = 'ui/Rectangle.lua',
      ['likelihud.Stack']     = 'ui/Stack.lua',
   },
}
