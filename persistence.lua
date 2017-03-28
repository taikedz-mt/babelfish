-- Functions to implement persistent data

local phrasebank = {}
local phrasebankfile = minetest.get_worldpath().."/phrasebank.ser"

local function ph_persist(id, translation, langcode)
	if not phrasebank[id] then
		phrasebank[id] = {}
	end

	phrasebank[id][langcode] = translation
end

local function ph_retrieve(id, langcode)
	return phrasebank[id][langcode]
end

function babel.forgetphrase(id, langcode)
	phrasebank[id][langcode] = nil
end

function babel.savedphrase(phrase, langcode)
	local gotphrase = babel.ph_retreive(phrase, langcode)
	if not gotphrase then
		gotphrase = dotranslate(gotphrase, langcode)
		babel.ph_persist(phrase, gotphrase, langcode)
	end

	return gotphrase
end

local function ph_save()
	local serdata = minetest.serialize(phrasebank)
	if not serdata then
		minetest.log("error", "[babelfish] Phrasebank serialization failed")
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
		minetest.log("error", "[babelfish] Phrasebank read failed")
		return
	end
	phrasebank = minetest.deserialize(file:read("*a"))
	file:close()
end
