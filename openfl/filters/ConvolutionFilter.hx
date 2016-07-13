package openfl.filters;


class ConvolutionFilter extends BitmapFilter {
	
	
	public var alpha:Float;
	public var bias:Float;
	public var clamp:Bool;
	public var color:Int;
	public var divisor:Float;
	public var matrix (default, set):Array<Float>;
	public var matrixX:Int;
	public var matrixY:Int;
	public var preserveAlpha:Bool;
	
	
	public function new (matrixX:Int = 0, matrixY:Int = 0, matrix:Array<Float> = null, divisor:Float = 1.0, bias:Float = 0.0, preserveAlpha:Bool = true, clamp:Bool = true, color:Int = 0, alpha:Float = 0.0) {
		
		super ();
		
		this.matrixX = matrixX;
		this.matrixY = matrixY;
		this.matrix = matrix;
		this.divisor = divisor;
		this.bias = bias;
		this.preserveAlpha = preserveAlpha;
		this.clamp = clamp;
		this.color = color;
		this.alpha = alpha;
		
	}
	
	public override function clone ():BitmapFilter {
		
		return new ConvolutionFilter (matrixX, matrixY, matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_matrix (v:Array<Float>):Array<Float> {
		
		if (v == null) {
			
			v = [0, 0, 0, 0, 1, 0, 0, 0, 0];
			
		}
		
		if (v.length != 9) {
			
			throw "Only a 3x3 matrix is supported";
			
		}
		
		return matrix = v;
		
	}
	
	
}