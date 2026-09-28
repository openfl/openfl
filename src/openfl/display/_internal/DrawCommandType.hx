package openfl.display._internal;

#if !flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract DrawCommandType(Int)

{
	var BEGIN_BITMAP_FILL;
	var BEGIN_FILL;
	var BEGIN_GRADIENT_FILL;
	var BEGIN_SHADER_FILL;
	var CUBIC_CURVE_TO;
	var CURVE_TO;
	var DRAW_CIRCLE;
	var DRAW_ELLIPSE;
	var DRAW_QUADS;
	var DRAW_RECT;
	var DRAW_ROUND_RECT;
	var DRAW_TILES;
	var DRAW_TRIANGLES;
	var END_FILL;
	var LINE_BITMAP_STYLE;
	var LINE_GRADIENT_STYLE;
	var LINE_STYLE;
	var LINE_TO;
	var MOVE_TO;
	var OVERRIDE_BLEND_MODE;
	var OVERRIDE_MATRIX;
	var WINDING_EVEN_ODD;
	var WINDING_NON_ZERO;
	var UNKNOWN;
}
#end
