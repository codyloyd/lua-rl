Map = {}
Map.new = function(opts)
  local self = {}
  self.tiles = {}
  mapWidth = 100
  mapHeight = 30 
  self.width = mapWidth
  self.height = mapHeight

  -- fill map with empty tiles
  for x = 1, mapWidth do
    self.tiles[x] = {}
    for y = 1, mapHeight do
      self.tiles[x][y] = Tile.nullTile
    end
  end

  -- generate map data
  local gen = ROT.Map.Brogue:new(mapWidth,mapHeight)
  gen:create(function (x,y,val)
    if val == 0 then
      self.tiles[x][y] = Tile.floorTile
    elseif val == 1 then
      self.tiles[x][y] = Tile.wallTile
    end
  end)

  function self.getTile(x,y)
    if x > 0 and x < self.width and y > 0 and y < self.height then
      return self.tiles[x][y]
    end
  end

  function self.setTile(x, y, tile)
    if self.tiles[x] and self.tiles[x][y] then
      self.tiles[x][y] = tile
    end
  end

  return self
end
