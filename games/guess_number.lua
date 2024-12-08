local GuessNumber = {}

-- function to start the game
function GuessNumber.startGame()
    local targetNumber = math.random(1, 100)  -- random number between 1 and 100
    local attempts = 10

    print("Welcome to Guess the Number!")
    print("I have picked a number between 1 and 100. You have 10 tries to guess it.")

    -- loop until game is over with guessing correctly or 10 tries gone
    while attempts > 0 do
        io.write("Enter your guess: ")
        local guess = tonumber(io.read())  -- get user input and convert to number

        if not guess then
            print("Please enter a valid number.")
        elseif guess < targetNumber then
            attempts = attempts - 1
            print("Too low! You have " .. attempts .. " tries left.")
        elseif guess > targetNumber then
            attempts = attempts - 1
            print("Too high! You have " .. attempts .. " tries left.")
        else
            print("Congratulations! You guessed the number!")
            return true  -- game won, exit the loop
        end
    end

    print("Sorry, you've run out of attempts! The number was " .. targetNumber)
    return false  -- game lost
end

return GuessNumber
