local helponjoin = minetest.setting_getbool("babelfish.helponjoin") or false

minetest.register_on_joinplayer(function(player)
	local playername = player:get_player_name()

	if babel.compliance then
		minetest.chat_send_player(playername,babel.compliance)
	end
	if babel.compliance or helponjoin then
		minetest.chat_send_player(playername, "This is an multilingual server!")
		minetest.chat_send_player(playername, "Type '/help bb' and '/help babel' for more information on translations.")
	end
end)
