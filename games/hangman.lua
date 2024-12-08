local Hangman = {}

-- function to read the words from the words.txt file
local function loadWords()
    local words = {}
    local file = io.open("games/words.txt", "r")
    if file then
        for line in file:lines() do
            table.insert(words, line)
        end
        file:close()
    else
        print("Error: Could not load words file.")
        return {}
    end
    return words
end

-- function to start game
function Hangman.startGame()
    local words = loadWords()
    if #words == 0 then
        print("No words available for the game.")
        return
    end

    local wordToGuess = words[math.random(1, #words)]
    local guessedLetters = {}
    local maxAttempts = 6
    local attemptsLeft = maxAttempts
    local wordProgress = {}

    -- initialize wordProgress with underscores
    for i = 1, #wordToGuess do
        wordProgress[i] = "_"
    end

    print("Welcome to Hangman!")
    print("The word has " .. #wordToGuess .. " letters.")
    print("You have " .. attemptsLeft .. " tries left.")

    while attemptsLeft > 0 do
        -- displays current word progress
        print("Current word: " .. table.concat(wordProgress, " "))

        -- get user input
        io.write("Enter a letter: ")
        local input = io.read():lower()

        -- validate the user input
        if #input ~= 1 or not input:match("%a") then
            print("Please enter a single letter.")
        elseif guessedLetters[input] then
            print("You've already guessed that letter.")
        else
            guessedLetters[input] = true

            -- check if the letter is in the word
            local correctGuess = false
            for i = 1, #wordToGuess do
                if wordToGuess:sub(i, i) == input then
                    wordProgress[i] = input
                    correctGuess = true
                end
            end

            if correctGuess then
                print("Correct! You guessed a letter.")
            else
                attemptsLeft = attemptsLeft - 1
                print("Wrong! You have " .. attemptsLeft .. " tries left.")
            end
        end

        -- check if the word is fully guessed
        if table.concat(wordProgress) == wordToGuess then
            print("Congratulations! You've guessed the word: " .. wordToGuess)
            return
        end
    end

    print("Game over! The word was: " .. wordToGuess)
end

return Hangman