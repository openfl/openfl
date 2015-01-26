package openfl._v2.filters; #if lime_legacy


class ColorMatrixFilter extends BitmapFilter {
	
	
	public var matrix:Array<Float>;
	
	
	public function new (matrix:Array<Float> = null) {
		
		super ("ColorMatrixFilter");
		
		if (matrix == null) {
			
			matrix = [ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0 ];
			
		}
	  
		this.matrix = matrix;
		
	}
	
	
	override public function clone ():BitmapFilter {
		
		return new ColorMatrixFilter (matrix);
		
	}
	
	
}


#end