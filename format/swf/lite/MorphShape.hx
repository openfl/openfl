package format.swf.lite;

import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import format.swf.lite.symbols.MorphShapeSymbol;
import flash.display.Shape;

import format.swf.exporters.ShapeCommandExporter;
import format.swf.lite.symbols.ShapeSymbol;
import openfl._internal.renderer.RenderSession;

class MorphShape extends Shape {

	@:noCompletion private var __symbol: MorphShapeSymbol;
	@:noCompletion private var __swf:SWFLite;

	public var ratio(default, set) : Float;

    private var mustCache:Bool = false;


	public function new (swf:SWFLite, symbol:MorphShapeSymbol) {

		super ();

		__symbol = symbol;
		@:privateAccess this.graphics.__symbol = symbol;

        if(symbol.useBitmapCache) {
            graphics.keepBitmapData = true;
        }

		__swf = swf;

		if ( __symbol.cachedHandlers == null ) {
			__symbol.cachedHandlers = new Map<Int, ShapeCommandExporter>();
		}
		ratio = 0;

	}

    private override function __reset() {
        ratio = 0;
    }


	private override function __getBounds (rect:Rectangle):Void {
		__update(true, false);
		super.__getBounds(rect);
	}


	override public function getSymbol():format.swf.lite.symbols.SWFSymbol{
		return __symbol;
	}


	public function set_ratio( _ratio ){

		if( ratio == _ratio ){
			return _ratio;
		}

		__setRenderDirty();

		return ratio = _ratio;
	}

	#if profile
		private static var __updateCount:Map<String, Int> = new Map<String, Int>();

		public static function __init__ () {
			#if js
				untyped $global.Profile = $global.Profile || {};
				untyped $global.Profile.MorphShapeInfo = {};
				untyped $global.Profile.MorphShapeInfo.resetStatistics = resetStatistics;
				untyped $global.Profile.MorphShapeInfo.logStatistics = logStatistics;
			#end
		}

		public static function resetStatistics () {
			__updateCount = new Map<String, Int> ();
		}

		public static function logStatistics(?threshold = 0) {

			for( id in __updateCount.keys () ) {
				var value = __updateCount[id];
				if(value < threshold) {
					continue;
				}
				trace (' ${id} => created x${value}');
			}
		}
	#end

	public override function __update (transformOnly:Bool, updateChildren:Bool):Void {

        __updateTransforms();

		if(__renderDirty){
			var result = __updateMorphShape(__symbol, ratio, __renderTransform, graphics);

			if ( result ) {
				mustCache = true;
			#if(profile && js)
				var profileId = getProfileId();
				var value = __updateCount.get(profileId);
				value = value != null ? value : 0;
				__updateCount.set(profileId, value + 1);
			#end
			}
	    }

		super.__update(transformOnly, updateChildren);
    }

	private static function __updateMorphShape(symbol:MorphShapeSymbol, ratio:Float, renderTransform:Matrix, graphics:Graphics) {
		var cacheEntry = symbol.getCacheEntry(renderTransform, ratio);

		if(cacheEntry == null) {
			var twips_ratio = Math.floor(ratio*65535);
			var handler = symbol.cachedHandlers.get(twips_ratio);
			if ( handler == null ) {
				var swf_shape = symbol.getShape(ratio);

				handler = new ShapeCommandExporter ();
				swf_shape.export (handler);
				symbol.cachedHandlers.set(twips_ratio, handler);
			}

			graphics.clear();
			ShapeSymbol.processCommands(graphics, handler.commands);

			return true;

		} else {
			Reflect.setField(graphics, "__bitmap", cacheEntry.bitmapData);
			Reflect.setField(graphics, "__dirty", false);
			@:privateAccess graphics.__bounds = cacheEntry.bounds;

			return false;
		}
	}

	public override function __renderGL (renderSession:RenderSession):Void {

        super.__renderGL(renderSession);

        if(mustCache) {
            if(@:privateAccess graphics.__bitmap != null) {
                __symbol.addCacheEntry(@:privateAccess graphics.__bitmap, @:privateAccess graphics.__bounds, __renderTransform, ratio);
            }
            mustCache = false;
        }
	}

}
