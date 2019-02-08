-- local n = require('startScreen')
local screen = {}

screen.enter = function()
end

screen.exit = function()
end

screen.render = function(frame)
  for i=1, 10, 1 do
    bg= {255-(i*20), 255-(i*20), 255-(i*20)}
    fg= {i*20,i*20,i*20}
    frame:write('you winnnnnnnn!',1,i,fg,bg)
  end
end

screen.keypressed = function(key)
  if key=='return' then 
    switchScreen(startScreen)
  end
end

return screen
