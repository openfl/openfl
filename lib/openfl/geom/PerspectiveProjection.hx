package openfl.geom;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/geom/PerspectiveProjection", "default")
#end
extern class PerspectiveProjection
{
	// public static inline var TO_RADIAN:Float = 0.01745329251994329577; // Math.PI / 180
	public var fieldOfView(default, set_fieldOfView):Float;
	public var focalLength:Float;
	public var projectionCenter:Point;
	public function new();
	public function toMatrix3D():Matrix3D;
	private function set_fieldOfView(value:Float):Float;
}
#else
typedef PerspectiveProjection = flash.geom.PerspectiveProjection;
#end
