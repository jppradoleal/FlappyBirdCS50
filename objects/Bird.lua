Bird = Class{}

-- Variavel de gravidade, quanto maior mais o passaro é puxado pra baixo
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

    -- Variavel de velocidade y (vertical)
    self.dy = 0
end

-- Desenha o passarinho na tela
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    -- Velocidade y += gravidade * deltaTime
    self.dy = self.dy + GRAVITY * dt

    -- Se espaço foi pressionado velocidade vai um pouco pra cima(pulo)
    if love.keyboard.wasPressed('space') then
        self.dy = -5
        sounds['jump']:play()
    end

    -- posição vertical recebe velocidade vertical
    self.y = self.y + self.dy
end

function Bird:collides(pipe)
    -- Se o tamanho do passarinho (-2 de lado) maior que o x do cano ou, se o x do passarinho
    -- + 2 é menor que o tamanho do cano
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        -- Se o tamanho vertical do passarinho (-2) é maior que o y do passarinho
        -- ou se o tamanho vertical do passarinho(-2) é menor que o tamanho vertical do cano
        if (self.y+2) + (self.height-4) >= pipe.y and self.y+2 <= pipe.y + PIPE_HEIGHT then
            -- colidiu
            return true
        end
    end
    -- Não colidiu
    return false
end