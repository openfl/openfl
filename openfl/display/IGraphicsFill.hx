package openfl.display; #if (!display && !flash) #if !openfl_legacy


interface IGraphicsFill {
	
	var __graphicsFillType (default, null):GraphicsFillType;
	
}


@:fakeEnum(Int) enum GraphicsFillType {
	
	SOLID_FILL;
	GRADIENT_FILL;
	BITMAP_FILL;
	END_FILL;
	
}


#else
typedef IGraphicsFill = openfl._legacy.display.IGraphicsFill;
#end
#else


#if flash
@:native("flash.display.IGraphicsFill")
#end

extern interface IGraphicsFill {}


#end