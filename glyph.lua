require('colors')
Glyph = {}
Glyph.new = function(opts) 
  local self = {}
  self.char = opts and opts.char or ' '
  self.tileset = opts and opts.tileset or 'Terrain'
  self.tileid = opts and opts.tileid or 15
  self.bitMask = nil
  self.bitMaskMap = opts and opts.bitMaskMap or nil
  self.fg = opts and opts.fg or Colors.white
  self.bg = opts and opts.bg or Colors.black
  return self
end
