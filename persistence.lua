-- Functions to implement persistent data

local phrasebank = {}
local phrasebankfile = minetest.get_worldpath().."/phrasebank.ser"

babel.persist_save = function(id, phrase, langcode)
	if not phrasebank[id] then
		phrasebank[id] = {}
	end

	-- TODO cater for being original and langcoded
	if not langcode then
		langcode = "original"
	end

	phrasebank[id][langcode] = phrase
	ph_save()
end

babel.persist_get = function(id, langcode)
	if not langcode then
		langcode = "original"
	end

	if not phrasebank[id] then
		return ""
	end

	if not phrasebank[id][langcode] then
		phrasebank[id][langcode] = dotranslate(phrasebank[id]["original"], langcode)
		ph_save()
	end

	return phrasebank[id][langcode]
end

babel.persist_drop = function(id, langcode)
	if not langcode then
		phrasebank[id] = nil
	else
		phrasebank[id][langcode] = nil
	end
	ph_save()
end

-- File manip

local function ph_save()
	local serdata = minetest.serialize(phrasebank)
	if not serdata then
		minetest.log("info", "[babelfish] Phrasebank serialization failed")
		return
	end
	local file, err = io.open(phrasebankfile, "w")
	if err then
		return err
	end
	file:write(serdata)
	file:close()
end

local function ph_load()
	local file, err = io.open(phrasebankfile, "r")
	if err then
		minetest.log("info", "[babelfish] No phrasebank found")
		return
	end
	phrasebank = minetest.deserialize(file:read("*a"))
	file:close()
end

minetest.register_chatcommand("bbp_save",{
	func = function(username, args)
		babel.getphrase("babel-help", "")
	end
})

minetest.register_chatcommand("bbp_get",{
	func = function(username, args)
	end
})

minetest.register_chatcommand("bbp_drop",{
	func = function(username, args)
	end
})

-- Runtime

ph_load()
