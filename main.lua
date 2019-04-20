-- biblioteca push para efeito pixelado
push = require("libs/push")

-- Tamanho da janela
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 452

-- Tamanho da janela virtual
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Imagens de fundo e chão, respectivamente
local background = love.graphics.newImage('sprites/background.png')
local ground = love.graphics.newImage('sprites/ground.png')

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

-- Desenha na janela
function love.draw()
    -- Inicia o ciclo de desenho/update
    push:start()

    -- Desenha o BG e o chão respectivamente
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT-16)

    -- Finaliza o ciclo
    push:finish()
end