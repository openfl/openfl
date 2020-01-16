package flash.events {


	/**
	 * @externs
	 */
	public class VideoTextureEvent extends Event {


		public static const RENDER_STATE:String = "renderState";

		public function get colorSpace ():String { return null; }
		public function get status ():String { return null; }


		public function VideoTextureEvent (type:String, bubbles:Boolean = true, cancelable:Boolean = true, status:String = null, colorSpace:String = null) { super (type); }


	}


}