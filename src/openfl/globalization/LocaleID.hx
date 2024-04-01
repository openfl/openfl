package openfl.globalization;

#if !flash
/**
	The LocaleID class provides methods for parsing and using locale ID names.
	This class supports locale ID names that use the syntax defined by the
	[Unicode Technical Standard #35](https://unicode.org/reports/tr35/).

	@see [Unicode Technical Standard #35](https://unicode.org/reports/tr35/)
**/
@:final class LocaleID
{
	/**
		Indicates that the user's default linguistic preferences should be used,
		as specified in the user's operating system settings. For example, suc
		preferences are typically set using the "Control Panel" for Windows, or
		the "System Preferences" in macOS.

		Using the `LocaleID.DEFAULT` setting can result in the use of a
		different locale ID name for different kinds of operations. For example,
		one locale could be used for sorting and a different one for formatting.
		This flexibility respects the user preferences, and the class behaves
		this way by design.

		This locale identifier is not always the most appropriate one to use.
		For applications running in the browser, the browser's preferred locale
		could be a better choice. It is often a good idea to let the user alter
		the preferred locale ID name setting and preserve that preference in a
		user profile, cookie, or shared object.
	**/
	public static inline var DEFAULT:String = "i-default";

	@:noCompletion private static var RTL_LANGUAGES = [
		"ae", // Avestan
		"ar", // Arabic
		"arc", // Aramaic
		"bcc", // Southern Balochi
		"bqi", // Bakthiari
		"ckb", // Sorani
		"dv", // Dhivehi
		"fa", // Persian
		"glk", // Gilaki
		"he", // Hebrew
		"ku", // Kurdish
		"mzn", // Mazanderani
		"nqo", // N"Ko
		"pnb", // Western Punjabi
		"ps", // Pashto
		"sd", // Sindhi
		"ug", // Uyghur
		"ur", // Urdu
		"yi" // Yiddish
	];

	@:noCompletion private static function normalizeRequestedLocaleIDName(requestedLocaleIDName:String):String
	{
		if (requestedLocaleIDName == null)
		{
			return null;
		}
		if (requestedLocaleIDName == DEFAULT)
		{
			#if html5
			// Lime's Locale.currentLocale uses navigator.language, which may
			// not be the right choice when using JS Intl types
			requestedLocaleIDName = untyped Intl.DateTimeFormat().resolvedOptions().locale;
			#elseif lime
			requestedLocaleIDName = lime.system.Locale.currentLocale;
			#else
			requestedLocaleIDName = openfl.system.Capabilities.language;
			#end
		}
		// A Unicode CLDR locale identifier can be converted to a valid
		// BCP47 language tag (which is also a Unicode BCP 47 locale
		// identifier) by performing the following transformation.
		// 1. Replace the "_" separators with "-"
		// 2. Replace the special language identifier "root" with the BCP 47
		//    primary language tag "und"
		// 3. Add an initial "und" primary language subtag if the first
		//    subtag is a script.
		// Source: https://unicode.org/reports/tr35/#Unicode_Locale_Identifier_CLDR_to_BCP_47
		requestedLocaleIDName = ~/_/g.replace(requestedLocaleIDName, "-");
		var parts = requestedLocaleIDName.split("-");
		var language = parts.shift();
		language = language.toLowerCase();
		if (language == "root")
		{
			language = "und";
		}
		var script:String = null;
		var region:String = null;
		if (parts.length > 0)
		{
			var next = parts.shift();
			if (next != null && next.length == 4)
			{
				script = next.charAt(0).toUpperCase() + next.substr(1).toLowerCase();
				next = parts.shift();
			}
			if (next != null && (next.length == 2 || next.length == 3))
			{
				region = next.toUpperCase();
				next = parts.shift();
			}
		}
		var result = language;
		if (script != null)
		{
			result += "-" + script;
		}
		if (region != null)
		{
			result += "-" + region;
		}
		return result;
	}

	/**
		Constructs a new LocaleID object, given a locale name. The locale name
		must conform to the syntax defined by the
		[Unicode Technical Standard #35](https://unicode.org/reports/tr35/).

		When the constructor completes successfully the `lastOperationStatus`
		property is set to:

		- `LastOperationStatus.NO_ERROR`

		When the requested locale ID name is not available then the
		`lastOperationStatus` is set to one of the following:

		- LastOperationStatus.USING_FALLBACK_WARNING
		- LastOperationStatus.USING_DEFAULT_WARNING

		Otherwise, the `lastOperationStatus` property is set to one of the
		constants defined in the `LastOperationStatu`s class.

		For details on the warnings listed above and other possible values of
		the `lastOperationStatus` property, see the descriptions in the
		`LastOperationStatus` class.
	**/
	public function new(name:String)
	{
		if (name == DEFAULT)
		{
			this.name = name;
			language = name;
			region = "";
			script = "";
			rtl = false;
			this.lastOperationStatus = NO_ERROR;
		}
		else
		{
			try
			{
				#if html5
				var intlLocale = untyped #if haxe4 js.Syntax.code #else __js__ #end ('new Intl.Locale')(name).maximize();
				this.name = Reflect.field(intlLocale, "baseName");
				language = Reflect.field(intlLocale, "language");
				region = Reflect.field(intlLocale, "region");
				script = Reflect.field(intlLocale, "script");
				#else
				this.name = normalizeRequestedLocaleIDName(name);
				var parts = this.name.split("-");
				language = parts.shift();
				if (parts.length > 0)
				{
					var next = parts.shift();
					if (next != null && next.length == 4)
					{
						script = next;
						next = parts.shift();
					}
					else
					{
						script = "";
					}
					if (next != null && (next.length == 2 || next.length == 3))
					{
						region = next;
						next = parts.shift();
					}
					else
					{
						region = "";
					}
				}
				#end
				rtl = RTL_LANGUAGES.indexOf(language) != -1;
				this.lastOperationStatus = NO_ERROR;
			}
			catch (e:Dynamic)
			{
				this.lastOperationStatus = ERROR_CODE_UNKNOWN;
			}
		}
	}

	/**
		Returns a slightly more "canonical" locale identifier.

		This method performs the following conversion to the locale ID name to
		give it a more canonical form.

		- Proper casing is applied to all of the components.
		- Underscores are converted to dashes.

		No additional processing is performed. For example, aliases are not
		replaced, and no elements are added or removed.

		When this method is called and it completes successfully, the
		`lastOperationStatus property` is set to:

		- `LastOperationStatus.NO_ERROR`

		Otherwise, the `lastOperationStatus` property is set to one of the
		constants defined in the LastOperationStatus class.
	**/
	public var name(default, null):String;

	/**
		The status of the most recent operation that this LocaleID object
		performed. The `lastOperationStatus` property is set whenever the
		constructor or a method of this class is called or another property is
		set. For the possible values see the description for each method.
	**/
	public var lastOperationStatus(default, null):LastOperationStatus;

	@:noCompletion private var language:String;
	@:noCompletion private var region:String;
	@:noCompletion private var script:String;
	@:noCompletion private var rtl:Bool;

	/**
		Returns the language code specified by the locale ID name.

		If the locale name cannot be properly parsed then the language code is
		the same as the full locale name.

		When this method is called and it completes successfully, the
		`lastOperationStatus` property is set to:

		- `LastOperationStatus.NO_ERROR`

		Otherwise, the `lastOperationStatus` property is set to one of the
		constants defined in the `LastOperationStatus` class.
	**/
	public function getLanguage():String
	{
		return language;
	}

	/**
		Returns the region code specified by the locale ID name.

		This method returns an empty string if the region code cannot be parsed
		or guessed/ This could occur if an unknown or incomplete locale ID name
		like "xy" is used. The region code is not validated against a fixed
		list. For example, the region code returned for a locale ID name of
		"xx-YY" is "YY".

		When this method is called and it completes successfully, the
		`lastOperationStatus` property is set to:

		- `LastOperationStatus.NO_ERROR`

		If the region is not part of the specified locale name, the most likely
		region code for the locale is "guessed" and `lastOperationStatus`
		property is set to `LastOperationStatus.USING_FALLBACK_WARNING`.

		Otherwise, the `lastOperationStatus` property is set to one of the
		constants defined in the `LastOperationStatus` class.
	**/
	public function getRegion():String
	{
		return region;
	}

	/**
		Returns the script code specified by the locale ID name.

		This method returns an empty string if the script code cannot be parsed
		or guessed. This could occur if an unknown or incomplete locale ID name
		like "xy" is used. The script code is not validated against a fixed
		list. For example, the script code returned for a locale ID name of
		"xx-Abcd-YY" is "Abcd".

		The region, as well as the language, can also affect the return value.
		For example, the script code for "mn-MN" (Mongolian-Mongolia) is "Cyrl"
		(Cyrillic), while the script code for "mn-CN" (Mongolian-China) is
		"Mong" (Mongolian).

		When this method is called and it completes successfully, the
		`lastOperationStatus` property is set to:

		- `LastOperationStatus.NO_ERROR`

		If the script code is not part of the specified locale name, the most
		likely script code is "guessed" and `lastOperationStatus` property is
		set to `LastOperationStatus.USING_FALLBACK_WARNING`.

		Otherwise, the `lastOperationStatus` property is set to one of the
		constants defined in the `LastOperationStatus` class.
	**/
	public function getScript():String
	{
		return script;
	}

	/**
		Returns the language variant code specified by the locale ID name.

		This method returns an empty string if there is no language variant code
		in the given locale ID name. (No guessing is necessary because few
			locales have or need a language variant.)

		When this method is called and it completes successfully, the
		`lastOperationStatus` property is set to:

		- `LastOperationStatus.NO_ERROR`

		Otherwise, the `lastOperationStatus` property is set to one of the
		constants defined in the `LastOperationStatus` class.
	**/
	public function getVariant():String
	{
		return "";
	}

	/**
		Specifies whether the text direction for the specified locale is right
		to left.

		The result can be used to determine the direction of the text in the
		OpenFL text engine, and to decide whether to mirror the user interface
		to support the current text direction.

		When this method is called and it completes successfully, the
		`lastOperationStatus` property is set to:

		- `LastOperationStatus.NO_ERROR`

		Otherwise, the `lastOperationStatus` property is set to one of the
		constants defined in the `LastOperationStatus` class.
	**/
	public function isRightToLeft():Bool
	{
		return rtl;
	}
}
#else
typedef LocaleID = flash.globalization.LocaleID;
#end
