--xml_translator\utils\xml_translator_translation_utils.lua

-- Adding path to xml_translator modules to package.path
package.path = package.path .. ";gamedata\\scripts\\xml_translator\\utils\\?.lua;"

local logger = require("xml_translator_logger")
local file_utils = require("xml_translator_logger_file_utils")

local M = {}

-- Loading translations from a file
function M.load_translations_from_file(file_path)
	local translations = {}
	logger.log_message("DEBUG", string.format("Attempting to load translations from file: %s", file_path))

	local content = file_utils.read_file(file_path)
	if content then
		logger.log_message("DEBUG", "File content read successfully")

		-- Removing BOM (if any)
		if content:sub(1, 3) == "\239\187\191" then
			content = content:sub(4)
			logger.log_message("DEBUG", "Removed BOM from file content")
		end

		-- Загрузка содержимого как Lua-код
		local func, err = load("return " .. content, "translations", "t", {})
		if not func then
			func, err = load(content, "translations", "t", {})
			logger.log_message("DEBUG", "Attempting to load content as Lua code without 'return' prefix")
		end

		if func then
			logger.log_message("DEBUG", "Lua code loaded successfully, executing...")
			local status, result = pcall(func)
			if status then
				if type(result) == "table" then
					translations = result
					logger.log_message("INFO", string.format("Successfully loaded translations from: %s", file_path))
				else
					logger.log_message("WARNING", string.format("Expected a table, but got: %s", type(result)))
				end
			else
				logger.log_message("ERROR", string.format("Failed to execute translations: %s", result))
			end
		else
			logger.log_message("ERROR", string.format("Failed to load translations: %s", err))
		end
	else
		logger.log_message("ERROR", string.format("Failed to read file: %s", file_path))
	end

	logger.log_message("DEBUG", string.format("Returning translations table with %d entries", #translations))
	return translations
end

-- Record translations to file
function M.write_translations_to_file(file_path, translations, base_name)
	logger.log_message("DEBUG", string.format("Preparing to write translations to file: %s", file_path))

	local lines = { "-- Translations for " .. base_name .. "\n", "return {\n" }
	for string_id, text in pairs(translations) do
		table.insert(lines, string.format('    ["%s"] = [=[%s]=],\n', string_id, text))
	end
	table.insert(lines, "}\n")

	local success = file_utils.write_file(file_path, table.concat(lines))
	if success then
		logger.log_message("INFO", string.format("Successfully wrote translations to file: %s", file_path))
	else
		logger.log_message("ERROR", string.format("Failed to write translations to file: %s", file_path))
	end
end

-- Updating translations
function M.update_translations(existing_translations, string_ids)
	logger.log_message("DEBUG", "Starting to update translations")

	local updated_translations = {}
	local removed_count = 0
	for string_id, text in pairs(existing_translations) do
		if not string_ids[string_id] then
			updated_translations[string_id] = text
		else
			removed_count = removed_count + 1
		end
	end

	logger.log_message("INFO", string.format("Removed %d translations", removed_count))
	logger.log_message("DEBUG", string.format("Updated translations table contains %d entries", #updated_translations))

	return updated_translations
end

return M
