babel.engine = "yandex"

local serviceurl = "https://translate.yandex.net/api/v1.5/tr.json/translate?"
local json = require("json")

local function extract_phrase(json_string)
	local jsontable = json.decode(json_string)
	return jsontable.text[1]
end

function babel.translate(self,phrase,lang)
	local transurl = serviceurl ..
		"key="..babel.key.."&"..
		"text="..phrase:gsub(" ","+").."&"..
		"lang="..lang
	
	local response = babel:call(transurl)
	
	return extract_phrase(response)
end
