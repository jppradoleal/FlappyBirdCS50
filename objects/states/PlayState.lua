PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.score = 0

    -- Inicia o ultimo y gravado, para um vão aleatorio
    self.lastY = -PIPE_HEIGHT + math.random(90) + 20
end

function PlayState:update(dt)

    self.timer = self.timer + dt

    -- Se o timer passou de 2 segundos
    if self.timer > 2 then
    
        -- y = altura do cano + 10, e o menor valor entre ultimo y e random, e altura da tela - 90 - altura do cano
        local y = math.max(-PIPE_HEIGHT + 10,
                            math.min( self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT ))
        -- Ultimo y recebe o y atual
        self.lastY = y
    
        -- Cano é instanciado na posição y
        table.insert(self.pipePairs, PipePair(y))
    
        -- Timer reseta
        self.timer = 0
    end
    
    for k, pair in pairs(self.pipePairs) do
        -- Atualiza os canos
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end
        pair:update(dt)
    end
    
    for k, pair in pairs(self.pipePairs) do
        -- Remove se puder remover
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    
    -- Atualiza o passarinho
    self.bird:update(dt)
    
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('score', {score = self.score})
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {score=self.score})
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end