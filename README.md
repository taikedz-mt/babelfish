# Babelfish

Add translation commands to Minetest

* `/babel {language} {sentense}`
	* Translates that sentence to English for you
	* `/babel en une phrase en langue etrangere`

* `/babelshout {language} {sentence}`
	* Broadcasts a message in the target language (French in this case)
	* `/babelshout fr My english sentence`

* `/babelmsg {language} {player} {sentence}`
	* Sends a private message to another player in the target language
	* `/babelmsg es spanishplayer I do not understand you, please use the translation commands`

## Requirements

The server requires `lua-json` and `lua-sec` (Ubuntu's package names) to be installed, as well as potentially adding the mod to the trusted mods for security purposes.

## Engines

Available translation engine currently available is only Yandex

Others can be made available as required.
