package openfl.filters;
#if !openfl_legacy


import openfl.display.BitmapData;
import openfl.filters.commands.*;
import lime.utils.Float32Array;
import openfl.utils.Float32ArrayContainer;

#if (js && html5)
import js.html.ImageData;
#end


@:final class ColorMatrixFilter extends BitmapFilter {

	public var multipliers:Float32Array;
	public var offsets:Float32Array;

	public function new (multipliers:Float32Array = null, offsets:Float32Array = null) {

		super ();

		if ( multipliers != null && multipliers.length != 16 ) {
			throw "Invalid length for color matrix filter multipliers";
		}

		if ( offsets != null && offsets.length != 4 ) {
			throw "Invalid length for color matrix filter offsets";

		}
		this.multipliers = multipliers;
		this.offsets = offsets;

	}


	public override function clone ():BitmapFilter {

		return new ColorMatrixFilter (multipliers, offsets);

	}

	public override function equals(filter:BitmapFilter) {
		if ( Std.is(filter, ColorMatrixFilter) ) {
			var otherFilter:ColorMatrixFilter = cast filter;
			for ( index in 0...multipliers.length ) {
				if ( multipliers[index] != otherFilter.multipliers[index] ) {
					return false;
				}
			}
			for ( index in 0...offsets.length ) {
				if ( offsets[index] != otherFilter.offsets[index] ) {
					return false;
				}
			}
			return true;
		}
		return false;
	}

	private override function __getCommands (bitmap:BitmapData):Array<CommandType> {

		return [ColorTransform (bitmap, bitmap, multipliers, offsets)];

	}

}


#else
typedef ColorMatrixFilter = openfl._legacy.filters.ColorMatrixFilter;
#end
