package format.swf.lite.symbols;


import format.swf.lite.timeline.Frame;
import format.swf.lite.timeline.FrameObjectType;
import lime.graphics.GLRenderContext;
import openfl.Assets;

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
					} else if(Std.is(symbol, ShapeSymbol)) {
						result.set(frameObject.symbol, cast symbol);
					}
				}
			}
		}
	}

	public function createNeededTextures(gl:GLRenderContext, swflite:SWFLite):Void {
		var shapes = new Map();

		__findNeededShapesAndCreateSimpleSpriteTextures(shapes, gl, swflite);

		for(s in shapes) {
			s.graphics.createTextures(gl);
		}
	}

	private function __findNeededShapesAndCreateSimpleSpriteTextures(result:Map<Int, ShapeSymbol>, gl:GLRenderContext, swflite:SWFLite):Void {
		for(frame in frames) {
			for(frameObject in frame.objects) {
				if(frameObject.type == FrameObjectType.CREATE || frameObject.type == FrameObjectType.UPDATE_CHARACTER) {
					var symbol = swflite.symbols.get(frameObject.symbol);

					if(Std.is(symbol, SpriteSymbol)) {
						cast(symbol, SpriteSymbol).__findNeededShapesAndCreateSimpleSpriteTextures(result, gl, swflite);
					} else if(Std.is(symbol, ShapeSymbol)) {
						result.set(frameObject.symbol, cast symbol);
					} else if(Std.is(symbol, SimpleSpriteSymbol)) {
						var bitmapData = Assets.getBitmapData(cast(swflite.symbols.get(cast(symbol, SimpleSpriteSymbol).bitmapID),format.swf.lite.symbols.BitmapSymbol).path);
						bitmapData.getTexture(gl);
					}
				}
			}
		}
	}

}
