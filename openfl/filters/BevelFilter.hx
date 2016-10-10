package openfl.filters; #if !openfl_legacy


import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.filters.commands.*;


@:final class BevelFilter extends BitmapFilter {

	public var angle:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var distance:Float;
	public var highlightAlpha:Float;
	public var highlightColor: Int;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var shadowAlpha:Float;
	public var shadowColor: Int;
	public var strength:Float;
	public var type: BitmapFilterType;

	private var __highlightBitmapDataInner:BitmapData;
	private var __shadowBitmapDataInner:BitmapData;
	private var __highlightBitmapDataOuter:BitmapData;
	private var __shadowBitmapDataOuter:BitmapData;
	private static var __inverseAlphaMatrix = [ 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0, 255.0 ];

	public function new (distance:Float = 4, angle:Float = 45, highlightColor:Int = 0xFFFFFF, highlightAlpha:Float = 1, shadowColor: Int = 0x000000, shadowAlpha: Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, type: BitmapFilterType = BitmapFilterType.INNER, knockout:Bool = false) {

		super ();

		this.distance = distance;
		this.angle = angle;
		this.highlightColor = highlightColor;
		this.highlightAlpha = highlightAlpha;
		this.shadowColor = shadowColor;
		this.shadowAlpha = shadowAlpha;
		this.blurX = blurX;
		this.blurY = blurY;
		this.strength = strength;
		this.quality = quality;
		this.type = type;
		this.knockout = knockout;

	}


	public override function clone ():BitmapFilter {

		return new BevelFilter (distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);

	}

	public override function dispose(): Void{
		if (__highlightBitmapDataInner != null){
			__highlightBitmapDataInner.dispose();
			__highlightBitmapDataInner = null;
		}
		if (__shadowBitmapDataInner != null){
			__shadowBitmapDataInner.dispose();
			__shadowBitmapDataInner = null;
		}
		if (__highlightBitmapDataOuter != null){
			__highlightBitmapDataOuter.dispose();
			__highlightBitmapDataOuter = null;
		}
		if (__shadowBitmapDataOuter != null){
			__shadowBitmapDataOuter.dispose();
			__shadowBitmapDataOuter = null;
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

		if (type != BevelFilterType.OUTER ) {
			if(__highlightBitmapDataInner == null)
				__highlightBitmapDataInner = @:privateAccess BitmapData.__asRenderTexture ();
			if(__shadowBitmapDataInner == null)
				__shadowBitmapDataInner = @:privateAccess BitmapData.__asRenderTexture ();

			@:privateAccess __highlightBitmapDataInner.__resize(bitmap.width, bitmap.height);
			@:privateAccess __shadowBitmapDataInner.__resize(bitmap.width, bitmap.height);

			// create 2 dropshadow filters.
			commands.push (ColorTransform (__highlightBitmapDataInner, bitmap, __inverseAlphaMatrix));
			commands.push (ColorTransform (__shadowBitmapDataInner, bitmap, __inverseAlphaMatrix));

			for( quality_index in 0...quality ) {
				var first_pass = quality_index == 0;

				if (first_pass) {
					commands.push (Blur1D (__highlightBitmapDataInner, src, blurX, true, 1.0, distance, angle));
					commands.push (Blur1D (__shadowBitmapDataInner, src, blurX, true, 1.0, distance, angle+180));
				}
				else {
					commands.push (Blur1D (__highlightBitmapDataInner, __highlightBitmapDataInner, blurX, true, 1.0, 0.0, 0.0));
					commands.push (Blur1D (__shadowBitmapDataInner, __shadowBitmapDataInner, blurX, true, 1.0, 0.0, 0.0));
				}

				commands.push (Blur1D (__highlightBitmapDataInner, __highlightBitmapDataInner, blurY, false, quality_index == quality - 1 ? strength : 1.0, 0.0, 0.0));
				commands.push (Blur1D (__shadowBitmapDataInner, __shadowBitmapDataInner, blurY, false, quality_index == quality - 1 ? strength : 1.0, 0.0, 0.0));
			}

			commands.push (Colorize (__highlightBitmapDataInner, __highlightBitmapDataInner, highlightColor, highlightAlpha));
			commands.push (Colorize (__shadowBitmapDataInner, __shadowBitmapDataInner, shadowColor, shadowAlpha));

			if ( knockout ) {
				throw ":TODO:";
				//commands.push (Knockout(bitmap, bitmap, __shadowBitmapDataInner, !inner ));
			}

		}

		if (type != BevelFilterType.INNER ) {
			if(__highlightBitmapDataOuter == null)
				__highlightBitmapDataOuter = @:privateAccess BitmapData.__asRenderTexture ();
			if(__shadowBitmapDataOuter == null)
				__shadowBitmapDataOuter = @:privateAccess BitmapData.__asRenderTexture ();

			@:privateAccess __highlightBitmapDataOuter.__resize(bitmap.width, bitmap.height);
			@:privateAccess __shadowBitmapDataOuter.__resize(bitmap.width, bitmap.height);

			// create 2 dropshadow filters.

			for( quality_index in 0...quality ) {
				var first_pass = quality_index == 0;

				if (first_pass) {
					commands.push (Blur1D (__highlightBitmapDataOuter, src, blurX, true, 1.0, distance, angle+180));
					commands.push (Blur1D (__shadowBitmapDataOuter, src, blurX, true, 1.0, distance, angle));
				}
				else {
					commands.push (Blur1D (__highlightBitmapDataOuter, __highlightBitmapDataOuter, blurX, true, 1.0, 0.0, 0.0));
					commands.push (Blur1D (__shadowBitmapDataOuter, __shadowBitmapDataOuter, blurX, true, 1.0, 0.0, 0.0));
				}

				commands.push (Blur1D (__highlightBitmapDataOuter, __highlightBitmapDataOuter, blurY, false, quality_index == quality - 1 ? strength : 1.0, 0.0, 0.0));
				commands.push (Blur1D (__shadowBitmapDataOuter, __shadowBitmapDataOuter, blurY, false, quality_index == quality - 1 ? strength : 1.0, 0.0, 0.0));
			}

			commands.push (Colorize (__highlightBitmapDataOuter, __highlightBitmapDataOuter, highlightColor, highlightAlpha));
			commands.push (Colorize (__shadowBitmapDataOuter, __shadowBitmapDataOuter, shadowColor, shadowAlpha));

			if ( knockout ) {
				throw ":TODO:";
				//commands.push (Knockout(bitmap, bitmap, __shadowBitmapDataOuter, !inner ));
			}
		}

		// :NOTE: Probably the shadows should be drawn on top of the bitmap, so the arguments here should be inversed I think
		switch type {
		case BitmapFilterType.INNER:
			commands.push (CombineInner (bitmap, bitmap, __shadowBitmapDataInner));
			commands.push (CombineInner (bitmap, bitmap, __highlightBitmapDataInner));
		case BitmapFilterType.OUTER:
			commands.push (Combine (bitmap, __shadowBitmapDataOuter, bitmap));
			commands.push (Combine (bitmap, __highlightBitmapDataOuter, bitmap));
		case BitmapFilterType.FULL:
			commands.push (CombineInner (bitmap, bitmap, __shadowBitmapDataInner));
			commands.push (CombineInner (bitmap, bitmap, __highlightBitmapDataInner));
			commands.push (Combine (bitmap, __shadowBitmapDataOuter, bitmap));
			commands.push (Combine (bitmap, __highlightBitmapDataOuter, bitmap));
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
typedef BevelFilter = openfl._legacy.filters.BevelFilter;
#end
