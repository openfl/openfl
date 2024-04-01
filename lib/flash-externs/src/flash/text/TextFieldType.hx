package flash.text;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract TextFieldType(String) from String to String

{
	public var DYNAMIC = "dynamic";
	public var INPUT = "input";
}
#else
typedef TextFieldType = openfl.text.TextFieldType;
#end
