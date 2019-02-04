require('glyph')
require('colors')

Tile = {}
Tile.new = function(opts)
  local self = {}
  local glyph = Glyph.new(opts)
  for k,v in pairs(glyph) do
    self[k] = v
  end
  self.name = opts and opts.name or 'tile'
  self.blocksLight = opts and opts.blocksLight
  self.isWalkable = opts and opts.isWalkable
  return self
end

Tile.wallTile = Tile.new({name='wallTile',char='#',fg=Colors.brown, blocksLight=true})
Tile.floorTile = Tile.new({name='floorTile',char='.', fg=Colors.darkGray, isWalkable=true})
Tile.stairUpTile = Tile.new({name='stairUpTile',char='<', fg=Colors.white, isWalkable=true})
Tile.stairDownTile = Tile.new({name='stairDownTile',char='>', fg=Colors.white, isWalkable=true})
Tile.nullTile = Tile.new()
