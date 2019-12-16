package flash.system;

#if flash
@:enum abstract TouchscreenType(String) from String to String
{
	public var FINGER = "finger";
	public var NONE = "none";
	public var STYLUS = "stylus";
}
#else
typedef TouchscreenType = openfl.system.TouchscreenType;
#end
