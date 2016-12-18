babel.engine = "yandex"

babel.langcodes = {"af","sq","am","ar","hy","az","ba","eu","be","bn","bs","bg","ca","ceb","zh","hr","cs","da","nl","en","eo","et","fi","fr","gl","ka","de","el","gu","ht","he","mrj","hi","hu","is","id","ga","it","ja","jv","kn","kk","ko","ky","la","lv","lt","mk","mg","ms","ml","mt","mi","mr","mhr","mn","ne","no","pap","fa","pl","pt","pa","ro","ru","gd","sr","si","sk","sl","es","su","sw","sv","tl","tg","ta","tt","te","th","tr","udm","uk","ur","uz","vi","cy","xh","yi"}

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
	
	local response = babel:https(transurl)
	
	return extract_phrase(response)
end
