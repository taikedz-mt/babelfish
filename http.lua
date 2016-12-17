function babel.https(self,url)
	local http = require("ssl.https")

	local response = http.request(url)

	return response
end

function babel.http(self,url)
	local http = require("socket.http")

	local response = http.request(url)

	return response
end
