package openfl.system;

#if lime
import lime.system.Locale;
import lime.system.System;
import openfl.Lib;
#if linux
import sys.io.Process;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Capabilities
{
	@:noCompletion private static var __standardDensities:Array<Int> = [120, 160, 240, 320, 480, 640, 800, 960];

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
		#if mac
		return "OpenFL Macintosh";
		#elseif linux
		return "OpenFL Linux";
		#else
		var name = System.platformName;
		return "OpenFL" + (name != null ? " " + name : "");
		#end
	}

	public static function getScreenDPI():Float
	{
		var window = Lib.limeApplication != null ? Lib.limeApplication.window : null;
		var screenDPI:Float;

		#if (desktop || web)
		screenDPI = 72;

		if (window != null)
		{
			screenDPI *= window.scale;
		}
		#else
		screenDPI = __standardDensities[0];

		if (window != null)
		{
			var display = window.display;

			if (display != null)
			{
				var actual = display.dpi;

				var closestValue = screenDPI;
				var closestDifference = Math.abs(actual - screenDPI);
				var difference:Float;

				for (density in __standardDensities)
				{
					difference = Math.abs(actual - density);

					if (difference < closestDifference)
					{
						closestDifference = difference;
						closestValue = density;
					}
				}

				screenDPI = closestValue;
			}
		}
		#end

		return screenDPI;
	}

	public static function getScreenResolutionX():Float
	{
		var stage = Lib.current.stage;
		var resolutionX = 0;

		if (stage == null) return 0;

		if (stage.limeWindow != null)
		{
			var display = stage.limeWindow.display;

			if (display != null)
			{
				resolutionX = Math.ceil(display.currentMode.width * stage.limeWindow.scale);
			}
		}

		if (resolutionX > 0)
		{
			return resolutionX;
		}

		return stage.stageWidth;
	}

	public static function getScreenResolutionY():Float
	{
		var stage = Lib.current.stage;
		var resolutionY = 0;

		if (stage == null) return 0;

		if (stage.limeWindow != null)
		{
			var display = stage.limeWindow.display;

			if (display != null)
			{
				resolutionY = Math.ceil(display.currentMode.height * stage.limeWindow.scale);
			}
		}

		if (resolutionY > 0)
		{
			return resolutionY;
		}

		return stage.stageHeight;
	}

	public static function getOS():String
	{
		#if (ios || tvos)
		return System.deviceModel;
		#elseif mac
		return "Mac OS " + System.platformVersion;
		#elseif linux
		var kernelVersion = "";
		try
		{
			var process = new Process("uname", ["-r"]);
			kernelVersion = StringTools.trim(process.stdout.readLine().toString());
			process.close();
		}
		catch (e:Dynamic) {}
		if (kernelVersion != "") return "Linux " + kernelVersion;
		else
			return "Linux";
		#else
		var label = System.platformLabel;
		return label != null ? label : "";
		#end
	}
}
#end
