package openfl.display;


interface IGraphicsData {
	
	var __graphicsDataType (default, null):GraphicsDataType;
	
}


@:dox(hide) @:fakeEnum(Int) enum GraphicsDataType {
	
	STROKE;
	SOLID;
	GRADIENT;
	PATH;
	BITMAP;
	END;
	QUAD_PATH;
	TRIANGLE_PATH;
	SHADER;
	
}