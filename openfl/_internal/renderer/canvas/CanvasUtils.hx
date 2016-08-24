package openfl._internal.renderer.canvas;


import openfl.geom.ColorTransform;
import openfl.geom.ColorTransform.__with_var_rgba;


class CanvasUtils
{
	public static inline function rgbaString(r : Float, g : Float, b : Float, a : Float) : String
	{
		var r = Std.int(r);
		var g = Std.int(g);
		var b = Std.int(b);

		return if (a >= 1)
			"#" + StringTools.hex ((r << 16) | (g << 8) | b, 6)
		else
			"rgba(" + r + ", " + g + ", " + b + ", " + a + ")";
	}

	public static inline function rgbaStyle(colorTransform : ColorTransform, input_rgb : Int, input_a : Float) : String
	{
		return if (colorTransform == null)
		{
			if (input_a >= 1)
			{
				"#" + StringTools.hex (input_rgb, 6);
			}
			else
				__with_var_rgba(input_rgb, input_a,
					rgbaString(r,g,b, input_a)
				);
		}
		else __with_var_rgba(input_rgb, input_a,
			{
				var r:Float = r;
				var g:Float = g;
				var b:Float = b;
				colorTransform.__apply_to_var_rgba();
				
				rgbaString(r,g,b,a);
			});
	}
}
