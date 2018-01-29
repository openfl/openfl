package openfl.filters;


import lime.graphics.utils.ImageDataUtil;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Shader;
import openfl.filters.BitmapFilter;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)


@:final class BlurFilter extends BitmapFilter {
	
	
	//private static var __blurShader = new BlurShader ();
	
	public var blurX (get, set):Float;
	public var blurY (get, set):Float;
	public var quality (get, set):Int;
	
	private var __blurX:Float;
	private var __blurY:Float;
	private var __horizontalPasses:Int;
	private var __quality:Int;
	private var __verticalPasses:Int;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (BlurFilter.prototype, {
			"blurX": { get: untyped __js__ ("function () { return this.get_blurX (); }"), set: untyped __js__ ("function (v) { return this.set_blurX (v); }") },
			"blurY": { get: untyped __js__ ("function () { return this.get_blurY (); }"), set: untyped __js__ ("function (v) { return this.set_blurY (v); }") },
			"quality": { get: untyped __js__ ("function () { return this.get_quality (); }"), set: untyped __js__ ("function (v) { return this.set_quality (v); }") },
		});
		
	}
	#end
	
	
	public function new (blurX:Float = 4, blurY:Float = 4, quality:Int = 1) {
		
		super ();
		
		this.blurX = blurX;
		this.blurY = blurY;
		this.quality = quality;
		
		__needSecondBitmapData = true;
		__preserveObject = false;
		__renderDirty = true;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new BlurFilter (__blurX, __blurY, __quality);
		
	}
	
	
	private override function __applyFilter (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {
		
		var finalImage = ImageDataUtil.gaussianBlur (bitmapData.image, sourceBitmapData.image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), __blurX, __blurY, __quality);
		if (finalImage == bitmapData.image) return bitmapData;
		return sourceBitmapData;
		
	}
	
	
	private override function __initShader (renderSession:RenderSession, pass:Int):Shader {
		
		// var data = __blurShader.data;
		
		// if (pass <= horizontalPasses) {
			
		// 	var scale = Math.pow (0.5, pass >> 1);
		// 	data.uRadius.value[0] = blurX * scale;
		// 	data.uRadius.value[1] = 0;
			
		// } else {
			
		// 	var scale = Math.pow (0.5, (pass - horizontalPasses) >> 1);
		// 	data.uRadius.value[0] = 0;
		// 	data.uRadius.value[1] = blurY * scale;
			
		// }
		
		// return __blurShader;
		
		return null;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_blurX ():Float {
		
		return __blurX;
		
	}
	
	
	private function set_blurX (value:Float):Float {
		
		if (value != __blurX) {
			__blurX = value;
			__renderDirty = true;
			__leftExtension = (value > 0 ? Math.ceil (value) : 0);
			__rightExtension = __leftExtension;
		}
		return value;
		
	}
	
	
	private function get_blurY ():Float {
		
		return __blurY;
		
	}
	
	
	private function set_blurY (value:Float):Float {
		
		if (value != __blurY) {
			__blurY = value;
			__renderDirty = true;
			__topExtension = (value > 0 ? Math.ceil (value) : 0);
			__bottomExtension = __topExtension;
		}
		return value;
		
	}
	
	
	private function get_quality ():Int {
		
		return __quality;
		
	}
	
	
	private function set_quality (value:Int):Int {
		
		// TODO: Quality effect with fewer passes?
		
		__horizontalPasses = (__blurX <= 0) ? 0 : Math.round (__blurX * (value / 4)) + 1;
		__verticalPasses = (__blurY <= 0) ? 0 : Math.round (__blurY * (value / 4)) + 1;
		
		__numShaderPasses = __horizontalPasses + __verticalPasses;
		
		if (value != __quality) __renderDirty = true;
		return __quality = value;
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


private class BlurShader extends Shader {
	
	
	@:glFragmentSource( 
		
		"varying float vAlpha;
		varying vec2 vTexCoord;
		uniform sampler2D uImage0;
		
		varying vec2 vBlurCoords[7];
		
		void main(void) {
			
			vec4 sum = vec4(0.0);
			sum += texture2D(uImage0, vBlurCoords[0]) * 0.00443;
			sum += texture2D(uImage0, vBlurCoords[1]) * 0.05399;
			sum += texture2D(uImage0, vBlurCoords[2]) * 0.24197;
			sum += texture2D(uImage0, vBlurCoords[3]) * 0.39894;
			sum += texture2D(uImage0, vBlurCoords[4]) * 0.24197;
			sum += texture2D(uImage0, vBlurCoords[5]) * 0.05399;
			sum += texture2D(uImage0, vBlurCoords[6]) * 0.00443;
			
			gl_FragColor = sum;
			
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
		#end
		
	}
	
	
	private override function __update ():Void {
		
		data.uTextureSize.value = [ data.uImage0.input.width, data.uImage0.input.height ];
		
		super.__update ();
		
	}
	
	
}