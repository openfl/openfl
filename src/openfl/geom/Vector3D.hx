package openfl.geom;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class Vector3D {
	
	
	public static var X_AXIS (get, never):Vector3D;
	public static var Y_AXIS (get, never):Vector3D;
	public static var Z_AXIS (get, never):Vector3D;
	
	public var length (get, never):Float;
	public var lengthSquared (get, never):Float;
	public var w:Float;
	public var x:Float;
	public var y:Float;
	public var z:Float;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (Vector3D, {
			"X_AXIS": { get: function () { return Vector3D.get_X_AXIS (); } },
			"Y_AXIS": { get: function () { return Vector3D.get_Y_AXIS (); } },
			"Z_AXIS": { get: function () { return Vector3D.get_Z_AXIS (); } }
		});
		
		untyped Object.defineProperties (Vector3D.prototype, {
			"length": { get: untyped __js__ ("function () { return this.get_length (); }") },
			"lengthSquared": { get: untyped __js__ ("function () { return this.get_lengthSquared (); }") },
		});
		
	}
	#end
	
	
	public function new (x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0) {
		
		this.w = w;
		this.x = x;
		this.y = y;
		this.z = z;
		
	}
	
	
	public function add (a:Vector3D):Vector3D {
		
		return new Vector3D (this.x + a.x, this.y + a.y, this.z + a.z);
		
	}
	
	
	public static function angleBetween (a:Vector3D, b:Vector3D):Float {
		
		var la = a.length;
		var lb = b.length;
		var dot = a.dotProduct (b);
		
		if (la != 0) {
			
			dot /= la;
			
		}
		
		if (lb != 0) {
			
			dot /= lb;
			
		}
		
		return Math.acos (dot);
		
	}
	
	
	public function clone ():Vector3D {
		
		return new Vector3D (x, y, z, w);
		
	}
	
	
	public function copyFrom (sourceVector3D:Vector3D):Void {
		
		x = sourceVector3D.x;
		y = sourceVector3D.y;
		z = sourceVector3D.z;
		
	}
	
	
	public function crossProduct (a:Vector3D):Vector3D {
		
		return new Vector3D (y * a.z - z * a.y, z * a.x - x * a.z, x * a.y - y * a.x, 1);
		
	}
	
	
	public function decrementBy (a:Vector3D):Void {
		
		x -= a.x;
		y -= a.y;
		z -= a.z;
		
	}
	
	
	public static function distance (pt1:Vector3D, pt2:Vector3D):Float {
		
		var x:Float = pt2.x - pt1.x;
		var y:Float = pt2.y - pt1.y;
		var z:Float = pt2.z - pt1.z;
		
		return Math.sqrt (x * x + y * y + z * z);
		
	}
	
	
	public function dotProduct (a:Vector3D):Float {
		
		return x * a.x + y * a.y + z * a.z;
		
	}
	
	
	public function equals (toCompare:Vector3D, allFour:Bool = false):Bool {
		
		return x == toCompare.x && y == toCompare.y && z == toCompare.z && (!allFour || w == toCompare.w);
		
	}
	
	
	public function incrementBy (a:Vector3D):Void {
		
		x += a.x;
		y += a.y;
		z += a.z;
		
	}
	
	
	public function nearEquals (toCompare:Vector3D, tolerance:Float, ?allFour:Bool = false):Bool {
		
		return Math.abs (x - toCompare.x) < tolerance && Math.abs (y - toCompare.y) < tolerance && Math.abs (z - toCompare.z) < tolerance && (!allFour || Math.abs (w - toCompare.w) < tolerance);
		
	}
	
	
	public function negate ():Void {
		
		x *= -1;
		y *= -1;
		z *= -1;
		
	}
	
	
	public function normalize ():Float {
		
		var l = length;
		
		if (l != 0) {
			
			x /= l;
			y /= l;
			z /= l;
			
		}
		
		return l;
		
	}
	
	
	public function project ():Void {
		
		x /= w;
		y /= w;
		z /= w;
		
	}
	
	
	public function scaleBy (s:Float):Void {
		
		x *= s;
		y *= s;
		z *= s;
		
	}
	
	
	public function setTo (xa:Float, ya:Float, za:Float):Void {
		
		x = xa;
		y = ya;
		z = za;
		
	}
	
	
	public function subtract (a:Vector3D):Vector3D {
		
		return new Vector3D (x - a.x, y - a.y, z - a.z);
		
	}
	
	
	public function toString ():String {
		
		return 'Vector3D($x, $y, $z)';
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_length ():Float {
		
		return Math.sqrt (x * x + y * y + z * z);
		
	}
	
	
	private function get_lengthSquared ():Float {
		
		return x * x + y * y + z * z;
		
	}
	
	
	private inline static function get_X_AXIS ():Vector3D {
		
		return new Vector3D (1, 0, 0);
		
	}
	
	
	private inline static function get_Y_AXIS ():Vector3D {
		
		return new Vector3D (0, 1, 0);
		
	}
	
	
	private inline static function get_Z_AXIS ():Vector3D {
		
		return new Vector3D (0, 0, 1);
		
	}
	
	
}