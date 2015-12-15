package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DProfile")
#end


@:fakeEnum(String) extern enum Context3DProfile {
	
	BASELINE;
	BASELINE_CONSTRAINED;
	BASELINE_EXTENDED;
	STANDARD;
	STANDARD_CONSTRAINED;
	
}