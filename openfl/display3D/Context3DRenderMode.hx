package openfl.display3D; #if (!display && !flash)


enum Context3DRenderMode {
	
	AUTO;
	SOFTWARE;
	
}


#else


#if flash
@:native("flash.display3D.Context3DRenderMode")
#end

@:fakeEnum(String) extern enum Context3DRenderMode {
	
	AUTO;
	SOFTWARE;
	
}


#end