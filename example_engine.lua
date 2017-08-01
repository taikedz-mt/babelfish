-- Example Engine File
-- You can use this file as an example to base your own engine off of

-- Compliance notes
-- If the web service requires translations to be announced,
-- this will be the compliance string to be displayed.
babel.compliance = "Translations are Powered by Example.com"

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

local httpapi

function babel.register_http(hat)
	httpapi = hat
end

-- The public-facing translation function
function babel:translate(phrase, lang, handler)
	-- phrase : A string of the phrase to translate
	-- lang : the language code to pass to the server
	-- handler : a handler function to return the data to babelfish core

	-- Construct the request URL
	-- We sanitize both lang and phrase as they can be player-entered data
	-- For example:
	local transurl = serviceurl ..
		"key="..babel.key.."&"..
		"text="..babel.sanitize(phrase).."&"..
		"lang="..babel.sanitize(lang)
	
	-- make the request
	httpapi.fetch({url = transurl}, function(htresponse)
		if htresponse.succeeded then
			handler(extract_phrase(htresponse.data) )
		else
			handler("Failed request")
			minetest.log("error", "Error on requesting -- "..dump(htresponse))
		end
	end)
	
	-- do further processing on response, or just return it as-is
	return response
end
