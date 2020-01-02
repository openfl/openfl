package openfl._internal.backend.html5;

#if openfl_html5
import openfl._internal.backend.lime_standalone.Application;
import openfl._internal.backend.lime_standalone.Locale;
import openfl._internal.backend.lime_standalone.System;

class HTML5CapabilitiesBackend
{
	public static function getLanguage():String
	{
		var language = Locale.currentLocale.language;

		if (language != null)
		{
			language = language.toLowerCase();

			switch (language)
			{
				case "cs", "da", "nl", "en", "fi", "fr", "de", "hu", "it", "ja", "ko", "nb", "pl", "pt", "ru", "es", "sv", "tr":
					return language;

				case "zh":
					var region = Locale.currentLocale.region;

					if (region != null)
					{
						switch (region.toUpperCase())
						{
							case "TW", "HANT":
								return "zh-TW";

							default:
						}
					}

					return "zh-CN";

				default:
					return "xu";
			}
		}

		return "en";
	}

	public static function getManufacturer():String
	{
		var name = System.platformName;
		return "OpenFL" + (name != null ? " " + name : "");
	}

	public static function getScreenDPI():Float
	{
		var window = Application.current != null ? Application.current.window : null;
		var screenDPI:Float;

		screenDPI = 72;

		if (window != null)
		{
			screenDPI *= window.scale;
		}

		return screenDPI;
	}

	public static function getScreenResolutionX():Float
	{
		var stage = Lib.current.stage;
		var resolutionX = 0;

		if (stage == null) return 0;

		// if (stage.window != null)
		// {
		// 	var display = stage.window.display;

		// 	if (display != null)
		// 	{
		// 		resolutionX = Math.ceil(display.currentMode.width * stage.window.scale);
		// 	}
		// }

		// if (resolutionX > 0)
		// {
		// 	return resolutionX;
		// }

		return stage.stageWidth;
	}

	public static function getScreenResolutionY():Float
	{
		var stage = Lib.current.stage;
		var resolutionY = 0;

		if (stage == null) return 0;

		// if (stage.window != null)
		// {
		// 	var display = stage.window.display;

		// 	if (display != null)
		// 	{
		// 		resolutionY = Math.ceil(display.currentMode.height * stage.window.scale);
		// 	}
		// }

		// if (resolutionY > 0)
		// {
		// 	return resolutionY;
		// }

		return stage.stageHeight;
	}

	public static function getOS():String
	{
		var label = System.platformLabel;
		return label != null ? label : "";
	}
}
#end
