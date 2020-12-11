package openfl.events;

/**
	The EventType abstract type provides type safety when
	matching dispatch events with the correct type of listener

	For example, the following code has the wrong type in the
	event listener, it should be a MouseEvent:

	```haxe
	addEventListener(MouseEvent.CLICK, function(event:TouchEvent) {});
	```

	OpenFL uses the EventType abstract for standard event types
	to turn these logical errors into a compile-time errors.
**/
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
