package openfl.ui;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Keyboard
{
	public static var capsLock:Bool;
	public static var numLock:Bool;

	public static function isAccessible():Bool
	{
		// default browser security restrictions are always enforced
		return false;
	}
}
