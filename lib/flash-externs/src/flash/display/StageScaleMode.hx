package flash.display;

#if flash
@:enum abstract StageScaleMode(String) from String to String
{
	public var EXACT_FIT = "exactFit";
	public var NO_BORDER = "noBorder";
	public var NO_SCALE = "noScale";
	public var SHOW_ALL = "showAll";
}
#else
typedef StageScaleMode = openfl.display.StageScaleMode;
#end
