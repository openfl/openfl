package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DRenderMode")
#end


@:fakeEnum(String) extern enum Context3DRenderMode {
	
	AUTO;
	SOFTWARE;
	
}