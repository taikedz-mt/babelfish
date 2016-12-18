babel = {}

local modpath = minetest.get_modpath("babelfish")
dofile(modpath.."/http.lua" )
dofile(modpath.."/chat.lua" )
local engine = minetest.setting_get("babelfish.engine") or "yandex"
babel.key = minetest.setting_get("babelfish.key")
dofile(modpath.."/"..engine.."_engine.lua")

local chat_history = {}

minetest.register_on_chat_message(function(player, message)
	chat_history[player] = message
end)

local function components(mystring)
	local iter = mystring:gmatch("%S+")
	local targetlang = iter() or ""
	local targetphrase = mystring:gsub("^"..targetlang.." ", "")

	return targetlang, targetphrase
end

local function validate_lang(langstring)
	for target, langname in pairs(babel.langcodes) do
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

local function dotranslate(lang, phrase)
	return babel:translate(phrase, lang)
end

local function f_babel(player, argstring)
	local targetplayer, targetlang = components(argstring)

	if not validate_lang(targetlang) then
		babel.chat_send_player(player, targetlang.." is not a recognized language")
		return
	end

	if not chat_history[targetplayer] then
		babel.chat_send_player(player, targetplayer.." has not said anything")
		return
	end

	local newphrase = dotranslate(targetlang, chat_history[targetplayer])

	babel.chat_send_player(player, "[BABEL]: "..newphrase)
end

function f_babelshout(player, argstring)
	local targetlang, targetphrase = components(argstring)

	if not validate_lang(targetlang) then
		babel.chat_send_player(player, targetlang.." is not a recognized language")
		return
	end

	local newphrase = dotranslate(targetlang, targetphrase)

	babel.chat_send_all("[BABEL from "..player.."]: "..newphrase)
	minetest.log("action", player.." CHAT [BABEL]: "..newphrase)
end

function f_babelmsg(player, argstring)
	local targetlang, targetphrase = components(argstring)
	local targetplayer, targetphrase = components(targetphrase)

	if not validate_lang(targetlang) then
		babel.chat_send_player(player, targetlang.." is not a recognized language")
		return
	end

	if not validate_player(targetplayer) then
		babel.chat_send_player(player, targetplayer.." is not a connected player")
		return
	end
	
	local newphrase = dotranslate(targetlang, targetphrase)

	babel.chat_send_player(targetplayer, "[BABEL from "..player.."]: "..newphrase)
	minetest.log("action", player.." PM to "..targetplayer.." [BABEL]: "..newphrase)
end

minetest.register_chatcommand("bblangs", {
	description = "List the available language codes",
	func = function(player,command)
		minetest.chat_send_player(player,dump(babel.langcodes))
	end
})

minetest.register_chatcommand("babel", {
	description = "Translate a player's last chat message",
	params = "<playername> <lang-code>",
	func = f_babel
})

minetest.register_chatcommand("bb", {
	description = "Translate a sentence and transmit it to everybody",
	params = "<lang-code> <sentence>",
	func = f_babelshout
})

minetest.register_chatcommand("babelshout", {
	description = "Translate a sentence and transmit it to everybody",
	params = "<lang-code> <sentence>",
	func = f_babelshout
})

minetest.register_chatcommand("bmsg", {
	description = "Translate a sentence, and send it to a specific player",
	params = "<lang-code> <player> <sentence>",
	func = f_babelmsg
})

minetest.register_chatcommand("babelmsg", {
	description = "Translate a sentence, and send it to a specific player",
	params = "<lang-code> <player> <sentence>",
	func = f_babelmsg
})
