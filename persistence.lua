-- Functions to implement persistent data

local phrasebank = {}
local phrasebankfile = minetest.get_worldpath().."/phrasebank.ser"

-- Save

local function ph_persist(id, translation, langcode)
	if not phrasebank[id] then
		phrasebank[id] = {}
	end

	phrasebank[id][langcode] = translation
end

babel.savephrase = function(id, translation, langcode)
	ph_persist(id, translation, langcode)
end

-- Forget

babel.forgetphrase = function(id, langcode)
	if not phrasebank[id] then return end
	phrasebank[id][langcode] = nil
end

-- Retrieve

local function ph_retrieve(id, langcode)
	if not phrasebank[id] then return "" end
	return phrasebank[id][langcode]
end

babel.getphrase = function(phrase, langcode)
	local gotphrase = babel.ph_retrieve(phrase, langcode)

	if not gotphrase then
		gotphrase = dotranslate(gotphrase, langcode)
		ph_persist(phrase, gotphrase, langcode)
	end

	return gotphrase
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

-- Runtime

ph_load()
