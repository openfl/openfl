package flash.geom;

#if flash
@:require(flash10) extern class PerspectiveProjection
{
	#if (haxe_ver < 4.3)
	public var fieldOfView:Float;
	public var focalLength:Float;
	public var projectionCenter:Point;
	#else
	@:flash.property var fieldOfView(get, set):Float;
	@:flash.property var focalLength(get, set):Float;
	@:flash.property var projectionCenter(get, set):Point;
	#end

	public function new();
	public function toMatrix3D():Matrix3D;

	#if (haxe_ver >= 4.3)
	private function get_fieldOfView():Float;
	private function get_focalLength():Float;
	private function get_projectionCenter():Point;
	private function set_fieldOfView(value:Float):Float;
	private function set_focalLength(value:Float):Float;
	private function set_projectionCenter(value:Point):Point;
	#end
}
#else
typedef PerspectiveProjection = openfl.geom.PerspectiveProjection;
#end
