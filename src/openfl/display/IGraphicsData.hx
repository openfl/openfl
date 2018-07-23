package openfl.display; #if !flash


interface IGraphicsData {
	
	@:noCompletion private var __graphicsDataType (default, null):GraphicsDataType;
	
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


#else
typedef IGraphicsData = flash.display.IGraphicsData;
#end