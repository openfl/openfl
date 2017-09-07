package openfl.filters;

import openfl.display.BitmapData;
import openfl.filters.commands.*;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:final class GradientGlowFilter extends GradientFilter {

	private var __glowBitmapData:BitmapData;

	public function new (distance:Float = 4, angle:Float = 45, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Float>, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, type:BitmapFilterType = BitmapFilterType.INNER, knockout:Bool = false) {

		super (distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);

	}


	public override function clone ():BitmapFilter {

		return new GradientGlowFilter (distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);

	}

	public override function dispose(): Void{
		if (__glowBitmapData != null){
			__glowBitmapData.dispose();
			__glowBitmapData = null;
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

		if(__glowBitmapData==null)
			__glowBitmapData = @:privateAccess BitmapData.__asRenderTexture ();

		if (__lookupTextureIsDirty) {

			updateLookupTexture();
			__lookupTextureIsDirty = false;

		}

		@:privateAccess __glowBitmapData.__resizeTo (bitmap);

		commands.push (Blur1D (__glowBitmapData, bitmap, blurX, quality, true, 1.0, distance, angle));
		commands.push (Blur1D (__glowBitmapData, __glowBitmapData, blurY, quality, false, strength, 0.0, 0.0));

		commands.push (ColorLookup (__glowBitmapData, __glowBitmapData, __lookupTexture));

		switch (type) {

			case BitmapFilterType.FULL:
				commands.push (Combine (bitmap, bitmap, __glowBitmapData));

			case BitmapFilterType.INNER:
				commands.push (CombineInner (bitmap, bitmap, __glowBitmapData));

			case BitmapFilterType.OUTER:
				commands.push (Combine (bitmap, __glowBitmapData, bitmap));

			default:

		}

		return commands;

	}
}
