package openfl._internal.backend.lime_standalone;

package lime.system;

#if flash
import flash.system.Capabilities;
#end
import lime.system.CFFI;
import lime.system.JNI;

abstract Locale(String) from String to String
{
	@:isVar public static var currentLocale(get, set):Locale;
	public static var systemLocale(get, never):Locale;
	private static var __systemLocale:Locale;

	public var language(get, never):String;
	public var region(get, never):String;

	public function new(value:String)
	{
		this = value;
	}

	@:noCompletion @:op(A == B) private static function equals(a:Locale, b:Locale):Bool
	{
		var language = a.language;
		var region = a.region;

		var language2 = b.language;
		var region2 = b.region;

		var languageMatch = (language == language2);
		var regionMatch = (region == region2);

		if (!languageMatch && language != null && language2 != null)
		{
			languageMatch = (language.toLowerCase() == language2.toLowerCase());
		}

		if (!regionMatch && region != null && region2 != null)
		{
			regionMatch = (region.toLowerCase() == region2.toLowerCase());
		}

		return (languageMatch && regionMatch);
	}

	#if hl
	@:hlNative("lime", "lime_locale_get_system_locale") private static function lime_locale_get_system_locale():hl.Bytes
	{
		return null;
	}
	#end

	private static function __init():Void
	{
		if (__systemLocale == null)
		{
			var locale = null;

			#if flash
			locale = Capabilities.language;
			#elseif (js && html5)
			locale = untyped navigator.language;
			#elseif (android)
			var getDefault:Void->Dynamic = JNI.createStaticMethod("java/util/Locale", "getDefault", "()Ljava/util/Locale;");
			var toString:Dynamic->String = JNI.createMemberMethod("java/util/Locale", "toString", "()Ljava/lang/String;");

			locale = toString(getDefault());
			#elseif (lime_cffi && !macro)
			#if hl
			var _locale = lime_locale_get_system_locale();
			locale = _locale != null ? @:privateAccess String.fromUTF8(_locale) : null;
			#else
			locale = CFFI.load("lime", "lime_locale_get_system_locale", 0)();
			#end
			#end

			if (locale != null)
			{
				__systemLocale = locale;
			}
			else
			{
				__systemLocale = "en-US";
			}

			currentLocale = __systemLocale;
		}
	}

	// Get & Set Methods
	@:noCompletion private function get_language():String
	{
		if (this != null)
		{
			var index = this.indexOf("_");

			if (index > -1)
			{
				var dashIndex = this.indexOf("-");
				if (dashIndex > -1 && dashIndex < index) index = dashIndex;

				return this.substring(0, index);
			}

			index = this.indexOf("-");

			if (index > -1)
			{
				return this.substring(0, index);
			}
		}

		return this;
	}

	@:noCompletion private function get_region():String
	{
		if (this != null)
		{
			var underscoreIndex = this.indexOf("_");
			var dotIndex = this.indexOf(".");
			var dashIndex = this.indexOf("-");

			if (underscoreIndex > -1)
			{
				if (dotIndex > -1)
				{
					return this.substring(underscoreIndex + 1, dotIndex);
				}
				else
				{
					return this.substring(underscoreIndex + 1);
				}
			}
			else if (dashIndex > -1)
			{
				if (dotIndex > -1)
				{
					return this.substring(dashIndex + 1, dotIndex);
				}
				else
				{
					return this.substring(dashIndex + 1);
				}
			}
		}

		return null;
	}

	// Get & Set Methods
	private static function get_currentLocale():Locale
	{
		__init();

		return currentLocale;
	}

	private static function set_currentLocale(value:Locale):Locale
	{
		__init();

		return currentLocale = value;
	}

	private static function get_systemLocale():Locale
	{
		__init();

		return __systemLocale;
	}
}
