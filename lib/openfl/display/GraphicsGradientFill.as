package openfl.display {
	
	
	import openfl.geom.Matrix;
	
	
	/**
	 * @externs
	 */
	final public class GraphicsGradientFill implements IGraphicsData, IGraphicsFill {
		
		
		public var alphas:Array;
		public var colors:Array;
		public var focalPointRatio:Number;
		public var interpolationMethod:String;
		public var matrix:Matrix;
		public var ratios:Array;
		public var spreadMethod:String;
		public var type:String;
		
		
		public function GraphicsGradientFill (type:String = null, colors:Array = null, alphas:Array = null, ratios:Array = null, matrix:Matrix = null, spreadMethod:String = null, interpolationMethod:String = null, focalPointRatio:Number = 0) {}
		
		
	}
	
	
}