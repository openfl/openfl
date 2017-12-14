package openfl.geom;


import lime.math.Rectangle in LimeRectangle;
import lime.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class Rectangle {
	
	
	private static var __limeRectangle:LimeRectangle;
	private static var __pool = new ObjectPool<Rectangle> (function () return new Rectangle (), function (r) r.setTo (0, 0, 0, 0));
	
	public var bottom (get, set):Float;
	public var bottomRight (get, set):Point;
	public var height:Float;
	public var left (get, set):Float;
	public var right (get, set):Float;
	public var size (get, set):Point;
	public var top (get, set):Float;
	public var topLeft (get, set):Point;
	public var width:Float;
	public var x:Float;
	public var y:Float;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (Rectangle.prototype, {
			"bottom": { get: untyped __js__ ("function () { return this.get_bottom (); }"), set: untyped __js__ ("function (v) { return this.set_bottom (v); }") },
			"bottomRight": { get: untyped __js__ ("function () { return this.get_bottomRight (); }"), set: untyped __js__ ("function (v) { return this.set_bottomRight (v); }") },
			"left": { get: untyped __js__ ("function () { return this.get_left (); }"), set: untyped __js__ ("function (v) { return this.set_left (v); }") },
			"right": { get: untyped __js__ ("function () { return this.get_right (); }"), set: untyped __js__ ("function (v) { return this.set_right (v); }") },
			"size": { get: untyped __js__ ("function () { return this.get_size (); }"), set: untyped __js__ ("function (v) { return this.set_size (v); }") },
			"top": { get: untyped __js__ ("function () { return this.get_top (); }"), set: untyped __js__ ("function (v) { return this.set_top (v); }") },
			"topLeft": { get: untyped __js__ ("function () { return this.get_topLeft (); }"), set: untyped __js__ ("function (v) { return this.set_topLeft (v); }") },
		});
		
	}
	#end
	
	
	public function new (x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0):Void {
		
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		
	}
	
	
	public function clone ():Rectangle {
		
		return new Rectangle (x, y, width, height);
		
	}
	
	
	public function contains (x:Float, y:Float):Bool {
		
		return x >= this.x && y >= this.y && x < right && y < bottom;
		
	}
	
	
	public function containsPoint (point:Point):Bool {
		
		return contains (point.x, point.y);
		
	}
	
	
	public function containsRect (rect:Rectangle):Bool {
		
		if (rect.width <= 0 || rect.height <= 0) {
			
			return rect.x > x && rect.y > y && rect.right < right && rect.bottom < bottom;
			
		} else {
			
			return rect.x >= x && rect.y >= y && rect.right <= right && rect.bottom <= bottom;
			
		}
		
	}
	
	
	public function copyFrom (sourceRect:Rectangle):Void {
		
		x = sourceRect.x;
		y = sourceRect.y;
		width = sourceRect.width;
		height = sourceRect.height;
		
	}
	
	
	public function equals (toCompare:Rectangle):Bool {
		
		if (toCompare == this) return true;
		else return toCompare != null && x == toCompare.x && y == toCompare.y && width == toCompare.width && height == toCompare.height;
		
	}
	
	
	public function inflate (dx:Float, dy:Float):Void {
		
		x -= dx; width += dx * 2;
		y -= dy; height += dy * 2;
		
	}
	
	
	public function inflatePoint (point:Point):Void {
		
		inflate (point.x, point.y);
		
	}
	
	
	public function intersection (toIntersect:Rectangle):Rectangle {
		
		var x0 = x < toIntersect.x ? toIntersect.x : x;
		var x1 = right > toIntersect.right ? toIntersect.right : right;
		
		if (x1 <= x0) {
			
			return new Rectangle ();
			
		}
		
		var y0 = y < toIntersect.y ? toIntersect.y : y;
		var y1 = bottom > toIntersect.bottom ? toIntersect.bottom : bottom;
		
		if (y1 <= y0) {
			
			return new Rectangle ();
			
		}
		
		return new Rectangle (x0, y0, x1 - x0, y1 - y0);
		
	}
	
	
	public function intersects (toIntersect:Rectangle):Bool {
		
		var x0 = x < toIntersect.x ? toIntersect.x : x;
		var x1 = right > toIntersect.right ? toIntersect.right : right;
		
		if (x1 <= x0) {
			
			return false;
			
		}
		
		var y0 = y < toIntersect.y ? toIntersect.y : y;
		var y1 = bottom > toIntersect.bottom ? toIntersect.bottom : bottom;
		
		return y1 > y0;
		
	}
	
	
	public function isEmpty ():Bool {
		
		return (width <= 0 || height <= 0);
		
	}
	
	
	public function offset (dx:Float, dy:Float):Void {
		
		x += dx;
		y += dy;
		
	}
	
	
	public function offsetPoint (point:Point):Void {
		
		x += point.x;
		y += point.y;
		
	}
	
	
	public function setEmpty ():Void {
		
		x = y = width = height = 0;
		
	}
	
	
	public function setTo (xa:Float, ya:Float, widtha:Float, heighta:Float):Void {
		
		x = xa;
		y = ya;
		width = widtha;
		height = heighta;
		
	}
	
	
	public function toString ():String {
		
		return '(x=$x, y=$y, width=$width, height=$height)';
		
	}
	
	
	public function union (toUnion:Rectangle):Rectangle {
		
		if (width == 0 || height == 0) {
			
			return toUnion.clone ();
			
		} else if (toUnion.width == 0 || toUnion.height == 0) {
			
			return clone ();
			
		}
		
		var x0 = x > toUnion.x ? toUnion.x : x;
		var x1 = right < toUnion.right ? toUnion.right : right;
		var y0 = y > toUnion.y ? toUnion.y : y;
		var y1 = bottom < toUnion.bottom ? toUnion.bottom : bottom;
		
		return new Rectangle (x0, y0, x1 - x0, y1 - y0);
		
	}
	
	
	public function __contract (x:Float, y:Float, width:Float, height:Float):Void {
		
		if (this.width == 0 && this.height == 0) {
			
			return;
			
		}
		
		var offsetX = 0.0;
		var offsetY = 0.0;
		var offsetRight = 0.0;
		var offsetBottom = 0.0;
		
		if (this.x < x) offsetX = x - this.x;
		if (this.y < y) offsetY = y - this.y;
		if (this.right > x + width) offsetRight = (x + width) - this.right;
		if (this.bottom > y + height) offsetBottom = (y + height) - this.bottom;
		
		this.x += offsetX;
		this.y += offsetY;
		this.width += offsetRight - offsetX;
		this.height += offsetBottom - offsetY;
		
	}
	
	
	public function __expand (x:Float, y:Float, width:Float, height:Float):Void {
		
		if (this.width == 0 && this.height == 0) {
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			return;
			
		}
		
		var cacheRight = right;
		var cacheBottom = bottom;
		
		if (this.x > x)
		{
			this.x = x;
			this.width = cacheRight - x;
		}
		if (this.y > y)
		{
			this.y = y;
			this.height = cacheBottom - y;
		}
		if (cacheRight < x + width) this.width = x + width - this.x;
		if (cacheBottom < y + height) this.height = y + height - this.y;
		
	}
	
	
	private function __toLimeRectangle ():LimeRectangle {
		
		if (__limeRectangle == null) {
			
			__limeRectangle = new LimeRectangle ();
			
		}
		
		__limeRectangle.setTo (x, y, width, height);
		return __limeRectangle;
		
	}
	
	
	private function __transform (rect:Rectangle, m:Matrix):Void {
		
		var tx0 = m.a * x + m.c * y;
		var tx1 = tx0;
		var ty0 = m.b * x + m.d * y;
		var ty1 = ty0;
		
		var tx = m.a * (x + width) + m.c * y;
		var ty = m.b * (x + width) + m.d * y;
		
		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;
		
		tx = m.a * (x + width) + m.c * (y + height);
		ty = m.b * (x + width) + m.d * (y + height);
		
		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;
		
		tx = m.a * x + m.c * (y + height);
		ty = m.b * x + m.d * (y + height);
		
		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;
		
		rect.setTo (tx0 + m.tx, ty0 + m.ty, tx1 - tx0, ty1 - ty0);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_bottom ():Float { return y + height; }
	private function set_bottom (b:Float):Float { height = b - y; return b; }
	private function get_bottomRight ():Point { return new Point (x + width, y + height); }
	private function set_bottomRight (p:Point):Point { width = p.x - x; height = p.y - y; return p.clone (); }
	private function get_left ():Float { return x; }
	private function set_left (l:Float):Float { width -= l - x; x = l; return l; }
	private function get_right ():Float { return x + width; }
	private function set_right (r:Float):Float { width = r - x; return r; }
	private function get_size ():Point { return new Point (width, height); }
	private function set_size (p:Point):Point { width = p.x; height = p.y; return p.clone (); }
	private function get_top ():Float { return y; }
	private function set_top (t:Float):Float { height -= t - y; y = t; return t; }
	private function get_topLeft ():Point { return new Point (x, y); }
	private function set_topLeft (p:Point):Point { x = p.x; y = p.y; return p.clone (); }
	
	
}