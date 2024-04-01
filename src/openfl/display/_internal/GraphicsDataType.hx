package openfl.display._internal;

@:dox(hide) #if (haxe_ver >= 4.0) enum #else @:enum #end abstract GraphicsDataType(Int)

{
	var STROKE = 0;
	var SOLID = 1;
	var GRADIENT = 2;
	var PATH = 3;
	var BITMAP = 4;
	var END = 5;
	var QUAD_PATH = 6;
	var TRIANGLE_PATH = 7;
	var SHADER = 8;
}
