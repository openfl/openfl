package flash {
	
	
	// import flash.display.Application;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	
	
	/**
	 * @externs
	 */
	public class Lib {
		
		
		// public static var application:Application;
		public static var current:MovieClip;
		
		public static function as (v:*, c:Class):* { return null; }
		public static function attach (name:String):MovieClip { return null; }
		public static function getTimer ():int { return 0; }
		public static function getURL (request:URLRequest, target:String = null):void {}
		// public static function notImplemented (?posInfo:Dynamic):Dynamic;
		// public static function preventDefaultTouchMove ():Dynamic;
		public static function trace (arg:*):void {}
		
		
	}
	
	
}