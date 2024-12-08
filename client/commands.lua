local connection = require('client.connection')
local GuessNumber = require('games.guess_number')
local Hangman =  require('games.hangman')
local TicTacToe = require('games.tic_tac_toe')
local Commands = {}

-- global state to track if user has joined a channel
local currChannel = nil

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
        if params ~= '' then
            connection.send('JOIN ' .. params)
            currentChannel = params
            print('Joined channel: ' .. params)
        else
            print('Usage: /join <channel>')
        end
    elseif command == 'msg' then
        if currentChannel then
            local target, message = params:match('^(%S+)%s*(.*)$')
            if target and message ~= '' then
                connection.send('PRIVMSG ' .. target .. ' :' .. message)
            else
                print('Usage: /msg <target> <message>')
            end
        else
            print('You are not in a channel! Please join one before messaging.')
        end
    elseif command == 'quit' then
        connection.send('QUIT :Til next time!')
        os.exit()
    elseif command == 'help' then
        print('All commands:')
        for cmd, desc in pairs(cmdList) do
            print(' - ' .. desc)
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
