--xml_translator\xml_translator_xml_handler.lua

-- Adding path to xml_translator modules to package.path
package.path = package.path
	.. ";gamedata\\scripts\\xml_translator\\?.lua;gamedata\\scripts\\xml_translator\\config\\?.lua;gamedata\\scripts\\xml_translator\\utils\\?.lua;"

-- Connecting modules
local logger = require("xml_translator_logger")
local path_utils = require("xml_translator_path_utils")
local translation_utils = require("xml_translator_translation_utils")
local xml_utils = require("xml_translator_xml_utils")
local config = require("xml_translator_config")
local encoding_utils = require("xml_translator_encoding_utils")

-- Main module
local M = {}

-- Processing files in text\eng
function M.handle_eng_file(xml_file_name, xml_obj)
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

	-- Collecting new translations from XML
	local text_list = {}
	local root = xml_obj:getRoot()
	if root then
		local function process_child(child)
			if xml_obj:isElement(child) and xml_obj:getElementName(child) == "string" then
				local attr_table = xml_obj:getElementAttr(child)
				local string_id = attr_table and attr_table.id
				if string_id then
					local text_elements = xml_obj:query("text", child)
					if text_elements and text_elements[1] then
						local text = xml_obj:getText(text_elements[1])
						if text then
							local utf8_text = encoding_utils.from_windows1251(text)
							text_list[string_id] = utf8_text
							logger.log_message("INFO", string.format("Adding new translation for ID: %s", string_id))
						end
					end
				end
			end
		end
		xml_obj:iterateChildren(root, process_child)
	else
		logger.log_message("ERROR", "Root element not found in XML")
	end

	-- If there are new translations, add them to the existing ones and write them to a file
	if next(text_list) then
		translation_utils.write_translations_to_file(missing_translation_path, text_list, base_name)
	else
		logger.log_message("INFO", "No new translations to add")
	end

	logger.log_message("INFO", string.format("Finished processing English XML file: %s", xml_file_name))
end

-- Processing files in translations xml folder
function M.handle_translation_file(xml_file_name, xml_obj, missing_translations_dir)
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
		local updated_translations = translation_utils.update_translations(existing_translations, xml_string_ids)

		-- Write updated translations to file
		logger.log_message("DEBUG", "Writing updated translations to file")
		translation_utils.write_translations_to_file(missing_translation_path, updated_translations, base_name)

		logger.log_message("INFO", string.format("Finished processing %s XML file: %s", config.LANGUAGE, xml_file_name))
	else
		logger.log_message("ERROR", string.format("Invalid XML file name: %s", xml_file_name))
	end
end

return M
