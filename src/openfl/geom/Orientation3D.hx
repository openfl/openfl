package openfl.geom; #if !openfljs


@:enum abstract Orientation3D(Null<Int>) {
	
	public var AXIS_ANGLE = 0;
	public var EULER_ANGLES = 1;
	public var QUATERNION = 2;
	
	@:from private static function fromString (value:String):Orientation3D {
		
		return switch (value) {
			
			case "axisAngle": AXIS_ANGLE;
			case "eulerAngles": EULER_ANGLES;
			case "quaternion": QUATERNION;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Orientation3D.AXIS_ANGLE: "axisAngle";
			case Orientation3D.EULER_ANGLES: "eulerAngles";
			case Orientation3D.QUATERNION: "quaternion";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract Orientation3D(String) from String to String {
	
	public var AXIS_ANGLE = "axisAngle";
	public var EULER_ANGLES = "eulerAngles";
	public var QUATERNION = "quaternion";
	
}


#end