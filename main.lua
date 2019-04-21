-- biblioteca push para efeito pixelado
push = require("libs/push")
Class = require("libs/class")

-- Importa os objetos de game state
require('objects/StateMachine')
require('objects/states/BaseState')
require('objects/states/PlayState')
require('objects/states/TitleScreenState')
require('objects/states/ScoreState')
require('objects/states/CountdownState')

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

-- Função chamada quando a janela esta carregando
function love.load()
    -- Define o filtro nearest como padrão
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Seta o titulo da janela
    love.window.setTitle('Flappy Bird')

    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- Cria a janela
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }

    gStateMachine:change('title')

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
    -- Posição do BG reseta sempre que passa do valor BACKGROUND_LOOP_POINT
    bgScroll = (bgScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    
    -- Posição do BG reseta sempre que passa do valor virtual width
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    
    gStateMachine:update(dt)

    -- Reseta a table de botoes pressionados no final do frame
    love.keyboard.keysPressed = {}
end

-- Desenha na janela
function love.draw()
    -- Inicia o ciclo de desenho/update
    push:start()
    -- Desenha o BG
    love.graphics.draw(background, -bgScroll, 0)

    gStateMachine:render()

    -- Desenha o chão
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)
    -- Finaliza o ciclo
    push:finish()
end