package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DProgramType")
#end


@:fakeEnum(String) extern enum Context3DProgramType {
	
	FRAGMENT;
	VERTEX;
	
}