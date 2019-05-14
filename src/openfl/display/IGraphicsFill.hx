package openfl.display;


interface IGraphicsFill {
	
	var __graphicsFillType (default, null):GraphicsFillType;
	
}


@:enum abstract GraphicsFillType(Int) {

	var SOLID_FILL = 0;
	var GRADIENT_FILL = 1;
	var BITMAP_FILL = 2;
	var END_FILL = 3;

}