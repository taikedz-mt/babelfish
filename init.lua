-- (C) 2016 Tai "DuCake" Kedzierski
-- This code is conveyed to you under the terms
-- of the GNU Lesser General Public License v3.0
-- You should have received a copy of the license
-- in a LICENSE.txt file
-- If not, please see https://www.gnu.org/licenses/lgpl-3.0.html

babel = {}

local modpath = minetest.get_modpath("babelfish")
dofile(modpath.."/chat.lua" )
local langprefs = minetest.get_worldpath().."/babel_langprefs"
local engine = minetest.setting_get("babelfish.engine") or "yandex"
babel.key = minetest.setting_get("babelfish.key")

minetest.register_privilege("babelmoderator")

-- ===== SECURITY ======

local ie = minetest.request_insecure_environment()

if not ie then
	error("Could not get secure environment. Add babelfish to secure.trusted_mods ")
end

local oldrequire = require
require = ie.require -- override require so that system libraries being loaded can benefit

	if not babel.key then engine = "none" end
	dofile(modpath.."/"..engine.."_engine.lua")

	local httpapitable = minetest.request_http_api()
	babel.register_http(httpapitable)

require = oldrequire -- restore the sandbox's require

-- =====================

-- ========================== Language engine and overridable validation

function babel.validate_lang(self, langstring)
	for target, langname in pairs(babel.langcodes) do
		if target == langstring then
			return true
		end
	end

	return tostring(langstring).." is not a recognized language"
end

-- =====================================================================/

local chat_history = {}
local player_pref_language = {}

minetest.register_on_chat_message(function(player, message)
	chat_history[player] = message
end)

local function components(mystring)
	local iter = mystring:gmatch("%S+")
	local targetlang = iter() or ""
	local targetphrase = mystring:gsub("^"..targetlang.." ", "")

	return targetlang, targetphrase
end

local function validate_player(playername)
	if minetest.get_player_by_name(playername) then
		return true
	end
	return false
end

local function dotranslate(lang, phrase, handler)
	return babel:translate(phrase, lang, handler)
end

-- Shortcut translation
-- Send a message like "Hello everyone ! %fr"
-- The message is broadcast in original form, then in French
minetest.register_on_chat_message(function(player, message)
	-- Search for "%" token
	local n,m = message:find("%%..")
	local targetlang = nil
	local targetphrase = message
	if n then
		local sfront = message:sub(1, n-1)
		local sback = message:sub(m+1, message:len() )
		targetlang = message:sub(n+1, m) -- Removes '%' token
		targetphrase = message:gsub("%%"..targetlang,'',1)
	end

	if not targetlang then
		return false
	end

	-- True, or error string
	local validation = babel:validate_lang(targetlang)

	if validation ~= true then
		babel.chat_send_player(player, validation)

	else
		dotranslate(targetlang, targetphrase, function(newphrase)
			babel.chat_send_all("["..babel.engine.." "..player.."]: "..newphrase)
			minetest.log("action", player.." CHAT ["..babel.engine.."]: "..newphrase)
		end)
	end
end)

local function f_babel(player, argstring)
	local targetplayer = argstring
	if not player_pref_language[player] then
		player_pref_language[player] = "en"
	end

	local targetlang = player_pref_language[player]

	local validation = babel:validate_lang(targetlang)
	if validation ~= true then
		babel.chat_send_player(player, validation)
		return
	end

	if not chat_history[targetplayer] then
		babel.chat_send_player(player, targetplayer.." has not said anything")
		return
	end

	dotranslate(targetlang, chat_history[targetplayer], function(newphrase)
		babel.chat_send_player(player, "["..babel.engine.."]: "..newphrase)
	end)
end

local function f_babelshout(player, argstring)
	local targetlang, targetphrase = components(argstring)

	local validation = babel:validate_lang(targetlang)
	if validation ~= true then
		babel.chat_send_player(player, validation)
		return
	end

	dotranslate(targetlang, targetphrase, function(newphrase)
		babel.chat_send_all("["..babel.engine.." "..player.."]: "..newphrase)
		minetest.log("action", player.." CHAT ["..babel.engine.."]: "..newphrase)
	end)
end

local function f_babelmsg(player, argstring)
	local targetplayer, targetphrase = components(argstring)
	local targetlang = player_pref_language[targetplayer]

	local validation = babel:validate_lang(targetlang)
	if validation ~= true then
		babel.chat_send_player(player, validation)
		return
	end

	if not validate_player(targetplayer) then
		babel.chat_send_player(player, targetplayer.." is not a connected player")
		return
	end
	
	dotranslate(targetlang, targetphrase, function(newphrase)
		babel.chat_send_player(targetplayer, "["..babel.engine.." PM from "..player.."]: "..newphrase)
		minetest.log("action", player.." PM to "..targetplayer.." ["..babel.engine.."]: "..newphrase)
	end)
end

minetest.register_chatcommand("bblang", {
	description = "Set your preferred language",
	func = function(player,args)
		local validation = babel:validate_lang(args)
		if validation ~= true then
			babel.chat_send_player(player, validation)
			return
		else
			player_pref_language[player] = args
			babel.chat_send_player(player, args.." : OK" )
			prefsave()
		end
	end
})

minetest.register_chatcommand("bbcodes", {
	description = "List the available language codes",
	func = function(player,command)
		minetest.chat_send_player(player,dump(babel.langcodes))
	end
})

minetest.register_chatcommand("babel", {
	description = "Translate a player's last chat message. Use /bblang to set your language",
	params = "<playername>",
	func = f_babel
})

minetest.register_chatcommand("bb", {
	description = "Translate a sentence and transmit it to everybody",
	params = "<lang-code> <sentence>",
	func = f_babelshout
})

minetest.register_chatcommand("bmsg", {
	description = "Send a private message to a player, in their preferred language",
	params = "<player> <sentence>",
	func = f_babelmsg
})

-- Admin commands

minetest.register_chatcommand("bbset", {
	description = "Set a player's preferred language (if they do not know how)",
	params = "<player> <language-code>",
	privs = {babelmoderator = true},
	func = function(player, message)
		local tplayer, langcode = components(message)
		if minetest.get_player_by_name(tplayer) then
			player_pref_language[tplayer] = langcode
		end
	end,
})

-- Display help string, and compliance if set
dofile(minetest.get_modpath("babelfish").."/compliance.lua")

function prefsave()
	local serdata = minetest.serialize(player_pref_language)
	if not serdata then
		minetest.log("error", "[babelfish] Data serialization failed")
		return
	end
	local file, err = io.open(langprefs, "w")
	if err then
		return err
	end
	file:write(serdata)
	file:close()
end

function prefload()
	local file, err = io.open(langprefs, "r")
	if err then
		minetest.log("error", "[babelfish] Data read failed")
		return
	end
	player_pref_language = minetest.deserialize(file:read("*a"))
	file:close()
end

prefload()
