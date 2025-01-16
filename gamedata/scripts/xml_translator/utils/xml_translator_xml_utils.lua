-- Adding path to xml_translator modules to package.path
package.path = package.path .. ";gamedata\\scripts\\xml_translator\\utils\\?.lua;"
-- Connecting the logger modulele
local logger = require("xml_translator_logger")
local translation_utils = require("xml_translator_applying_translations_utils")

-- Main module
local M = {}

-- Collect all string_ids from XML
function M.collect_string_ids_from_xml(xml_obj)
	logger.log_message("DEBUG", "Starting to collect string_ids from XML")

	local string_ids = {}
	local root = xml_obj:getRoot()

	-- Checking for the presence of a root element
	if root then
		logger.log_message("DEBUG", "Root element found in XML")

		-- Function for processing child elements
		local function process_child(child)
			if xml_obj:isElement(child) and xml_obj:getElementName(child) == "string" then
				local attr_table = xml_obj:getElementAttr(child)
				local string_id = attr_table and attr_table.id

				-- If string_id is found, add it to the table
				if string_id then
					-- Get the text inside the <string> element
					local text_elements = xml_obj:query("text", child)
					if text_elements and text_elements[1] then
						local text = xml_obj:getText(text_elements[1])
						if text then
							string_ids[string_id] = text
							logger.log_message(
								"DEBUG",
								string.format("Found string_id: %s with text: %s", string_id, text)
							)
						else
							logger.log_message("WARNING", string.format("Text not found for string_id: %s", string_id))
						end
					else
						logger.log_message(
							"WARNING",
							string.format("Text element not found for string_id: %s", string_id)
						)
					end
				else
					logger.log_message("WARNING", "string element found, but id attribute is missing")
				end
			end
		end

		-- Iterate through children
		xml_obj:iterateChildren(root, process_child)
		logger.log_message("DEBUG", string.format("Collected %d string_ids", #string_ids))
	else
		logger.log_message("ERROR", "Root element not found in XML")
	end

	return string_ids
end

-- Applying translations to XML
function M.change_xml_text(xml_obj, translations, encoding_utils)
	logger.log_message("DEBUG", "Starting to apply translations to XML")

	-- Проверка наличия переводов
	if not translations then
		logger.log_message("WARNING", "No translations provided for file.")
		return
	end

	local found_count = 0
	local missing_count = 0

	-- Iterate through all translations
	for string_id, new_text in pairs(translations) do
		logger.log_message("DEBUG", string.format("Processing string_id: %s", string_id))

		-- Convert text to Windows-1251 encoding
		local win1251_text = encoding_utils.to_windows1251(new_text)
		logger.log_message("DEBUG", string.format("Converted text to Windows-1251: %s", win1251_text))

		-- Search for an element in XML by string_id
		local query = string.format("string[id=%s] > text", string_id)
		local res = xml_obj:query(query)

		-- Если элемент найден, обновляем его текст
		if res[1] then
			xml_obj:setText(res[1], win1251_text)
			found_count = found_count + 1
			logger.log_message("DEBUG", string.format("Updated text for string_id: %s", string_id))
		else
			missing_count = missing_count + 1
			logger.log_message("WARNING", string.format("string_id not found in XML: %s", string_id))
		end
	end

	-- Logging results
	logger.log_message("INFO", string.format("Translations applied: %d found, %d missing", found_count, missing_count))
end

-- Writing new translations to a file
function M.ensure_translation_file(xml_file_name, xml_obj, missing_translations_dir)
	logger.log_message("DEBUG", string.format("Ensuring translation file for: %s", xml_file_name))

	-- Get the base name of the file
	local base_name = xml_file_name:match("([^/\\]+)%.xml$")
	if not base_name then
		logger.log_message("ERROR", string.format("Invalid XML file path: %s", xml_file_name))
		return nil
	end

	-- Forming a path to a file with missing translations
	local missing_translation_path = string.format("%s\\%s.lua", missing_translations_dir, base_name)
	logger.log_message("DEBUG", string.format("Missing translations file path: %s", missing_translation_path))

	-- Loading existing translations
	local existing_translations = translation_utils.load_translations_from_file(missing_translation_path)

	-- Collecting new translations from XML
	local new_translations = {}
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
							-- Если перевод для string_id отсутствует, добавляем его
							if not existing_translations[string_id] then
								new_translations[string_id] = text
								logger.log_message(
									"INFO",
									string.format("Adding new translation for ID: %s", string_id)
								)
							else
								logger.log_message("INFO", string.format("Skipping existing ID: %s", string_id))
							end
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
	if next(new_translations) then
		for string_id, text in pairs(new_translations) do
			existing_translations[string_id] = text
		end
		translation_utils.write_translations_to_file(missing_translation_path, existing_translations, base_name)
	else
		logger.log_message("INFO", "No new translations to add")
	end
end

return M
