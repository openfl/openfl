package openfl.display; #if (!display && !flash) #if !openfl_legacy


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
typedef IGraphicsData = openfl._legacy.display.IGraphicsData;
#end
#else


#if flash
@:native("flash.display.IGraphicsData")
#end

extern interface IGraphicsData {}


#end