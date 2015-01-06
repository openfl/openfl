package openfl.display3D; #if !flash


enum Context3DRenderMode {
	
	AUTO;
	SOFTWARE;
	
}


#else
typedef Context3DRenderMode = flash.display3D.Context3DRenderMode;
#end