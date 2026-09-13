package openfl.utils._internal;

#if cs

import haxe.macro.Expr;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class NullUtils
{
	public static macro function boolEquals(a:Expr, b:Expr):Expr
	{
		return macro $a == null ? $b == null : $b != null && (cast $a : Bool) == (cast $b : Bool);
	}

	public static macro function intEquals(a:Expr, b:Expr):Expr
	{
		return macro $a == null ? $b == null : $b != null && (cast $a : Int) == (cast $b : Int);
	}

	public static macro function uintEquals(a:Expr, b:Expr):Expr
	{
		return macro $a == null ? $b == null : $b != null && (cast $a : UInt) == (cast $b : UInt);
	}

	public static macro function floatEquals(a:Expr, b:Expr):Expr
	{
		return macro $a == null ? $b == null : $b != null && (cast $a : Float) == (cast $b : Float);
	}
}

#end
