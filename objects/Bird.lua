Bird = Class{}

local GRAVITY = 20

function Bird:init()
    -- Variavel de imagem do passarinho
    self.image = love.graphics.newImage('sprites/bird.png')
    -- Variaveis de tamanho
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    -- Variaveis de posição
    self.x = VIRTUAL_WIDTH / 2 - (self.width/2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height/2)

    self.dy = 0
end

-- Desenha o passarinho na tela
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end

    self.y = self.y + self.dy
end