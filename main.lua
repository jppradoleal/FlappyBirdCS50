-- biblioteca push para efeito pixelado
push = require("libs/push")
Class = require("libs/class")

-- Importa a classe Bird
require('objects/Bird')

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

    love.keyboard.keysPressed = {}
end

-- Redimensiona a janela virtual junto com a janela real
function love.resize(w, h)
    push:resize(w, h)
end

-- Verifica se alguma tecla foi pressionada
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    -- Fecha o jogo ao apertar esc
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- Posição do BG reseta sempre que passa do valor BACKGROUND_LOOP_POINT
    bgScroll = (bgScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    
    -- Posição do BG reseta sempre que passa do valor virtual width
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    -- Atualiza o passarinho
    bird:update(dt)

    love.keyboard.keysPressed = {}
end

-- Desenha na janela
function love.draw()
    -- Inicia o ciclo de desenho/update
    push:start()
    -- Desenha o BG e o chão respectivamente
    love.graphics.draw(background, -bgScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)

    -- Renderiza o passarinho
    bird:render()

    -- Finaliza o ciclo
    push:finish()
end