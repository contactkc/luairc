local Hangman = {}
local HangmanMeta = {
    __index = {
        -- function to load words from the file
        loadWords = function()
            local words = {}
            local file = io.open('games/words.txt', 'r')
            if file then
                for line in file:lines() do
                    table.insert(words, line)
                end
                file:close()
            else
                print('Error: Could not load words file.')
                return {}
            end
            return words
        end,

        -- function to start a new hangman game
        startGame = function(self)
            local words = self.loadWords()
            if #words == 0 then
                print('No words available for the game.')
                return
            end

            self.wordToGuess = words[math.random(1, #words)]
            self.guessedLetters = {}
            self.maxAttempts = 6
            self.attemptsLeft = self.maxAttempts
            self.wordProgress = {}

            -- initialize word progress with underscores
            for i = 1, #self.wordToGuess do
                self.wordProgress[i] = '_'
            end

            print('Welcome to Hangman!')
            print('The word has ' .. #self.wordToGuess .. ' letters.')
            print('You have ' .. self.attemptsLeft .. ' tries left.')

            while self.attemptsLeft > 0 do
                print('Current word: ' .. table.concat(self.wordProgress, ' '))
                io.write('Enter a letter: ')
                local input = io.read():lower()

                -- validate user input
                if #input ~= 1 or not input:match('%a') then
                    print('Please enter a single letter.')
                elseif self.guessedLetters[input] then
                    print('You\'ve already guessed that letter.')
                else
                    self.guessedLetters[input] = true
                    local correctGuess = false
                    for i = 1, #self.wordToGuess do
                        if self.wordToGuess:sub(i, i) == input then
                            self.wordProgress[i] = input
                            correctGuess = true
                        end
                    end

                    if correctGuess then
                        print('Correct! You guessed a letter.')
                    else
                        self.attemptsLeft = self.attemptsLeft - 1
                        print('Wrong! You have ' .. self.attemptsLeft .. ' tries left.')
                    end
                end

                if table.concat(self.wordProgress) == self.wordToGuess then
                    print('Congratulations! You\'ve guessed the word: ' .. self.wordToGuess)
                    return
                end
            end

            print('Game over! The word was: ' .. self.wordToGuess)
        end,
    }
}

-- function to create a new hangman game
function Hangman.new()
    return setmetatable({}, HangmanMeta)
end

return Hangman