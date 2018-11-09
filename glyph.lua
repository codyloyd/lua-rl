require('colors')
Glyph = {}
Glyph.new = function(opts) 
  local self = {}
  self.char = opts and opts.char or ' '
  self.fg = opts and opts.fg or Colors.white
  self.bg = opts and opts.bg or Colors.black 
  return self
end