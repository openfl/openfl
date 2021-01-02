package flash.geom;

#if flash
import openfl.display.DisplayObject;

extern class Transform
{
	public var colorTransform:ColorTransform;
	public var concatenatedColorTransform(default, never):ColorTransform;
	public var concatenatedMatrix(default, never):Matrix;
	public var matrix:Matrix;
	@:require(flash10) public var matrix3D:Matrix3D;
	#if flash
	@:require(flash10) public var perspectiveProjection:PerspectiveProjection;
	#end
	public var pixelBounds(default, never):Rectangle;
	public function new(displayObject:DisplayObject);
	#if flash
	@:require(flash10) public function getRelativeMatrix3D(relativeTo:DisplayObject):Matrix3D;
	#end
}
#else
typedef Transform = openfl.geom.Transform;
#end
