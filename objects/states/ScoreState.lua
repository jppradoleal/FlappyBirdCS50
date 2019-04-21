ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
    self.badge = nil
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        sounds['clicked']:play()
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to play again!', 0, 136, VIRTUAL_WIDTH, 'center')

    if self.score > 4 and self.score < 10 then
        self.badge = badges['first']
    elseif self.score > 9 and self.score< 50 then
        self.badge = badges['second']
    elseif self.score>49 and self.score < 100 then
        self.badge = badges['third']
    elseif self.score>99 and self.score < 150 then
        self.badge = badges['forth']
    elseif self.score>149 then
        self.badge = badges['fifth'] 
    end

    if self.badge then
        love.graphics.draw(self.badge, VIRTUAL_WIDTH / 2 - 8, 172)
        love.graphics.setFont(smallFont)
        love.graphics.printf("You earned a badge!", 0, 192, VIRTUAL_WIDTH, 'center')
    end
end