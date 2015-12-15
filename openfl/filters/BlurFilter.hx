package openfl.filters; #if !openfl_legacy


import openfl.display.Shader;
import openfl.filters.BitmapFilter;
import openfl.geom.Rectangle;


@:final class BlurFilter extends BitmapFilter {
	
	
	public var blurX:Float;
	public var blurY:Float;
	public var quality (default, set):Int;
	
	private var __blurShader:BlurShader;
	
	
	public function new (blurX:Float = 4, blurY:Float = 4, quality:Int = 1) {
		
		super ();
		
		this.blurX = blurX;
		this.blurY = blurY;
		this.quality = quality;
		
		__blurShader = new BlurShader ();
		__blurShader.smooth = true;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new BlurFilter (blurX, blurY, quality);
		
	}
	
	
	private override function __growBounds (rect:Rectangle):Void {
		
		rect.x += -blurX * 0.5 * quality;
		rect.y += -blurY * 0.5 * quality;
		rect.width += blurX * 0.5 * quality;
		rect.height += blurY * 0.5 * quality;
		
	}
	
	
	private override function __preparePass (pass:Int):Shader {
		
		var even = pass % 2 == 0;
		var scale = Math.pow(0.5, pass >> 1);
		__blurShader.uRadius[0] = even ? scale * blurX : 0;
		__blurShader.uRadius[1] = even ? 0 : scale * blurY;
		
		return __blurShader;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_quality (value:Int):Int {
		
		__passes = value * 2;
		return quality = value;
		
	}
	
	
}


private class BlurShader extends Shader {
	
	
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
		'varying vec2 vBlurCoords[7];',
		
		'void main(void)',
		'{',
			'vec4 sum = vec4(0.0);',
			'sum += texture2D(${Shader.uSampler}, vBlurCoords[0]) * 0.00443;',
			'sum += texture2D(${Shader.uSampler}, vBlurCoords[1]) * 0.05399;',
			'sum += texture2D(${Shader.uSampler}, vBlurCoords[2]) * 0.24197;',
			'sum += texture2D(${Shader.uSampler}, vBlurCoords[3]) * 0.39894;',
			'sum += texture2D(${Shader.uSampler}, vBlurCoords[4]) * 0.24197;',
			'sum += texture2D(${Shader.uSampler}, vBlurCoords[5]) * 0.05399;',
			'sum += texture2D(${Shader.uSampler}, vBlurCoords[6]) * 0.00443;',
			
		'	gl_FragColor = sum;',
		'}',
	];
	
	
	public function new () {
		
		super ();
		
	}
	
	
}


#else
typedef BlurFilter = openfl._legacy.filters.BlurFilter;
#end