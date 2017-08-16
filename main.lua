function love.load()

testMessage = 'test'

end

function love.update(dt)

end

function love.draw()

love.graphics.printf(testMessage, 0, 0, love.graphics.getWidth(), 'center')

end
