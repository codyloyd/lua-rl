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

Tile.wallTile = {
  name='wallTile',
  char='#',
  tileset='Terrain',
  tileid=48,
  bitMaskMap = {
    [0]=48,
    [1]=48,
    [2]=48,
    [3]=48,
    [4]=48,
    [5]=48,
    [6]=48,
    [7]=48,
    [8]= 96,
    [9]= 96,
    [10]=96,
    [11]=96,
    [12]=96,
    [13]=96,
    [14]=96,
    [15]=96
  },
  fg=Colors.lightGray,
  blocksLight=true
}

Tile.floorTile = {
  name='floorTile',
  char='.',
  tileset='Terrain_Objects',
  tileid=8,
  fg=Colors.darkGray,
  isWalkable=true
}

Tile.stairUpTile = {
    name='stairUpTile',
    char='<',
    tileset='Terrain',
    tileid=28,
    fg=Colors.white,
    isWalkable=true
}

Tile.stairDownTile = {
    name='stairDownTile',
    char='>',
    tileset='Terrain',
    tileid=29,
    fg=Colors.white,
    isWalkable=true
}

Tile.nullTile = Tile.new()
