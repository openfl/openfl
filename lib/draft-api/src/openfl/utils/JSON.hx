package openfl.utils;

import haxe.Json;

@:transitive
@:forward
abstract JSON(Object) from Object to Object
{
	public function new()
	{
		this = {};
	}

	public static function decode(data:String):JSON
	{
		return Json.parse(data);
	}

	public static function encode(json:JSON):String
	{
		return Json.stringify(json);
	}
}
