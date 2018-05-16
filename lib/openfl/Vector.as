package openfl {
	
	
	
	/**
	 * @externs
	 */
	public class Vector {
		
		
		public var fixed:Boolean;
		public var length:int;
		
		public function Vector (length:int = 0, fixed:Boolean = false, array:Array = null) {}
		
		public function concat (a:openfl.Vector = null):openfl.Vector { return null; }
		public function copy ():openfl.Vector { return null; }
		// public function get (index:int):* { return null; }
		public function indexOf (x:*, from:int = 0):int { return 0; }
		public function insertAt (index:int, element:*):void {}
		public function join (sep:String = ","):String { return null; }
		public function lastIndexOf (x:*, from:int = 0):int { return 0; }
		public function pop ():* { return null; }
		public function push (x:*):int { return 0; }
		public function removeAt (index:int):* { return null; }
		public function reverse ():openfl.Vector { return null; }
		// public function set (index:int, value:*):* { return null; }
		public function shift ():* { return null; }
		public function slice (pos:int = 0, end:int = 0):openfl.Vector { return null; }
		public function sort (f:Function):void {}
		public function splice (pos:int, len:int):openfl.Vector { return null; }
		public function unshift (x:*):void {}
		public static function ofArray (a:Array):openfl.Vector { return null; }
		
		// @:noCompletion public function iterator ():Iterator<T>;
		
		
	}
	
	
}