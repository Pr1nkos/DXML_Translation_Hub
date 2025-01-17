-- Adding path to xml_translator modules to package.path
package.path = package.path
	.. ";gamedata\\scripts\\xml_translator\\?.lua;gamedata\\scripts\\xml_translator\\utils\\?.lua;"

-- Подключение модулей
local logger = require("xml_translator_logger")
local applying_translations_utils = require("xml_translator_applying_translations_utils")
local xml_handler = require("xml_translator_xml_handler")
local xml_utils = require("xml_translator_xml_utils")
local encoding_utils = require("xml_translator_encoding_utils")
local path_utils = require("xml_translator_path_utils")

-- Основной модуль
local M = {}
-- Список для хранения обработанных string_id
local processed_string_ids = {}
-- Callback handling

-- Function to count the number of elements in a table
local function table_size(t)
	local count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

function M.on_xml_read(xml_file_name, xml_obj, config)
	logger.log_message("INFO", string.format("Callback triggered for file: %s", xml_file_name))
	logger.log_message("DEBUG", string.format("Processing XML file: %s", xml_file_name))

	-- Checking that the file is in the text/eng or text/rus folder
	if
		not xml_file_name:match("^text\\eng\\.+%.xml$")
		and not xml_file_name:match("^text\\" .. config.LANGUAGE .. "\\.+%.xml$")
	then
		logger.log_message("DEBUG", string.format("File %s is not in text/eng or text/rus, skipping", xml_file_name))
		return
	end

	-- Logging the contents of processed_string_ids
	logger.log_message(
		"DEBUG",
		string.format("processed_string_ids is a table with %d entries", table_size(processed_string_ids))
	)
	if next(processed_string_ids) == nil then
		logger.log_message("DEBUG", "processed_string_ids is empty")
	else
		for string_id, _ in pairs(processed_string_ids) do
			logger.log_message("DEBUG", string.format("processed_string_ids contains: %s", string_id))
		end
	end

	-- Loading applying_translations
	logger.log_message("DEBUG", "Loading applying translations")
	local base_name = path_utils.get_base_name(xml_file_name)
	local applying_translations =
		applying_translations_utils.load_applying_translations(base_name, config.DYNAMIC_TRANSLATIONS_DIR)

	-- Application of translations, if any
	if applying_translations and next(applying_translations) ~= nil then
		logger.log_message("DEBUG", "Applying translations to XML")
		xml_utils.change_xml_text(xml_obj, applying_translations[base_name], encoding_utils, processed_string_ids)
		logger.log_message("INFO", string.format("Translations applied for file: %s", xml_file_name))
	else
		logger.log_message("DEBUG", "No applying translations found, skipping")
	end

	-- File processing depending on its location (eng or rus)
	if xml_file_name:match("^text\\eng\\.+%.xml$") then
		logger.log_message("INFO", string.format("Handling English XML file: %s", xml_file_name))
		xml_handler.handle_eng_file(xml_file_name, xml_obj, processed_string_ids)
	elseif xml_file_name:match("^text\\" .. config.LANGUAGE .. "\\.+%.xml$") then
		logger.log_message("INFO", string.format("Handling %s XML file: %s", config.LANGUAGE, xml_file_name))
		xml_handler.handle_translation_file(
			xml_file_name,
			xml_obj,
			config.MISSING_TRANSLATIONS_DIR,
			processed_string_ids
		)
	end
end

return M
