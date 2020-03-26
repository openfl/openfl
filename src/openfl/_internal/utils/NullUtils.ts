namespace openfl._internal.utils;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class NullUtils
{
	public static macro valueEquals(a: Expr, b: Expr, type: Expr): Expr
	{
		var typeString = ExprTools.toString(type);

		switch (typeString)
		{
			case "Bool":
				return (macro($a != null && $b != null) ? (cast $a: boolean) == (cast $b: boolean) : ($a == null) && ($b == null));
			case "Int":
				return (macro($a != null && $b != null) ? (cast $a: number) == (cast $b: number) : ($a == null) && ($b == null));
			case "UInt":
				return (macro($a != null && $b != null) ? (cast $a: number) == (cast $b: number) : ($a == null) && ($b == null));
			case "Float":
				return (macro($a != null && $b != null) ? (cast $a: number) == (cast $b: number) : ($a == null) && ($b == null));
			default:
				Context.error("Unsupported type:$typeString", Context.currentPos());
				return macro false;
		}
	}
}
