package openfl.utils._internal;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class NullUtils
{
	public static macro function valueEquals(a:Expr, b:Expr, type:Expr):Expr
	{
		var typeString = ExprTools.toString(type);

		switch (typeString)
		{
			case "Bool":
				return (macro($a != null && $b != null) ? (cast $a : Bool) == (cast $b : Bool) : ($a == null) && ($b == null));
			case "Int":
				return (macro($a != null && $b != null) ? (cast $a : Int) == (cast $b : Int) : ($a == null) && ($b == null));
			case "UInt":
				return (macro($a != null && $b != null) ? (cast $a : UInt) == (cast $b : UInt) : ($a == null) && ($b == null));
			case "Float":
				return (macro($a != null && $b != null) ? (cast $a : Float) == (cast $b : Float) : ($a == null) && ($b == null));
			default:
				Context.error("Unsupported type:$typeString", Context.currentPos());
				return macro false;
		}
	}
}
