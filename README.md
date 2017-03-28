# Babelfish

Add translation commands to Minetest

Provided under the GNU Lesser General Public License v3.0

### Chat intercepts

For global chat, players can simply use a language code preceded by a "%" symbol. For example

	Hello everyone ! %fr

The message will be sent in its original form, as well as in French.

	Hello %fr everyone !

that is, the token can be anywhere.

The token is removed from both messsages.

## Commands

* `/babel {player}`
	* Translates the last message from the specified player to your preferred language
	* Only you see the result of this
	* `/babel mrGibberish`

* `/bblang {language}`
	* Set your preferred language using a language code
	* Default is English
	* Currently does not save across server reboots

* `/bmsg {player} {sentence}`
	* Sends a private message to another player in the target language
	* `/bmsg spanishplayer I do not understand you, please use the translation commands`

* `/bbcodes`
	* List the available language codes

## Moderator Commands

* `/bbset {player} {langcode}`
	* set a player's language code
	* requires `babelmoderator` privilege

## Requirements

The server requires `lua-json` to be installed, as well as adding the mod to the trusted mods for security purposes. For example when adding both `babelfish` and `irc` as trusted mods:

	secure.trusted_mods = irc,babelfish

Otherwise, you may get errors like `httpapi not defined`

On Ubuntu/Debian, Minetest does not pick up on packages in `/usr/local/lib` ; instead you need to install luarocks and then use that

	apt-get install luarocks gcc
	luarocks install luajson
	apt-get remove gcc

# Configuration

(*Required*) Add your API key to `minetest.conf` under `babelfish.key`

	babelfish.key = <your key>

(*Optional*) Add an engine name (bing, google, etc) to minetest conf under `babelfish.engine`. The default is `yandex`. Other engines would need to be developed.

	babelfish.engine = yandex

(*Optional*) You can display a friendly message to users who join by setting

	babelfish.helponjoin = true

Players will see a message when joining inviting them to check `/help bb` and `/help babel`

## Integrations

This mod supports additional functions from [IRC](https://github.com/minetest-mods/irc) - any shout actions are propagated through the IRC too.

## Use as an API

Other mods can use the babelfish engine simply by calling `babel:translate(phrase, language_code)` to obtain the translated string.

**Note** - this should only be used when providing translations for items whose content is set by players dynamically, for example signs, books, etc.

For hardcoded text that is provided by mods, please use [intllib](https://github.com/minetest-mods/intllib) instead, until persistent translations are added.

## Adding engines

See the [Engines](Engines.md) file for more information.

## To-Do

Still to implement:

* Book Translator - a node which accepts a book, a language specification, and returns the translated book
* Special "persistent translations" call so that a phrase is translated once, and stored for later re-use
* Special command for translating to all players in their preferred languages
	* depends on a temp-persistence being implemented
	* requires privs - this can easily consume the API quota quickly
	* for moderators/admins making announcements
