package flash.display {
	
	
	//import lime.graphics.GLRenderContext;
	//import lime.math.Matrix4;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	// typedef GLRenderContext = js.html.webgl.RenderingContext;
	// typedef Matrix4 = Dynamic;
	
	
	/**
	 * @externs
	 */
	public class OpenGLRenderer extends DisplayObjectRenderer {
		
		
		public var gl:*;
		
		public function applyAlpha (alpha:Number):void {}
		public function applyBitmapData (bitmapData:BitmapData, smooth:Boolean, repeat:Boolean = false):void {}
		public function applyColorTransform (colorTransform:ColorTransform):void {}
		public function applyHasColorTransform (enabled:Boolean):void {}
		public function applyMatrix (matrix:Array):void {}
		public function getMatrix (transform:Matrix):* { return null; }
		public function setShader (shader:Shader):void {}
		public function setViewport ():void {}
		public function updateShader ():void {}
		public function useAlphaArray ():void {}
		public function useColorTransformArray ():void {}
		
		
	}
	
	
}