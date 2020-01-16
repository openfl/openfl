package openfl._internal.backend.dummy;

class DummySystemBackend
{
	public static function exit(code:Int):Void {}

	public static function gc():Void {}

	public static function getTotalMemory():Int
	{
		return 0;
	}
}
