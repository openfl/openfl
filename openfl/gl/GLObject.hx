package openfl.gl;
#if display


extern class GLObject {
	
	var id(default, null):Dynamic;
	var invalidated(get_invalidated, null):Bool;
	var valid(get_valid, null):Bool;
	
	function new(inVersion:Int, inId:Dynamic):Void;
	function getType():String;
	function invalidate():Void;
	function toString():String;
	function isValid():Bool;
	function isInvalid():Bool;
	
}


#end