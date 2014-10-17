package openfl.geom; #if !flash


enum Orientation3D {
	
	AXIS_ANGLE;
	EULER_ANGLES;
	QUATERNION;
	
}


#else
typedef Orientation3D = flash.geom.Orientation3D;
#end