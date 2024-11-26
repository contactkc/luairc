local connection = require('client.connection')
local Commands = {}

-- list of commands to show when calling /help
local cmdList = {
    quit = '/quit to disconnect from the server',
    msg = '/msg <target> <message> to send a private message',
    join = '/join <channel> to join a channel',
    help = '/help to show all commands'
}

-- function to handle commands 
-- regex match is to parse user input commands to the irc client
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
    else
        print('Command not found!: ' .. command)
    end
end

return Commands
