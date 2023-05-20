package flash.text;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract AntiAliasType(String) from String to String

{
	public var ADVANCED = "advanced";
	public var NORMAL = "normal";
}
#else
typedef AntiAliasType = openfl.text.AntiAliasType;
#end
