package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ConvolutionFilter extends BitmapFilter
{
	@:noCompletion private static var __convolutionShader:ConvolutionShader = new ConvolutionShader();

	public var alpha:Float;
	public var bias:Float;
	public var clamp:Bool;
	public var color:Int;
	public var divisor:Float;
	public var matrix(get, set):Array<Float>;
	public var matrixX:Int;
	public var matrixY:Int;
	public var preserveAlpha:Bool;

	@:noCompletion private var __matrix:Array<Float>;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(ConvolutionFilter.prototype, {
			"matrix": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_matrix (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_matrix (v); }")},
		});
	}
	#end

	public function new(matrixX:Int = 0, matrixY:Int = 0, matrix:Array<Float> = null, divisor:Float = 1.0, bias:Float = 0.0, preserveAlpha:Bool = true,
			clamp:Bool = true, color:Int = 0, alpha:Float = 0.0)
	{
		super();

		this.matrixX = matrixX;
		this.matrixY = matrixY;
		__matrix = matrix;
		this.divisor = divisor;
		this.bias = bias;
		this.preserveAlpha = preserveAlpha;
		this.clamp = clamp;
		this.color = color;
		this.alpha = alpha;

		__numShaderPasses = 1;
	}

	public override function clone():BitmapFilter
	{
		return new ConvolutionFilter(matrixX, matrixY, __matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		#if !macro
		__convolutionShader.uConvoMatrix.value = matrix;
		__convolutionShader.uDivisor.value[0] = divisor;
		__convolutionShader.uBias.value[0] = bias;
		__convolutionShader.uPreserveAlpha.value[0] = preserveAlpha;
		#end

		return __convolutionShader;
	}

	// Get & Set Methods
	@:noCompletion private function get_matrix():Array<Float>
	{
		return __matrix;
	}

	@:noCompletion private function set_matrix(v:Array<Float>):Array<Float>
	{
		if (v == null)
		{
			v = [0, 0, 0, 0, 1, 0, 0, 0, 0];
		}

		if (v.length != 9)
		{
			throw "Only a 3x3 matrix is supported";
		}

		return __matrix = v;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class ConvolutionShader extends BitmapFilterShader
{
	@:glFragmentSource("varying vec2 vBlurCoords[9];

		uniform sampler2D openfl_Texture;

		uniform float uBias;
		uniform mat3 uConvoMatrix;
		uniform float uDivisor;
		uniform bool uPreserveAlpha;

		void main(void) {

			vec4 tc = texture2D (openfl_Texture, vBlurCoords[4]);
			vec4 c = vec4 (0.0);

			c += texture2D (openfl_Texture, vBlurCoords[0]) * uConvoMatrix[0][0];
			c += texture2D (openfl_Texture, vBlurCoords[1]) * uConvoMatrix[0][1];
			c += texture2D (openfl_Texture, vBlurCoords[2]) * uConvoMatrix[0][2];

			c += texture2D (openfl_Texture, vBlurCoords[3]) * uConvoMatrix[1][0];
			c += tc * uConvoMatrix[1][1];
			c += texture2D (openfl_Texture, vBlurCoords[5]) * uConvoMatrix[1][2];

			c += texture2D (openfl_Texture, vBlurCoords[6]) * uConvoMatrix[2][0];
			c += texture2D (openfl_Texture, vBlurCoords[7]) * uConvoMatrix[2][1];
			c += texture2D (openfl_Texture, vBlurCoords[8]) * uConvoMatrix[2][2];

			if (uDivisor > 0.0) {

				c /= vec4 (uDivisor, uDivisor, uDivisor, uDivisor);

			}

			c += vec4 (uBias, uBias, uBias, uBias);

			if (uPreserveAlpha) {

				c.a = tc.a;

			}

			gl_FragColor = c;

		}")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		varying vec2 vBlurCoords[9];

		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;

		void main(void) {

			vec2 r = vec2 (1.0, 1.0) / openfl_TextureSize;
			vec2 t = openfl_TextureCoord;

			vBlurCoords[0] = t + r * vec2 (-1.0, -1.0);
			vBlurCoords[1] = t + r * vec2 (0.0, -1.0);
			vBlurCoords[2] = t + r * vec2 (1.0, -1.0);

			vBlurCoords[3] = t + r * vec2 (-1.0, 0.0);
			vBlurCoords[4] = t;
			vBlurCoords[5] = t + r * vec2 (1.0, 0.0);

			vBlurCoords[6] = t + r * vec2 (-1.0, 1.0);
			vBlurCoords[7] = t + r * vec2 (0.0, 1.0);
			vBlurCoords[8] = t + r * vec2 (1.0, 1.0);

			gl_Position = openfl_Matrix * openfl_Position;

		}")
	public function new()
	{
		super();

		#if !macro
		uDivisor.value = [1];
		uBias.value = [0];
		uPreserveAlpha.value = [true];
		#end
	}
}
#else
typedef ConvolutionFilter = flash.filters.ConvolutionFilter;
#end
