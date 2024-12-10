local GuessNumber = {}
-- make metatable
local GuessNumberMeta = {
    __index = {
        -- starts game
        startGame = function(self)
            local targetNumber = math.random(1, 100)
            local attempts = self.attempts or 10
            print('Welcome to Guess the Number!')
            print('I have picked a number between 1 and 100. You have ' .. attempts .. ' tries to guess it.')

            while attempts > 0 do
                io.write('Enter your guess: ')
                local guess = tonumber(io.read())

                if not guess then
                    print('Please enter a valid number.')
                elseif guess < targetNumber then
                    attempts = attempts - 1
                    print('Too low! You have ' .. attempts .. ' tries left.')
                elseif guess > targetNumber then
                    attempts = attempts - 1
                    print('Too high! You have ' .. attempts .. ' tries left.')
                else
                    print('Congratulations! You guessed the number!')
                    return true
                end
            end

            print('Sorry, you\'ve run out of attempts! The number was ' .. targetNumber)
            return false
        end,
    }
}

function GuessNumber.new()
    return setmetatable({ attempts = 10 }, GuessNumberMeta)
end

return GuessNumber