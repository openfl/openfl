package openfl.filters {
	
	
	/**
	 * @externs
	 */
	final public class ConvolutionFilter extends BitmapFilter {
		
		
		public var alpha:Number;
		public var bias:Number;
		public var clamp:Boolean;
		public var color:int;
		public var divisor:Number;
		
		public var matrix:Array;
		
		protected function get_matrix ():Array { return null; }
		protected function set_matrix (value:Array):Array { return null; }
		
		public var matrixX:int;
		public var matrixY:int;
		public var preserveAlpha:Boolean;
		
		
		public function ConvolutionFilter (matrixX:int = 0, matrixY:int = 0, matrix:Array = null, divisor:Number = 1.0, bias:Number = 0.0, preserveAlpha:Boolean = true, clamp:Boolean = true, color:int = 0, alpha:Number = 0.0) {}
		
	}
	
	
}