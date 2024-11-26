local socket = require('socket')
local Connection = {}
local client

-- function to create a tcp socket and connect to the server
function Connection.connect(server, port)
    client = socket.tcp()
    client:connect(server, port)
end

-- function to send a message to the server and appends \r\n which is required by IRC protocol
function Connection.send(data)
    if client then
        client:send(data .. '\r\n')
    end
end

--[[
function Connection.receive()
    if client then
        return client:receive()
    end
end
]]--

-- handles timeouts, reads incoming single line messages from server and returns nil if nothing
function Connection.receive()
    if clientSocket then 
        local line, err = clientSocket:receive("*l")
        if not err then
            return line
        elseif err ~= "timeout" then
            print("Error receiving data: " .. err)
        end
    end
    return nil
end

return Connection