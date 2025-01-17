--xml_translator\utils\xml_translator_encoding_utils.lua

-- Connecting the logger module
local logger = require("xml_translator_logger")

-- Main module
local M = {}

-- Source table for UTF-8 → Windows-1251 conversion
M.encoding_table = {
	-- Cyrillic
	["А"] = "\192",
	["а"] = "\224",
	["Б"] = "\193",
	["б"] = "\225",
	["В"] = "\194",
	["в"] = "\226",
	["Г"] = "\195",
	["г"] = "\227",
	["Д"] = "\196",
	["д"] = "\228",
	["Е"] = "\197",
	["е"] = "\229",
	["Ж"] = "\198",
	["ж"] = "\230",
	["З"] = "\199",
	["з"] = "\231",
	["И"] = "\200",
	["и"] = "\232",
	["Й"] = "\201",
	["й"] = "\233",
	["К"] = "\202",
	["к"] = "\234",
	["Л"] = "\203",
	["л"] = "\235",
	["М"] = "\204",
	["м"] = "\236",
	["Н"] = "\205",
	["н"] = "\237",
	["О"] = "\206",
	["о"] = "\238",
	["П"] = "\207",
	["п"] = "\239",
	["Р"] = "\208",
	["р"] = "\240",
	["С"] = "\209",
	["с"] = "\241",
	["Т"] = "\210",
	["т"] = "\242",
	["У"] = "\211",
	["у"] = "\243",
	["Ф"] = "\212",
	["ф"] = "\244",
	["Х"] = "\213",
	["х"] = "\245",
	["Ц"] = "\214",
	["ц"] = "\246",
	["Ч"] = "\215",
	["ч"] = "\247",
	["Ш"] = "\216",
	["ш"] = "\248",
	["Щ"] = "\217",
	["щ"] = "\249",
	["Ъ"] = "\218",
	["ъ"] = "\250",
	["Ы"] = "\219",
	["ы"] = "\251",
	["Ь"] = "\220",
	["ь"] = "\252",
	["Э"] = "\221",
	["э"] = "\253",
	["Ю"] = "\222",
	["ю"] = "\254",
	["Я"] = "\223",
	["я"] = "\255",
	["Ё"] = "\168",
	["ё"] = "\184",

	-- Special characters
	["Ђ"] = "\128",
	["ђ"] = "\144",
	["Ѓ"] = "\129",
	["ѓ"] = "\131",
	["‚"] = "\130",
	["„"] = "\132",
	["…"] = "\133",
	["†"] = "\134",
	["‡"] = "\135",
	["€"] = "\136",
	["‰"] = "\137",
	["Љ"] = "\138",
	["‹"] = "\139",
	["Њ"] = "\140",
	["Ќ"] = "\141",
	["Ћ"] = "\142",
	["Џ"] = "\143",
	["‘"] = "\145",
	["’"] = "\146",
	["“"] = "\147",
	["”"] = "\148",
	["•"] = "\149",
	["–"] = "\150",
	["—"] = "\151",
	["™"] = "\153",
	["љ"] = "\154",
	["›"] = "\155",
	["њ"] = "\156",
	["ќ"] = "\157",
	["ћ"] = "\158",
	["џ"] = "\159",
	["Ў"] = "\161",
	["ў"] = "\162",
	["Ј"] = "\163",
	["¤"] = "\164",
	["Ґ"] = "\165",
	["¦"] = "\166",
	["§"] = "\167",
	["©"] = "\169",
	["Є"] = "\170",
	["«"] = "\171",
	["¬"] = "\172",
	["­"] = "\173",
	["®"] = "\174",
	["Ї"] = "\175",
	["°"] = "\176",
	["±"] = "\177",
	["І"] = "\178",
	["і"] = "\179",
	["ґ"] = "\180",
	["µ"] = "\181",
	["¶"] = "\182",
	["·"] = "\183",
	["№"] = "\185",
	["є"] = "\186",
	["»"] = "\187",
	["ј"] = "\188",
	["Ѕ"] = "\189",
	["ѕ"] = "\190",
	["ї"] = "\191",
}

-- Function to create an inverse table
local function create_reverse_table(table)
	local reverse_table = {}
	for k, v in pairs(table) do
		reverse_table[v] = k
	end
	return reverse_table
end

-- Create an intermediate table for Windows-1251 → UTF-8
M.reverse_encoding_table = create_reverse_table(M.encoding_table)

-- Function to iterate over UTF-8 characters
function M.utf8_chars(str)
	logger.log_message("DEBUG", "Starting UTF-8 character iteration")

	local i = 1
	return function()
		if i > #str then
			logger.log_message("DEBUG", "UTF-8 character iteration completed")
			return nil
		end
		local byte = str:byte(i)
		local char_len = 1
		if byte < 0x80 then
			-- 1-byte character
			char_len = 1
		elseif byte < 0xE0 then
			-- 2-byte character
			char_len = 2
		elseif byte < 0xF0 then
			-- 3-byte character
			char_len = 3
		else
			-- 4-byte character
			char_len = 4
		end
		local char = str:sub(i, i + char_len - 1)
		i = i + char_len
		logger.log_message("DEBUG", string.format("Processed UTF-8 character: %s", char))
		return char
	end
end

-- Function to convert UTF-8 → Windows-1251
function M.to_windows1251(text)
	logger.log_message("DEBUG", "Starting UTF-8 to Windows-1251 conversion")

	local result = ""
	for char in M.utf8_chars(text) do
		local win1251_char
		if M.encoding_table[char] then
			win1251_char = M.encoding_table[char]
			logger.log_message("DEBUG", string.format("Converted character: %s → %s", char, win1251_char))
		else
			win1251_char = char
		end
		result = result .. win1251_char
	end

	logger.log_message("INFO", "UTF-8 to Windows-1251 conversion completed")
	return result
end

-- Function to convert Windows-1251 → UTF-8
function M.from_windows1251(text)
	logger.log_message("DEBUG", "Starting Windows-1251 to UTF-8 conversion")

	local result = ""
	for i = 1, #text do
		local char = text:sub(i, i)
		if M.reverse_encoding_table[char] then
			utf8_char = M.reverse_encoding_table[char]
			logger.log_message("DEBUG", string.format("Converted character: %s → %s", char, utf8_char))
		else
			utf8_char = char
		end
		result = result .. utf8_char
	end

	logger.log_message("DEBUG", "Windows-1251 to UTF-8 conversion completed")
	return result
end

return M
