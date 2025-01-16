--xml_translator\xml_translator_logger.lua

-- Adding path to xml_translator modules to package.path
package.path = package.path .. ";gamedata\\scripts\\xml_translator\\config\\?.lua;"

local config = require("xml_translator_config")

local M = {}

-- Logging levels from the config
local log_levels = config.LOG_LEVELS

-- Current logging level (default DEBUG)
local current_level = config.LOG_LEVEL or log_levels.DEBUG

-- Path to the log file
local log_file_path

-- Initializing the path to the log file
if config.USE_STATIC_LOG_NAME then
	log_file_path = config.LOGS_DIR .. "\\xml_translator.log"
else
	log_file_path = config.LOGS_DIR .. "\\log_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".log"
end

-- Setting the logging level (number)
function M.set_log_level(level)
	if type(level) == "number" then
		current_level = level
	else
		printf("ERROR", "Invalid log level. Expected a number.")
	end
end

-- Function for writing a message to the log
function M.log_message(level, message)
	-- Проверяем, включено ли логирование и поддерживается ли уровень логирования
	if not config.ENABLE_LOGGING or not log_levels[level] or log_levels[level] < current_level then
		return
	end

	-- Generate a log entry
	local log_entry = string.format("[%s] [%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), level, message)

	-- Open the log file for writing
	local log_file = io.open(log_file_path, "a")
	if log_file then
		log_file:write(log_entry)
		log_file:close()
	else
		printf(string.format("[ERROR] [xml_translator] Failed to open log file: %s", log_file_path))
	end
end

-- Cleaning up the log file (if using a static name)
if config.USE_STATIC_LOG_NAME then
	local log_file = io.open(log_file_path, "w")
	if log_file then
		log_file:close()
	else
		M.log_message("ERROR", string.format("Failed to clear log file: %s", log_file_path))
	end
end

return M
