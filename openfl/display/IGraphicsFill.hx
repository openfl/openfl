package openfl.display; #if !flash #if !lime_legacy


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
typedef IGraphicsFill = openfl._v2.display.IGraphicsFill;
#end
#else
typedef IGraphicsFill = flash.display.IGraphicsFill;
#end