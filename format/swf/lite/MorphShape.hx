package format.swf.lite;

import openfl.geom.Rectangle;
import format.swf.lite.symbols.MorphShapeSymbol;
import flash.display.Shape;

import format.swf.exporters.ShapeCommandExporter;
import format.swf.lite.symbols.ShapeSymbol;

class MorphShape extends Shape {

	@:noCompletion private var __symbol: MorphShapeSymbol;
	@:noCompletion private var __swf:SWFLite;

	public var ratio(default, set) : Float;


	public function new (swf:SWFLite, symbol:MorphShapeSymbol) {

		super ();

		__symbol = symbol;
		@:privateAccess this.graphics.__symbol = symbol;

		__swf = swf;

		if ( __symbol.cachedHandlers == null ) {
			__symbol.cachedHandlers = new Map<Int, ShapeCommandExporter>();
		}
		ratio = 0;

	}


	private override function __getRenderBounds (rect:Rectangle):Void {
		__update(true, false);
		super.__getRenderBounds(rect);
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

		if(__renderDirty){

			var twips_ratio = Math.floor(ratio*65535);
			var handler = __symbol.cachedHandlers.get(twips_ratio);
			if ( handler == null ) {
				var swf_shape = __symbol.getShape(ratio);

				handler = new ShapeCommandExporter ();
				swf_shape.export (handler);
				__symbol.cachedHandlers.set(twips_ratio, handler);
			}

			var graphics = this.graphics;
			graphics.clear();
			ShapeSymbol.processCommands(graphics, handler.commands);

			#if(profile && js)
			var profileId = getProfileId();
            var value = __updateCount.get(profileId);
            value = value != null ? value : 0;
			__updateCount.set(profileId, value + 1);
			#end
		}

		super.__update(transformOnly, updateChildren);
	}

}
