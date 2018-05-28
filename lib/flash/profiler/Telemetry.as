package flash.profiler {
	
	
	/**
	 * @externs
	 */
	final public class Telemetry {
		
		
		public static function get connected ():Boolean { return false; }
		public static function get spanMarker ():Number { return 0; }
		
		public static function registerCommandHandler (commandName:String, handler:Function):Boolean { return false; }
		public static function sendMetric (metric:String, value:*):void {}
		public static function sendSpanMetric (metric:String, startSpanMarker:Number, value:*):void {}
		public static function unregisterCommandHandler (commandName:String):Boolean { return false; }
		
		
	}
	
	
}