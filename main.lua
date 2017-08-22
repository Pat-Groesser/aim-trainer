function love.load()
  require('target')
  -- Game properties
  game = {}
  game.score = 0
  game.missedTargets = 0
  game.lifes = 3
  game.state = 1
  -- Other variables
  screenTitleFont = love.graphics.newFont(20)
  gameFont = love.graphics.newFont(15)
  -- Game states
  gameStates = {}
  gameStates.BEGIN = 1
  gameStates.PLAY = 2
  gameStates.GAMEOVER = 3
  -- Targets properties
  activeTargets = {}
  tmpHitTargets = {}
  targetSize = 40
  targetDisapearSpeed = 1/20
  targetSpawnSpeed = 1
  targetScaleRate = 1/2
  disapearTime = 0
  spawnTime = 0
end

function love.update(dt)
  if game.state == gameStates.PLAY then
    -- Update timers
    disapearTime = disapearTime + dt
    spawnTime = spawnTime + dt

    if disapearTime > targetDisapearSpeed then
      for i = 1, #activeTargets do
        if activeTargets[i].size ~= 0 then
          activeTargets[i].size = activeTargets[i].size - targetScaleRate
          if activeTargets[i].size == 0 then
              game.missedTargets = game.missedTargets + 1
              if game.missedTargets >= game.lifes then
                game.state = gameStates.GAMEOVER
              end
          end
          disapearTime = 0
      end
      end
    end
    if spawnTime > targetSpawnSpeed then
      table.insert(activeTargets, Target:new(targetSize))
      spawnTime = 0
    end
  end
end

function love.draw()
  if game.state == gameStates.BEGIN then
    love.graphics.setFont(screenTitleFont)
    love.graphics.printf('Click anywhere to start game. Don\'t miss your shots !', 0, love.graphics.getHeight()/2 , love.graphics.getWidth(), 'center')
  end

  if game.state == gameStates.PLAY then
    love.graphics.setColor(255, 0, 0)
    if activeTargets[1] ~= nil then
      for i = 1, #activeTargets do
        love.graphics.circle('fill', activeTargets[i].x, activeTargets[i].y, activeTargets[i].size)
      end
    end
  end

  if game.state == gameStates.GAMEOVER then
    love.graphics.setFont(screenTitleFont)
    love.graphics.printf('Game over ! Click anywhere to restart new game', 0, love.graphics.getHeight()/2 , love.graphics.getWidth(), 'center')

  end
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(gameFont)
  love.graphics.printf('Score : '..game.score, 20, 10, love.graphics.getWidth())
  love.graphics.printf('Miss : '..game.missedTargets..'/'..game.lifes, love.graphics.getWidth() - 150, 10, love.graphics.getWidth())
end

function love.mousepressed(x, y, button, isTouch)
  -- Start new game
  if game.state == gameStates.BEGIN or game.state == gameStates.GAMEOVER then
    game.missedTargets = 0
    game.score = 0
    activeTargets = {}
    table.insert(activeTargets, Target:new(targetSize))
    game.state = gameStates.PLAY
  end

  -- 1 is the value for the left click
  if 1 == button then
    local mousePosition = {}
    mousePosition.y = y
    mousePosition.x = x
    distanceBetweenAB = 0
    for i = 1, #activeTargets do
      if activeTargets[i].size ~= 0 then
        distanceBetweenAB = getDistanceBetween(activeTargets[i], mousePosition)
        if  distanceBetweenAB < activeTargets[i].size then
          activeTargets[i].hitDistance = distanceBetweenAB
          table.insert(tmpHitTargets, activeTargets[i])
        end
      end
    end
    if next(tmpHitTargets) ~= nil then
      addHit()
    end
  end
end

function getDistanceBetween(pointA, pointB)
  return math.sqrt((pointB.y - pointA.y)^2 + (pointB.x - pointB.x)^2)
end

function addHit()
  local closestTarget = tmpHitTargets[1]
  if #tmpHitTargets > 1 then
    for i = 1, #tmpHitTargets do
      if tmpHitTargets[i].hitDistance < closestTarget.hitDistance then
        closestTarget = tmpHitTargets[i]
      end
    end
  end
  closestTarget.size = 0
  game.score = game.score + 10
  tmpHitTargets = {}
end

-- function spawnTarget()
--   local collision = true
--   local spawnedTarget = {}
--   while collision == true do
--     collision = false
--     spawnedTarget = Target:new(targetSize)
--     for i = 1, #activeTargets do
--       if getDistanceBetween(spawnedTarget, activeTargets[i]) < targetSize * 2 then
--         collision = true
--       end
--     end
--   end
--   table.insert(activeTargets, spawnedTarget)
-- end
