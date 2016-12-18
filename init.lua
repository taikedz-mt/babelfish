babel = {}

local modpath = minetest.get_modpath("babelfish")
dofile(modpath.."/http.lua" )
dofile(modpath.."/chat.lua" )
local engine = minetest.setting_get("babelfish.engine") or "yandex"
babel.key = minetest.setting_get("babelfish.key")
dofile(modpath.."/"..engine.."_engine.lua")


local function components(mystring)
	local iter = mystring:gmatch("%S+")
	local targetlang = iter()
	local targetphrase = mystring:gsub("^"..targetlang.." ","")

	return targetlang,targetphrase
end

local function validate_lang(langstring)
	for _,target in pairs(babel.langcodes) do
		if target == langstring then
			return true
		end
	end

	return false
end

local function validate_player(playername)
	if minetest.get_player_by_name(playername) then
		return true
	end
	return false
end

local function dotranslate(lang,phrase)
	return babel:translate(phrase,lang)
end

minetest.register_chatcommand("babel",{
	description = "Translate a sentence",
	params = "<lang-code> <sentence>",
	func = function(player,argstring)
		local targetlang,targetphrase = components(argstring)

		if not validate_lang(targetlang) then
			babel.chat_send_player(player,targetlang.." is not a recognized language")
			return
		end

		local newphrase = dotranslate(targetlang,targetphrase)

		babel.chat_send_player(player,"[BABEL]: "..newphrase)
		minetest.log("action", player.." translation [BABEL]: "..newphrase)
	end
})

minetest.register_chatcommand("babelshout",{
	description = "Translate a sentence and transmit it to everybody",
	params = "<lang-code> <sentence>",
	func = function(player,argstring)
		local targetlang,targetphrase = components(argstring)

		if not validate_lang(targetlang) then
			babel.chat_send_player(player,targetlang.." is not a recognized language")
			return
		end

		local newphrase = dotranslate(targetlang,targetphrase)

		babel.chat_send_all("[BABEL from "..player.."]: "..newphrase)
		minetest.log("action", player.." translation to all [BABEL]: "..newphrase)
	end
})

minetest.register_chatcommand("babelmsg",{
	description = "Translate a sentence, and send it to a specific player",
	params = "<lang-code> <player> <sentence>",
	func = function(player,argstring)
		local targetlang,targetphrase = components(argstring)
		local targetplayer,targetphrase = components(targetphrase)

		if not validate_lang(targetlang) then
			babel.chat_send_player(player,targetlang.." is not a recognized language")
			return
		end

		if not validate_player(targetplayer) then
			babel.chat_send_player(player,targetlang.." is not a connected player")
			return
		end
		
		local newphrase = dotranslate(targetlang,targetphrase)

		babel.chat_send_player(targetplayer,"[BABEL from "..player.."]: "..newphrase)
		minetest.log("action", player.." translation to "..targetplayer.." [BABEL]: "..newphrase)
	end
})
