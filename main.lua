ROT=require './lib/rotLove/src/rot'
require('colors')

function love.load()
  love.keyboard.setKeyRepeat(true)
  startScreen = require('startScreen')
  playScreen = require('playScreen')
  winScreen = require('winScreen')
  loseScreen = require('loseScreen')
  screenWidth = 100
  screenHeight = 30 

  frame=ROT.Display(screenWidth, screenHeight + 1,1,Colors.white,Colors.black)
  scheduler=ROT.Scheduler.Simple:new()
  engine=ROT.Engine:new(scheduler)
  engine:start()

  switchScreen(startScreen)
end

function love.update(dt)
end

function love.draw()
  frame:draw()
end

function love.keypressed(key)
  currentScreen.keypressed(key)
end

function refresh()
  frame:clear()
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