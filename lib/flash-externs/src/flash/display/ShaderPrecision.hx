package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ShaderPrecision(String) from String to String

{
	public var FAST = "fast";
	public var FULL = "full";
}
#else
typedef ShaderPrecision = openfl.display.ShaderPrecision;
#end
