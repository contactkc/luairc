-- load config, client, and socket
local config = require('config')
local Client = require('client.init')
local socket = require('socket')
local auth = require('client.auth')

-- initialize client
Client.connect(config.server, config.port)

-- authentication for logging in
local loginSuccess = false

while not loginSuccess do
    print('Do you want to (1) Sign up or (2) Login?')
    io.write('> ')
    local choice = io.read()

    if choice == '1' then
        local signupSuccess = auth.signup()
        if signupSuccess then
            print('Please log in to continue.')
            loginSuccess = auth.login()
        end
    elseif choice == '2' then
        loginSuccess = auth.login()
    else
        print('Invalid option. Try 1 for signing up or 2 for logging in.')
    end
end

if loginSuccess then
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
else
    print('Failed to log in. Exiting.')
    os.exit()
end