package flash.errors {
	
	
	/**
	 * @externs
	 */
	public class Error /*#if openfl_dynamic implements Dynamic #end*/ {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var length:Int;
		// #end
		
		public function get errorID ():int { return 0; }
		public var message:String; //Dynamic
		public var name:String; //Dynamic
		
		
		public function Error (message:String = "", id:int = 0) {}
		
		// #if flash
		// @:noCompletion @:dox(hide) public static function getErrorMessage (index:Int):String;
		// #end
		
		public function getStackTrace ():String { return null; }
		
		// #if flash
		// @:noCompletion @:dox(hide) public static function throwError (type:Class<Dynamic>, index:UInt, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic;
		// #end
		
		
	}
	
	
}