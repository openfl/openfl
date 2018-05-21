package flash.geom {
	
	
	/**
	 * @externs
	 */
	public class Vector3D {
		
		
		public static function get X_AXIS ():Vector3D { return null; }
		
		protected static function get_X_AXIS ():Vector3D { return null; }
		
		public static function get Y_AXIS ():Vector3D { return null; }
		
		protected static function get_Y_AXIS ():Vector3D { return null; }
		
		public static function get Z_AXIS ():Vector3D { return null; }
		
		protected static function get_Z_AXIS ():Vector3D { return null; }
		
		
		public function get length ():Number { return 0; }
		
		protected function get_length ():Number { return 0; }
		
		public function get lengthSquared ():Number { return 0; }
		
		public var w:Number;
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		
		public function Vector3D (x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0) {}
		
		
		//public inline function add (a:Vector3D):Vector3D;
		public function add (a:Vector3D):Vector3D { return null; }
		
		
		//public inline static function angleBetween (a:Vector3D, b:Vector3D):Number;
		public static function angleBetween (a:Vector3D, b:Vector3D):Number{ return 0; }
		
		
		//public inline function clone ():Vector3D;
		public function clone ():Vector3D { return null; }
		
		
		public function copyFrom (sourceVector3D:Vector3D):void {}
		
		
		//public inline function crossProduct (a:Vector3D):Vector3D;
		public function crossProduct (a:Vector3D):Vector3D { return null; }
		
		
		//public inline function decrementBy (a:Vector3D):void;
		public function decrementBy (a:Vector3D):void {}
		
		
		//public inline static function distance (pt1:Vector3D, pt2:Vector3D):Number;
		public static function distance (pt1:Vector3D, pt2:Vector3D):Number { return 0; }
		
		
		//public inline function dotProduct (a:Vector3D):Number;
		public function dotProduct (a:Vector3D):Number { return 0; }
		
		
		//public inline function equals (toCompare:Vector3D, allFour:Bool = false):Bool;
		public function equals (toCompare:Vector3D, allFour:Boolean = false):Boolean { return false; }
		
		
		//public inline function incrementBy (a:Vector3D):void;
		public function incrementBy (a:Vector3D):void {}
		
		
		//public inline function nearEquals (toCompare:Vector3D, tolerance:Number, ?allFour:Bool = false):Bool;
		public function nearEquals (toCompare:Vector3D, tolerance:Number, allFour:Boolean = false):Boolean { return false; }
		
		
		//public inline function negate ():void;
		public function negate ():void {}
		
		
		//public inline function normalize ():Number;
		public function normalize ():Number { return 0; }
		
		
		//public inline function project ():void;
		public function project ():void {}
		
		
		//public inline function scaleBy (s:Number):void;
		public function scaleBy (s:Number):void {}
		
		
		public function setTo (xa:Number, ya:Number, za:Number):void {}
		
		
		//public inline function subtract (a:Vector3D):Vector3D;
		public function subtract (a:Vector3D):Vector3D { return null; }
		
		
		//public inline function toString ():String;
		public function toString ():String { return null; }
		
		
	}
	
	
}