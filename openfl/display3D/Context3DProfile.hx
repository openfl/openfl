package openfl.display3D; #if !flash


enum Context3DProfile {
	
	BASELINE;
	BASELINE_CONSTRAINED;
	BASELINE_EXTENDED;
	
}


#else
typedef Context3DProfile = flash.display3D.Context3DProfile;
#end