package openfl.display;

#if !flash

#if !openfljs
/**
	The StageScaleMode class provides values for the
	`Stage.scaleMode` property.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageScaleMode(Null<Int>)

{
	/**
		Specifies that the entire application be visible in the specified area without
		trying to preserve the original aspect ratio. Distortion can occur.
	**/
	public var EXACT_FIT = 0;

	/**
		Specifies that the entire application fill the specified area, without
		distortion but possibly with some cropping, while maintaining the original
		aspect ratio of the application.
	**/
	public var NO_BORDER = 1;

	/**
		Specifies that the size of the application be fixed, so that it remains
		unchanged even as the size of the player window changes. Cropping might occur
		if the player window is smaller than the content.
	**/
	public var NO_SCALE = 2;

	/**
		Specifies that the entire application be visible in the specified area without
		distortion while maintaining the original aspect ratio of the application.
		Borders can appear on two sides of the application.
	**/
	public var SHOW_ALL = 3;

	@:from private static function fromString(value:String):StageScaleMode
	{
		return switch (value)
		{
			case "exactFit": EXACT_FIT;
			case "noBorder": NO_BORDER;
			case "noScale": NO_SCALE;
			case "showAll": SHOW_ALL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : StageScaleMode)
		{
			case StageScaleMode.EXACT_FIT: "exactFit";
			case StageScaleMode.NO_BORDER: "noBorder";
			case StageScaleMode.NO_SCALE: "noScale";
			case StageScaleMode.SHOW_ALL: "showAll";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageScaleMode(String) from String to String

{
	public var EXACT_FIT = "exactFit";
	public var NO_BORDER = "noBorder";
	public var NO_SCALE = "noScale";
	public var SHOW_ALL = "showAll";
}
#end
#else
typedef StageScaleMode = flash.display.StageScaleMode;
#end
