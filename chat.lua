local irct = minetest.get_modpath("irc")

function babel.chat_send_player(player,message)
	minetest.chat_send_player(player,message)
end

function babel.chat_send_all(message)
	if irct then
		irc:say(message)
	end
	minetest.chat_send_all(message)
end
