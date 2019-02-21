require('map')
require('gameWorld')
require('tile')
require('entity')
require('colors')
require('dialog')

local screen = {}
local gameWorld
local subscreen
player = nil

screen.enter = function()
  gameWorld = GameWorld.new()
  player = gameWorld.player

  uiElements = {}
  uiElements.healthBar = gooi.newBar({value=1}):bg(Colors.black):fg(Colors.white)
  uiElements.magicBar = gooi.newBar({value=1}):bg(Colors.black):fg(Colors.white)

  updateUi = Luvent.newEvent()
  updateUi:addAction(
    function(uiElement, payload)
      uiElements[uiElement].value = payload
      if uiElement == 'healthBar' and payload < .6 then
        uiElements[uiElement]:fg(Colors.red)
      end
    end
  )

  topLeft = gooi.newPanel({x=0,y=0,w = 300, h = 60, layout="grid 3x3"})
  topLeft
  :setColspan(1,2,2)
  :setColspan(2,2,2)
  :setColspan(3,2,2)
  :add(
      gooi.newLabel({text='Health'}):left():fg(Colors.white),
      uiElements.healthBar,
      gooi.newLabel({text='MAGIC'}):left():fg(Colors.white),
      uiElements.magicBar
  ):setGroup('ui')
end

screen.exit = function()
end

screen.render = function()
  love.graphics.setCanvas(mapCanvas)
  love.graphics.clear(Colors.black)
  local level = gameWorld:getCurrentLevel()
  local map = gameWorld:getCurrentLevel().map
  --generate FOV data
  local visibleTiles = {}
  local exploredTiles = level.exploredTiles

  fov = ROT.FOV.Precise:new(function(fov,x,y)
    if map.getTile(x,y) and map.getTile(x,y).blocksLight then
      return false
    end
    return true
  end)

  fov:compute(player.x, player.y, 10, function(x,y,r,v)
    local key  =x..','..y
    visibleTiles[key] = true
    exploredTiles[key] = true
  end)

  -- render map
  topLeftX = math.max(1, player.x - (screenWidth / 2))
  topLeftX = math.min(topLeftX, mapWidth - screenWidth)
  topLeftY = math.max(1, player.y - (screenHeight / 2))
  topLeftY = math.min(topLeftY, mapHeight - screenHeight)
  for x=topLeftX, topLeftX - 1 + screenWidth do
    for y=topLeftY, topLeftY - 1 + screenHeight do
      local tile = map.getTile(x,y)
      local key = x..','..y
      if visibleTiles[key] and tile then
        if tile then
          local id = tile.tileid
          if tile.bitMaskMap and tile.bitMask then
            id = tile.bitMaskMap[tile.bitMask]
          end

          local image = tiles[tile.tileset].image
          local quad = tiles[tile.tileset].tiles[id]
          if x == player.x and y == player.y or level.items[x..','..y] or level.getEntityAt(x,y) then
            --do nothing
          else
            love.graphics.setColor(tile.fg)
            love.graphics.draw(image, quad, (x-(topLeftX))*tilewidth,(y-(topLeftY))*tileheight)
          end
        end
      elseif exploredTiles[key] then
        local id = tile.tileid
        if tile.bitMaskMap and tile.bitMask then
          id = tile.bitMaskMap[tile.bitMask]
        end

        local image = tiles[tile.tileset].image
        local quad = tiles[tile.tileset].tiles[id]
        love.graphics.setColor(Colors.lightBlack)
        love.graphics.draw(image, quad, (x-(topLeftX))*tilewidth,(y-(topLeftY))*tileheight)
      end
    end
  end


  --render items
  for coords, item in pairs(level.items) do
    x,y = tonumber(splitString(coords, ',')[1]), tonumber(splitString(coords, ',')[2])
    if x >= topLeftX and y >= topLeftY and x < topLeftX + screenWidth and y < topLeftY + screenHeight then
      local key = coords
      if visibleTiles[key] then
        local image = tiles[item.tileset].image
        local quad = tiles[item.tileset].tiles[tonumber(item.tileid)]
        love.graphics.setColor(item.fg)
        love.graphics.draw(image,quad,(x-(topLeftX))*tilewidth, (y-(topLeftY))*tileheight)
      end
    end
  end

  -- render entities
  for _, entity in pairs(level.entities) do
    if entity.x >= topLeftX and entity.y >= topLeftY and entity.x < topLeftX + screenWidth and entity.y < topLeftY + screenHeight then
      local key = entity.x..','..entity.y
      if visibleTiles[key] then
        local image = tiles[entity.tileset].image
        local quad = tiles[entity.tileset].tiles[tonumber(entity.tileid)]
        love.graphics.setColor(entity.fg)
        love.graphics.draw(image, quad, (entity.x-(topLeftX))*tilewidth,(entity.y-(topLeftY))*tileheight)
      end
    end
  end

  -- render player
  love.graphics.setColor(Colors.pureWhite)
  love.graphics.print('@', 4+(player.x-(topLeftX))*tilewidth, (player.y-(topLeftY))*tileheight, 0, 1.5)
  love.graphics.setCanvas()


  --render subscreen


  function getHealthColor(hp, maxHp)
    percentage = hp/maxHp
    if percentage > .6 then
      return Colors.white
    else
      return Colors.red
    end
  end


  love.graphics.setColor(Colors.pureWhite)
  -- effects(function()
    love.graphics.draw(mapCanvas, 0,0,0,2)
  -- end)

  if subscreen then
    love.graphics.setColor(Colors.pureWhite)
    subscreen:render()
  else
    gooi.draw('ui')
  end

end

screen.keypressed = function(key)
  --render subscreen keypress highjacks keypress function
  if subscreen then
    subscreen:keypressed(key)
    if key=='escape' then
      subscreen = nil
      refresh()
    end
    return
  end

  if key=='q' then
  end

  if key=='return' then 
    switchScreen(winScreen)
  elseif key=='escape' then
    switchScreen(loseScreen)
  elseif key=='up' or key=='k' then
    move(0,-1)
  elseif key=='down' or key=='j' then
    move(0,1)
  elseif key=='left' or key =='h' then
    move(-1,0)
  elseif key=='right' or key== 'l' then
    move(1,0)
  elseif key=='b' then
    move(-1,1)
  elseif key=='n' then
    move(1,1)
  elseif key=='y' then
    move(-1,-1)
  elseif key=='u' then
    move(1,-1)
  elseif key=='.' and (love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift")) then
    downstairs = gameWorld:getCurrentLevel().downstairs
    if player.x == downstairs.x and player.y == downstairs.y then
      gameWorld:goDownLevel()
      refresh()
    end
  elseif key==',' and (love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift")) then
    upstairs = gameWorld:getCurrentLevel().upstairs
    if player.x == upstairs.x and player.y == upstairs.y then
      gameWorld:goUpLevel()
      refresh()
    end
  elseif key=='g' then
    -- pick item up
    local item = gameWorld:getCurrentLevel().items[player.x..','..player.y]
    if item then
      player:addInventoryItem(item)
      gameWorld:getCurrentLevel().removeItem(item)
    end
  elseif key=='i' then
    print('inventory lol')
  end
end

function move(dx, dy)
  newX = math.max(1, math.min(mapWidth, player.x + dx))
  newY = math.max(1, math.min(mapWidth, player.y + dy))
  player:tryMove(newX, newY, gameWorld:getCurrentLevel())
  engine:unlock()
end

return screen
