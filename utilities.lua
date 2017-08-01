babel.sanitize = function(stringdata)
	stringdata = stringdata:gsub(" ","+")
	stringdata = stringdata:gsub("&", "%26")

	return stringdata
end
