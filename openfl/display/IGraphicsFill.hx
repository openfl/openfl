package openfl.display; #if !flash


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
typedef IGraphicsFill = flash.display.IGraphicsFill;
#end