package openfl.filters; #if !openfl_legacy


import openfl.display.Shader;
import openfl.geom.Rectangle;


@:final class GlowFilter extends BitmapFilter {
	
	
	public var alpha:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var inner:Bool;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength:Float;
	
	private var __glowShader:GlowShader;
	
	
	public function new (color:Int = 0xFF0000, alpha:Float = 1, blurX:Float = 6, blurY:Float = 6, strength:Float = 2, quality:Int = 1, inner:Bool = false, knockout:Bool = false) {
		
		super ();
		
		this.color = color;
		this.alpha = alpha;
		this.blurX = blurX;
		this.blurY = blurY;
		this.strength = strength;
		this.quality = quality;
		this.inner = inner;
		this.knockout = knockout;
		
		__glowShader = new GlowShader ();
		__glowShader.smooth = true;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout);
		
	}
	
	
	private override function __growBounds (rect:Rectangle):Void {
		
		rect.x += -blurX * 0.5 * quality;
		rect.y += -blurY * 0.5 * quality;
		rect.width += blurX * 0.5 * quality;
		rect.height += blurY * 0.5 * quality;
		
	}
	
	
	private override function __preparePass (pass:Int):Shader {
		
		if (pass == __passes - 1) {
			
			return null;
			
		} else {
			
			var even = pass % 2 == 0;
			var scale = Math.pow (0.5, pass >> 1);
			__glowShader.uRadius[0] = even ? scale * blurX : 0;
			__glowShader.uRadius[1] = even ? 0 : scale * blurY;
			__glowShader.uColor[0] = ((color >> 16) & 0xFF) / 255;
			__glowShader.uColor[1] = ((color >> 8) & 0xFF) / 255;
			__glowShader.uColor[2] = (color & 0xFF) / 255;
			__glowShader.uColor[3] = alpha;
			
			return __glowShader;
			
		}
		
	}
	
	
	private override function __useLastFilter (pass:Int):Bool {
		
		return pass == __passes - 1;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_knockout (value:Bool):Bool {
		
		__saveLastFilter = !value;
		return knockout = value;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		__passes = value * 2 + 1;
		return quality = value;
		
	}
	
	
}


private class GlowShader extends Shader {
	
	
	@vertex var vertex = [
		'uniform vec2 uRadius;',
		'varying vec2 vBlurCoords[7];',
		
		'void main(void)',
		'{',
		
			'vec2 r = uRadius / ${Shader.uTextureSize};',
			'vBlurCoords[0] = ${Shader.aTexCoord} - r * 1.2;',
			'vBlurCoords[1] = ${Shader.aTexCoord} - r * 0.8;',
			'vBlurCoords[2] = ${Shader.aTexCoord} - r * 0.4;',
			'vBlurCoords[3] = ${Shader.aTexCoord};',
			'vBlurCoords[4] = ${Shader.aTexCoord} + r * 0.4;',
			'vBlurCoords[5] = ${Shader.aTexCoord} + r * 0.8;',
			'vBlurCoords[6] = ${Shader.aTexCoord} + r * 1.2;',
			
			'${Shader.vTexCoord} = ${Shader.aTexCoord};',
			'${Shader.vColor} = ${Shader.aColor};',
			'gl_Position = vec4((${Shader.uProjectionMatrix} * vec3(${Shader.aPosition}, 1.0)).xy, 0.0, 1.0);',
		'}',
	];
	
	
	@fragment var fragment = [
		'uniform vec4 uColor;',
		
		'varying vec2 vBlurCoords[7];',
		
		'void main(void)',
		'{',
			'float a = 0.0;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[0]).a * 0.00443;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[1]).a * 0.05399;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[2]).a * 0.24197;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[3]).a * 0.39894;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[4]).a * 0.24197;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[5]).a * 0.05399;',
			'a += texture2D(${Shader.uSampler}, vBlurCoords[6]).a * 0.00443;',
			'a *= uColor.a;',
			
		'	gl_FragColor = vec4(uColor.rgb * a, a);',
		'}',
	];
	
	
	public function new () {
		
		super ();
		
	}
	
	
}


#else
typedef GlowFilter = openfl._legacy.filters.GlowFilter;
#end