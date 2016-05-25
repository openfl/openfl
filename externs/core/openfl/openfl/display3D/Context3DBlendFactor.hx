package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DBlendFactor")
#end


@:fakeEnum(String) extern enum Context3DBlendFactor {
	
	DESTINATION_ALPHA;
	DESTINATION_COLOR;
	ONE;
	ONE_MINUS_DESTINATION_ALPHA;
	ONE_MINUS_DESTINATION_COLOR;
	ONE_MINUS_SOURCE_ALPHA;
	ONE_MINUS_SOURCE_COLOR;
	SOURCE_ALPHA;
	SOURCE_COLOR;
	ZERO;
	
}