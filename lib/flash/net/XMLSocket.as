package flash.net {
	
	
	import flash.events.EventDispatcher;
	
	
	/**
	 * @externs
	 */
	public class XMLSocket extends EventDispatcher {
		
		
		public function get connected ():Boolean { return false; }
		public var timeout:int;
		
		public function XMLSocket (host:String = null, port:int = 80) {}
		public function close ():void {}
		public function connect (host:String, port:int):void {}
		public function send (object:Object):void {}
		
		
	}
	
	
}