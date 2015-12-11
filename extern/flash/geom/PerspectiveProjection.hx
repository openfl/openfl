package flash.geom; #if (!display && flash)


extern class PerspectiveProjection {
	
	
	public static inline var TO_RADIAN:Float = 0.01745329251994329577; // Math.PI / 180
	
	public var fieldOfView (default, set_fieldOfView):Float;
	public var focalLength:Float;
	public var projectionCenter:Point; // FIXME: does this do anything at all?
	
	private var matrix3D:Matrix3D;
	
	
	public function new ();
	
	
	public function toMatrix3D ():Matrix3D;
	
	
}


#else
typedef PerspectiveProjection = openfl.geom.PerspectiveProjection;
#end