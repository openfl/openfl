package openfl.geom; #if (!display && !flash)


enum Orientation3D {
	
	AXIS_ANGLE;
	EULER_ANGLES;
	QUATERNION;
	
}


#else


#if flash
@:native("flash.geom.Orientation3D")
#end


@:fakeEnum(String) extern enum Orientation3D {
	
	AXIS_ANGLE;
	EULER_ANGLES;
	QUATERNION;
	
}


#end