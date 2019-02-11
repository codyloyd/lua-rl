-- local playScreen = require('playScreen')
local screen = {}

screen.enter = function()
end

screen.exit = function()
end

screen.render = function(frame)
  love.graphics.setColor(Colors.white)
  love.graphics.print("LOOK AT ME I'M A ROGUELIKE WRITTEN IN LUA", 16, 24, 0, 1.5)
end

screen.keypressed = function(key)
  if key=='return' then 
    switchScreen(playScreen)
  end
end

return screen
