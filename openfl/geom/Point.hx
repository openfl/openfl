package openfl.geom; #if !flash #if (display || openfl_next || js)


import lime.math.Vector2;


class Point {
	
	
	public var length (get, null):Float;
	public var x:Float;
	public var y:Float;
	
	
	public function new (x:Float = 0, y:Float = 0) {
		
		this.x = x;
		this.y = y;
		
	}
	
	
	public function add (v:Point):Point {
		
		return new Point (v.x + x, v.y + y);
		
	}
	
	
	public function clone ():Point {
		
		return new Point (x, y);
		
	}
	
	
	public static function distance (pt1:Point, pt2:Point):Float {
		
		var dx = pt1.x - pt2.x;
		var dy = pt1.y - pt2.y;
		return Math.sqrt (dx * dx + dy * dy);
		
	}
	
	
	public function equals (toCompare:Point):Bool {
		
		return toCompare != null && toCompare.x == x && toCompare.y == y;
		
	}
	
	
	public static function interpolate (pt1:Point, pt2:Point, f:Float):Point {
		
		return new Point (pt2.x + f * (pt1.x - pt2.x), pt2.y + f * (pt1.y - pt2.y));
		
	}
	
	
	public function normalize (thickness:Float):Void {
		
		if (x == 0 && y == 0) {
			
			return;
			
		} else {
			
			var norm = thickness / Math.sqrt (x * x + y * y);
			x *= norm;
			y *= norm;
			
		}
		
	}
	
	
	public function offset (dx:Float, dy:Float):Void {
		
		x += dx;
		y += dy;
		
	}
	
	
	public static function polar (len:Float, angle:Float):Point {
		
		return new Point (len * Math.cos (angle), len * Math.sin (angle));
		
	}
	
	
	inline public function setTo (xa:Float, ya:Float):Void {	
		
		x = xa;
		y = ya;
	}
	
	
	public function subtract (v:Point):Point {
		
		return new Point (x - v.x, y - v.y);
		
	}
	
	
	public function toString ():String {
		
		return "(x=" + x + ", y=" + y + ")";
		
	}
	
	
	@:noCompletion private function __toLimeVector2 ():Vector2 {
		
		return new Vector2 (x, y);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_length ():Float {
		
		return Math.sqrt (x * x + y * y);
		
	}
	
	
}


#else
typedef Point = openfl._v2.geom.Point;
#end
#else
typedef Point = flash.geom.Point;
#end