package flash.display {
	
	
	// import flash.Vector;
	
	
	/**
	 * @externs
	 */
	final public class GraphicsTrianglePath implements IGraphicsData, IGraphicsPath {
		
		
		public var culling:String;
		public var indices:Vector.<int>;
		public var uvtData:Vector.<Number>;
		public var vertices:Vector.<Number>;
		
		public function GraphicsTrianglePath (vertices:Vector.<Number> = null, indices:Vector.<int> = null, uvtData:Vector.<Number> = null, culling:String = null) {}
		
	}
	
	
}