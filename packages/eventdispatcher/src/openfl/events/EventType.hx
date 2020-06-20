package openfl.events;

abstract EventType<T>(String) from String to String
{
	@:op(A == B) private static inline function equals<T>(a:EventType<T>, b:String):Bool
	{
		return (a : String) == b;
	}

	@:op(A != B) private static inline function notEquals<T>(a:EventType<T>, b:String):Bool
	{
		return (a : String) != b;
	}
}
