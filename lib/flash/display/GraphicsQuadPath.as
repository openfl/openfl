package flash.display {
	
	
	import flash.Vector;
	
	
	/**
	 * @externs
	 */
	final public class GraphicsQuadPath implements IGraphicsData, IGraphicsPath {
		
		
		public var indices:flash.Vector;
		public var rects:flash.Vector;
		public var transforms:flash.Vector;
		
		public function GraphicsQuadPath (rects:flash.Vector = null, indices:flash.Vector = null, transforms:flash.Vector = null) {}
		
		
	}
	
	
}