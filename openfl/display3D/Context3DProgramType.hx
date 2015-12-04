package openfl.display3D; #if (!display && !flash)


import openfl.gl.GL;


enum Context3DProgramType {
	
	VERTEX;
	FRAGMENT;
	
}


#else


#if flash
@:native("flash.display3D.Context3DProgramType")
#end

@:fakeEnum(String) extern enum Context3DProgramType {
	
	FRAGMENT;
	VERTEX;
	
}


#end