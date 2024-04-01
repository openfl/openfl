package flash.geom;

#if flash
import openfl.display.DisplayObject;

extern class Transform
{
	#if (haxe_ver < 4.3)
	public var colorTransform:ColorTransform;
	public var concatenatedColorTransform(default, never):ColorTransform;
	public var concatenatedMatrix(default, never):Matrix;
	public var matrix:Matrix;
	@:require(flash10) public var matrix3D:Matrix3D;
	@:require(flash10) public var perspectiveProjection:PerspectiveProjection;
	public var pixelBounds(default, never):Rectangle;
	#else
	@:flash.property var colorTransform(get, set):ColorTransform;
	@:flash.property var concatenatedColorTransform(get, never):ColorTransform;
	@:flash.property var concatenatedMatrix(get, never):Matrix;
	@:flash.property var matrix(get, set):Matrix;
	@:flash.property @:require(flash10) var matrix3D(get, set):Matrix3D;
	@:flash.property @:require(flash10) var perspectiveProjection(get, set):PerspectiveProjection;
	@:flash.property var pixelBounds(get, never):Rectangle;
	#end

	public function new(displayObject:DisplayObject);
	@:require(flash10) public function getRelativeMatrix3D(relativeTo:DisplayObject):Matrix3D;

	#if (haxe_ver >= 4.3)
	private function get_colorTransform():ColorTransform;
	private function get_concatenatedColorTransform():ColorTransform;
	private function get_concatenatedMatrix():Matrix;
	private function get_matrix():Matrix;
	private function get_matrix3D():Matrix3D;
	private function get_perspectiveProjection():PerspectiveProjection;
	private function get_pixelBounds():Rectangle;
	private function set_colorTransform(value:ColorTransform):ColorTransform;
	private function set_matrix(value:Matrix):Matrix;
	private function set_matrix3D(value:Matrix3D):Matrix3D;
	private function set_perspectiveProjection(value:PerspectiveProjection):PerspectiveProjection;
	#end
}
#else
typedef Transform = openfl.geom.Transform;
#end
