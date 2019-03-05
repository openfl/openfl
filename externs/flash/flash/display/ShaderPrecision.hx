package flash.display;

#if flash
@:enum abstract ShaderPrecision(String) from String to String
{
	public var FAST = "fast";
	public var FULL = "full";
}
#else
typedef ShaderPrecision = openfl.display.ShaderPrecision;
#end
