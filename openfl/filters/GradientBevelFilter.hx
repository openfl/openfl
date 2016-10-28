package openfl.filters; #if !openfl_legacy

import lime.math.color.ARGB;

import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.filters.commands.*;


@:final class GradientBevelFilter extends BitmapFilter {

	public var angle:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var distance:Float;
	public var colors:Array<Int>;
	public var alphas: Array<Float>;
	public var ratios:Array<Float>;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength:Float;
	public var type: BitmapFilterType;

	private var __lookupTextureIsDirty:Bool = true;
	private var __lookupTexture:BitmapData;
	private var __highlightBitmapData:BitmapData;
	private var __clonedHighlightBitmapData:BitmapData;
	private var __shadowBitmapData:BitmapData;

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


	public override function clone ():BitmapFilter {

		return new GradientBevelFilter (distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);

	}

	public override function dispose(): Void{
		if (__highlightBitmapData != null){
			__highlightBitmapData.dispose();
			__highlightBitmapData = null;
		}
		if (__clonedHighlightBitmapData != null){
			__clonedHighlightBitmapData.dispose();
			__clonedHighlightBitmapData = null;
		}
		if (__shadowBitmapData != null){
			__shadowBitmapData.dispose();
			__shadowBitmapData = null;
		}
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

		for( x in 0...__lookupTexture.width ) {
			var ratio = (x + 0.5) / __lookupTexture.width;

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

			for( y in 0...__lookupTexture.height ) {

				__lookupTexture.setPixel32(x, y, color);

			}

		}

	}

	private override function __growBounds (rect:Rectangle):Void {

		var halfBlurX = Math.ceil( blurX * 0.5 * quality );
		var halfBlurY = Math.ceil( blurY * 0.5 * quality );
		var sX = distance * Math.cos (angle * Math.PI / 180);
		var sY = distance * Math.sin (angle * Math.PI / 180);
		rect.x -= Math.abs (sX) + halfBlurX;
		rect.y -= Math.abs (sY) + halfBlurY;
		rect.width += 2.0 * (Math.abs (sX) + halfBlurX);
		rect.height += 2.0 * (Math.abs (sY) + halfBlurY);

	}

	private override function __getCommands (bitmap:BitmapData):Array<CommandType> {

		var commands:Array<CommandType> = [];
		var src = bitmap;

		if(__highlightBitmapData == null)
			__highlightBitmapData = @:privateAccess BitmapData.__asRenderTexture ();
		if(__shadowBitmapData == null)
			__shadowBitmapData = @:privateAccess BitmapData.__asRenderTexture ();
		if ( __clonedHighlightBitmapData == null )
			__clonedHighlightBitmapData = @:privateAccess BitmapData.__asRenderTexture ();

		if (__lookupTextureIsDirty) {

			updateLookupTexture();
			__lookupTextureIsDirty = false;

		}

		@:privateAccess __highlightBitmapData.__resize(bitmap.width, bitmap.height);
		@:privateAccess __shadowBitmapData.__resize(bitmap.width, bitmap.height);
		@:privateAccess __clonedHighlightBitmapData.__resize(bitmap.width, bitmap.height);

		if ( blurX > 1 || blurY > 1 ) {
			for( quality_index in 0...quality ) {
				var first_pass = quality_index == 0;

				if (first_pass) {
					commands.push (Blur1D (__clonedHighlightBitmapData, src, blurX, true, 1.0, distance, angle));
					commands.push (Blur1D (__shadowBitmapData, src, blurX, true, 1.0, distance, angle+180));
				}
				else {
					commands.push (Blur1D (__clonedHighlightBitmapData, __clonedHighlightBitmapData, blurX, true, 1.0, 0.0, 0.0));
					commands.push (Blur1D (__shadowBitmapData, __shadowBitmapData, blurX, true, 1.0, 0.0, 0.0));
				}

				commands.push (Blur1D (__clonedHighlightBitmapData, __clonedHighlightBitmapData, blurY, false, quality_index == quality - 1 ? strength : 1.0, 0.0, 0.0));
				commands.push (Blur1D (__shadowBitmapData, __shadowBitmapData, blurY, false, quality_index == quality - 1 ? strength : 1.0, 0.0, 0.0));
			}
		} else {
			commands.push (Offset (__clonedHighlightBitmapData, src, 1.0, distance, angle));
			commands.push (Offset (__shadowBitmapData, src, 1.0, distance, angle+180));
		}


		commands.push ( DestOut( __highlightBitmapData, __shadowBitmapData, __clonedHighlightBitmapData));
		commands.push ( DestOut( __shadowBitmapData, __clonedHighlightBitmapData, __shadowBitmapData ));

		commands.push ( ColorLookup (__highlightBitmapData, __highlightBitmapData, __lookupTexture));
		commands.push ( ColorLookup (__shadowBitmapData, __shadowBitmapData, __lookupTexture));

		switch type {
		case BitmapFilterType.INNER:
			if ( knockout ) {
				commands.push (Combine(__highlightBitmapData, __highlightBitmapData, __shadowBitmapData));
				commands.push (InnerKnockout(bitmap, bitmap, __highlightBitmapData ));
			} else {
				commands.push (CombineInner (bitmap, bitmap, __shadowBitmapData));
				commands.push (CombineInner (bitmap, bitmap, __highlightBitmapData));
			}
		case BitmapFilterType.OUTER:
			if ( knockout ) {
				commands.push (Combine(__highlightBitmapData, __highlightBitmapData, __shadowBitmapData));
				commands.push (OuterKnockoutTransparency(bitmap, bitmap, __highlightBitmapData, true ));
			} else {
				commands.push (Combine (bitmap, __shadowBitmapData, bitmap));
				commands.push (Combine (bitmap, __highlightBitmapData, bitmap));
			}
		case BitmapFilterType.FULL:
			if ( knockout ) {
				commands.push (Combine(bitmap, __highlightBitmapData, __shadowBitmapData));
			} else {
				commands.push (CombineInner (bitmap, bitmap, __shadowBitmapData));
				commands.push (CombineInner (bitmap, bitmap, __highlightBitmapData));
				commands.push (Combine (bitmap, __shadowBitmapData, bitmap));
				commands.push (Combine (bitmap, __highlightBitmapData, bitmap));
			}
		}


		return commands;

	}

	// Get & Set Methods




	private function set_knockout (value:Bool):Bool {

		return knockout = value;

	}


	private function set_quality (value:Int):Int {

		__passes = value * 2 + 1;
		return quality = value;

	}


}

#else
typedef GradientBevelFilter = openfl._legacy.filters.GradientBevelFilter;
#end
