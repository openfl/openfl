package openfl.filters; #if !openfl_legacy


import openfl.display.BitmapData;
import openfl.filters.commands.*;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;


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

	private var __highlightBitmapData:BitmapData;
	private var __clonedHighlightBitmapData:BitmapData;
	private var __shadowBitmapData:BitmapData;
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
	}


	private override function __growBounds (rect:Rectangle, transform:Matrix):Void {

		var offset = Point.pool.get ();
		BitmapFilter._getTransformedOffset(offset, distance, angle, transform);
		var halfBlurX = Math.ceil( blurX * 0.5 * quality );
		var halfBlurY = Math.ceil( blurY * 0.5 * quality );
		rect.x -= Math.abs (offset.x) + halfBlurX;
		rect.y -= Math.abs (offset.y) + halfBlurY;
		rect.width += 2.0 * (Math.abs (offset.x) + halfBlurX);
		rect.height += 2.0 * (Math.abs (offset.y) + halfBlurY);

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

		@:privateAccess __highlightBitmapData.__resize(bitmap.width, bitmap.height);
		@:privateAccess __shadowBitmapData.__resize(bitmap.width, bitmap.height);
		@:privateAccess __clonedHighlightBitmapData.__resize(bitmap.width, bitmap.height);

		// create 2 dropshadow filters.
		commands.push (ColorTransform (__clonedHighlightBitmapData, bitmap, __inverseAlphaMatrix));
		commands.push (ColorTransform (__shadowBitmapData, bitmap, __inverseAlphaMatrix));

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

		commands.push (Colorize (__highlightBitmapData, __highlightBitmapData, highlightColor, highlightAlpha));
		commands.push (Colorize (__shadowBitmapData, __shadowBitmapData, shadowColor, shadowAlpha));


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
typedef BevelFilter = openfl._legacy.filters.BevelFilter;
#end
