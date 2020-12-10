package openfl.geom;

#if !flash
import openfl._internal.utils.ObjectPool;
#if lime
import openfl._internal.utils.Float32Array;
import lime.math.ColorMatrix;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ColorTransform
{
	#if lime
	@:noCompletion private static var __limeColorMatrix:Float32Array;
	#end
	@:noCompletion private static var __pool:ObjectPool<ColorTransform> = new ObjectPool<ColorTransform>(function() return new ColorTransform(),
		function(ct) ct.__identity());

	public var alphaMultiplier:Float;
	public var alphaOffset:Float;
	public var blueMultiplier:Float;
	public var blueOffset:Float;
	public var color(get, set):Int;
	public var greenMultiplier:Float;
	public var greenOffset:Float;
	public var redMultiplier:Float;
	public var redOffset:Float;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(ColorTransform.prototype, "color", {
			get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_color (); }"),
			set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_color (v); }")
		});
	}
	#end

	public function new(redMultiplier:Float = 1, greenMultiplier:Float = 1, blueMultiplier:Float = 1, alphaMultiplier:Float = 1, redOffset:Float = 0,
			greenOffset:Float = 0, blueOffset:Float = 0, alphaOffset:Float = 0):Void
	{
		this.redMultiplier = redMultiplier;
		this.greenMultiplier = greenMultiplier;
		this.blueMultiplier = blueMultiplier;
		this.alphaMultiplier = alphaMultiplier;
		this.redOffset = redOffset;
		this.greenOffset = greenOffset;
		this.blueOffset = blueOffset;
		this.alphaOffset = alphaOffset;
	}

	public function concat(second:ColorTransform):Void
	{
		redOffset = second.redOffset * redMultiplier + redOffset;
		greenOffset = second.greenOffset * greenMultiplier + greenOffset;
		blueOffset = second.blueOffset * blueMultiplier + blueOffset;
		alphaOffset = second.alphaOffset * alphaMultiplier + alphaOffset;

		redMultiplier *= second.redMultiplier;
		greenMultiplier *= second.greenMultiplier;
		blueMultiplier *= second.blueMultiplier;
		alphaMultiplier *= second.alphaMultiplier;
	}

	public function toString():String
	{
		return
			'(redMultiplier=$redMultiplier, greenMultiplier=$greenMultiplier, blueMultiplier=$blueMultiplier, alphaMultiplier=$alphaMultiplier, redOffset=$redOffset, greenOffset=$greenOffset, blueOffset=$blueOffset, alphaOffset=$alphaOffset)';
	}

	@:noCompletion private function __clone():ColorTransform
	{
		return new ColorTransform(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
	}

	@:noCompletion private function __copyFrom(ct:ColorTransform):Void
	{
		redMultiplier = ct.redMultiplier;
		greenMultiplier = ct.greenMultiplier;
		blueMultiplier = ct.blueMultiplier;
		alphaMultiplier = ct.alphaMultiplier;

		redOffset = ct.redOffset;
		greenOffset = ct.greenOffset;
		blueOffset = ct.blueOffset;
		alphaOffset = ct.alphaOffset;
	}

	@:noCompletion private function __combine(ct:ColorTransform):Void
	{
		redMultiplier *= ct.redMultiplier;
		greenMultiplier *= ct.greenMultiplier;
		blueMultiplier *= ct.blueMultiplier;
		alphaMultiplier *= ct.alphaMultiplier;

		redOffset += ct.redOffset;
		greenOffset += ct.greenOffset;
		blueOffset += ct.blueOffset;
		alphaOffset += ct.alphaOffset;
	}

	@:noCompletion private function __identity():Void
	{
		redMultiplier = 1;
		greenMultiplier = 1;
		blueMultiplier = 1;
		alphaMultiplier = 1;
		redOffset = 0;
		greenOffset = 0;
		blueOffset = 0;
		alphaOffset = 0;
	}

	@:noCompletion private function __invert():Void
	{
		redMultiplier = redMultiplier != 0 ? 1 / redMultiplier : 1;
		greenMultiplier = greenMultiplier != 0 ? 1 / greenMultiplier : 1;
		blueMultiplier = blueMultiplier != 0 ? 1 / blueMultiplier : 1;
		alphaMultiplier = alphaMultiplier != 0 ? 1 / alphaMultiplier : 1;
		redOffset = -redOffset;
		greenOffset = -greenOffset;
		blueOffset = -blueOffset;
		alphaOffset = -alphaOffset;
	}

	@:noCompletion private function __equals(ct:ColorTransform, ignoreAlphaMultiplier:Bool):Bool
	{
		return (ct != null
			&& redMultiplier == ct.redMultiplier
			&& greenMultiplier == ct.greenMultiplier
			&& blueMultiplier == ct.blueMultiplier
			&& (ignoreAlphaMultiplier || alphaMultiplier == ct.alphaMultiplier)
			&& redOffset == ct.redOffset
			&& greenOffset == ct.greenOffset
			&& blueOffset == ct.blueOffset
			&& alphaOffset == ct.alphaOffset);
	}

	@:noCompletion private function __isDefault(ignoreAlphaMultiplier:Bool):Bool
	{
		if (ignoreAlphaMultiplier)
		{
			return (redMultiplier == 1
				&& greenMultiplier == 1
				&& blueMultiplier == 1
				&& /*alphaMultiplier == 1 &&*/ redOffset == 0
				&& greenOffset == 0
				&& blueOffset == 0
				&& alphaOffset == 0);
		}
		else
		{
			return (redMultiplier == 1 && greenMultiplier == 1 && blueMultiplier == 1 && alphaMultiplier == 1 && redOffset == 0 && greenOffset == 0
				&& blueOffset == 0 && alphaOffset == 0);
		}
	}

	@:noCompletion private function __setArrays(colorMultipliers:Array<Float>, colorOffsets:Array<Float>):Void
	{
		colorMultipliers[0] = redMultiplier;
		colorMultipliers[1] = greenMultiplier;
		colorMultipliers[2] = blueMultiplier;
		colorMultipliers[3] = alphaMultiplier;
		colorOffsets[0] = redOffset;
		colorOffsets[1] = greenOffset;
		colorOffsets[2] = blueOffset;
		colorOffsets[3] = alphaOffset;
	}

	// Getters & Setters
	@:noCompletion private function get_color():Int
	{
		return ((Std.int(redOffset) << 16) | (Std.int(greenOffset) << 8) | Std.int(blueOffset));
	}

	@:noCompletion private function set_color(value:Int):Int
	{
		redOffset = (value >> 16) & 0xFF;
		greenOffset = (value >> 8) & 0xFF;
		blueOffset = value & 0xFF;

		redMultiplier = 0;
		greenMultiplier = 0;
		blueMultiplier = 0;

		return color;
	}

	#if lime
	@:noCompletion private function __toLimeColorMatrix():ColorMatrix
	{
		if (__limeColorMatrix == null)
		{
			__limeColorMatrix = new Float32Array(20);
		}

		__limeColorMatrix[0] = redMultiplier;
		__limeColorMatrix[4] = redOffset / 255;
		__limeColorMatrix[6] = greenMultiplier;
		__limeColorMatrix[9] = greenOffset / 255;
		__limeColorMatrix[12] = blueMultiplier;
		__limeColorMatrix[14] = blueOffset / 255;
		__limeColorMatrix[18] = alphaMultiplier;
		__limeColorMatrix[19] = alphaOffset / 255;

		return __limeColorMatrix;
	}
	#end
}
#else
typedef ColorTransform = flash.geom.ColorTransform;
#end
