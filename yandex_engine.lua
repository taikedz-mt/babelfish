-- (C) 2016 Tai "DuCake" Kedzierski
-- This code is conveyed to you under the terms
-- of the GNU Lesser General Public License v3.0
-- You should have received a copy of the license
-- in a LICENSE.txt file
-- If not, please see https://www.gnu.org/licenses/lgpl-3.0.html

local json = require("json")

local httpapi

function babel.register_http(hat)
	httpapi = hat
end

babel.engine = "YANDEX" -- used for tagging messages

babel.langcodes = {
	af = "Afrikaans",
	sq = "Albanian",
	am = "Amharic",
	ar = "Arabic",
	hy = "Armenian",
	az = "Azerbaijan",
	ba = "Bashkir",
	eu = "Basque",
	be = "Belarusian",
	bn = "Bengali",
	bs = "Bosnian",
	bg = "Bulgarian",
	ca = "Catalan",
	ceb = "Cebuano",
	zh = "Chinese",
	hr = "Croatian",
	cs = "Czech",
	da = "Danish",
	nl = "Dutch",
	en = "English",
	eo = "Esperanto",
	et = "Estonian",
	fi = "Finnish",
	fr = "French",
	gl = "Galician",
	ka = "Georgian",
	de = "German",
	el = "Greek",
	gu = "Gujarati",
	ht = "Haitian",
	he = "Hebrew",
	mrj = "Hill",
	hi = "Hindi",
	hu = "Hungarian",
	is = "Icelandic",
	id = "Indonesian",
	ga = "Irish",
	it = "Italian",
	ja = "Japanese",
	jv = "Javanese",
	kn = "Kannada",
	kk = "Kazakh",
	ko = "Korean",
	ky = "Kyrgyz",
	la = "Latin",
	lv = "Latvian",
	lt = "Lithuanian",
	mk = "Macedonian",
	mg = "Malagasy",
	ms = "Malay",
	ml = "Malayalam",
	mt = "Maltese",
	mi = "Maori",
	mr = "Marathi",
	mhr = "Mari",
	mn = "Mongolian",
	ne = "Nepali",
	no = "Norwegian",
	pap = "Papiamento",
	fa = "Persian",
	pl = "Polish",
	pt = "Portuguese",
	pa = "Punjabi",
	ro = "Romanian",
	ru = "Russian",
	gd = "Scottish",
	sr = "Serbian",
	si = "Sinhala",
	sk = "Slovakian",
	sl = "Slovenian",
	es = "Spanish",
	su = "Sundanese",
	sw = "Swahili",
	sv = "Swedish",
	tl = "Tagalog",
	tg = "Tajik",
	ta = "Tamil",
	tt = "Tatar",
	te = "Telugu",
	th = "Thai",
	tr = "Turkish",
	udm = "Udmurt",
	uk = "Ukrainian",
	ur = "Urdu",
	uz = "Uzbek",
	vi = "Vietnamese",
	cy = "Welsh",
	xh = "Xhosa",
	yi = "Yiddish",
}

local serviceurl = "https://translate.yandex.net/api/v1.5/tr.json/translate?"

local function extract_phrase(json_string)
	local jsontable = json.decode(json_string)
	return jsontable.text[1]
end

function babel.translate(self, phrase, lang, handler)
	local transurl = serviceurl ..
		"key="..babel.key.."&"..
		"text="..phrase:gsub(" ","+").."&"..
		"lang="..lang
	
	httpapi.fetch({url = transurl}, function(htresponse)
		if htresponse.succeeded then
			handler(extract_phrase(htresponse.data) )
		else
			handler("Failed request")
			minetest.log("error", "Error on requesting -- "..dump(htresponse))
		end
	end)
end

babel.compliance = "Translations are Powered by Yandex.Translate"
dofile(minetest.get_modpath("babelfish").."/compliance.lua")
