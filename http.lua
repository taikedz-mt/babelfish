-- (C) 2016 Tai "DuCake" Kedzierski
-- This code is conveyed to you under the terms
-- of the GNU Lesser General Public License v3.0
-- You should have received a copy of the license
-- in a LICENSE.txt file
-- If not, please see https://www.gnu.org/licenses/lgpl-3.0.html

local ie = minetest.request_insecure_environment()

local https = ie.require("ssl.https")
local http = ie.require("socket.http")

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
