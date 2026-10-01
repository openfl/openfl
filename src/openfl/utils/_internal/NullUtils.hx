package openfl.utils._internal;

#if cs

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class NullUtils
{
	public static inline function boolEquals(a:Null<Bool>, b:Null<Bool>):Bool
	{
		return a == null ? b == null : b != null && (cast a : Bool) == (cast b : Bool);
	}

	public static inline function intEquals(a:Null<Int>, b:Null<Int>):Bool
	{
		return a == null ? b == null : b != null && (cast a : Int) == (cast b : Int);
	}

	public static inline function uintEquals(a:Null<UInt>, b:Null<UInt>):Bool
	{
		return a == null ? b == null : b != null && (cast a : UInt) == (cast b : UInt);
	}

	public static inline function floatEquals(a:Null<Float>, b:Null<Float>):Bool
	{
		return a == null ? b == null : b != null && (cast a : Float) == (cast b : Float);
	}
}

#end
