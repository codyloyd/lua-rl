-- local playScreen = require('playScreen')
local screen = {}

screen.enter = function()
  print('entered start screen')
end

screen.exit = function()
  print('exited start screen')
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