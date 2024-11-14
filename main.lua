-- load config
local config = require('config')
local client = require('client')

-- initialize client
client.connect(config.server, config.port)
client.login(config.nick, config.username)

-- loop to handle user input
while true do
    local input = io.read()
    client.handleInput(input)
end