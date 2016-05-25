package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DTriangleFace")
#end


@:fakeEnum(String) extern enum Context3DTriangleFace {
	
	BACK;
	FRONT;
	FRONT_AND_BACK;
	NONE;
	
}