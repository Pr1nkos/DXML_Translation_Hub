local logger = require("xml_translator_logger")

local M = {}

-- Read file contents
function M.read_file(file_path)
    local file = io.open(file_path, "r")
    if file then
        local content = file:read("*a")
        file:close()
        return content
    else
        logger.log_message("INFO", string.format("No file found: %s", file_path))
        return nil
    end
end

-- Write content to file
function M.write_file(file_path, content)
    local file = io.open(file_path, "wb")
    if file then
        file:write(content)
        file:close()
        logger.log_message("INFO", string.format("Successfully wrote to file: %s", file_path))
        return true
    else
        logger.log_message("ERROR", string.format("Failed to open file for writing: %s", file_path))
        return false
    end
end

-- Check file existence
function M.file_exists(file_path)
    local file = io.open(file_path, "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end

return M