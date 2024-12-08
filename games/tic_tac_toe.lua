local TicTacToe = {}

-- initialize the game grid
local function initializeGrid()
    local grid = {}
    for i = 1, 3 do
        grid[i] = {}
        for j = 1, 3 do
            grid[i][j] = " "
        end
    end
    return grid
end

-- display grid
local function displayGrid(grid)
    for i = 1, 3 do
        print(grid[i][1] .. " | " .. grid[i][2] .. " | " .. grid[i][3])
        if i < 3 then
            print("--+---+--")
        end
    end
end

-- function to check if a player has won
local function checkWinner(grid)
    -- rows and columns check
    for i = 1, 3 do
        if grid[i][1] == grid[i][2] and grid[i][2] == grid[i][3] and grid[i][1] ~= " " then
            return grid[i][1]
        end
        if grid[1][i] == grid[2][i] and grid[2][i] == grid[3][i] and grid[1][i] ~= " " then
            return grid[1][i]
        end
    end

    -- diagonal check
    if grid[1][1] == grid[2][2] and grid[2][2] == grid[3][3] and grid[1][1] ~= " " then
        return grid[1][1]
    end
    if grid[1][3] == grid[2][2] and grid[2][2] == grid[3][1] and grid[1][3] ~= " " then
        return grid[1][3]
    end

    return nil  -- no one wins
end

-- function to check if the grid is full
local function isGridFull(grid)
    for i = 1, 3 do
        for j = 1, 3 do
            if grid[i][j] == " " then
                return false
            end
        end
    end
    return true
end

-- function to place a random "O" on the grid
local function placeComputerMove(grid)
    local emptyCells = {}
    for i = 1, 3 do
        for j = 1, 3 do
            if grid[i][j] == " " then
                table.insert(emptyCells, {i, j})
            end
        end
    end

    if #emptyCells > 0 then
        local move = emptyCells[math.random(1, #emptyCells)]
        grid[move[1]][move[2]] = "O"
    end
end

-- function to start the game
function TicTacToe.startGame()
    local grid = initializeGrid()
    local playerTurn = true  -- true for player's turn (X), false for computer's turn (O)
    local winner = nil

    print("Welcome to Tic-Tac-Toe!")
    displayGrid(grid)

    -- game loop
    while not winner and not isGridFull(grid) do
        if playerTurn then
            -- loop for user input position
            print("Your turn! (Enter column and row for X)")
            io.write("Enter column (1-3): ")
            local col = tonumber(io.read())
            io.write("Enter row (1-3): ")
            local row = tonumber(io.read())

            if col < 1 or col > 3 or row < 1 or row > 3 or grid[row][col] ~= " " then
                print("Invalid move! Try again.")
            else
                grid[row][col] = "X"
                displayGrid(grid)
                winner = checkWinner(grid)
                playerTurn = false
            end
        else
            -- computer's turn to place random position
            print("My turn...")
            placeComputerMove(grid)
            displayGrid(grid)
            winner = checkWinner(grid)
            playerTurn = true
        end
    end

    if winner then
        if winner == "X" then
            print("Congratulations! You win!")
        else
            print("Sorry, the computer wins!")
        end
    else
        print("It's a tie!")
    end
end

return TicTacToe