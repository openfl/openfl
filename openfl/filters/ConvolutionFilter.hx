package openfl.filters; #if !flash #if !openfl_legacy
import openfl.display.Shader;

class ConvolutionFilter extends BitmapFilter {

	public var alpha:Float;
	public var bias:Float;
	public var clamp:Bool;
	public var color:Int;
	public var divisor:Float;
	public var matrix(default, set):Array<Float>;
	public var matrixX:Int;
	public var matrixY:Int;
	public var preserveAlpha:Bool;
	
	private var __convolutionShader:ConvolutionShader;
	
	public function new(matrixX:Int = 0, matrixY:Int = 0, matrix:Array<Float> = null, divisor:Float = 1.0, bias:Float = 0.0, preserveAlpha:Bool = true, clamp:Bool = true, color:Int = 0, alpha:Float = 0.0) {
		
		super ();
		
		__convolutionShader = new ConvolutionShader();
		__passes = 1;
		
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
	
	override function __preparePass(pass:Int):Shader {
		return __convolutionShader;
	}
	
	inline function set_matrix(v:Array<Float>) {
		
		if (v == null) {
			v = [0, 0, 0, 0, 1, 0, 0, 0, 0];
		}
		if (v.length != 9) {
			throw "Only a 3x3 matrix is supported";
		}
		__convolutionShader.uMatrix = v;
		
		return matrix = v;
	}
	
}

private class ConvolutionShader extends Shader {
	
	@vertex var vertex = [
		'varying vec2 vBlurCoords[9];',
		
		'void main(void)',
		'{',
		
			'vec2 r = vec2(1.,1.) / ${Shader.uTextureSize};',
			'vec2 t = ${Shader.aTexCoord};',
			'vBlurCoords[0] = t + r * vec2(-1., -1.);',
			'vBlurCoords[1] = t + r * vec2( 0., -1.);',
			'vBlurCoords[2] = t + r * vec2( 1., -1.);',
			
			'vBlurCoords[3] = t + r * vec2(-1.,  0.);',
			'vBlurCoords[4] = t;',
			'vBlurCoords[5] = t + r * vec2( 1.,  0.);',
			
			'vBlurCoords[6] = t + r * vec2(-1.,  1.);',
			'vBlurCoords[7] = t + r * vec2( 0.,  1.);',
			'vBlurCoords[8] = t + r * vec2( 1.,  1.);',
			
			'${Shader.vTexCoord} = ${Shader.aTexCoord};',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
		'}',
	];
	
	@fragment var fragment = [
		'uniform mat3 uMatrix;',
		
		'varying vec2 vBlurCoords[9];',
		
		'void main(void)',
		'{',
			'vec4 tc = texture2D(${Shader.uSampler}, vBlurCoords[4]);',
			
			'vec4 c = vec4(0.0);',
			'c += texture2D(${Shader.uSampler}, vBlurCoords[0]) * uMatrix[0][0];',
			'c += texture2D(${Shader.uSampler}, vBlurCoords[1]) * uMatrix[0][1];',
			'c += texture2D(${Shader.uSampler}, vBlurCoords[2]) * uMatrix[0][2];',
			
			'c += texture2D(${Shader.uSampler}, vBlurCoords[3]) * uMatrix[1][0];',
			'c += tc * uMatrix[1][1];',
			'c += texture2D(${Shader.uSampler}, vBlurCoords[5]) * uMatrix[1][2];',
			
			'c += texture2D(${Shader.uSampler}, vBlurCoords[6]) * uMatrix[2][0];',
			'c += texture2D(${Shader.uSampler}, vBlurCoords[7]) * uMatrix[2][1];',
			'c += texture2D(${Shader.uSampler}, vBlurCoords[8]) * uMatrix[2][2];',

		'	gl_FragColor = vec4(c.rgb, tc.a);',
		'}',
	];
	
	public function new() {
		super();
		__uMatrix.transpose = false;
	}
}

#else
typedef ConvolutionFilter = openfl._legacy.filters.ConvolutionFilter;
#end
#else
typedef ConvolutionFilter = flash.filters.ConvolutionFilter;
#end