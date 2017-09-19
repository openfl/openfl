package openfl.filters;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.filters.commands.*;

class GradientBevelFilter extends GradientFilter {

	private var __highlightBitmapData:BitmapData;
	private var __shadowBitmapData:BitmapData;

	public function new (distance:Float = 4, angle:Float = 45, colors:Array<Int> = null, alphas:Array<Float> = null, ratios:Array<Float> = null, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, type: BitmapFilterType = BitmapFilterType.INNER, knockout:Bool = false) {

		super (distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);

	}


	public override function clone ():BitmapFilter {

		return new GradientBevelFilter (distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);

	}

	public override function dispose(): Void{
		if (__highlightBitmapData != null){
			__highlightBitmapData.dispose();
			__highlightBitmapData = null;
		}

		if (__shadowBitmapData != null){
			__shadowBitmapData.dispose();
			__shadowBitmapData = null;
		}
	}


	private override function __growBounds (rect:Rectangle):Void {

		var offset = Point.pool.get ();
		BitmapFilter.__getOffset(offset, distance, angle);
		var halfBlurX = Math.ceil( (Math.ceil (blurX) - 1) / 2 * quality );
		var halfBlurY = Math.ceil( (Math.ceil (blurY) - 1) / 2 * quality );
		rect.x -= Math.abs (offset.x) + halfBlurX;
		rect.y -= Math.abs (offset.y) + halfBlurY;
		rect.width += 2.0 * (Math.abs (offset.x) + halfBlurX);
		rect.height += 2.0 * (Math.abs (offset.y) + halfBlurY);
		Point.pool.put (offset);

	}

	private override function __getCommands (bitmap:BitmapData):Array<CommandType> {

		var commands:Array<CommandType> = [];
		var src = bitmap;

		if(__highlightBitmapData == null) {
			__highlightBitmapData = @:privateAccess BitmapData.__asRenderTexture ();
		}

		if(__shadowBitmapData == null) {
			__shadowBitmapData = @:privateAccess BitmapData.__asRenderTexture ();
		}

		if (__lookupTextureIsDirty) {
			updateLookupTexture();
			__lookupTextureIsDirty = false;
		}

		@:privateAccess __highlightBitmapData.__resizeTo (bitmap);
		@:privateAccess __shadowBitmapData.__resizeTo (bitmap);

		if ( blurX > 1 || blurY > 1 ) {
			commands.push (Blur1D (__highlightBitmapData, src, blurX, quality, true, 1.0, distance, angle+180));
			commands.push (Blur1D (__shadowBitmapData, src, blurX, quality, true, 1.0, distance, angle));

			commands.push (Blur1D (__highlightBitmapData, __highlightBitmapData, blurY, quality, false, strength, 0.0, 0.0));
			commands.push (Blur1D (__shadowBitmapData, __shadowBitmapData, blurY, quality, false, strength, 0.0, 0.0));
		} else {
			commands.push (Offset (__highlightBitmapData, src, 1.0, distance, angle+180));
			commands.push (Offset (__shadowBitmapData, src, 1.0, distance, angle));
		}

		commands.push ( DestOut( __highlightBitmapData, __highlightBitmapData, __shadowBitmapData));

		if ( knockout && type == BitmapFilterType.FULL) {
			commands.push ( ColorLookup (bitmap, __highlightBitmapData, __lookupTexture));

			return commands;
		} else {
			commands.push ( ColorLookup (__highlightBitmapData, __highlightBitmapData, __lookupTexture));
		}


		switch (type) {
			case BitmapFilterType.INNER:
				if ( knockout ) {
					commands.push (InnerKnockout(bitmap, bitmap, __highlightBitmapData ));
				} else {
					commands.push (CombineInner (bitmap, bitmap, __highlightBitmapData));
				}

			case BitmapFilterType.OUTER:
				if ( knockout ) {
					commands.push (OuterKnockoutTransparency(bitmap, bitmap, __highlightBitmapData, true ));
				} else {
					commands.push (Combine (bitmap, __highlightBitmapData, bitmap));
				}

			case BitmapFilterType.FULL:
				if ( knockout ) {
					throw "knockout && full combination should already have been handled";
				} else {
					commands.push (Combine (bitmap, bitmap, __highlightBitmapData));
				}
		}


		return commands;

	}

}
