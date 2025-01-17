-- xml_translator\utils\xml_translator_applying_translations_utils.lua

-- Adding path to xml_translator modules to package.path
package.path = package.path .. ";gamedata\\scripts\\xml_translator\\utils\\?.lua;"
-- Connecting modules
local logger = require("xml_translator_logger")
local path_utils = require("xml_translator_path_utils")
local error_utils = require("xml_translator_safe_require")

-- Main module
local M = {}

-- Loading translations from applying_translate
function M.load_applying_translations(base_name, dynamic_translations_dir)
	logger.log_message("DEBUG", string.format("Starting to load applying translations for XML file: %s", xml_file_name))

	local applying_translations = {}

	if not base_name then
		logger.log_message("ERROR", string.format("Invalid XML file name: %s", xml_file_name))
		return applying_translations
	end

	-- Forming the path to the translation file
	local lua_file_name = path_utils.get_translation_path(base_name, dynamic_translations_dir)
	logger.log_message("DEBUG", string.format("Translation file path formed: %s", lua_file_name))

	-- Check file existence
	local file = io.open(lua_file_name, "r")
	if file then
		file:close()
		logger.log_message("DEBUG", "Translation file exists, attempting to load translations")

		-- Secure downloading of translations
		local translations = error_utils.safe_require(dynamic_translations_dir .. "." .. base_name)
		if translations then
			applying_translations[base_name] = translations
			logger.log_message("INFO", string.format("Successfully loaded translations from: %s", lua_file_name))
		else
			logger.log_message("WARNING", string.format("Failed to load translations from: %s", lua_file_name))
		end
	else
		logger.log_message("INFO", string.format("No applying translations found for: %s", lua_file_name))
	end

	logger.log_message(
		"DEBUG",
		string.format("Returning applying translations table with %d entries", #applying_translations)
	)
	return applying_translations
end

return M
