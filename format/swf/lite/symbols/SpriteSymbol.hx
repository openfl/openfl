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

	public function findDependentSymbols(swflite:SWFLite, shapes:Map<Int, ShapeSymbol> = null, simpleSprites:Map<Int, SimpleSpriteSymbol> = null, dynamicTexts:Map<Int, DynamicTextSymbol> = null, morphShapes:Map<Int, MorphShapeSymbol> = null):Void {
		for(frame in frames) {
			for(frameObject in frame.objects) {
				if(frameObject.type == FrameObjectType.CREATE || frameObject.type == FrameObjectType.UPDATE_CHARACTER) {
					var symbol = swflite.symbols.get(frameObject.symbol);

					if(Std.is(symbol, SpriteSymbol)) {
						cast(symbol, SpriteSymbol).findDependentSymbols(swflite, shapes, simpleSprites, dynamicTexts);
					} else if(shapes != null && Std.is(symbol, ShapeSymbol)) {
						shapes.set(frameObject.symbol, cast symbol);
					} else if(morphShapes != null && Std.is(symbol, MorphShapeSymbol)) {
						morphShapes.set(frameObject.symbol, cast symbol);
					} else if(simpleSprites != null && Std.is(symbol, SimpleSpriteSymbol)) {
						simpleSprites.set(frameObject.symbol, cast symbol);
					} else if(dynamicTexts != null && Std.is(symbol, DynamicTextSymbol)) {
						dynamicTexts.set(frameObject.symbol, cast symbol);
					}
				}
			}
		}
	}

	public function createNeededTextures(gl:GLRenderContext, swflite:SWFLite):Void {
		var shapes = new Map();
		var simpleSprites = new Map();

		findDependentSymbols(swflite, shapes, simpleSprites);

		for(s in shapes) {
			s.graphics.createTextures(gl);
		}

		for(s in simpleSprites) {
			var bitmapData = Assets.getBitmapData(cast(swflite.symbols.get(s.bitmapID),format.swf.lite.symbols.BitmapSymbol).path);
			bitmapData.getTexture(gl);
		}
	}

}
