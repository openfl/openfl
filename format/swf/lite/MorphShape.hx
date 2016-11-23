package format.swf.lite;

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
		__swf = swf;

		ratio = 0;

	}

	public function set_ratio( _ratio ){

		if( ratio == _ratio ){
			return _ratio;
		}

		__setRenderDirty();

		return ratio = _ratio;
	}

	public override function __update (transformOnly:Bool, updateChildren:Bool, ?maskGraphics:Graphics = null):Void {

		if(__renderDirty){
			var swf_shape = __symbol.getShape(ratio);

			var handler = new ShapeCommandExporter ();
			swf_shape.export (handler);

			var graphics = this.graphics;
			graphics.clear();

			for (command in handler.commands) {

				switch (command) {

					case BeginFill (color, alpha):

						graphics.beginFill (color, alpha);

					case BeginBitmapFill (bitmapID, matrix, repeat, smooth):

						#if openfl

						var bitmap:BitmapSymbol = cast __swf.symbols.get (bitmapID);

						if (bitmap != null && bitmap.path != "") {

							graphics.beginBitmapFill (@:privateAccess MovieClip.__getBitmap (bitmap), matrix, repeat, smooth);

						}

						#end

					case BeginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):

						#if (cpp || neko)
						this.cacheAsBitmap = true;
						#end
						graphics.beginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);

					case CurveTo (controlX, controlY, anchorX, anchorY):

						#if (cpp || neko)
						this.cacheAsBitmap = true;
						#end
						graphics.curveTo (controlX, controlY, anchorX, anchorY);

					case EndFill:

						graphics.endFill ();

					case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):

						if (thickness != null) {

							graphics.lineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);

						} else {

							graphics.lineStyle ();

						}

					case LineTo (x, y):

						graphics.lineTo (x, y);

					case MoveTo (x, y):

						graphics.moveTo (x, y);

				}
			}
		}

		super.__update(transformOnly, updateChildren, maskGraphics);
	}

}
