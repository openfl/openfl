package flash.geom;

#if flash
extern class Point
{
	#if (haxe_ver < 4.3)
	public var length(default, never):Float;
	#else
	@:flash.property var length(get, never):Float;
	#end

	public var x:Float;
	public var y:Float;
	public function new(x:Float = 0, y:Float = 0);
	public function add(v:Point):Point;
	public function clone():Point;
	@:require(flash11) public function copyFrom(sourcePoint:Point):Void;
	public static function distance(pt1:Point, pt2:Point):Float;
	public function equals(toCompare:Point):Bool;
	public static function interpolate(pt1:Point, pt2:Point, f:Float):Point;
	public function normalize(thickness:Float):Void;
	public function offset(dx:Float, dy:Float):Void;
	public static function polar(len:Float, angle:Float):Point;
	@:require(flash11) public function setTo(xa:Float, ya:Float):Void;
	public function subtract(v:Point):Point;
	public function toString():String;

	#if (haxe_ver >= 4.3)
	private function get_length():Float;
	#end
}
#else
typedef Point = openfl.geom.Point;
#end
