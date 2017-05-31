package openfl.filters; #if !openfl_legacy


import openfl._internal.renderer.opengl.utils.RenderTexture;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.filters.commands.*;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import lime.utils.Float32Array;

#if (js && html5)
import js.html.ImageData;
#end

@:access(openfl.display.BitmapData)
@:access(openfl.geom.Rectangle)

class BitmapFilter {

	public static var __inverseAlphaMultipliers = new Float32Array([1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, -1.0]);
	public static var __inverseAlphaOffsets = new Float32Array([0.0, 0.0, 0.0, 1.0]);


	public function new () {



	}


	public function clone ():BitmapFilter {

		return new BitmapFilter ();

	}

	public function dispose():Void{

	}

	#if (js && html5)
	public function __applyFilter (sourceData:ImageData, targetData:ImageData, sourceRect:Rectangle, destPoint:Point):Void {
		throw ":TODO: Unsupported path. Patch code.";
	}
	#end


	private static function __applyFilters (filters:Array<BitmapFilter>, renderSession:RenderSession, bitmap:BitmapData, transform:Matrix) {

		if (!bitmap.__usingPingPongTexture) {
			throw ":TODO: unsupported mode";
		}

		for (filter in filters) {

			var commands = filter.__getCommands (bitmap);

			for (command in commands) {
				switch (command) {
					case Blur1D (target, source, blur, quality, horizontal, strength, distance, angle) :
						var transformedOffset = Point.pool.get ();
						_getTransformedOffset(transformedOffset, distance, angle, transform);
						Blur1DCommand.apply (renderSession, target, source, blur, quality, horizontal, strength, transformedOffset);
						Point.pool.put (transformedOffset);

					case Offset (target, source, strength, distance, angle) :
						var transformedOffset = Point.pool.get ();
						_getTransformedOffset(transformedOffset, distance, angle, transform);
						OffsetCommand.apply (renderSession, target, source, strength, transformedOffset);
						Point.pool.put (transformedOffset);

					case Colorize (target, source, color, alpha) :
						ColorizeCommand.apply (renderSession, target, source, color, alpha);

					case ColorLookup (target, source, colorLookup) :
						ColorLookupCommand.apply (renderSession, target, source, colorLookup);

					case ColorTransform (target, source, multipliers, offsets) :
						ColorTransformCommand.apply (renderSession, target, source, multipliers, offsets);

					case CombineInner (target, source1, source2) :
						CombineInnerCommand.apply (renderSession, target, source1, source2);

					case Combine (target, source1, source2) :
						CombineCommand.apply (renderSession, target, source1, source2);

					case InnerKnockout (target, source1, source2) :
						InnerKnockoutCommand.apply(renderSession, target, source1, source2);

					case OuterKnockout (target, source1, source2) :
						OuterKnockoutCommand.apply(renderSession, target, source1, source2);

					case OuterKnockoutTransparency (target, source1, source2, allowTransparency) :
						OuterKnockoutCommand.apply(renderSession, target, source1, source2, allowTransparency);

					case DestOut (target, highlightSource, shadowSource) :
						DestOutCommand.apply(renderSession, target, highlightSource, shadowSource);

					default :
						throw("Unsupported command!");
				}

			}

			filter.dispose();
		}

	}


	private static function __expandBounds (filters:Array<BitmapFilter>, rect:Rectangle, transform:Matrix) {

		for (filter in filters) {

			filter.__growBounds (rect, transform);

		}

	}


	private function __growBounds (rect:Rectangle, transform:Matrix) {



	}


	private function __getCommands (bitmap:BitmapData):Array<CommandType> {

		return [];

	}

	private static inline function _getTransformedOffset(transformedOffset:Point, distance:Float, angleInDegrees:Float, transform:Matrix) {

		var offset = Point.pool.get ();
		offset.x = distance * Math.cos (angleInDegrees * Math.PI / 180);
		offset.y = distance * Math.sin (angleInDegrees * Math.PI / 180);

		if (transform.a != 1.0  || transform.d != 1.0 || transform.b != 0.0 || transform.c != 0.0) {

			transformedOffset.copyFrom (transform.deltaTransformPoint (offset));

		} else {
			transformedOffset.copyFrom (offset);
		}

		Point.pool.put (offset);
	}
}


#else
typedef BitmapFilter = openfl._legacy.filters.BitmapFilter;
#end
