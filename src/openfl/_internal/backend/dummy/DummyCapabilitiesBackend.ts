namespace openfl._internal.backend.dummy;

import openfl.Lib;

class DummyCapabilitiesBackend
{
	public static getLanguage(): string
	{
		return "en";
	}

	public static getManufacturer(): string
	{
		return "Unknown";
	}

	public static getScreenDPI(): number
	{
		return 72;
	}

	public static getScreenResolutionX(): number
	{
		var stage = Lib.current.stage;
		if (stage == null) return 0;
		return stage.stageWidth;
	}

	public static getScreenResolutionY(): number
	{
		var stage = Lib.current.stage;
		if (stage == null) return 0;
		return stage.stageHeight;
	}

	public static getOS(): string
	{
		return "Unknown";
	}
}
