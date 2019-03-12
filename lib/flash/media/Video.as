package flash.media {
	
	
	import flash.display.DisplayObject;
	import flash.net.NetStream;
	
	
	/**
	 * @externs
	 */
	public class Video extends DisplayObject {
		
		
		public var deblocking:int;
		public var smoothing:Boolean;
		public function get videoHeight ():int { return 0; }
		
		protected function get_videoHeight ():int { return 0; }
		
		public function get videoWidth ():int { return 0; }
		
		protected function get_videoWidth ():int { return 0; }
		
		
		public function Video (width:int = 320, height:int = 240) {}
		
		// #if flash
		// @:noCompletion @:dox(hide) public function attachCamera (camera:flash.media.Camera):Void;
		// #end
		
		public function attachNetStream (netStream:NetStream):void {}
		public function clear ():void {}
		
		
	}
	
	
}
