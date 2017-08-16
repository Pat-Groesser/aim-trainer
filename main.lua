function love.load()

-- Target properties
target = {}
generateRandomTargetPosition()

-- Game properties
game = {}
game.score = 0
game.timer = 0

-- Other variables
gameFont = love.graphics.newFont(15)

end

function love.update(dt)

end

function love.draw()

love.graphics.setColor(255, 0, 0)
love.graphics.circle('fill', target.x, target.y, target.size)

love.graphics.setColor(255, 255, 255)
love.graphics.setFont(gameFont)
love.graphics.printf('Score : '..game.score, 20, 10, love.graphics.getWidth())
end

function love.mousepressed(x, y, button, isTouch)
  -- 1 is the value for the left click
  if 1 == button then
    local mousePosition = {}
    mousePosition.y = y
    mousePosition.x = x
    if getDistanceBetween(target, mousePosition) < target.size then
      game.score = game.score + 10
      generateRandomTargetPosition()
    end
  end
end

function getDistanceBetween(pointA, pointB)
  return math.sqrt((pointB.y - pointA.y)^2 + (pointB.x - pointB.x)^2)
end

function generateRandomTargetPosition()
  target.size = math.random(10, 100)
  target.x = math.random(target.size, love.graphics.getWidth()-target.size)
  target.y = math.random(120, love.graphics.getHeight()-target.size)
end
