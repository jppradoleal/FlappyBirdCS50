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

-- Imagens de fundo e chão, respectivamente
local background = love.graphics.newImage('sprites/background.png')
local bgScroll = 0 

local ground = love.graphics.newImage('sprites/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30 
local GROUND_SCROLL_SPEED = 60

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
end

-- Redimensiona a janela virtual junto com a janela real
function love.resize(w, h)
    push:resize(w, h)
end

-- Verifica se alguma tecla foi pressionada
function love.keypressed(key)
    -- Fecha o jogo ao apertar esc
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    bgScroll = (bgScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end

-- Desenha na janela
function love.draw()
    -- Inicia o ciclo de desenho/update
    push:start()
    -- Desenha o BG e o chão respectivamente
    love.graphics.draw(background, -bgScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)

    bird:render()

    -- Finaliza o ciclo
    push:finish()
end