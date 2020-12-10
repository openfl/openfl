package flash.geom;

#if flash
@:require(flash10) extern class PerspectiveProjection
{
	public var fieldOfView:Float;
	public var focalLength:Float;
	public var projectionCenter:Point;
	public function new();
	public function toMatrix3D():Matrix3D;
}
#else
typedef PerspectiveProjection = openfl.geom.PerspectiveProjection;
#end
