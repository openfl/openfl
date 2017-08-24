package format.swf.lite;

import openfl.geom.Rectangle;
import format.swf.lite.symbols.MorphShapeSymbol;
import flash.display.Shape;
import flash.display.Graphics;

import format.swf.exporters.ShapeCommandExporter;
import format.swf.lite.symbols.BitmapSymbol;

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
			graphics.processCommands(handler.commands);
		}

		super.__update(transformOnly, updateChildren);
	}

}
