package openfl.display {
	
	
	// import lime.graphics.DOMRenderContext;
	// import js.html.Element;
	
	// typedef DOMRenderContext = js.html.Element;
	
	
	/**
	 * @externs
	 */
	public class DOMRenderer extends DisplayObjectRenderer {
		
		
		public var element:*;
		public function get pixelRatio ():Number { return 0; }
		
		public function applyStyle (parent:DisplayObject, childElement:*):void {}
		public function clearStyle (childElement:*):void {}
		
		
	}
	
	
}