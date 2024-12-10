local connection = require('client.connection')
local GuessNumber = require('games.guess_number')
local Hangman =  require('games.hangman')
local TicTacToe = require('games.tic_tac_toe')
local Commands = {}

-- global state to track if user has joined a channel
local currChannel = nil
local isReceiving = false

-- list of commands to show when calling /help
local cmdList = {
    quit = '/quit to disconnect from the server',
    msg = '/msg <target> <message> to send a private message',
    join = '/join <channel> to join a channel',
    receive = '/receive to start receiving messages (READ ONLY, CTRL+C TO EXIT PROGRAM)',
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
            currChannel = params
            print('Joined channel: ' .. params)
        else
            print('Usage: /join <channel>')
        end
    elseif command == 'msg' then
        if currChannel then
            local target, message = params:match('^(%S+)%s*(.*)$')
            if target and message ~= '' then
                connection.send('PRIVMSG ' .. target .. ' :' .. message)
            else
                print('Usage: /msg <target> <message>')
            end
        else
            print('You are not in a channel! Please join one before messaging.')
        end
    elseif command == 'receive' then
        if currChannel then
            if isReceiving then
                print('Already receiving messages from channels.')
            else
                print('Starting to receive messages from channels...')
                local pollingCoroutine = coroutine.create(function()
                    connection.main_loop()
                end)
                coroutine.resume(pollingCoroutine)
            end
        else
            print('You need to join a channel before using /receive.')
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
        local game = GuessNumber.new()
        game:startGame()
    elseif command == 'hangman' then
        local game = Hangman.new()
        game:startGame()
    elseif command == 'tictactoe' then
        local game = TicTacToe.new()
        game:startGame()
    else
        print('Command not found!: ' .. command)
    end
end

return Commands
