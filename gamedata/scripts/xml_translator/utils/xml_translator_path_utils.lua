--xml_translator\utils\xml_translator_path_utils.lua

-- Connecting the logger module
local logger = require("xml_translator_logger")

-- Main module
local M = {}

-- Retrieve base file name
function M.get_base_name(file_path)
	logger.log_message("DEBUG", string.format("Extracting base name from file path: %s", file_path))

	-- Use regular expression to extract filename without extension
	local base_name = file_path:match("([^/\\]+)%.%w+$")

	if base_name then
		logger.log_message("DEBUG", string.format("Base name extracted: %s", base_name))
	else
		logger.log_message("WARNING", string.format("Failed to extract base name from file path: %s", file_path))
	end

	return base_name
end

-- Forming the path to the translation file
function M.get_translation_path(base_name, translations_dir)
	logger.log_message("DEBUG", string.format("Forming translation path for base name: %s", base_name))

	-- Form the path to the translation file
	local translation_path = translations_dir .. "\\" .. base_name .. ".lua"

	logger.log_message("DEBUG", string.format("Translation path formed: %s", translation_path))

	return translation_path
end

return M
