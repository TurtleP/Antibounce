local Logger = {}

Logger.File = love.filesystem.newFile("log_" .. os.date("%Y-%m-%d") .. ".txt", "w")

function Logger:_Log(level, msg, ...)
    local args = {...}

    local data =
    {
        {"timestamp", os.date("%H:%M")},
        {"level", level},
        {"message", msg:format(unpack(args))}
    }

    local buffer = "{\n"

    for index = 1, #data do
        local append = ",\n"
        if index == #data then
            append = ""
        end

        buffer = buffer .. "  " .. data[index][1] .. " = " .. data[index][2] .. append
    end

    buffer = buffer .. "\n}\n\n"

    print(buffer)

    Logger.File:write(buffer)
    Logger.File:flush()
end

function Logger:debug(msg, ...)
    self:_Log("DEBUG", msg, ...)
end

function Logger:info(msg, ...)
    self:_Log("INFO", msg, ...)
end

function Logger:warning(msg, ...)
    self:_Log("WARN", msg, ...)
end

function Logger:critical(msg, ...)
    self:_Log("CRIT", msg, ...)
end

return Logger
