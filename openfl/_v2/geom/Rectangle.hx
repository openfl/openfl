package openfl._v2.geom; #if lime_legacy


class Rectangle {
	
	
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
		
		return x == toCompare.x && y == toCompare.y && width == toCompare.width && height == toCompare.height;
		
	}
	
	
	public function extendBounds (r:Rectangle) {
		
		var dx = x - r.x;
		if (dx > 0) {
			
			x -= dx;
			width += dx;
			
		}

		var dy = y - r.y;
		if (dy > 0) {
			
			y -= dy;
			height += dy;
			
		}
		
		if (r.right > right) {
			
			right = r.right;
			
		}
		
		if (r.bottom > bottom) {
			
			bottom = r.bottom;
			
		}
		
	}
	
	
	public function inflate (dx:Float, dy:Float):Void {
		
		x -= dx;
		y -= dy;
		width += dx * 2;
		height += dy * 2;
		
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
		
		x = 0;
		y = 0;
		width = 0;
		height = 0;
		
	}
	
	
	public function setTo (xa:Float, ya:Float, widtha:Float, heighta:Float):Void {
		
		x = xa;
		y = ya;
		width = widtha;
		height = heighta;
		
	}
	
	
	public function toString ():String {
		
		return "(x=" + x + ", y=" + y + ", width=" + width + ", height=" + height + ")";
		
	}
	
	
	public function transform (m:Matrix):Rectangle {
		
		var tx0 = m.a * x + m.c * y;
		var tx1 = tx0;
		var ty0 = m.b * x + m.d * y;
		var ty1 = tx0;
		
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
		
		return new Rectangle (tx0 + m.tx, ty0 + m.ty, tx1 - tx0, ty1 - ty0);
		
	}
	
	
	public function union (toUnion:Rectangle):Rectangle {
		
		var x0 = x > toUnion.x ? toUnion.x : x;
		var x1 = right < toUnion.right ? toUnion.right : right;
		var y0 = y > toUnion.y ? toUnion.y : y;
		var y1 = bottom < toUnion.bottom ? toUnion.bottom : bottom;
		return new Rectangle (x0, y0, x1 - x0, y1 - y0);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_bottom () { return y + height; }
	private function set_bottom (value:Float) { height = value - y; return value; }
	private function get_bottomRight () { return new Point (x + width, y + height); }
	private function set_bottomRight (value:Point) { width = value.x - x; height = value.y - y; return value.clone (); }
	private function get_left () { return x; }
	private function set_left (value:Float) { width -= value - x; x = value; return value; }
	private function get_right () { return x + width; }
	private function set_right (value:Float) { width = value - x; return value; }
	private function get_size () { return new Point (width, height); }
	private function set_size (value:Point) { width = value.x; height = value.y; return value.clone (); }
	private function get_top () { return y; }
	private function set_top (value:Float) { height -= value - y; y = value; return value; }
	private function get_topLeft () { return new Point (x, y); }
	private function set_topLeft (value:Point) { x = value.x; y = value.y; return value.clone (); }
	
	
}


#end