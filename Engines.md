# Translation Engines

Babelfish provides a default translation engine based on Yandex, but also allows you to write your own integration.

Most services are likely to require an API key, and you can add your own configurations as well.

Therefore, remeber to document how to use and configure your engine, as well as how to obtain keys.

Add a suitable file to the [`engines-docs/`](engines-docs/) folder when creating an engine.

## Build your own engine

You can use the `example_engine.lua` file to base a new engine off of. It contains the basic API elements needed for a full engine.

* The engine must provide a single function onto the `babel` object

	`babel:translate(language_code, sentence)`

	* The function must return a string representing the translated text.

* The engine must provide a table on `babel.langcodes` containing the list of language codes supported by the service.

	`babel.langcodes = {en = "English", fr = "French"}`

* The engine must provide a `babel.engine` string to identify the engine, for display in translation results.

* The engine can override `babel.validate_lang(self, language_code)` if needed to provide any special messages.

* Due to mod security, you will need to provide a way for your engine to receive a safe URL handler. Define this at the top of your file

	local httpapi

	function babel.register_http(hat)
		httpapi = hat
	end

* When the babelfish loads your translation engine, a security-enabled URL calling handle will be available to you in your `httpapi` variable. **DO NOT** make the `httpapi` variable or its function public !!

### Compliance

Some translation APIs require you to comply to certain rules; most generally they require you to highlight the fact that your translations are provided by their engine.

A `babel.compliance` variable can optionally be included, as the text to display when a player joins.

The name of the engine is also displayed on all messages sent to chat, so that compliance is met, but also to indicate that the original meaning may have been lost in machine translation.

