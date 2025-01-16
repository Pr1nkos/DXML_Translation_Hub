--xml_translator\xml_translator_safe_require.lua

local logger = require("xml_translator_logger")

local M = {}

-- Secure module loading
function M.safe_require(module_name)
	logger.log_message("DEBUG", string.format("Attempting to load module: %s", module_name))
	local status, result = pcall(require, module_name)
	if status then
		logger.log_message("DEBUG", string.format("Successfully loaded module: %s", module_name))
		return result
	else
		logger.log_message("WARNING", string.format("Failed to load module '%s'. Error: %s", module_name, result))
		return nil
	end
end

return M
