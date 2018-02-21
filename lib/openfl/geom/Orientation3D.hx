package openfl.geom;


@:enum abstract Orientation3D(String) from String to String {
	
	public var AXIS_ANGLE = "axisAngle";
	public var EULER_ANGLES = "eulerAngles";
	public var QUATERNION = "quaternion";
	
}