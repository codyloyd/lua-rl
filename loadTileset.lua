json = require('/lib/json/json')
inspect = require('/lib/inspect/inspect')

function loadTileset(jsonFile)
  local tileset = {}

  local data = json.decode(readAll(jsonFile))

  tileset.image = love.graphics.newImage('img/'..data.image)
  tileset.tiles = {}
  for i=0,data.tilecount do
    tileset.tiles[i] = love.graphics.newQuad(
      (i % data.columns)*data.tilewidth,
      (math.floor(i/data.columns))*data.tileheight,
      data.tilewidth,
      data.tileheight,
      tileset.image:getDimensions()
    )
  end
  return tileset
end

function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end
