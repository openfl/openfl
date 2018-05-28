package openfl.display {
	
	
	import openfl.events.EventDispatcher;
	
	
	/**
	 * @externs
	 */
	final public class FrameLabel extends EventDispatcher {
		
		
		public function get frame ():int { return 0; }
		
		protected function get_frame ():int { return 0; }
		
		public function get name ():String { return null; }
		
		protected function get_name ():String { return null; }
		
		
		public function FrameLabel (name:String, frame:int) {}
		
		
	}
	
	
}
