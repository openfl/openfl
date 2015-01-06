package openfl.display3D; #if !flash


enum Context3DWrapMode {
	
	CLAMP;
	REPEAT;
	
}


#else
typedef Context3DWrapMode = flash.display3D.Context3DWrapMode;
#end