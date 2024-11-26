-- load commands and connections and initialize Client
local connection = require('client.connection')
local commands = require('client.commands')
local Client = {}

-- handles connecting to the server and port in config
function Client.connect(server, port)
    connection.connect(server, port)
end

-- handles logging into the server using the nick and user inside config
function Client.login(nick, username)
    connection.send('NICK ' .. nick)
    connection.send('USER ' .. username .. ' 0 * :' .. nick)
end

--[[
handles user input where if the input starts with a backslash then the input is
    treated as a command and sent to commands.lua else it is treated as message
        to #lua channel
]]-- 
function Client.handleInput(input)
    if input:sub(1, 1) == '/' then
        commands.handleCommand(input)
    else
        connection.send('PRIVMSG #lua :' .. input)
    end
end

-- calls receive function from connection.lua to receive incoming server messages
function Client.receive()
    return connection.receive()
end

return Client