package openfl._internal.renderer.cairo;
#if lime_console

import cpp.Pointer;
import cpp.UInt8;
import lime.graphics.cairo.Context;
import lime.graphics.cairo.Format;
import lime.graphics.cairo.Pattern;
import lime.graphics.cairo.Surface;
import lime.graphics.Image;
import lime.text.Glyph;
import lime.text.TextLayout;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Graphics;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.display.Tilesheet;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;


@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.Tilesheet)


// TODO(james4k): Implement AbstractRenderer to support the full rendering path.
// Currently, this guy is sometimes used in BitmapData.draw, while other
// renderers are used for general rendering.

class CairoRenderer {
	
	
	public static function renderToBitmap (
		dest:BitmapData, source:DisplayObject,
		matrix:Matrix = null,
		colorTransform:ColorTransform = null,
		blendMode:BlendMode = null,
		clipRect:Rectangle = null,
		smoothing:Bool = false
	) {

		var renderer = new CairoRenderer (dest);
		renderer.render (source, matrix, colorTransform, blendMode, clipRect, smoothing);
		renderer.destroy ();

		//renderer.shuffleToRGBA ();
		dest.__image.premultiplied = true;
		dest.__image.dirty = true;

	}
	

	private var dest:BitmapData;
	private var ctx:Context;

	
	private function new (dest:BitmapData) {

		var target = Surface.createForData (
			cast (Pointer.arrayElem (dest.__image.data.buffer.getData (), 0)),
			Format.ARGB32,
			dest.width,
			dest.height,
			dest.width * 4
		);

		this.dest = dest;
		this.ctx = Context.create (target);

		target.destroy ();

	}


	private function destroy () {

		ctx.destroy ();

	}


	private function shuffleToRGBA () {

		var byteptr = Pointer.arrayElem (dest.__image.data.buffer.getData (), 0);
		var pixels:Pointer<Int> = byteptr.reinterpret ();
		
		// TODO(james4k): can stride not equal width? unroll the loop a bit?
		for (y in 0...dest.height) {
			var s = dest.width;
			for (x in 0...dest.width) {
				
				var p = pixels.add (y*s + x);
				p.ref = ((p.ref & 0x00ffffff) << 8) | ((p.ref & 0xff000000) >> 24);
	
			}
		}

	}


	// div divides an integer by an integer using integer math.
	// Normally in haxe, Int divided by Int returns Float. Can't seem to be
	// avoided even with cast() or Std.int()
	private inline function div (a:Int, b:Int):Int {

		return untyped __cpp__ ("{0} / {1}", a, b);

	}


	private function render (
		object:DisplayObject,
		matrix:Matrix = null,
		colorTransform:ColorTransform = null,
		blendMode:BlendMode = null,
		clipRect:Rectangle = null,
		smoothing:Bool = false
	) {

		var transform = object.__worldTransform;
		var colorTransform = object.__worldColorTransform;

		// TODO(james4k): blendMode, clipRect, smoothing

		object.__worldTransform = matrix != null ? matrix : new Matrix ();
		object.__worldColorTransform = colorTransform != null ? colorTransform : new ColorTransform ();
		//object.blendMode = 
		object.__updateChildren (false);

		renderDisplayObject (object);

		object.__worldTransform = transform;
		object.__worldColorTransform = colorTransform;
		//object.blendMode = 
		// TODO(james4k): can we just dirty everyone?
		object.__updateChildren (true);

	}


	private function renderDisplayObject (object:DisplayObject) {

		if (!object.__renderable || object.__worldAlpha <= 0) {
			return;
		}

		if (Std.is (object, DisplayObjectContainer)) {

			renderDisplayObjectContainer (cast (object));

		} else if (Std.is (object, Shape)) {

			renderShape (cast (object));

		} else if (Std.is (object, TextField)) {

			renderTextField (cast (object));

		}

	}

	
	private function renderDisplayObjectContainer (object:DisplayObjectContainer) {
		
		if (Std.is (object, Sprite)) {

			renderSprite (cast (object));

		} else if (Std.is (object, Bitmap)) {

			renderBitmap (cast (object));

		}

		for (child in object.__children) {

			renderDisplayObject (child);

		}

		object.__removedChildren = [];

	}


	private function renderBitmap (bitmap:Bitmap) {



	}


	private function renderShape (shape:Shape) {



	}


