package openfl.display3D; #if (!display && !flash)


enum Context3DProfile {
	
	BASELINE;
	BASELINE_CONSTRAINED;
	BASELINE_EXTENDED;
	
}


#else


@:fakeEnum(String) extern enum Context3DProfile {
	
	BASELINE;
	BASELINE_CONSTRAINED;
	BASELINE_EXTENDED;
	STANDARD;
	STANDARD_CONSTRAINED;
	
}


#end