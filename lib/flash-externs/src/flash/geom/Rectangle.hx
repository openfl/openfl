package flash.geom;

#if flash
extern class Rectangle
{
	#if (haxe_ver < 4.3)
	public var bottom:Float;
	public var bottomRight:Point;
	public var left:Float;
	public var right:Float;
	public var size:Point;
	public var top:Float;
	public var topLeft:Point;
	#else
	@:flash.property var bottom(get, set):Float;
	@:flash.property var bottomRight(get, set):Point;
	@:flash.property var left(get, set):Float;
	@:flash.property var right(get, set):Float;
	@:flash.property var size(get, set):Point;
	@:flash.property var top(get, set):Float;
	@:flash.property var topLeft(get, set):Point;
	#end

	public var height:Float;
	public var width:Float;
	public var x:Float;
	public var y:Float;
	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0):Void;
	public function clone():Rectangle;
	public function contains(x:Float, y:Float):Bool;
	public function containsPoint(point:Point):Bool;
	public function containsRect(rect:Rectangle):Bool;
	@:require(flash11) public function copyFrom(sourceRect:Rectangle):Void;
	public function equals(toCompare:Rectangle):Bool;
	public function inflate(dx:Float, dy:Float):Void;
	public function inflatePoint(point:Point):Void;
	public function intersection(toIntersect:Rectangle):Rectangle;
	public function intersects(toIntersect:Rectangle):Bool;
	public function isEmpty():Bool;
	public function offset(dx:Float, dy:Float):Void;
	public function offsetPoint(point:Point):Void;
	public function setEmpty():Void;
	@:require(flash11) public function setTo(xa:Float, ya:Float, widtha:Float, heighta:Float):Void;
	public function toString():String;
	public function union(toUnion:Rectangle):Rectangle;

	#if (haxe_ver >= 4.3)
	private function get_bottom():Float;
	private function get_bottomRight():Point;
	private function get_left():Float;
	private function get_right():Float;
	private function get_size():Point;
	private function get_top():Float;
	private function get_topLeft():Point;
	private function set_bottom(value:Float):Float;
	private function set_bottomRight(value:Point):Point;
	private function set_left(value:Float):Float;
	private function set_right(value:Float):Float;
	private function set_size(value:Point):Point;
	private function set_top(value:Float):Float;
	private function set_topLeft(value:Point):Point;
	#end
}
#else
typedef Rectangle = openfl.geom.Rectangle;
#end
