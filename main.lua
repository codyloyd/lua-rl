ROT=require './lib/rotLove/src/rot'
require('colors')
require('loadTileset')
inspect = require('/lib/inspect/inspect')
local moonshine = require 'lib/moonshine'

love.window.setMode(1024,768)
love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
  love.keyboard.setKeyRepeat(true)
  startScreen = require('startScreen')
  playScreen = require('playScreen')
  winScreen = require('winScreen')
  loseScreen = require('loseScreen')
  screenWidth = 40
  screenHeight = 14
  tilewidth = 16
  tileheight = 24

  font = love.graphics.setNewFont('font/CP437.ttf', 16)
  charWidth = love.graphics.getFont():getWidth('e')
  charHeight = love.graphics.getFont():getHeight('e')

  scheduler=ROT.Scheduler.Speed:new()
  engine=ROT.Engine:new(scheduler)
  engine:start()

  switchScreen(startScreen)

  tiles = {}
  tiles.Terrain = loadTileset('img/Terrain.json')
  tiles.Terrain_Objects = loadTileset('img/Terrain_Objects.json')
  tiles.Monsters = loadTileset('img/Monsters.json')
  tiles.Avatar = loadTileset('img/Avatar.json')
  tiles.Items = loadTileset('img/Items.json')
  love.window.setMode(2*screenWidth*tilewidth,2*screenHeight*tileheight)
  canvas = love.graphics.newCanvas()
  canvas:setFilter('nearest', 'nearest')
end

function love.update(dt)
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear(Colors.black)
  currentScreen.render(frame)
  love.graphics.setCanvas()
  love.graphics.draw(canvas, 0 ,0 ,0, 2)
end

function love.keypressed(key)
  currentScreen.keypressed(key)
end

function refresh()
  currentScreen.render(frame)
end

function switchScreen(screen)
  if currentScreen then
    currentScreen.exit()
  end
  currentScreen=screen
  if currentScreen then
    currentScreen.enter()
    refresh()
  end
end

--helpers

function sendMessage(recipient, message)
  if recipient:hasMixin('MessageRecipient') then
    recipient:receiveMessage(message)
  end
end

function sendMessageNearby(level, x, y, message)
  local entities = level.getEntitiesWithinRadius(x,y,5)
  for _, entity in pairs(entities) do
    sendMessage(entity, message)
  end
end

function getNeighborPositions(centerX, centerY)
  local tiles = {}
  for dx = -1, 1 do
    for dy = -1, 1 do
      if dx ~= 0 and dy ~= 0 then
        table.insert(tiles, {x = centerX + dx, y = centerY + dy})
      end
    end
  end
end

function splitString(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end
