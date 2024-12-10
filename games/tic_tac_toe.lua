local TicTacToe = {}
local TicTacToeMeta = {
    __index = {
        -- initialize the game grid
        initializeGrid = function()
            local grid = {}
            for i = 1, 3 do
                grid[i] = {}
                for j = 1, 3 do
                    grid[i][j] = ' '
                end
            end
            return grid
        end,

        -- display the grid
        displayGrid = function(self)
            for i = 1, 3 do
                print(self.grid[i][1] .. ' | ' .. self.grid[i][2] .. ' | ' .. self.grid[i][3])
                if i < 3 then
                    print('--+---+--')
                end
            end
        end,

        -- checks if there's a winner
        checkWinner = function(self)
            for i = 1, 3 do
                if self.grid[i][1] == self.grid[i][2] and self.grid[i][2] == self.grid[i][3] and self.grid[i][1] ~= ' ' then
                    return self.grid[i][1]
                end
                if self.grid[1][i] == self.grid[2][i] and self.grid[2][i] == self.grid[3][i] and self.grid[1][i] ~= ' ' then
                    return self.grid[1][i]
                end
            end

            if self.grid[1][1] == self.grid[2][2] and self.grid[2][2] == self.grid[3][3] and self.grid[1][1] ~= ' ' then
                return self.grid[1][1]
            end
            if self.grid[1][3] == self.grid[2][2] and self.grid[2][2] == self.grid[3][1] and self.grid[1][3] ~= ' ' then
                return self.grid[1][3]
            end

            return nil
        end,

        -- checks if the grid is full
        isGridFull = function(self)
            for i = 1, 3 do
                for j = 1, 3 do
                    if self.grid[i][j] == ' ' then
                        return false
                    end
                end
            end
            return true
        end,

        -- Place the computer's move
        placeComputerMove = function(self)
            local emptyCells = {}
            for i = 1, 3 do
                for j = 1, 3 do
                    if self.grid[i][j] == ' ' then
                        table.insert(emptyCells, {i, j})
                    end
                end
            end

            if #emptyCells > 0 then
                local move = emptyCells[math.random(1, #emptyCells)]
                self.grid[move[1]][move[2]] = 'O'
            end
        end,

        -- function to start the game
        startGame = function(self)
            self.grid = self:initializeGrid()
            self.playerTurn = true  -- true for player's turn (X), false for computer's turn (O)
            self.winner = nil

            print('Welcome to Tic-Tac-Toe!')
            self:displayGrid()

            while not self.winner and not self:isGridFull() do
                if self.playerTurn then
                    print('Your turn! (Enter column and row for X)')
                    io.write('Enter column (1-3): ')
                    local col = tonumber(io.read())
                    io.write('Enter row (1-3): ')
                    local row = tonumber(io.read())

                    if col < 1 or col > 3 or row < 1 or row > 3 or self.grid[row][col] ~= " " then
                        print('Invalid move! Try again.')
                    else
                        self.grid[row][col] = 'X'
                        self:displayGrid()
                        self.winner = self:checkWinner()
                        self.playerTurn = false
                    end
                else
                    print('My turn...')
                    self:placeComputerMove()
                    self:displayGrid()
                    self.winner = self:checkWinner()
                    self.playerTurn = true
                end
            end

            if self.winner then
                if self.winner == 'X' then
                    print('Congratulations! You win!')
                else
                    print('Sorry, the computer wins!')
                end
            else
                print('It\'s a tie!')
            end
        end,
    }
}

-- function to create a new TicTacToe game
function TicTacToe.new()
    return setmetatable({}, TicTacToeMeta)
end

return TicTacToe