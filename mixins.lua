Mixins = {}

-- Movable!
Mixins.Movable = {
  name = 'Movable'
}

function Mixins.Movable:tryMove(x,y,level) 
    tile = level.map.getTile(x,y)
    target = level.getEntityAt(x,y)
    if target and target:hasMixin('Destructible') then
      if self:hasMixin('Attacker') then
        self:attack(target)
      end
      return
    end
    if tile and tile.isWalkable then
      self.x, self.y = x, y
      return true
    end
    return false
  end

-- Destructible!

Mixins.Destructible = {
  name = 'Destructible',
}

function Mixins.Destructible:init(opts)
  self.maxHp = opts and opts.maxHp or 10
  self.hp = opts and opts.hp or self.maxHp
  self.defenseValue = opts and opts.defenseValue or 0
end

function Mixins.Destructible:takeDamage(attacker, damage)
  self.hp = self.hp - damage
  if self.hp <= 0 then
    sendMessage(attacker, string.format('You kill the %s!', self.name))
    sendMessage(self, string.format('You die at the hands of the %s!', attacker.name))
    self.level.removeEntity(self)
  end
end

-- Attacker!!

local Attacker = {
  name = 'Attacker',
  groupName = 'Attacker'
}

function Attacker:init(opts)
  self.attackValue = opts and opts.attackValue or 1
end

function Attacker:attack(target)
  if target == self then return end
  if target:hasMixin('Destructible') then
    attack, defense = self.attackValue, target.defenseValue
    damage = math.random(1, math.max(0, attack - defense))
    sendMessage(self, string.format("You strike the %s for %d damage!", target.name, damage))
    sendMessage(target, string.format("The %s strikes you for %d damage!", self.name, damage))
    target:takeDamage(self, damage)
  end
end

Mixins.Attacker = Attacker

-- MessageRecipient!!

local MessageRecipient = {
  name = 'MessageRecipient'
}

function MessageRecipient:init(opts)
  self.messages = {}
end

function MessageRecipient:receiveMessage(message)
  table.insert(self.messages, message)
end

function MessageRecipient:clearMessages()
  self.messages = {}
end

Mixins.MessageRecipient = MessageRecipient

-- Sight !!
local Sight = {
  name = 'Sight'
}

function Sight:init(opts)
  self.sightRadius = opts and opts.sightRadius or 5
end

function Sight:canSee(entity)
  -- if they're on the same level
  if entity.map ~= self.map then return false end
  -- and technically within the SightRadius
  if math.abs(entity.x - self.x) > self.sightRadius or
    math.abs(entity.y - self.y) > self.sightRadius then
    return false
  end

  return true
  -- local found = false
  -- fov:compute(self.x, self.y, self.sightRadius, function(x,y,r,v) 
  --   if x == entity.x and y == entity.y then 
  --     found = true 
  --   end
  -- end)
  -- return found
end

Mixins.Sight = Sight

-- Actors!!

Mixins.PlayerActor = {
  name= 'PlayerActor',
  groupName= 'Actor',
  act= function(self)
    refresh()
    engine:lock()
    self:clearMessages()
  end
}

Mixins.FungusActor = {
  name= 'FungusActor',
  groupName= 'Actor',
}

function Mixins.FungusActor:init()
  self.growthsRemaining = 5;
end

function Mixins.FungusActor:act()
  if self.growthsRemaining > 0 then
    if love.math.random() < .03 then
      local xoffset, yoffset = math.random(-1, 1), math.random(-1, 1)
      if xoffset ~= 0 or yoffset ~= 0 then
        local x, y = self.x + xoffset, self.y + yoffset
        if self.level.isEmptyFloor(x, y) then
          local newFungus = Entity.new(Entity.FungusTemplate)
          newFungus.x, newFungus.y = x, y
          self.level.addEntity(newFungus)
          self.growthsRemaining = self.growthsRemaining - 1
          sendMessageNearby(self.level, self.x, self.y, 'The fungus is spreading!')
        end
      end
    end
  end
end

Mixins.MonsterActor = {
  name = 'MonsterActor',
  groupName = 'Actor'
}

function Mixins.MonsterActor:act()
  local dx = math.random( -1, 1 )
  local dy = math.random( -1, 1 )
  if self:canSee(player) then
    local newX, newY = nil, nil
    path = ROT.Path.AStar(player.x, player.y, function(x,y)
      return self.map.getTile(x,y) and self.map.getTile(x,y).isWalkable
    end)
    count = 0
    path:compute(self.x, self.y, function(x,y) 
      if count == 1 then
        newX, newY = x, y
      end
      count = count + 1
    end)
    if newX and newY then
      self:tryMove(newX, newY, self.level)
      return
    end
  else
    if dx or dy then
      self:tryMove(self.x + dx, self.y + dy, self.level)
    end
  end
end
