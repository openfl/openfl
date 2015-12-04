package openfl.geom; #if (!display && !flash)


enum Orientation3D {
	
	AXIS_ANGLE;
	EULER_ANGLES;
	QUATERNION;
	
}


#else


@:fakeEnum(String) extern enum Orientation3D {
	
	AXIS_ANGLE;
	EULER_ANGLES;
	QUATERNION;
	
}


#end