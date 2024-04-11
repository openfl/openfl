package flash.text;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract FontType(String) from String to String

{
	public var DEVICE = "device";
	public var EMBEDDED = "embedded";
	public var EMBEDDED_CFF = "embeddedCFF";
}
#else
typedef FontType = openfl.text.FontType;
#end
