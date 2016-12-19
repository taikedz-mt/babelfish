# Translation Engines

Some translation engines are provided for free and therefore require you to comply to certain rules.

There is a `compliance.lua` file included to handle this.

## Build your own engine

You can use the `example_engine.lua` file to base a new engine off of. It contains the basic API elements needed for a full engine.

* The engine must provide a single function onto the `babel` object

	`babel:translate(language_code, sentence)`

	* The function must return a string representing the translated text.

* The engine must provide a table on `babel.langcodes` containing the list of language codes supported by the service.

	`babel.langcodes = {en = "English", fr = "French"}`

* The engine must provide a `babel.engine` string to identify the engine, for display in translation results.

* The engine can override `babel.validate_lang(self, language_code)` if needed to provide any special messages.

* The engine can call `babel:request(url)` helper function which make the request (http or https) and return the raw response data.

## Yandex.Translate

The Yandex engine uses Yandex.Translate's services.

### Language codes

The following language codes were taken from the Yandex API page as the languages supported by Yandex.

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
	ht	Haitian
	he	Hebrew
	mrj	Hill
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
	
