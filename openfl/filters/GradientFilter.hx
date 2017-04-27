package openfl.filters;

import lime.math.color.ARGB;
import openfl.display.BitmapData;

class GradientFilter extends BitmapFilter {

	public var angle:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var colors:Array<Int>; // :TODO: use setter to invalidate and regenerate lookup texture
	public var alphas:Array<Float>; // :TODO: use setter to invalidate and regenerate lookup texture
	public var ratios:Array<Float>; // :TODO: use setter to invalidate and regenerate lookup texture
	public var distance:Float;
	public var type:BitmapFilterType;
	public var knockout:Bool;
	public var quality:Int;
	public var strength:Float;
	
	private var __lookupTextureIsDirty:Bool = true;
	private var __lookupTexture:BitmapData;


	public function new (distance:Float = 4, angle:Float = 45, colors:Array<Int> = null, alphas:Array<Float> = null, ratios:Array<Float> = null, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, type: BitmapFilterType = BitmapFilterType.INNER, knockout:Bool = false) {

		super ();

		this.distance = distance;
		this.angle = angle;
		this.colors = colors;
		this.alphas = alphas;
		this.ratios = ratios;
		this.blurX = blurX;
		this.blurY = blurY;
		this.strength = strength;
		this.quality = quality;
		this.type = type;
		this.knockout = knockout;
	}


	public override function dispose(): Void{
		if (__lookupTexture != null){
			__lookupTexture.dispose();
			__lookupTexture = null;
			__lookupTextureIsDirty = true;
		}
	}

	private function updateLookupTexture():Void {

		inline function alpha(color:UInt):Float {
			return (color >>> 24) / 255;
		}

		inline function rgb(color:UInt):UInt {
			return (color & 0xffffff);
		}

		inline function ri(color:UInt):UInt {
			return ((rgb(color) >> 16) & 0xff);
		}

		inline function gi(color:UInt):UInt {
			return ((rgb(color) >> 8) & 0xff);
		}

		inline function bi(color:UInt):UInt {
			return (rgb(color) & 0xff);
		}

		inline function r(color:UInt):Float {
			return ((rgb(color) >> 16) & 0xff) / 255;
		}

		inline function g(color:UInt):Float {
			return ((rgb(color) >> 8) & 0xff) / 255;
		}

		inline function b(color:UInt):Float {
			return (rgb(color) & 0xff) / 255;
		}

		inline function interpolate(color1:UInt, color2:UInt, ratio:Float):UInt {
			var r1:Float = r(color1);
			var g1:Float = g(color1);
			var b1:Float = b(color1);
			var alpha1:Float = alpha(color1);
			var ri:Int = Std.int((r1 + (r(color2) - r1) * ratio) * 255);
			var gi:Int = Std.int((g1 + (g(color2) - g1) * ratio) * 255);
			var bi:Int = Std.int((b1 + (b(color2) - b1) * ratio) * 255);
			var alphai:Int = Std.int((alpha1 + (alpha(color2) - alpha1) * ratio) * 255);
			return bi | (gi << 8) | (ri << 16) | (alphai << 24);
		}

		if (__lookupTexture == null ){
			__lookupTexture = new BitmapData (256, 1);
		}

		var upperBoundIndex = 0;
		var lowerBound = 0.0;
		var upperBound = Math.max(Math.min(ratios[0] / 0xFF, 1.0),0.0);
		var lowerBoundColor = ARGB.create(Math.round(alphas[0] * 255), ri(colors[0]), gi(colors[0]), bi(colors[0]));
		var upperBoundColor = ARGB.create(Math.round(alphas[0] * 255), ri(colors[0]), gi(colors[0]), bi(colors[0]));
		var width = __lookupTexture.physicalWidth;

		for( x in 0...width ) {
			var ratio = (x + 0.5) / width;

			if (ratio > upperBound) {

				while (ratio > upperBound ) {
					if ( upperBoundIndex < ratios.length - 1) {
						++upperBoundIndex;
						upperBound = Math.max(Math.min(ratios[upperBoundIndex] / 0xFF, 1.0),0.0);
					} else {
						upperBound = 1.0;
					}
				}

				var lowerBoundIndex = upperBoundIndex == 0 ? 0 : upperBoundIndex - 1;
				upperBoundColor.set(Math.round(alphas[upperBoundIndex] * 255), ri(colors[upperBoundIndex]), gi(colors[upperBoundIndex]), bi(colors[upperBoundIndex]));
				lowerBoundColor.set(Math.round(alphas[lowerBoundIndex] * 255), ri(colors[lowerBoundIndex]), gi(colors[lowerBoundIndex]), bi(colors[lowerBoundIndex]));
				lowerBound = Math.max(Math.min(ratios[lowerBoundIndex] / 0xFF, 1.0),0.0);

			}

			var lerpFactor = (ratio - lowerBound) / (upperBound - lowerBound);
			var color:ARGB = interpolate(lowerBoundColor, upperBoundColor, lerpFactor);

			for( y in 0...__lookupTexture.physicalHeight ) {

				__lookupTexture.setPixel32(x, y, color);

			}

		}

	}

}
