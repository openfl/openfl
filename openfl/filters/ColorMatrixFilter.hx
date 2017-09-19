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


	public var matrix (default, set):Array<Float>;
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

	private override function __getCommands (bitmap:BitmapData):Array<CommandType> {

		return [ColorTransform (bitmap, bitmap, multipliers, offsets)];

	}


	// Get & Set Methods


	private function set_matrix (value:Array<Float>):Array<Float> {

		if (value == null)
		{
			value = [ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0 ];
		}

		return matrix = value;

	}


}


#else
typedef ColorMatrixFilter = openfl._legacy.filters.ColorMatrixFilter;
#end
