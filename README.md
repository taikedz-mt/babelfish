# Babelfish

Add translation commands to Minetest

* `/babel {language} {player}`
	* Translates the last message from the specified player to the target language
	* Only you see the result of this
	* `/babel en mrGibberish`

* `/bb {language} {sentence}`
	* Broadcasts a message in the target language (French in this case)
	* `/bb fr My english sentence`

* `/bmsg {language} {player} {sentence}`
	* Sends a private message to another player in the target language
	* `/bmsg es spanishplayer I do not understand you, please use the translation commands`

* `/bblangs`
	* List the available language codes

## Requirements

The server requires `lua-json` and `lua-sec` to be installed, as well as potentially adding the mod to the trusted mods for security purposes. For example when adding both `babelfish` and `irc` as trusted mods:

	secure.trusted_mods = irc,babelfish

On Ubuntu/Debian, Minetest does not pick up on packages in `/usr/local/lib` ; instead you need to install luarocks and then use that

	apt-get install luarocks gcc
	luarocks install luasec
	luarocks install luajson
	apt-get remove gcc

# Configuration

(Required) Add your API key to `minetest.conf` under `babelfish.key`

	babelfish.key = <your key>

(Optional) Add an engine name (bing, google, etc) to minetest conf under `babelfish.engine`. The default is `yandex`. Other engines would need to be developed.

	babelfish.engine = yandex

(Optional) You can display a friendly message to users who join by setting

	babelfish.helponjoin = true

Players will see a message when joining inviting them to check `/help bb` and `/help babel`

## Integrations

This mod supports additional functions from [IRC](https://github.com/minetest-mods/irc) - any shout actions are propagated through the IRC too.

## Use as an API

Other mods can use the babelfish engine simply by calling `babel:translate(phrase, language_code)` to obtain the translated string.

**Note** - this should only be used when providing translations for items whose content is set by players dynamically, for example signs, books, etc.

For hardcoded text that is provided by mods, please use [inttlib](https://github.com/minetest-mods/intllib) instead.

## Adding engines

See the [Engines](Engines.md) file for more information.
