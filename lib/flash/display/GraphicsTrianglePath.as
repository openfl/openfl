package flash.display {
	
	
	import flash.Vector;
	
	
	/**
	 * @externs
	 */
	final public class GraphicsTrianglePath implements IGraphicsData, IGraphicsPath {
		
		
		public var culling:String;
		public var indices:flash.Vector;
		public var uvtData:flash.Vector;
		public var vertices:flash.Vector;
		
		public function GraphicsTrianglePath (vertices:flash.Vector = null, indices:flash.Vector = null, uvtData:flash.Vector = null, culling:String = null) {}
		
	}
	
	
}