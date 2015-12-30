package openfl.filters; #if !openfl_legacy


import openfl.display.Shader;
import openfl.geom.Rectangle;


@:final class DropShadowFilter extends BitmapFilter {
	
	
	public var alpha:Float;
	public var angle:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var distance:Float;
	public var hideObject (default, set):Bool;
	public var inner:Bool;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength:Float;
	
	private var __dropShadowShader:DropShadowShader;
	
	
	public function new (distance:Float = 4, angle:Float = 45, color:Int = 0, alpha:Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, inner:Bool = false, knockout:Bool = false, hideObject:Bool = false) {
		
		super ();
		
		this.distance = distance;
		this.angle = angle;
		this.color = color;
		this.alpha = alpha;
		this.blurX = blurX;
		this.blurY = blurY;
		this.strength = strength;
		this.quality = quality;
		this.inner = inner;
		this.knockout = knockout;
		this.hideObject = hideObject;
		
		__dropShadowShader = new DropShadowShader ();
		__dropShadowShader.smooth = true;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		
	}
	
	
	private override function __growBounds (rect:Rectangle):Void {
		
		var sX = distance * Math.cos (angle * Math.PI / 180);
		var sY = distance * Math.sin (angle * Math.PI / 180);
		rect.x += -(Math.abs (sX) + (blurX * 0.5)) * quality;
		rect.y += -(Math.abs (sY) + (blurY * 0.5)) * quality;
		rect.width += (sX + (blurX * 0.5)) * quality;
		rect.height += (sY + (blurY * 0.5))  * quality;
		
	}
	
	
	private override function __preparePass (pass:Int):Shader {
		
		if (pass == __passes - 1) {
			
			return null;
			
		} else {
			
			var even = pass % 2 == 0;
			var scale = Math.pow (0.5, pass >> 1);
			__dropShadowShader.uRadius[0] = even ? scale * blurX : 0;
			__dropShadowShader.uRadius[1] = even ? 0 : scale * blurY;
			__dropShadowShader.uShift[0] = pass == 0 ? distance * Math.cos (angle * Math.PI / 180) : 0;
			__dropShadowShader.uShift[1] = pass == 0 ? distance * Math.sin (angle * Math.PI / 180) : 0;
			__dropShadowShader.uColor[0] = ((color >> 16) & 0xFF) / 255;
			__dropShadowShader.uColor[1] = ((color >> 8) & 0xFF) / 255;
			__dropShadowShader.uColor[2] = (color & 0xFF) / 255;
			__dropShadowShader.uColor[3] = alpha;
			
			return __dropShadowShader;
			
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
	
	
	private function set_hideObject (value:Bool):Bool {
		
		__saveLastFilter = !value;
		return hideObject = value;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		__passes = value * 2 + 1;
		return quality = value;
		
	}
	
	
}


private class DropShadowShader extends Shader {
	
	
	@vertex var vertex = [
		'uniform vec2 uRadius;',
		'uniform vec2 uShift;',
		'varying vec2 vBlurCoords[7];',
		
		'void main(void)',
		'{',
		
			'vec2 r = uRadius / ${Shader.uTextureSize};',
			'vec2 tc = ${Shader.aTexCoord} - (uShift / ${Shader.uTextureSize});',
			'vBlurCoords[0] = tc - r * 1.2;',
			'vBlurCoords[1] = tc - r * 0.8;',
			'vBlurCoords[2] = tc - r * 0.4;',
			'vBlurCoords[3] = tc;',
			'vBlurCoords[4] = tc + r * 0.4;',
			'vBlurCoords[5] = tc + r * 0.8;',
			'vBlurCoords[6] = tc + r * 1.2;',
			
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
typedef DropShadowFilter = openfl._legacy.filters.DropShadowFilter;
#end