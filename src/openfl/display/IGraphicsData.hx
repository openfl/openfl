package openfl.display;


interface IGraphicsData {
	
	var __graphicsDataType (default, null):GraphicsDataType;
	
}


@:enum abstract GraphicsDataType(Int) {

	var STROKE = 0;
	var SOLID = 1;
	var GRADIENT = 2;
	var PATH = 3;
	var BITMAP = 4;
	var END = 5;
	var TRIANGLE_PATH = 6;

}