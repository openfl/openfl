package openfl.display {
	
	
	import openfl.Vector;
	
	
	/**
	 * @externs
	 */
	final public class GraphicsTrianglePath implements IGraphicsData, IGraphicsPath {
		
		
		public var culling:String;
		public var indices:openfl.Vector;
		public var uvtData:openfl.Vector;
		public var vertices:openfl.Vector;
		
		public function GraphicsTrianglePath (vertices:openfl.Vector = null, indices:openfl.Vector = null, uvtData:openfl.Vector = null, culling:String = null) {}
		
	}
	
	
}