-- gamedata\scripts\xml_translator\config.lua

local config = {}

-- Setting: if true, the log file name will be static, otherwise the date and time will be added
config.USE_STATIC_LOG_NAME = true

-- Settings: enable/disable logging
config.ENABLE_LOGGING = true

-- Settings: logging levels
config.LOG_LEVELS = {
	DEBUG = 1,
	INFO = 2,
	WARNING = 3,
	ERROR = 4,
}

-- Logging level (number)
config.LOG_LEVEL = 2 -- Default 1 --> (DEBUG)

-- ѕуть к папке с логами
config.LOGS_DIR = "gamedata\\scripts\\xml_translator\\logs"

--Translation language (only works with rus now, because it on game start loads only eng and rus xml text files)
config.LANGUAGE = "rus"

-- Path to the folder with dynamic translations
config.DYNAMIC_TRANSLATIONS_DIR =
	string.format("gamedata\\scripts\\xml_translator\\dynamic_translations_%s", config.LANGUAGE)

-- Path to the folder with missing translations
config.MISSING_TRANSLATIONS_DIR =
	string.format("gamedata\\scripts\\xml_translator\\missing_translations_%s", config.LANGUAGE)

return config
