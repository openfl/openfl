package openfl.filters; #if !openfl_legacy


import openfl.display.BitmapData;
import openfl.filters.commands.*;
import openfl.geom.Rectangle;


@:final class GlowFilter extends BitmapFilter {

	public var alpha:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var inner:Bool;
	public var knockout (default, set):Bool;
	public var quality (default, set):Int;
	public var strength:Float;

	private var __glowBitmapData:BitmapData;
	public function new (color:Int = 0xFF0000, alpha:Float = 1, blurX:Float = 6, blurY:Float = 6, strength:Float = 2, quality:Int = 1, inner:Bool = false, knockout:Bool = false) {

		super ();

		if (blurX == 0) {
			blurX = 1;
		}
		if (blurY == 0) {
			blurY = 1;
		}

		this.color = color;
		this.alpha = alpha;
		this.blurX = blurX;
		this.blurY = blurY;
		this.strength = strength;
		this.quality = quality;
		this.inner = inner;
		this.knockout = knockout;
	}


	public override function clone ():BitmapFilter {

		return new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout);

	}

	public override function dispose(): Void{
		if (__glowBitmapData != null){
			__glowBitmapData.dispose();
			__glowBitmapData = null;
		}
	}

	public override function equals(filter:BitmapFilter) {
		if ( Std.is(filter, GlowFilter) ) {
			var otherFilter:GlowFilter = cast filter;
			return this.color == otherFilter.color && this.alpha == otherFilter.alpha && this.blurX == otherFilter.blurX
				&& this.blurY == otherFilter.blurY && this.strength == otherFilter.strength && this.quality == otherFilter.quality
				&& this.inner == otherFilter.inner && this.knockout && otherFilter.knockout;
		}
		return false;
	}


	private override function __growBounds (rect:Rectangle):Void {

		var halfBlurX = Math.ceil( (Math.ceil (blurX) - 1) / 2 * quality );
		var halfBlurY = Math.ceil( (Math.ceil (blurY) - 1) / 2 * quality );

		rect.x += -halfBlurX;
		rect.y += -halfBlurY;
		rect.width += 2.0 * halfBlurX;
		rect.height += 2.0 * halfBlurY;
	}


	private override function __getCommands (bitmap:BitmapData):Array<CommandType> {

		if(__glowBitmapData==null)
			__glowBitmapData = @:privateAccess BitmapData.__asRenderTexture ();

		var commands:Array<CommandType> = [];
		var src = bitmap;

		@:privateAccess __glowBitmapData.__resizeTo (bitmap);

		if (inner) {
			commands.push (ColorTransform (__glowBitmapData, bitmap, BitmapFilter.__inverseAlphaMultipliers, BitmapFilter.__inverseAlphaOffsets));

			src = __glowBitmapData;
		}

		commands.push (Blur1D (__glowBitmapData, src, blurX, quality, true, 1.0, 0.0, 0.0));
		commands.push (Blur1D (__glowBitmapData, __glowBitmapData, blurY, quality, false, strength, 0.0, 0.0));

		commands.push (Colorize (__glowBitmapData, __glowBitmapData, color, alpha));

		if (knockout) {
			if ( inner ) {
				commands.push (InnerKnockout(bitmap, bitmap, __glowBitmapData));
			} else {
				commands.push (OuterKnockout(bitmap, bitmap, __glowBitmapData));
			}
		}
		else if (inner) {

			commands.push (CombineInner (bitmap, bitmap, __glowBitmapData));

		}
		else {

			commands.push (Combine (bitmap, __glowBitmapData, bitmap));

		}

		return commands;

	}



	// Get & Set Methods




	private function set_knockout (value:Bool):Bool {

		return knockout = value;

	}


	private function set_quality (value:Int):Int {

		return quality = value;

	}


}

#else
typedef GlowFilter = openfl._legacy.filters.GlowFilter;
#end
