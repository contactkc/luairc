-- load config, client, auth, connection, and socket
local config = require('config')
local Client = require('client.init')
local socket = require('socket')
local auth = require('client.auth')
local connection = require('client.connection')

-- initialize client
Client.connect(config.server, config.port)

-- coroutine authentication for logging in
local function authenticateUser()
    while true do
        print('Do you want to (1) Sign up or (2) Login? (3) or /quit to exit program.')
        io.write('> ')
        local choice = io.read()

        if choice == '1' then
            if auth.signup() then
                print('Please log in to continue.')
                if auth.login() then
                    return true
                end
            end
        elseif choice == '2' then
            if auth.login() then
                return true
            end
        elseif choice == '3' or choice:lower() == '/quit' then
            print('Til next time!')
            os.exit()
        else
            print('Invalid option. Try 1 for signing up or 2 for logging in.')
        end
        coroutine.yield() -- yields back control to allow retry or exit
    end
end

-- authentication coroutine
local authCoroutine = coroutine.create(authenticateUser)

-- run the authentication coroutine
local loginSuccess = false
while coroutine.status(authCoroutine) ~= 'dead' do
    local success, result = coroutine.resume(authCoroutine)
    if not success then
        print('Error during authentication: ', result)
        os.exit() -- exit on authentication failure
    end
    if result then
        loginSuccess = true
        break
    end
end

-- client starts if auth is successful
if loginSuccess then
    Client.login(config.nick, config.username)
    print('IRC client has started! Please type commands to start. /help if stuck.')

    -- coroutines for server messages and user input
    local function handleServerMessages()
        while true do
            local serverMsg = Client.receive()
            if serverMsg then
                print(serverMsg)
            end
            coroutine.yield()
        end
    end

    local function handleUserInput()
        while true do
            io.write('> ')
            local input = io.read()
            if input and input ~= '' then
                Client.handleInput(input)
            end
            coroutine.yield()
        end
    end

    --[[local function handlePolling()
        while true do
            connection.main_loop()  -- poll for new messages continuously
            coroutine.yield()  -- yield control to allow other coroutines
        end
    end ]]--

    local serverCoroutine = coroutine.create(handleServerMessages)
    local inputCoroutine = coroutine.create(handleUserInput)
    --local pollingCoroutine = coroutine.create(handlePolling)

    -- main loop
    while true do
        -- attempt to resume server messgae coroutine
        local success, result = coroutine.resume(serverCoroutine)
        if not success then
            print('Error receiving server messages: ', result)
            os.exit()
        end
        
        -- attempt to resume input handler coroutine
        success, result = coroutine.resume(inputCoroutine)
        if not success then
            print('Error receiving user input: ', result)
            os.exit()
        end

        --[[-- attempt to resume main loop coroutine
        success, result = coroutine.resume(pollingCoroutine)
        if not success then
            print('Error in main loop: ', result)
            os.exit()
        end
        ]]--

        socket.sleep(0.1) -- to reduce cpu usage
    end
else
    print('Failed to login. Exiting program.')
    os.exit()
end