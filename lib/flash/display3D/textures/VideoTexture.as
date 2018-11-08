package flash.display3D.textures {
	
	
	import flash.net.NetStream;
	
	
	/**
	 * @externs
	 */
	final public class VideoTexture extends TextureBase {
		
		
		public function get videoHeight ():int { return 0; }
		public function get videoWidth ():int { return 0; }
		
		//public function attachCamera (theCamera:Camera):void {}
		public function attachNetStream (netStream:NetStream):void {}
		
		
	}
	
	
}