package openfl.geom; #if (display || !flash)


extern class Vector3D {
	
	
	public static var X_AXIS (get, never):Vector3D;
	public static var Y_AXIS (get, never):Vector3D;
	public static var Z_AXIS (get, never):Vector3D;
	
	public var length (get, never):Float;
	public var lengthSquared (get, never):Float;
	
	public var w:Float;
	public var x:Float;
	public var y:Float;
	public var z:Float;
	
	
	public function new (x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0);
	
	
	//public inline function add (a:Vector3D):Vector3D;
	public function add (a:Vector3D):Vector3D;
	
	
	//public inline static function angleBetween (a:Vector3D, b:Vector3D):Float;
	public static function angleBetween (a:Vector3D, b:Vector3D):Float;
	
	
	//public inline function clone ():Vector3D;
	public function clone ():Vector3D;
	
	
	public function copyFrom (sourceVector3D:Vector3D):Void;
	
	
	//public inline function crossProduct (a:Vector3D):Vector3D;
	public function crossProduct (a:Vector3D):Vector3D;
	
	
	//public inline function decrementBy (a:Vector3D):Void;
	public function decrementBy (a:Vector3D):Void;
	
	
	//public inline static function distance (pt1:Vector3D, pt2:Vector3D):Float;
	public static function distance (pt1:Vector3D, pt2:Vector3D):Float;
	
	
	//public inline function dotProduct (a:Vector3D):Float;
	public function dotProduct (a:Vector3D):Float;
	
	
	//public inline function equals (toCompare:Vector3D, allFour:Bool = false):Bool;
	public function equals (toCompare:Vector3D, allFour:Bool = false):Bool;
	
	
	//public inline function incrementBy (a:Vector3D):Void;
	public function incrementBy (a:Vector3D):Void;
	
	
	//public inline function nearEquals (toCompare:Vector3D, tolerance:Float, ?allFour:Bool = false):Bool;
	public function nearEquals (toCompare:Vector3D, tolerance:Float, ?allFour:Bool = false):Bool;
	
	
	//public inline function negate ():Void;
	public function negate ():Void;
	
	
	//public inline function normalize ():Float;
	public function normalize ():Float;
	
	
	//public inline function project ():Void;
	public function project ():Void;
	
	
	//public inline function scaleBy (s:Float):Void;
	public function scaleBy (s:Float):Void;
	
	
	public function setTo (xa:Float, ya:Float, za:Float):Void;
	
	
	//public inline function subtract (a:Vector3D):Vector3D;
	public function subtract (a:Vector3D):Vector3D;
	
	
	//public inline function toString ():String;
	public function toString ():String;
	
	
}


#else
typedef Vector3D = flash.geom.Vector3D;
#end