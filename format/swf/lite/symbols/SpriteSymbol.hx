package format.swf.lite.symbols;


import format.swf.lite.timeline.Frame;
import format.swf.lite.timeline.FrameObjectType;

class SpriteSymbol extends SWFSymbol {


	@:s public var frames:Array<Frame>;
	@:s public var scalingGridRect:flash.geom.Rectangle;

	public function new () {

		super ();

		frames = new Array<Frame> ();

	}

	public function findNeededShapesSymbolId(result:Map<Int, ShapeSymbol>, swflite:SWFLite):Void {
		for(frame in frames) {
			for(frameObject in frame.objects) {
				if(frameObject.type == FrameObjectType.CREATE || frameObject.type == FrameObjectType.UPDATE_CHARACTER) {
					var symbol = swflite.symbols.get(frameObject.symbol);

					if(Std.is(symbol, SpriteSymbol)) {
						cast(symbol, SpriteSymbol).findNeededShapesSymbolId(result, swflite);
					}
					else if(Std.is(symbol, ShapeSymbol)) {
						result.set(frameObject.symbol, cast symbol);
					}
				}
			}
		}
	}
}
