-- Adding path to xml_translator modules to package.path
package.path = package.path .. ";gamedata\\scripts\\xml_translator\\utils\\?.lua;"
-- Connecting the logger module
local logger = require("xml_translator_logger")
local encoding_utils = require("xml_translator_encoding_utils")

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
-- Applying translations to XML
function M.change_xml_text(xml_obj, translations, encoding_utils, processed_string_ids)
	logger.log_message("DEBUG", "Starting to apply translations to XML")

	-- Проверка наличия переводов
	if not translations then
		logger.log_message("WARNING", "No translations provided for file.")
		return
	end

	-- -- Логирование содержимого processed_string_ids, если оно есть
	-- if processed_string_ids then
	-- 	if next(processed_string_ids) ~= nil then
	-- 		logger.log_message("DEBUG", "Contents of processed_string_ids:")
	-- 		for string_id, _ in pairs(processed_string_ids) do
	-- 			logger.log_message("DEBUG", string.format("  string_id: %s", string_id))
	-- 		end
	-- 	else
	-- 		logger.log_message("DEBUG", "processed_string_ids is empty")
	-- 	end
	-- else
	-- 	logger.log_message("DEBUG", "processed_string_ids is not provided")
	-- end

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
			-- Добавляем string_id в список обработанных
			if processed_string_ids then
				processed_string_ids[string_id] = true
				logger.log_message("DEBUG", string.format("Added string_id to processed_string_ids: %s", string_id))
				-- Логирование содержимого processed_string_ids после добавления
				-- logger.log_message("DEBUG", "Updated contents of processed_string_ids:")
				-- for id, _ in pairs(processed_string_ids) do
				-- 	logger.log_message("DEBUG", string.format("  string_id: %s", id))
				-- end
			else
				logger.log_message("DEBUG", "processed_string_ids is not provided, skipping addition")
			end
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
function M.ensure_translation_file(xml_obj, processed_string_ids)

	local existing_translations = {}
	local new_translations = {}
	local root = xml_obj:getRoot()
	if root then
		local function process_child(child)
			if xml_obj:isElement(child) and xml_obj:getElementName(child) == "string" then
				local attr_table = xml_obj:getElementAttr(child)
				local string_id = attr_table and attr_table.id
				if string_id and not processed_string_ids[string_id] then
					local text_elements = xml_obj:query("text", child)
					if text_elements and text_elements[1] then
						local text = xml_obj:getText(text_elements[1])
						if text then
							local utf8_text = encoding_utils.from_windows1251(text)
							-- Проверяем, существует ли уже такой string_id в существующих переводах
							if not existing_translations[string_id] then
								new_translations[string_id] = utf8_text
								logger.log_message(
									"INFO",
									string.format("Adding new translation for ID: %s", string_id)
								)
							else
								logger.log_message("DEBUG", string.format("Skipping existing ID: %s", string_id))
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
	return new_translations
end

return M
