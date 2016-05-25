package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DStencilAction")
#end


@:fakeEnum(String) extern enum Context3DStencilAction {
	
	DECREMENT_SATURATE;
	DECREMENT_WRAP;
	INCREMENT_SATURATE;
	INCREMENT_WRAP;
	INVERT;
	KEEP;
	SET;
	ZERO;
	
}