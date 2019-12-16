package flash.text;

#if flash
@:enum abstract TextFieldType(String) from String to String
{
	public var DYNAMIC = "dynamic";
	public var INPUT = "input";
}
#else
typedef TextFieldType = openfl.text.TextFieldType;
#end
