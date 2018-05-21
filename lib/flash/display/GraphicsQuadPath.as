package flash.display {
	
	
	// import flash.Vector;
	
	
	/**
	 * @externs
	 */
	final public class GraphicsQuadPath implements IGraphicsData, IGraphicsPath {
		
		
		public var indices:Vector.<int>;
		public var rects:Vector.<Number>;
		public var transforms:Vector.<Number>;
		
		public function GraphicsQuadPath (rects:Vector.<Number> = null, indices:Vector.<int> = null, transforms:Vector.<Number> = null) {}
		
		
	}
	
	
}