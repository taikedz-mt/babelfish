-- Include this if your chosen engine requires you to advertise its use.

minetest.register_on_joinplayer(function(player)
	local playername = player:get_player_name()

	if babel.compliance then
		minetest.chat_send_player(playername,babel.compliance)
	end
	minetest.chat_send_player(playername, "This is an multilingual server!")
	minetest.chat_send_player(playername, "Type '/help bb' for more information on translations.")
end)
