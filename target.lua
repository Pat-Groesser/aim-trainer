Target = {}

local function generateRandomTargetPosition(size)
  local randomPoints = {}
  randomPoints.x = math.random(size, love.graphics.getWidth()-size)
  randomPoints.y = math.random(size+20, love.graphics.getHeight()-size)

  return randomPoints
end

function Target:new(size)
  local randomPoints = generateRandomTargetPosition(size)
  local target = {
      x = randomPoints.x,
      y = randomPoints.y,
      size = size,
      hitDistance = 0
  }
  self.__index = self
  return setmetatable(target, self)
end
