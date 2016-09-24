package openfl.filters;

import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;


class ConvolutionFilter extends BitmapFilter {
	
	
	private static var __convolutionShader = new ConvolutionShader ();
	
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
	
	private override function __initShader (renderSession:RenderSession, object:DisplayObject):Shader {
		
		__convolutionShader.init (matrix, object);
		return __convolutionShader;
		
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

private class ConvolutionShader extends Shader {
	
	
	private static var GL_FRAGMENT_SOURCE = 
		
		"varying vec2 vBlurCoords[9];
		varying float vAlpha;
		varying vec2 vTexCoord;
		
		uniform sampler2D uImage0;
		
		uniform mat3 uConvoMatrix;
		
		void main(void) {
			
			vec4 tc = texture2D(uImage0, vBlurCoords[4]);
			
			vec4 c = vec4(0.0);
			c += texture2D(uImage0, vBlurCoords[0]) * uConvoMatrix[0][0];
			c += texture2D(uImage0, vBlurCoords[1]) * uConvoMatrix[0][1];
			c += texture2D(uImage0, vBlurCoords[2]) * uConvoMatrix[0][2];
			
			c += texture2D(uImage0, vBlurCoords[3]) * uConvoMatrix[1][0];
			c += tc * uConvoMatrix[1][1];
			c += texture2D(uImage0, vBlurCoords[5]) * uConvoMatrix[1][2];
			
			c += texture2D(uImage0, vBlurCoords[6]) * uConvoMatrix[2][0];
			c += texture2D(uImage0, vBlurCoords[7]) * uConvoMatrix[2][1];
			c += texture2D(uImage0, vBlurCoords[8]) * uConvoMatrix[2][2];
			
			gl_FragColor = vec4(c.rgb, tc.a);
			
		}";
	
	private static var GL_VERTEX_SOURCE = 
		
		"attribute float aAlpha;
		attribute vec4 aPosition;
		attribute vec2 aTexCoord;
		
		varying vec2 vBlurCoords[9];
		varying float vAlpha;
		varying vec2 vTexCoord;
		
		uniform mat4 uMatrix;
		uniform vec2 uTextureSize;
		
		void main(void) {
			
			vec2 r = vec2(1.0, 1.0) / uTextureSize;
			vec2 t = aTexCoord;
			
			vBlurCoords[0] = t + r * vec2( -1.0, -1.0);
			vBlurCoords[1] = t + r * vec2( 0.0, -1.0);
			vBlurCoords[2] = t + r * vec2( 1.0, -1.0);
			
			vBlurCoords[3] = t + r * vec2( -1.0, 0.0);
			vBlurCoords[4] = t;
			vBlurCoords[5] = t + r * vec2( 1.0,  0.0);
			
			vBlurCoords[6] = t + r * vec2(-1.0,  1.0);
			vBlurCoords[7] = t + r * vec2( 0.0,  1.0);
			vBlurCoords[8] = t + r * vec2( 1.0,  1.0);
			
			vAlpha = aAlpha;
			vTexCoord = aTexCoord;
			gl_Position = uMatrix * aPosition;
			
		}";
	
	private var multipliers:Array<Float>;
	private var size:Array<Float>;
	
	
	public function new () {
		
		glVertexSource = GL_VERTEX_SOURCE;
		glFragmentSource = GL_FRAGMENT_SOURCE;
		
		super ();
		
	}
	
	
	public function init (matrix:Array<Float>, object:DisplayObject):Void {
		
		for (i in 0...9)
		{
			multipliers[i] = matrix[i];
		}
		
		size[0] = object.width;
		size[1] = object.height;
	}
	
	
	private override function __init ():Void {
		
		super.__init ();
		
		if (data.uConvoMatrix != null && data.uConvoMatrix.value == null) {
			
			data.uConvoMatrix.value = [0, 0, 0, 0, 1, 0, 0, 0, 0];
			multipliers = cast data.uConvoMatrix.value;
			
			data.uTextureSize.value = [0, 0];
			size = cast data.uTextureSize.value;
			
		}
		
	}
	
	
}