	private function renderSprite (sprite:Sprite) {

		if (sprite.__graphics == null) {
			return;
		}

		draw (sprite);

	}
	
	
	private function renderTextField (tf:TextField) {

		TextFieldGraphics.render (tf);

		if (tf.__graphics == null) {
			return;
		}

		draw (tf);

	}


	private function draw (object:DisplayObject) {

		var graphics = object.__graphics;
		graphics.__dirty = false;

		var hasFill = false;
		var hasStroke = false;

		ctx.save ();
		ctx.setMatrix (
			object.__worldTransform.a,
			object.__worldTransform.b,
			object.__worldTransform.c,
			object.__worldTransform.d,
			object.__worldTransform.tx,
			object.__worldTransform.ty
		);

		for (cmd in graphics.__commands) {

			switch (cmd) {

				//case BeginBitmapFill (bitmap, matrix, repeat, smooth):

				case BeginFill (rgb, alpha):

					hasFill = true;
					ctx.setSourceRGBA (
						((rgb >> 16) & 0xFF) / 255.0,
						((rgb >> 8) & 0xFF) / 255.0,
						((rgb >> 0) & 0xFF) / 255.0,
						alpha * object.__worldAlpha
					);

				case EndFill:

					if (hasFill) {
						ctx.fillPreserve ();
					}
					if (hasStroke) {
						ctx.strokePreserve ();
					}
					ctx.newPath ();

					hasFill = false;
					hasStroke = false;

				// LineStyle (thickness:Null<Float>, color:Null<Int>, alpha:Null<Float>, pixelHinting:Null<Bool>,
				//            scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle, miterLimit:Null<Float>);
				case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):

					ctx.closePath ();

					if (thickness == null) {
						hasStroke = false;
						break;
					}

					hasStroke = true;

					// TODO(james4k): pixel hinting, scaleMode
					ctx.setLineWidth (thickness);
					ctx.setLineCap (switch (caps) {
						case NONE, null: Butt;
						case ROUND: Round;
						case SQUARE: Square;
					});
					ctx.setLineJoin (switch (joints) {
						case MITER: Miter;
						case ROUND, null: Round;
						case BEVEL: Bevel;
					});
					ctx.setMiterLimit (miterLimit == null ? 3 : miterLimit);

				case LineTo (x, y):

					ctx.lineTo (x, y);

				case MoveTo (x, y):

					ctx.moveTo (x, y);

				case DrawTiles (sheet, tileData, smooth, flags, count):

					var useScale = (flags & Tilesheet.TILE_SCALE) != 0;
					var useRotation = (flags & Tilesheet.TILE_ROTATION) != 0;
					var useTransform = (flags & Tilesheet.TILE_TRANS_2x2) != 0;
					var useRGB = (flags & Tilesheet.TILE_RGB) != 0;
					var useAlpha = (flags & Tilesheet.TILE_ALPHA) != 0;
					var useRect = (flags & Tilesheet.TILE_RECT) != 0;
					var useOrigin = (flags & Tilesheet.TILE_ORIGIN) != 0;

					var blendMode:BlendMode = switch(flags & 0xF0000) {
						case Tilesheet.TILE_BLEND_ADD:		ADD;
						case Tilesheet.TILE_BLEND_MULTIPLY:	MULTIPLY;
						case Tilesheet.TILE_BLEND_SCREEN:	SCREEN;
						case _:								NORMAL;
					};

					if (blendMode != BlendMode.NORMAL) {
						trace ("DrawTiles not implemented for BlendMode: " + blendMode);
					}

					if (useTransform) {
						useScale = false;
						useRotation = false;
					}

					var scaleIndex = 0;
					var rotationIndex = 0;
					var transformIndex = 0;
					var rgbIndex = 0;
					var alphaIndex = 0;

					var stride = 3;
					if (useRect) {
						stride = useOrigin ? 8 : 6;
					}
					if (useScale) {
						scaleIndex = stride;
						stride += 1;
					}
					if (useRotation) {
						rotationIndex = stride;
						stride += 1;
					}
					if (useTransform) {
						transformIndex = stride;
						stride += 4;
					}
					if (useRGB) {
						rgbIndex = stride;
						stride += 3;
					}
					if (useAlpha) {
						alphaIndex = stride;
						stride += 1;
					}

					var totalCount = tileData.length;
					if (count >= 0 && totalCount > count) {
						totalCount = count;
					}
					var itemCount = div (totalCount, stride);

					var tileID = -1;
					var rect:Rectangle = sheet.__rectTile;
					//var tileUV:Rectangle = sheet.__rectUV;
					var center:Point = sheet.__point;

					var surface = imageSurface (sheet.__bitmap.__image);
					var pattern = Pattern.createForSurface (surface);
					pattern.setExtend (None);
					pattern.setFilter (smooth ? Bilinear : Nearest);

					for (itemIndex in 0...itemCount) {

						var index = itemIndex * stride;

						var x = tileData[index + 0];
						var y = tileData[index + 1];

						if (useRect) {

							tileID = -1;

							rect.x = tileData[index + 2];
							rect.y = tileData[index + 3];
							rect.width = tileData[index + 4];
							rect.height = tileData[index + 5];
							
							if (useOrigin) {
								center.x = tileData[index + 6];
								center.y = tileData[index + 7];
							} else {
								center.setTo(0, 0);
							}
							
							//tileUV.setTo(
							//	rect.left / sheet.__bitmap.width,
							//	rect.top / sheet.__bitmap.height,
							//	rect.right / sheet.__bitmap.width,
							//	rect.bottom / sheet.__bitmap.height
							//);

						} else {

							tileID = Std.int (tileData[index + 2]);
							rect = sheet.getTileRect(tileID);	
							center = sheet.getTileCenter(tileID);	
							//tileUV = sheet.getTileUVs(tileID);	

						}

						if (rect == null || rect.width <= 0 || rect.height <= 0 || center == null) {
							continue;
						}	

						var alpha = object.__worldAlpha;
						var red = 1.0, green = 1.0, blue = 1.0;
						var scale = 1.0;
						var rotation = 0.0;
						var a = 0.0, b = 0.0, c = 0.0, d = 0.0, tx = 0.0, ty = 0.0;

						if (useRGB) {
							red   = tileData[index + rgbIndex + 0];
							green = tileData[index + rgbIndex + 1];
							blue  = tileData[index + rgbIndex + 2];
						}

						if (useAlpha) {
							alpha *= tileData[index + alphaIndex];	
						}

						if (useScale) {
							scale = tileData[index + scaleIndex];
						}

						if (useRotation) {
							rotation = tileData[index + rotationIndex];
						}

						if (useTransform) {
							a = tileData[index + transformIndex + 0];
							b = tileData[index + transformIndex + 1];
							c = tileData[index + transformIndex + 2];
							d = tileData[index + transformIndex + 3];
						} else {
							a = scale * Math.cos (rotation);
							b = scale * Math.sin (rotation);
							c = -b;
							d = a;
						}

						var tx = x - (center.x * a + center.y * c);
						var ty = y - (center.x * b + center.y * d);

						var m = new Matrix (a, b, c, d, tx, ty);
						ctx.transform (m.a, m.b, m.c, m.d, m.tx, m.ty);

						pattern.setMatrix (1, 0, 0, 1, rect.x, rect.y);
						
						// TODO(james4k): color transform could probably be done
						// in one group per object or draw command, instead of for every tile here..

						// TODO(james4k): multiply operator below doesn't operate on the alpha channel

						ctx.pushGroup ();
						ctx.rectangle (0, 0, rect.width, rect.height);
						ctx.setSource (pattern);
						ctx.fillPreserve ();
						ctx.setOperator (Multiply);
						ctx.setSourceRGBA (
							red * object.__worldColorTransform.redMultiplier,
							green * object.__worldColorTransform.greenMultiplier,
							blue * object.__worldColorTransform.blueMultiplier,
							alpha * object.__worldColorTransform.alphaMultiplier
						);
						ctx.fillPreserve ();
						ctx.setOperator (Add);
						ctx.setSourceRGBA (
							object.__worldColorTransform.redOffset,
							object.__worldColorTransform.greenOffset,
							object.__worldColorTransform.blueOffset,
							object.__worldColorTransform.alphaOffset
						);
						ctx.fill ();
						ctx.popGroupToSource ();
						ctx.mask (pattern);

						m.invert ();
						ctx.transform (m.a, m.b, m.c, m.d, m.tx, m.ty);

					}

					pattern.destroy ();
					surface.destroy ();
	
				default:

					trace ("not implemented: " + cmd);

			}

		}

		ctx.restore ();

	}


	private function imageSurface (image:Image):Surface {
	
		return Surface.createForData (
			cast (Pointer.arrayElem (image.data.buffer.getData (), 0)),
			Format.ARGB32,
			image.width,
			image.height,
			image.width * 4
		);
	
	}

	
}
#end

