package openfl.display;


interface IGraphicsFill {
	
	var __graphicsFillType (default, null):GraphicsFillType;
	
}


@:fakeEnum(Int) enum GraphicsFillType {
	
	SOLID_FILL;
	GRADIENT_FILL;
	BITMAP_FILL;
	END_FILL;
	
}