package openfl.filters;


class ColorMatrixFilter extends BitmapFilter {
	
	
	public var matrix:Array<Float>;
	
	
	public function new (matrix:Array<Float>) {
		
		super ("ColorMatrixFilter");
	  
		this.matrix = matrix;
		
	}
	
	
	override public function clone ():BitmapFilter {
		
		return new ColorMatrixFilter (matrix);
		
	}
	
	
}