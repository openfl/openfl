package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageScaleMode(String) from String to String

{
	public var EXACT_FIT = "exactFit";
	public var NO_BORDER = "noBorder";
	public var NO_SCALE = "noScale";
	public var SHOW_ALL = "showAll";
}
#else
typedef StageScaleMode = openfl.display.StageScaleMode;
#end
