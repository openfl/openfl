package openfl.display {
	
	
	import openfl.Vector;
	
	
	/**
	 * @externs
	 */
	final public class GraphicsQuadPath implements IGraphicsData, IGraphicsPath {
		
		
		public var indices:openfl.Vector;
		public var rects:openfl.Vector;
		public var transforms:openfl.Vector;
		
		public function GraphicsQuadPath (rects:openfl.Vector = null, indices:openfl.Vector = null, transforms:openfl.Vector = null) {}
		
		
	}
	
	
}