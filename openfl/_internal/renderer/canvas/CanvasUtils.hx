package openfl._internal.renderer.canvas;


import openfl.geom.ColorTransform;
import openfl.geom.ColorTransform.__with_var_rgba;


class CanvasUtils
{
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
					"rgba(" + r + ", " + g + ", " + b + ", " + input_a + ")"
				);
		}
		else __with_var_rgba(input_rgb, input_a,
			{
				var r:Float = r;
				var g:Float = g;
				var b:Float = b;
				colorTransform.__apply_to_var_rgba();
				
				if (a >= 1)
					"#" + StringTools.hex ((Std.int(r) << 16) | (Std.int(g) << 8) | Std.int(b), 6)
				else
					"rgba(" + r + ", " + g + ", " + b + ", " + a + ")";
			});
	}
}
