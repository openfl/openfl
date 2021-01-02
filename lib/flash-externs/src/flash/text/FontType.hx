package flash.text;

#if flash
@:enum abstract FontType(String) from String to String
{
	public var DEVICE = "device";
	public var EMBEDDED = "embedded";
	public var EMBEDDED_CFF = "embeddedCFF";
}
#else
typedef FontType = openfl.text.FontType;
#end
