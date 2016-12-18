# Babelfish

Add translation commands to Minetest

* `/babel {language} {player}`
	* Translates the last 3 messages from the specified player
	* Only you see the result of this
	* `/babel en mrGibberish`
	* (still WIP - do not use yet)

* `/babelshout {language} {sentence}`
* `/bb {language} {sentence}`
	* Broadcasts a message in the target language (French in this case)
	* `/babelshout fr My english sentence`

* `/babelmsg {language} {player} {sentence}`
* `/bmsg {language} {player} {sentence}`
	* Sends a private message to another player in the target language
	* `/babelmsg es spanishplayer I do not understand you, please use the translation commands`

# Configuration

Add the engine name (yandex, bing, google, etc) to minetest conf under `babelfish.engine`. The default is `yandex`

Add your API key to `minetest.conf` under `babelfish.key`

## Requirements

The server requires `lua-json` and `lua-sec` to be installed, as well as potentially adding the mod to the trusted mods for security purposes.

On Ubuntu/Debian, Minetest does not pick up on packages in `/usr/local/lib` ; instead you need to install luarocks and then use that

	apt-get install luarocks
	luarocks install luasec luajson

## Integrations

This mod supports IRC - any shout actions are propagated through the IRC too.

## Engines

Available translation engine currently available is only Yandex

Others can be made available as required.

The engine must provide a single function onto the `babel` object

	babel:translate(language_code, sentence)

The function must return a string representing the translated text.

The engine must also provide a table on `babel.langcodes` containing the list of language codes supported by the service.

The engine can make use of the `babel:http(url)` and `babel:https(url)`

## Language codes

The following language codes were compiled from the Yandex API page as the languages supported by Yandex.

	Code	Language

	af	Afrikaans
	sq	Albanian
	am	Amharic
	ar	Arabic
	hy	Armenian
	az	Azerbaijan
	ba	Bashkir
	eu	Basque
	be	Belarusian
	bn	Bengali
	bs	Bosnian
	bg	Bulgarian
	ca	Catalan
	ceb	Cebuano
	zh	Chinese
	hr	Croatian
	cs	Czech
	da	Danish
	nl	Dutch
	en	English
	eo	Esperanto
	et	Estonian
	fi	Finnish
	fr	French
	gl	Galician
	ka	Georgian
	de	German
	el	Greek
	gu	Gujarati
	ht	Haitian (Creole)
	he	Hebrew
	mrj	Hill Mari
	hi	Hindi
	hu	Hungarian
	is	Icelandic
	id	Indonesian
	ga	Irish
	it	Italian
	ja	Japanese
	jv	Javanese
	kn	Kannada
	kk	Kazakh
	ko	Korean
	ky	Kyrgyz
	la	Latin
	lv	Latvian
	lt	Lithuanian
	mk	Macedonian
	mg	Malagasy
	ms	Malay
	ml	Malayalam
	mt	Maltese
	mi	Maori
	mr	Marathi
	mhr	Mari
	mn	Mongolian
	ne	Nepali
	no	Norwegian
	pap	Papiamento
	fa	Persian
	pl	Polish
	pt	Portuguese
	pa	Punjabi
	ro	Romanian
	ru	Russian
	gd	Scottish
	sr	Serbian
	si	Sinhala
	sk	Slovakian
	sl	Slovenian
	es	Spanish
	su	Sundanese
	sw	Swahili
	sv	Swedish
	tl	Tagalog
	tg	Tajik
	ta	Tamil
	tt	Tatar
	te	Telugu
	th	Thai
	tr	Turkish
	udm	Udmurt
	uk	Ukrainian
	ur	Urdu
	uz	Uzbek
	vi	Vietnamese
	cy	Welsh
	xh	Xhosa
	yi	Yiddish

