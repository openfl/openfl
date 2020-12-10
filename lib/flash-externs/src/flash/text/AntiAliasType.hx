package flash.text;

#if flash
@:enum abstract AntiAliasType(String) from String to String
{
	public var ADVANCED = "advanced";
	public var NORMAL = "normal";
}
#else
typedef AntiAliasType = openfl.text.AntiAliasType;
#end
