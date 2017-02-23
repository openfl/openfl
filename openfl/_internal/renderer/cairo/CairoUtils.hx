package openfl._internal.renderer.cairo;


import haxe.macro.Expr;
import openfl.geom.ColorTransform;


class CairoUtils
{
	public static inline var scale = 1/0xFF;

	public static macro function applyColorTransform(colorTransform : ExprOf<ColorTransform>, rgb : ExprOf<Int>, a : ExprOf<Float>, rgbaExpr : Expr) : Expr
	{
		return macro ColorTransform.__with_var_rgba($rgb, $a,
			{
				var r:Float = r;
				var g:Float = g;
				var b:Float = b;
				
				if ($colorTransform != null)
					colorTransform.__apply_to_var_rgba();
				
				r *= CairoUtils.scale;
				g *= CairoUtils.scale;
				b *= CairoUtils.scale;
				$rgbaExpr;
			}
		);
	}
}
