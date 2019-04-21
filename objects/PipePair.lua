PipePair = Class{}

-- Variavel que armazena o tamanho do espaço entre os canos
local GAP_HEIGHT = 90

function PipePair:init(y)
    -- Variavel que armazena a posição x + algum valor, para que os canos nao renderizem dentro da tela
    self.x = VIRTUAL_WIDTH + 32

    -- Variavel que armazena a posição y
    self.y = y

    -- Instancia e armazena os dois canos nas posições
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- Inicia a variavel que verifica se pode ser removido
    self.remove = false

    self.scored = false
end

function PipePair:update(dt)
    -- Se esta alem do canto direito da tela
    if self.x > -PIPE_WIDTH then
        -- Atualiza a posição do par
        self.x = self.x - PIPE_SPEED * dt
        -- Atualiza a posição dos canos
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        -- Senão, pode remover
        self.remove = true
    end
end

-- Renderiza os canos dentro do par
function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end