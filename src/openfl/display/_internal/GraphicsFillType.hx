package openfl.display._internal;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract GraphicsFillType(Int)

{
	var SOLID_FILL = 0;
	var GRADIENT_FILL = 1;
	var BITMAP_FILL = 2;
	var END_FILL = 3;
	var SHADER_FILL = 4;
}
