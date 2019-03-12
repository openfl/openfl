package flash.display {
	
	
	//import lime.graphics.CanvasRenderContext;
	import flash.geom.Matrix;

	// typedef CanvasRenderContext = js.html.CanvasRenderingContext2D;
	
	/** 
	 * @externs 
	 */
	public class CanvasRenderer extends DisplayObjectRenderer {
		
		
		public var context:*;
		public function get pixelRatio ():Number { return 0; }
		
		public function applySmoothing (context:*, value:Boolean):void {}
		public function setTransform (transform:Matrix, context:* = null):void {}
		
		
	}
	
	
}
