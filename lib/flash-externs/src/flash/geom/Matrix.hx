package flash.geom;

#if flash
extern class Matrix
{
	public var a:Float;
	public var b:Float;
	public var c:Float;
	public var d:Float;
	public var tx:Float;
	public var ty:Float;
	public function new(a:Float = 1, b:Float = 0, c:Float = 0, d:Float = 1, tx:Float = 0, ty:Float = 0);
	public function clone():Matrix;
	public function concat(m:Matrix):Void;
	@:require(flash11) public function copyColumnFrom(column:Int, vector3D:Vector3D):Void;
	@:require(flash11) public function copyColumnTo(column:Int, vector3D:Vector3D):Void;
	@:require(flash11) public function copyFrom(sourceMatrix:Matrix):Void;
	@:require(flash11) public function copyRowFrom(row:Int, vector3D:Vector3D):Void;
	@:require(flash11) public function copyRowTo(row:Int, vector3D:Vector3D):Void;
	public function createBox(scaleX:Float, scaleY:Float, rotation:Float = 0, tx:Float = 0, ty:Float = 0):Void;
	public function createGradientBox(width:Float, height:Float, rotation:Float = 0, tx:Float = 0, ty:Float = 0):Void;
	public function deltaTransformPoint(point:Point):Point;
	public function identity():Void;
	public function invert():Matrix;
	public function rotate(theta:Float):Void;
	public function scale(sx:Float, sy:Float):Void;
	@:require(flash11) public function setTo(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void;
	public function toString():String;
	public function transformPoint(pos:Point):Point;
	public function translate(dx:Float, dy:Float):Void;
}
#else
typedef Matrix = openfl.geom.Matrix;
#end
