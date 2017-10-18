package openfl.filters;


import lime.graphics.utils.ImageDataUtil;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)


@:final class GlowFilter extends BitmapFilter {
	
	
	//private static var __glowShader = new GlowShader ();
	
	public var alpha (default, set):Float;
	public var blurX (default, set):Float;
	public var blurY (default, set):Float;
	public var color (default, set):Int;
	public var inner (default, set):Bool;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength (default, set):Float;
	
	private var horizontalPasses:Int;
	private var verticalPasses:Int;
	
	
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
		
		__needSecondBitmapData = true;
		__preserveObject = true;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout);
		
	}
	
	
	private override function __applyFilter (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {
		
		// TODO: Support knockout, inner
		
		var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
		sourceBitmapData.colorTransform (sourceBitmapData.rect, new ColorTransform (0, 0, 0, 1, r, g, b, alpha * 0xFF));
		
		var finalImage = ImageDataUtil.gaussianBlur (bitmapData.image, sourceBitmapData.image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), blurX, blurY, quality, strength);
		
		if (finalImage == bitmapData.image) return bitmapData;
		return sourceBitmapData;
		
	}
	
	
	private override function __initShader (renderSession:RenderSession, pass:Int):Shader {
		
		// var data = __glowShader.data;
		
		// if (pass <= horizontalPasses) {
			
		// 	var scale = Math.pow (0.5, pass >> 1);
		// 	data.uRadius.value[0] = blurX * scale;
		// 	data.uRadius.value[1] = 0;
			
		// } else {
			
		// 	var scale = Math.pow (0.5, (pass - horizontalPasses) >> 1);
		// 	data.uRadius.value[0] = 0;
		// 	data.uRadius.value[1] = blurY * scale;
			
		// }
		
		// data.uColor.value[0] = ((color >> 16) & 0xFF) / 255;
		// data.uColor.value[1] = ((color >> 8) & 0xFF) / 255;
		// data.uColor.value[2] = (color & 0xFF) / 255;
		// data.uColor.value[3] = alpha;
		
		// return __glowShader;
		
		return null;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_alpha (value:Float):Float {
		
		if (value != alpha) __renderDirty = true;
		return this.alpha = value;
		
	}
	
	
	private function set_blurX (value:Float):Float {
		
		if (value != blurX) {
			this.blurX = value;
			__renderDirty = true;
			__leftExtension = (value > 0 ? Math.ceil (value) : 0);
			__rightExtension = __leftExtension;
		}
		return value;
		
	}
	
	
	private function set_blurY (value:Float):Float {
		
		if (value != blurY) {
			this.blurY = value;
			__renderDirty = true;
			__topExtension = (value > 0 ? Math.ceil (value) : 0);
			__bottomExtension = __topExtension;
		}
		return value;
		
	}
	
	
	private function set_color (value:Int):Int {
		
		if (value != color) __renderDirty = true;
		return this.color = value;
		
	}
	
	
	private function set_inner (value:Bool):Bool {
		
		if (value != inner) __renderDirty = true;
		return this.inner = value;
		
	}
	
	
	private function set_knockout (value:Bool):Bool {
		
		if (value != knockout) __renderDirty = true;
		return this.knockout = value;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		// TODO: Quality effect with fewer passes?
		
		horizontalPasses = (blurX <= 0) ? 0 : Math.round (blurX * (value / 4)) + 1;
		verticalPasses = (blurY <= 0) ? 0 : Math.round (blurY * (value / 4)) + 1;
		
		__numShaderPasses = horizontalPasses + verticalPasses;
		
		if (value != quality) __renderDirty = true;
		return this.quality = value;
		
	}
	
	
	private function set_strength (value:Float):Float {
		
		if (value != strength) __renderDirty = true;
		return this.strength = value;
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


private class GlowShader extends Shader {
	
	
	@:glFragmentSource( 
		
		"varying float vAlpha;
		varying vec2 vTexCoord;
		uniform sampler2D uImage0;
		
		uniform vec4 uColor;
		
		varying vec2 vBlurCoords[7];
		
		void main(void) {
			
			float a = 0.0;
			a += texture2D(uImage0, vBlurCoords[0]).a * 0.00443;
			a += texture2D(uImage0, vBlurCoords[1]).a * 0.05399;
			a += texture2D(uImage0, vBlurCoords[2]).a * 0.24197;
			a += texture2D(uImage0, vBlurCoords[3]).a * 0.39894;
			a += texture2D(uImage0, vBlurCoords[4]).a * 0.24197;
			a += texture2D(uImage0, vBlurCoords[5]).a * 0.05399;
			a += texture2D(uImage0, vBlurCoords[6]).a * 0.00443;
			a *= uColor.a;
			
			gl_FragColor = vec4(uColor.rgb * a, a);
			
		}"
		
	)
	
	
	@:glVertexSource(
		
		"attribute float aAlpha;
		attribute vec4 aPosition;
		attribute vec2 aTexCoord;
		varying float vAlpha;
		varying vec2 vTexCoord;
		
		uniform mat4 uMatrix;
		
		uniform vec2 uRadius;
		varying vec2 vBlurCoords[7];
		uniform vec2 uTextureSize;
		
		void main(void) {
			
			vAlpha = aAlpha;
			vTexCoord = aTexCoord;
			gl_Position = uMatrix * aPosition;
			
			vec2 r = uRadius / uTextureSize;
			vBlurCoords[0] = aTexCoord - r * 1.0;
			vBlurCoords[1] = aTexCoord - r * 0.75;
			vBlurCoords[2] = aTexCoord - r * 0.5;
			vBlurCoords[3] = aTexCoord;
			vBlurCoords[4] = aTexCoord + r * 0.5;
			vBlurCoords[5] = aTexCoord + r * 0.75;
			vBlurCoords[6] = aTexCoord + r * 1.0;
			
		}"
		
	)
	
	
	public function new () {
		
		super ();
		
		#if !macro
		data.uRadius.value = [ 0, 0 ];
		data.uColor.value = [ 0, 0, 0, 0 ];
		#end
		
	}
	
	
	private override function __update ():Void {
		
		data.uTextureSize.value = [ data.uImage0.input.width, data.uImage0.input.height ];
		
		super.__update ();
		
	}
	
	
}