require('colors')
require('mixins')
require('glyph')

Entity = {}
Entity.new = function(opts) 
  self = {}
  local glyph = Glyph.new(opts)
  for k,v in pairs(glyph) do
    self[k] = v
  end
  self.name = opts and opts.name or 'ENTITY'
  self.x = opts and opts.x or 0
  self.y = opts and opts.y or 0
  self.map = opts and opts.map
  self.speed = opts and opts.speed or 1000

  -- mixin system
  self.attachedMixins = {}
  self.attachedMixinGroups = {}
  mixins = opts and opts.mixins
  if mixins then
    for _,mixin in ipairs(mixins) do
      for key,value in pairs(mixin) do
        if key ~= 'init' and key ~= 'name' then
          self[key] = value
        end
      end
      self.attachedMixins[mixin.name] = true
      if mixin.groupName then
        self.attachedMixinGroups[mixin.groupName] = true
      end
      if mixin.init then
        mixin.init(self, opts)
      end
    end
  end
  self.hasMixin = function(self, mixin) 
    if type(mixin) == 'table' then
      return self.attachedMixins[mixin.name]
    elseif type(mixin) == 'string' then
      return self.attachedMixins[mixin] or self.attachedMixinGroups[mixin]
    end
  end

  function self:getSpeed() return self.speed end

  return self
end

Entity.PlayerTemplate = {
  name = 'You', 
  char = '@',
  fg = Colors.white,
  bg = Colors.black,
  maxHp = 40,
  attackValue = 10,
  mixins = {Mixins.Movable, Mixins.PlayerActor, Mixins.Destructible, Mixins.Attacker, Mixins.MessageRecipient}
}

Entity.FungusTemplate = {
  name = 'fungus',
  char = 'F',
  fg = Colors.leaf,
  bg = Colors.black,
  maxHp = 10,
  speed = 250,
  mixins = {Mixins.FungusActor, Mixins.Destructible}
}

Entity.MonsterTemplate = {
  name = 'monster',
  char = 'M',
  fg = Colors.ocher,
  bg = Colors.black,
  maxHp = 10,
  speed = 900,
  sightRadius = 8,
  mixins = {Mixins.Movable, Mixins.Attacker, Mixins.MonsterActor, Mixins.Destructible, Mixins.Sight}
}

Entity.BatTemplate = {
  name = 'bat',
  char = 'b',
  fg = Colors.cornflower,
  bg = Colors.black,
  maxHp = 10,
  speed = 1600,
  sightRadius = 10,
  mixins = {Mixins.Movable, Mixins.Attacker, Mixins.MonsterActor, Mixins.Destructible, Mixins.Sight}
}
