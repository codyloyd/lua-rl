-- local startScreen = require('startScreen')
local screen = {}

screen.enter = function()
  print('entered loser screen')
end

screen.exit = function()
  print('exited loser screen')
end

screen.render = function(frame)
  frame:drawText(1,1,"%c{yellow}LOSER")
end

screen.keypressed = function(key)
  if key=='return' then switchScreen(startScreen) end
end

return screen