Dialog = {}

Dialog.new = function(opts) 
  local self = {}
  local text = opts and opts.text or nil
  local maxWidth = screenWidth * charWidth - (8 * charWidth)
  local maxHeight = screenHeight * charHeight - (8 * charWidth)

  if text then
    width = string.len(text) * charWidth + 2 * charWidth
    height = charHeight * math.ceil(width/(maxWidth - 2 * charWidth)) + 2 * charHeight
  else
    width = opts and opts.width or maxWidth
    height = opts and opts.height or maxHeight
  end

  function self:renderContent()
    return false
  end

  function self:render() 
    love.graphics.setColor(Colors.black)
    love.graphics.rectangle('fill', 2 * charWidth, 2 * charHeight, math.min(width, maxWidth), math.min(height, maxHeight))

    love.graphics.setColor(Colors.slate)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', 2 * charWidth, 2 * charHeight, math.min(width, maxWidth), math.min(height, maxHeight))

    love.graphics.setColor(Colors.white)

    if self:renderContent() or not text then
      self:renderContent()
    else
      love.graphics.printf(text, 3 * charWidth, 3 * charHeight, maxWidth - 2*charWidth, 'left')
    end
  end


  function self:keypressed(key)
  end

  return self
end
