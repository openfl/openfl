package openfl.filters;


import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;


class ConvolutionFilter extends BitmapFilter {
	
	
	//private static var __convolutionShader = new ConvolutionShader ();
	
	public var alpha:Float;
	public var bias:Float;
	public var clamp:Bool;
	public var color:Int;
	public var divisor:Float;
	public var matrix (get, set):Array<Float>;
	public var matrixX:Int;
	public var matrixY:Int;
	public var preserveAlpha:Bool;
	
	private var __matrix:Array<Float>;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (ConvolutionFilter.prototype, {
			"matrix": { get: untyped __js__ ("function () { return this.get_matrix (); }"), set: untyped __js__ ("function (v) { return this.set_matrix (v); }") },
		});
		
	}
	#end
	
	
	public function new (matrixX:Int = 0, matrixY:Int = 0, matrix:Array<Float> = null, divisor:Float = 1.0, bias:Float = 0.0, preserveAlpha:Bool = true, clamp:Bool = true, color:Int = 0, alpha:Float = 0.0) {
		
		super ();
		
		this.matrixX = matrixX;
		this.matrixY = matrixY;
		__matrix = matrix;
		this.divisor = divisor;
		this.bias = bias;
		this.preserveAlpha = preserveAlpha;
		this.clamp = clamp;
		this.color = color;
		this.alpha = alpha;
		
		// __numShaderPasses = 1;
		__numShaderPasses = 0;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new ConvolutionFilter (matrixX, matrixY, __matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
		
	}
	
	
	private override function __initShader (renderSession:RenderSession, pass:Int):Shader {
		
		// var data = __convolutionShader.data;
		
		// data.uConvoMatrix.value = matrix;
		// data.uDivisor.value[0] = divisor;
		// data.uBias.value[0] = bias;
		// data.uPreserveAlpha.value[0] = preserveAlpha;
		
		// return __convolutionShader;
		
		return null;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_matrix ():Array<Float> {
		
		return __matrix;
		
	}
	
	
	private function set_matrix (v:Array<Float>):Array<Float> {
		
		if (v == null) {
			
			v = [ 0, 0, 0, 0, 1, 0, 0, 0, 0 ];
			
		}
		
		if (v.length != 9) {
			
			throw "Only a 3x3 matrix is supported";
			
		}
		
		return __matrix = v;
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


private class ConvolutionShader extends Shader {
	
	
	@:glFragmentSource( 
		
		"varying vec2 vBlurCoords[9];
		varying float vAlpha;
		varying vec2 vTexCoord;
		
		uniform sampler2D uImage0;
		
		uniform float uBias;
		uniform mat3 uConvoMatrix;
		uniform float uDivisor;
		uniform bool uPreserveAlpha;
		
		void main(void) {
			
			vec4 tc = texture2D (uImage0, vBlurCoords[4]);
			vec4 c = vec4 (0.0);
			
			c += texture2D (uImage0, vBlurCoords[0]) * uConvoMatrix[0][0];
			c += texture2D (uImage0, vBlurCoords[1]) * uConvoMatrix[0][1];
			c += texture2D (uImage0, vBlurCoords[2]) * uConvoMatrix[0][2];
			
			c += texture2D (uImage0, vBlurCoords[3]) * uConvoMatrix[1][0];
			c += tc * uConvoMatrix[1][1];
			c += texture2D (uImage0, vBlurCoords[5]) * uConvoMatrix[1][2];
			
			c += texture2D (uImage0, vBlurCoords[6]) * uConvoMatrix[2][0];
			c += texture2D (uImage0, vBlurCoords[7]) * uConvoMatrix[2][1];
			c += texture2D (uImage0, vBlurCoords[8]) * uConvoMatrix[2][2];
			
			if (uDivisor > 0) {
				
				c /= vec4 (uDivisor, uDivisor, uDivisor, uDivisor);
				
			}
			
			c += vec4 (uBias, uBias, uBias, uBias);
			
			if (uPreserveAlpha) {
				
				c.a = tc.a;
				
			}
			
			gl_FragColor = c * vAlpha;
			
		}"
		
	)
	
	@:glVertexSource( 
		
		"attribute float aAlpha;
		attribute vec4 aPosition;
		attribute vec2 aTexCoord;
		
		varying vec2 vBlurCoords[9];
		varying float vAlpha;
		varying vec2 vTexCoord;
		
		uniform mat4 uMatrix;
		uniform vec2 uTextureSize;
		
		void main(void) {
			
			vec2 r = vec2 (1.0, 1.0) / uTextureSize;
			vec2 t = aTexCoord;
			
			vBlurCoords[0] = t + r * vec2 (-1.0, -1.0);
			vBlurCoords[1] = t + r * vec2 (0.0, -1.0);
			vBlurCoords[2] = t + r * vec2 (1.0, -1.0);
			
			vBlurCoords[3] = t + r * vec2 (-1.0, 0.0);
			vBlurCoords[4] = t;
			vBlurCoords[5] = t + r * vec2 (1.0, 0.0);
			
			vBlurCoords[6] = t + r * vec2 (-1.0, 1.0);
			vBlurCoords[7] = t + r * vec2 (0.0, 1.0);
			vBlurCoords[8] = t + r * vec2 (1.0, 1.0);
			
			vAlpha = aAlpha;
			vTexCoord = aTexCoord;
			gl_Position = uMatrix * aPosition;
			
		}"
		
	)
	
	
	public function new () {
		
		super ();
		
		data.uDivisor.value = [ 1 ];
		data.uBias.value = [ 0 ];
		data.uPreserveAlpha.value = [ true ];
		
	}
	
	
	private override function __update ():Void {
		
		data.uTextureSize.value = [ data.uImage0.input.width, data.uImage0.input.height ];
		
		super.__update ();
		
	}
	
	
}