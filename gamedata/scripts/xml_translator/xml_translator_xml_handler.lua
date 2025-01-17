-- Adding path to xml_translator modules to package.path
package.path = package.path
	.. ";gamedata\\scripts\\xml_translator\\?.lua;gamedata\\scripts\\xml_translator\\config\\?.lua;gamedata\\scripts\\xml_translator\\utils\\?.lua;"

-- Connecting modules
local logger = require("xml_translator_logger")
local path_utils = require("xml_translator_path_utils")
local translation_utils = require("xml_translator_translation_utils")
local xml_utils = require("xml_translator_xml_utils")
local config = require("xml_translator_config")

-- Main module
local M = {}

-- Processing files in text\eng
function M.handle_eng_file(xml_file_name, xml_obj, processed_string_ids)
	logger.log_message("INFO", string.format("Starting to process English XML file: %s", xml_file_name))
	logger.log_message("DEBUG", string.format("Processing file (in text\\eng): %s", xml_file_name))

	-- Get the base name of the file
	local base_name = path_utils.get_base_name(xml_file_name)
	if not base_name then
		logger.log_message("ERROR", string.format("Invalid XML file name: %s", xml_file_name))
		return
	end

	-- Forming a path to a file with missing translations
	local missing_translation_path = path_utils.get_translation_path(base_name, config.MISSING_TRANSLATIONS_DIR)
	logger.log_message("DEBUG", string.format("Missing translations file path: %s", missing_translation_path))

	-- Load existing missed translations
	local existing_translations = translation_utils.load_translations_from_file(missing_translation_path)
	if not existing_translations then
		existing_translations = {}
		logger.log_message("DEBUG", "No existing translations found, starting with an empty table")
	end

	-- Collecting new translations from XML
	logger.log_message("DEBUG", "Collecting new translations from XML")
	local new_translations = xml_utils.ensure_translation_file(xml_obj, processed_string_ids)

	-- If there are new translations, add them to the existing ones and write them to a file
	if next(new_translations) then
		-- We combine existing and new translations
		for string_id, text in pairs(new_translations) do
			existing_translations[string_id] = text
		end
		translation_utils.write_translations_to_file(missing_translation_path, existing_translations, base_name)
	else
		logger.log_message("INFO", "No new translations to add")
	end

	logger.log_message("INFO", string.format("Finished processing English XML file: %s", xml_file_name))
end

-- Processing files in translations xml folder
function M.handle_translation_file(xml_file_name, xml_obj, missing_translations_dir, processed_string_ids)
	logger.log_message("INFO", string.format("Starting to process %s XML file: %s", config.LANGUAGE, xml_file_name))
	logger.log_message("DEBUG", string.format("Processing file (in text\\rus): %s", xml_file_name))

	-- Get the base name of the file
	local base_name = path_utils.get_base_name(xml_file_name)
	if base_name then
		-- Forming a path to a file with missing translations
		local missing_translation_path = path_utils.get_translation_path(base_name, missing_translations_dir)
		logger.log_message("DEBUG", string.format("Missing translations file path: %s", missing_translation_path))

		-- Loading existing translations
		logger.log_message("DEBUG", "Loading existing translations")
		local existing_translations = translation_utils.load_translations_from_file(missing_translation_path)

		-- Collection of string_id from XML
		logger.log_message("DEBUG", "Collecting string_ids from XML")
		local xml_string_ids = xml_utils.collect_string_ids_from_xml(xml_obj)

		-- Updating translations
		logger.log_message("DEBUG", "Updating translations")
		local updated_translations =
			translation_utils.update_translations(existing_translations, xml_string_ids, processed_string_ids)

		-- Write updated translations to file
		logger.log_message("DEBUG", "Writing updated translations to file")
		translation_utils.write_translations_to_file(missing_translation_path, updated_translations, base_name)

		logger.log_message("INFO", string.format("Finished processing %s XML file: %s", config.LANGUAGE, xml_file_name))
	else
		logger.log_message("ERROR", string.format("Invalid XML file name: %s", xml_file_name))
	end
end

return M
