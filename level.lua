require('tile')
require('map')
require('entity')

Level = {}
function Level.new(opts)
  local self = {}
  self.entities = {}
  self.map = Map.new()
  self.exploredTiles = {}

  function self.getEntityAt(x,y) 
    for _,entity in pairs(self.entities) do
      if entity.x == x and entity.y == y then
        return entity
      end 
    end
    return false
  end

  function self.getEntitiesWithinRadius(centerX, centerY, radius)
    local results = {}
    local leftX, rightX = centerX - radius, centerX + radius
    local topY, bottomY = centerY - radius, centerY + radius
    for _, entity in pairs(self.entities) do
      if entity.x >= leftX and entity.x <= rightX and entity.y >= topY and entity.y <= bottomY then
        table.insert(results, entity)
      end
    end
    return results
  end

  function self.addEntity(entity)
    if entity.x < 0 and entity.x >= self.map.width or
      entity.y < 0 or entity.y >= self.map.height then
        -- throw error.. oops
    end
    entity.level = self
    table.insert(self.entities, entity)
    if entity:hasMixin('Actor') then scheduler:add(entity, true) end
  end

  function self.removeEntity(entityToRemove)
    for i, entity in pairs(self.entities) do
      if entity == entityToRemove then
        table.remove(self.entities, i)
        if entity:hasMixin('Actor') then scheduler:remove(entity) end
      end
    end
  end

  function self.isEmptyFloor(x, y)
    return self.map.getTile(x, y) and self.map.getTile(x,y).name == 'floorTile' and not self.getEntityAt(x,y)
  end

  function self.getRandomFloorPosition()
    local x, y
    repeat
      x, y = math.random(1,self.map.width), math.random(1,self.map.height)
    until (self.isEmptyFloor(x, y))
    return x, y
  end

  function self.addEntityAtRandomPosition(entity)
    entity.x, entity.y = self.getRandomFloorPosition()
    self.addEntity(entity)
  end

  -- add entities to map
  for i=1, 3 do
    local entity = Entity.new(Entity.FungusTemplate)
    self.addEntityAtRandomPosition(entity)
  end
  -- add downstairs
  self.downstairs = {}
  self.downstairs.x, self.downstairs.y = self.getRandomFloorPosition()
  self.map.setTile(self.downstairs.x, self.downstairs.y, Tile.stairDownTile)
  return self
end