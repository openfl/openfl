package openfl.display; #if !flash


interface IGraphicsData {
	
	var __graphicsDataType (default, null):GraphicsDataType;
	
}


@:fakeEnum(Int) enum GraphicsDataType {
	
	STROKE;
	SOLID;
	GRADIENT;
	PATH;
	BITMAP;
	END;
	
}


#else
typedef IGraphicsData = flash.display.IGraphicsData;
#end