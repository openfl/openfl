package openfl._internal.backend.dummy;

import openfl.Lib;

class DummyCapabilitiesBackend
{
	public static function getLanguage():String
	{
		return "en";
	}

	public static function getManufacturer():String
	{
		return "Unknown";
	}

	public static function getScreenDPI():Float
	{
		return 72;
	}

	public static function getScreenResolutionX():Float
	{
		var stage = Lib.current.stage;
		if (stage == null) return 0;
		return stage.stageWidth;
	}

	public static function getScreenResolutionY():Float
	{
		var stage = Lib.current.stage;
		if (stage == null) return 0;
		return stage.stageHeight;
	}

	public static function getOS():String
	{
		return "Unknown";
	}
}
