local https = require("ssl.https")
local http = require("socket.http")

function babel.https(self, url)
	local response = https.request(url)
	return response
end

function babel.http(self, url)
	local response = http.request(url)
	return response
end

function babel.request(self, url)
	if url:gmatch("^https://") then
		return babel:https(url)
	elseif url:gmatch("^http://") then
		return babel:http(url)
	end
end
