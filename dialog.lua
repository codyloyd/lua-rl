Dialog = {}

Dialog.new = function(opts) 
  local self = {}
  -- local charWidth = 8
  -- local charHeight = 12
  local text = opts and opts.text or nil
  local maxWidth = screenWidth * charWidth - (8 * charWidth)
  local maxHeight = screenHeight * charHeight - (8 * charWidth)

  if text then
    width = (opts and opts.width or string.len(text) ) * charWidth + 2 * charWidth
    height = charHeight * math.ceil(width/(maxWidth - 2 * charWidth)) + 2 * charHeight
  end
  function self:render() 
    love.graphics.setColor(Colors.black)
    love.graphics.rectangle('fill', 2 * charWidth, 2 * charHeight, math.min(width, maxWidth), math.min(height, maxHeight))

    love.graphics.setColor(Colors.slate)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', 2 * charWidth, 2 * charHeight, math.min(width, maxWidth), math.min(height, maxHeight))

    love.graphics.setColor(Colors.white)
    love.graphics.printf(text, 3 * charWidth, 3 * charHeight, maxWidth - 2*charWidth, 'left')
    -- if opts.render then opts.render() end
  end
  function self:keypressed(key)
    -- if opts.keypressed then opts.keypressed(key) end
    --managed keypresses
  end

  return self
end
