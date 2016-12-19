-- Example Engine File
-- You can use this file as an example to base your own engine off of

-- Declare the engine name
-- This is used in displaying messages by the main library
babel.engine = "EXAMPLE"

-- Declare the valid language codes
-- This can be hardcoded or dynamically built
babel.langcodes = {
	en = "English",
	gd = "Scottish",
}

-- The API URL for the service
local serviceurl = "https://translations.example.com/api/v42/json?"

-- The public-facing translation function
function babel.translate(self, phrase, lang)

	-- Construct the request URL
	local transurl = serviceurl ..
		"key="..babel.key.."&"..
		"text="..phrase:gsub(" ","+").."&"..
		"lang="..lang
	
	-- make the request
	local response = babel:request(transurl)
	
	-- do further processing on response, or just return it as-is
	return response
end

-- Compliance notes
-- If the web service requires translations to be announced,
-- this will be the compliance string to be displayed.
babel.compliance = "Translations are Powered by Example.com"
