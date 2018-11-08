package openfl.events {


	import openfl.display.DisplayObjectRenderer;
	import openfl.events.Event;
	import openfl.geom.ColorTransform;
	import openfl.geom.Matrix;
	
	
	/**
	 * @externs
	 */
	public class RenderEvent extends Event {
		
		
		public static const CLEAR_DOM:String = "clearDOM";
		public static const RENDER_CAIRO:String = "renderCairo";
		public static const RENDER_CANVAS:String = "renderCanvas";
		public static const RENDER_DOM:String = "renderDOM";
		public static const RENDER_OPENGL:String = "renderOpenGL";
		
		public var allowSmoothing:Boolean;
		public var objectColorTransform:ColorTransform;
		public var objectMatrix:Matrix;
		public function get renderer ():DisplayObjectRenderer { return null; }
		
		
		public function RenderEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false, objectMatrix:Matrix = null, objectColorTransform:ColorTransform = null, allowSmoothing:Boolean = true) { super (type); }
		
		
	}
	
	
}