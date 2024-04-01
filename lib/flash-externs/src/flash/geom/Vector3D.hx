package flash.geom;

#if flash
extern class Vector3D
{
	#if (haxe_ver < 4.3)
	public static var X_AXIS(default, never):Vector3D;
	public static var Y_AXIS(default, never):Vector3D;
	public static var Z_AXIS(default, never):Vector3D;
	public var length(default, never):Float;
	public var lengthSquared(default, never):Float;
	#else
	static final X_AXIS:Vector3D;
	static final Y_AXIS:Vector3D;
	static final Z_AXIS:Vector3D;
	@:flash.property var length(get, never):Float;
	@:flash.property var lengthSquared(get, never):Float;
	#end
	public var w:Float;
	public var x:Float;
	public var y:Float;
	public var z:Float;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0);
	public function add(a:Vector3D):Vector3D;
	public static function angleBetween(a:Vector3D, b:Vector3D):Float;
	public function clone():Vector3D;
	@:require(flash11) public function copyFrom(sourceVector3D:Vector3D):Void;
	public function crossProduct(a:Vector3D):Vector3D;
	public function decrementBy(a:Vector3D):Void;
	public static function distance(pt1:Vector3D, pt2:Vector3D):Float;
	public function dotProduct(a:Vector3D):Float;
	public function equals(toCompare:Vector3D, allFour:Bool = false):Bool;
	public function incrementBy(a:Vector3D):Void;
	public function nearEquals(toCompare:Vector3D, tolerance:Float, ?allFour:Bool = false):Bool;
	public function negate():Void;
	public function normalize():Float;
	public function project():Void;
	public function scaleBy(s:Float):Void;
	@:require(flash11) public function setTo(xa:Float, ya:Float, za:Float):Void;
	public function subtract(a:Vector3D):Vector3D;
	public function toString():String;

	#if (haxe_ver >= 4.3)
	private function get_length():Float;
	private function get_lengthSquared():Float;
	#end
}
#else
typedef Vector3D = openfl.geom.Vector3D;
#end
