-- local playScreen = require('playScreen')
local screen = {}

screen.enter = function()
end

screen.exit = function()
end

screen.render = function(frame)
  frame:drawText(1,1,"%c{yellow}Love2D Roguelike")
  frame:drawText(1,2,"Press [Enter] to begin!")
end

screen.keypressed = function(key)
  if key=='return' then 
    switchScreen(playScreen)
  end
end

return screen
