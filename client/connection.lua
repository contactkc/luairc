local socket = require('socket')
local conn

-- function to create a tcp socket and connect to the server
function connect(server, port)
    conn = socket.tcp()
    if not conn then
        error('Failed to create socket')
    end

    conn:settimeout(10)
    local success, err = conn:connect(server, port)
    if not success then
        error('Failed to connect to server: ' .. err)
    end
end

-- function to send a message to the server and appends \r\n which is required by IRC protocol
function send(data)
    if conn then
        conn:send(data .. '\r\n')
    end
end

-- function to receive data from the IRC server
function receive()
    if conn then
        local ready = socket.select({conn}, nil, 0) -- non-blocking, timeout 0
        if ready then
            local response, err = conn:receive('*l') -- read a line from server
            if response then
                -- only handles PRIVMSG lines which are server messages from others or private messages
                if response:match('^:.* PRIVMSG') then
                    -- extract the nickname, target (channel/user), and message
                    local sender, target, message = response:match(':(%S+)!.* PRIVMSG (%S+) :(.+)')
                    if sender and target and message then
                        -- format the message to send to client 'Received nickname target: message'
                        return string.format('Received: %s PRIVMSG: %s', sender, message)
                    end
                end
            elseif err == 'timeout' then
                return nil -- no data available, return nil
            else
                return nil -- some other error occurred
            end
        end
    end
    return nil -- no message ready
end

-- main loop to continuously receive messages asynchronously
function main_loop()
    while true do
        local message = receive()
        if message then
            print(message) -- output received message
        end

        socket.sleep(0.1)
    end
end

return { connect = connect, send = send, receive = receive, main_loop = main_loop }