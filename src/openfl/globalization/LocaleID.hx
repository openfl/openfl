package openfl.globalization;

#if !flash
@:final class LocaleID
{
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
			#if lime
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

	public var name(default, null):String;

	public var lastOperationStatus(default, null):LastOperationStatus;

	@:noCompletion private var language:String;
	@:noCompletion private var region:String;
	@:noCompletion private var script:String;
	@:noCompletion private var rtl:Bool;

	public function getLanguage():String
	{
		return language;
	}

	public function getRegion():String
	{
		return region;
	}

	public function getScript():String
	{
		return script;
	}

	public function getVariant():String
	{
		return "";
	}

	public function isRightToLeft():Bool
	{
		return rtl;
	}
}
#else
typedef LocaleID = flash.globalization.LocaleID;
#end
