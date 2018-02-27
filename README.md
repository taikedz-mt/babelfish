# Babelfish

> Add translation commands to Minetest
>
> Provided under the GNU Lesser General Public License v3.0

Allows Minetest players to communicate across language barriers.

Especially useful for moderators who need to talk to players who communicate in other languages, but also to players who wish to team up with players foreign to them.

### Chat intercepts

For global chat, players can simply use a language code preceded by a "%" symbol. For example

	Hello everyone ! %fr

The message will be sent in its original form, as well as in French. The language token can be placed anywhere:

	Hello %fr everyone !

Only the first token is interpreted and removed from both messsages.

	Hello everybody %fr %es

Will send

	Bonjour à tous %es


## Commands

* `/babel {player}`
	* Translates the last message from the specified player to your preferred language
	* Only you see the result of this
	* `/babel mrGibberish`

* `/bblang {language}`
	* Set your preferred language using a language code
	* Default is English

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

	sudo apt-get install luarocks gcc
	sudo luarocks install luajson
	sudo apt-get remove gcc

On some distributions, the following is sufficient:

	sudo apt-get install lua-json

Try each before filing a bug...

# Configuration

(*Required*): Add your API key to `minetest.conf` under `babelfish.key`

	babelfish.key = <your key>

(*Optional*): Add an engine name (bing, google, etc) to minetest conf under `babelfish.engine`. The default is `yandex`. Other engines would need to be developed.

	babelfish.engine = yandex

(*Optional*): You can display a friendly message to users who join by setting

	babelfish.helponjoin = true

Players will see a message when joining inviting them to check `/help bb` and `/help babel`

(*Optional*): You can set the default language that players will be given on joining. If none is set, the default language is English.

	babelfish.defaultlang = fr

## Integrations

This mod supports additional functions from [IRC](https://github.com/minetest-mods/irc) - any shout actions are propagated through the IRC too.

## Use as an API

Other mods can use the babelfish engine simply by calling `babel:translate(phrase, language_code)` to obtain the translated string.

This should only be used when providing translations for items whose content is set by players dynamically, for example signs, books, etc.

For hardcoded text that is provided by mods, consider using [intllib](https://github.com/minetest-mods/intllib) instead.

### Persistent translations

You can use the following functions if you expect to serve the same phrase many times - for example you can add this support to building signs.

* `babel:persist_save(id, phrase)`
* `babel:persist_save(id, phrase, langcode)`
	* Save a phrase under the chosen id (for example "world-rules"), saving the supplied phrase as the "original"
	* if langcode is specified, the phrase is store for that language
		* if it is the first phrase to be registeredd for that ID, it will also be the default phrase from which translations will be made

* `babel:persist_get(id, langcode, return_handler)`
	* retrieve the translation of a phrase, and pass it to the return handler function
		* if the translation does not exist already, the original will be translated and stored
	* Your return handler must take exactly 1 argument, the translated text
	* Example:

```lua
babel:persist_get("babel-help", "es", function(translated)
	minetest.chat_send_all(translated)
end)
```
	
* `babel:persist_drop(id)`
* `babel:persist_drop(id, langcode)`
	* utility function to forget a translation for a given language code

## Adding engines

See the [Engines](Engines.md) file for more information.

## To-Do

Still to implement:

* HitchGuide - a book that displays the main help in the preferred language, and allows setting the preferred language
* BabelFish - a fish-like item that will translate nodes with text - [placed books](https://github.com/taikedz/everamzah-books), signs, and the likes.
* Book Translator - a node which accepts a book, a language specification, and returns the translated book
* Special command for translating to all players in their preferred languages
	* requires privs - this can easily consume the API quota quickly
	* for moderators/admins making announcements
