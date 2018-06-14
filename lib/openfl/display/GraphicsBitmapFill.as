package openfl.display {
	
	
	import openfl.geom.Matrix;
	
	
	/**
	 * @externs
	 */
	final public class GraphicsBitmapFill implements IGraphicsData, IGraphicsFill {
		
		
		public var bitmapData:BitmapData;
		public var matrix:Matrix;
		public var repeat:Boolean;
		public var smooth:Boolean;
		
		
		public function GraphicsBitmapFill (bitmapData:BitmapData = null, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false) {}
		
		
	}
	
	
}