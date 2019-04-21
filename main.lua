-- biblioteca push para efeito pixelado
push = require("libs/push")
Class = require("libs/class")

-- Importa a classe Bird
require('objects/Bird')

-- Importa a  classe Pipe
require("objects/Pipe")

-- Importa a classe de pares de pipePairs
require('objects/PipePair')

-- Tamanho da janela
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 452

-- Tamanho da janela virtual
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Imagem de fundo
local background = love.graphics.newImage('sprites/background.png')
-- Variavel da posição horizontal do bg
local bgScroll = 0 
-- Imagem do chão
local ground = love.graphics.newImage('sprites/ground.png')
-- Posição da imagem do chão
local groundScroll = 0

-- Velocidade dos bg's
local BACKGROUND_SCROLL_SPEED = 30 
local GROUND_SCROLL_SPEED = 60

-- Ponto em que o bg reseta
local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

-- Variavel que armazena os canos instanciados
local pipePairs = {}

-- Variavel que dita a frequencia de spawn dos canos
local spawnTimer = 0

-- Variavel que armazena qual foi o y do ultimo cano instanciado
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- Variavel que dita se o scroll deve funcionar ou não
local scrolling = true

-- Função chamada quando a janela esta carregando
function love.load()
    -- Define o filtro nearest como padrão
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Seta o titulo da janela
    love.window.setTitle('Flappy Bird')
    -- Cria a janela
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- Variavel que armazena os botoes que foram pressionados durante o frame
    love.keyboard.keysPressed = {}
end

-- Redimensiona a janela virtual junto com a janela real
function love.resize(w, h)
    push:resize(w, h)
end

-- Função chamada sempre que uma tecla é pressionada
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    -- Fecha o jogo ao apertar esc
    if key == 'escape' then
        love.event.quit()
    end
end

-- A função keypressed não pode ser chamada duas vezes pois é sobreescrita
-- Entao é criado a função abaixo que recebe uma key e verifica se ela foi pressionada
-- Durante o frame
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- Só roda quando scrolling = true
    if scrolling then
        -- Posição do BG reseta sempre que passa do valor BACKGROUND_LOOP_POINT
        bgScroll = (bgScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        
        -- Posição do BG reseta sempre que passa do valor virtual width
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
        
        -- Timer aumenta conforme o tempo passa
        spawnTimer = spawnTimer + dt
        
        -- Se o timer passou de 2 segundos
        if spawnTimer > 5 then

            -- y = altura do cano + 10, e o menor valor entre ultimo y e random, e altura da tela - 90 - altura do cano
            local y = math.max(-PIPE_HEIGHT + 10,
                                math.min( lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT ))
            -- Ultimo y recebe o y atual
            lastY = y

            -- Cano é instanciado na posição y
            table.insert(pipePairs, PipePair(y))

            -- Timer reseta
            spawnTimer = 0
        end
        

        -- Atualiza o passarinho
        bird:update(dt)

        for k, pair in pairs(pipePairs) do
            -- Atualiza os canos
            pair:update(dt)
            for l, pipe in pairs(pair.pipes) do
                -- Para o scroll de o passaro colidir com algum dos canos
                if bird:collides(pipe) then
                    scrolling = false
                end
            end

            -- Se o x do par passar do tamanho negativo do cano então ele saiu da tela
            -- e pode ser removido
            if pair.x < -PIPE_WIDTH then
                pair.remove = true
            end
        end

        for k, pair in pairs(pipePairs) do
            -- Remove se puder remover
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end

        -- Reseta a table de botoes pressionados no final do frame
        love.keyboard.keysPressed = {}
    end
end

-- Desenha na janela
function love.draw()
    -- Inicia o ciclo de desenho/update
    push:start()
    -- Desenha o BG
    love.graphics.draw(background, -bgScroll, 0)

    -- Renderiza os pares de canos
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    -- Desenha o chão
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)

    -- Renderiza o passarinho
    bird:render()

    -- Finaliza o ciclo
    push:finish()
end