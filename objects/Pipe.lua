Pipe = Class{}

-- Recebe a imagem do cano
local PIPE_IMAGE = love.graphics.newImage('sprites/pipe.png')

-- Velocidade dos canos, deve ser a mesma do chão para nao ficar estranho
PIPE_SPEED = 60

-- Tamanho dos canos
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    -- Posição do cano, sempre começa fora da tela
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    -- Orientação do cano, se esta pra cima ou pra baixo
    self.orientation = orientation
end

function Pipe:render()

    -- Renderiza o cano e espelha o y se necessario
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0,
        1, self.orientation == 'top' and -1 or 1)
end