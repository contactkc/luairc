local openssl = require('openssl')
local M = {}
local logins = 'client/users.txt'

-- function to load logins from the file
local function loadUsers()
    local users = {}
    local file = io.open(logins, 'r')
    if file then
        for line in file:lines() do
            local username, hashedPassword = line:match('^(%S+)%s+(%S+)$')
            if username and hashedPassword then
                users[username] = hashedPassword
            end
        end
        file:close()
    end
    return users
end

-- function to save login to the file
local function saveUser(username, hashedPassword)
    local file = io.open(logins, 'a')
    if file then
        file:write(username .. ' ' .. hashedPassword .. '\n')
        file:close()
    end
end

-- function to hash using openssl
local function hashPassword(password)
    local digest = openssl.digest.new('sha256')
    return digest:final(password)
end

-- function to handle signup
function M.signup()
    io.write('Enter your desired username: ')
    local username = io.read()
    local users = loadUsers()

    -- checks if username already exists
    if users[username] then
        print('Username already exists. Please choose another.')
        return false
    end

    io.write('Enter your password: ')
    local password = io.read()

    -- hashing the password using SHA256 for security
    local hashedPassword = hashPassword(password)

    -- saves the new user with the hashed password
    saveUser(username, hashedPassword)
    print('Signup successful! You can now login.')
    return true
end

-- function to handle login
function M.login()
    io.write('Enter your username: ')
    local username = io.read()
    
    io.write('Enter your password: ')
    local password = io.read()

    -- hash the entered password
    local hashedPassword = hashPassword(password)
    local users = loadUsers()

    -- verify login credentials by comparing hashed passwords
    if users[username] == hashedPassword then
        print('Login successful!')
        return true
    else
        print('Invalid username or password.')
        return false
    end
end

return M
