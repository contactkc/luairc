local connection = require('client.connection')
local GuessNumber = require('games.guess_number')
local Hangman =  require('games.hangman')
local TicTacToe = require('games.tic_tac_toe')
local Commands = {}

-- list of commands to show when calling /help
local cmdList = {
    quit = '/quit to disconnect from the server',
    msg = '/msg <target> <message> to send a private message',
    join = '/join <channel> to join a channel',
    help = '/help to show all commands',
    guessnumber = '/guessnumber to start a number guessing game',
    hangman = '/hangman to start a hangman game',
    tictactoe = '/tictactoe to start a tic tac toe game'
}

-- function to handle commands
function Commands.handleCommand(input)
    local command, params = input:match('^/(%S+)%s*(.*)$')
    if command == 'join' then
        connection.send('JOIN ' .. params)
    elseif command == 'msg' then
        local target, message = params:match('^(%S+)%s*(.*)$')
        connection.send('PRIVMSG ' .. target .. ' :' .. message)
    elseif command == 'quit' then
        connection.send('QUIT :Til next time!')
        os.exit()
    elseif command == 'help' then
        print('All commands:')
        for cmd, desc in pairs(cmdList) do
            print(" - " .. desc)
        end
    elseif command == 'guessnumber' then
        GuessNumber.startGame()
    elseif command == 'hangman' then
        Hangman.startGame()
    elseif command == 'tictactoe' then
        TicTacToe.startGame()
    else
        print('Command not found!: ' .. command)
    end
end

return Commands
