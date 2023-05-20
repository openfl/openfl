package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract PixelSnapping(String) from String to String

{
	public var ALWAYS = "always";
	public var AUTO = "auto";
	public var NEVER = "never";
}
#else
typedef PixelSnapping = openfl.display.PixelSnapping;
#end
