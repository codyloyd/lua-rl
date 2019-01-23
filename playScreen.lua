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
noFOV = false

screen.enter = function()
  print('entered play screen')
  gameWorld = GameWorld.new()
  player = gameWorld.player
end

screen.exit = function()
  print('exited play screen')
end

screen.render = function(frame)
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

  fov:compute(player.x, player.y, 100, function(x,y,r,v)
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
          frame:write(tile.char, x-(topLeftX-1),y-(topLeftY-1), tile.fg, tile.bg)
        end
      elseif exploredTiles[key] then
        frame:write(tile.char, x-(topLeftX-1),y-(topLeftY-1), Colors.midnight, Colors.black)
      end
    end
  end

  -- render entities
  for _, entity in pairs(level.entities) do
    if entity.x >= topLeftX and entity.y >= topLeftY and entity.x < topLeftX + screenWidth and entity.y < topLeftY + screenHeight then
      local key = entity.x..','..entity.y
      if visibleTiles[key] then
        frame:write(entity.char, entity.x-(topLeftX-1), entity.y-(topLeftY-1), entity.fg, entity.bg)
      end
    end
  end

  -- render player
  frame:write(player.char,player.x-(topLeftX-1), player.y-(topLeftY-1), player.fg, player.bg)

  --render messages
  for i, message in ipairs(player.messages) do
    frame:write(message, 1, i)
  end
  player:clearMessages()

  frame:write(string.format("HP: %d/%d", player.hp, player.maxHp), 1, screenHeight+1)

  --render subscreen
  if subscreen then
    subscreen:render()
  end
end

screen.keypressed = function(key)
  --render subscreen keypress highjacks keypress function
  if subscreen then
    subscreen:keypressed(key)
    if key=='return' then 
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
  end
end

function move(dx, dy)
  newX = math.max(1, math.min(mapWidth, player.x + dx))
  newY = math.max(1, math.min(mapWidth, player.y + dy))
  player:tryMove(newX, newY, gameWorld:getCurrentLevel())
  engine:unlock()
end

return screen
