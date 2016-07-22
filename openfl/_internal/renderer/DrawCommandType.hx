package openfl._internal.renderer;


@:enum abstract DrawCommandType (Int) {
	
	var BEGIN_BITMAP_FILL   =  0;
	var BEGIN_FILL          =  1;
	var BEGIN_GRADIENT_FILL =  2;
	var CUBIC_CURVE_TO      =  3;
	var CURVE_TO            =  4;
	var DRAW_CIRCLE         =  5;
	var DRAW_ELLIPSE        =  6;
	var DRAW_RECT           =  7;
	var DRAW_ROUND_RECT     =  8;
	var DRAW_TILES          =  9;
	var DRAW_TRIANGLES      = 10;
	var END_FILL            = 11;
	var LINE_BITMAP_STYLE   = 12;
	var LINE_GRADIENT_STYLE = 13;
	var LINE_STYLE          = 14;
	var LINE_TO             = 15;
	var MOVE_TO             = 16;
	var OVERRIDE_MATRIX     = 17;
	var UNKNOWN             = 18;
	
}
