package openfl.filters; #if !openfl_legacy


import openfl.display.BitmapData;
import openfl.filters.commands.*;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import openfl.utils.Float32ArrayContainer;


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

	private var __shadowBitmapData:BitmapData;
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

	}


	public override function clone ():BitmapFilter {

		return new DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);

	}

	public override function dispose(): Void{
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

		if(__shadowBitmapData == null)
			__shadowBitmapData = @:privateAccess BitmapData.__asRenderTexture ();

		@:privateAccess __shadowBitmapData.__resizeTo (bitmap);

		if (inner) {
			commands.push (ColorTransform (__shadowBitmapData, bitmap, BitmapFilter.__inverseAlphaMultipliers, BitmapFilter.__inverseAlphaOffsets));
			src = __shadowBitmapData;
		}

		if ( blurX > 1 || blurY > 1 ) {
			commands.push (Blur1D (__shadowBitmapData, src, blurX, quality, true, 1.0, distance, angle));
			commands.push (Blur1D (__shadowBitmapData, __shadowBitmapData, blurY, quality, false, strength, 0.0, 0.0));
		} else {
			commands.push (Offset (__shadowBitmapData, src, strength, distance, angle));
		}

		if ( hideObject && !knockout && !inner ) {

			commands.push (Colorize (bitmap, __shadowBitmapData, color, alpha));
			return commands;
		}

		commands.push (Colorize (__shadowBitmapData, __shadowBitmapData, color, alpha));

		if (inner) {

			if ( knockout || hideObject ) {

				commands.push (InnerKnockout(bitmap, bitmap, __shadowBitmapData));

			} else {

				commands.push (CombineInner (bitmap, bitmap, __shadowBitmapData));

			}

		} else {

			if ( knockout ) {

				commands.push (OuterKnockout(bitmap, bitmap, __shadowBitmapData));

			} else if ( !hideObject ) {

				commands.push (Combine (bitmap, __shadowBitmapData, bitmap));

			} else {

				throw "hideObject && !knockout && !inner combination should already have been handled";

			}

		}

		return commands;

	}

	// Get & Set Methods




	private function set_knockout (value:Bool):Bool {

		return knockout = value;

	}


	private function set_hideObject (value:Bool):Bool {

		return hideObject = value;

	}


	private function set_quality (value:Int):Int {

		return quality = value;

	}


}

#else
typedef DropShadowFilter = openfl._legacy.filters.DropShadowFilter;
#end
