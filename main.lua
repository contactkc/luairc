-- load config, client, and socket
local config = require('config')
local Client = require('client.init')
local socket = require('socket')

-- initialize client
Client.connect(config.server, config.port)
Client.login(config.nick, config.username)

print('IRC client has started! Please type commands to start. /help if stuck.')

-- loop to handle user input
while true do
    -- checks for incoming messages
    local serverMsg = Client.receive()
    if serverMsg then
        print(serverMsg)
    end

    -- reads user input
    io.write('> ')
    local input = io.read()
    if input and input ~= '' then
        Client.handleInput(input)
    end

    -- possible cpu overuse so sleep to prevent
    socket.sleep(0.1)
end