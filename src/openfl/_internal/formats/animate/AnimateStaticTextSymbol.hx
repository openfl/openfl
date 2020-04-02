package openfl._internal.formats.animate;

import openfl.display.CapsStyle;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.Shape;
import openfl.geom.Matrix;
import openfl.text.StaticText;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.formats.animate.AnimateLibrary)
@:access(openfl.display.CapsStyle)
@:access(openfl.display.JointStyle)
@:access(openfl.display.LineScaleMode)
@:access(openfl.text.StaticText)
class AnimateStaticTextSymbol extends AnimateSymbol
{
	public var matrix:Matrix;
	public var records:Array<StaticTextRecord>;
	public var rendered:#if flash flash.text.StaticText.StaticText2 #else StaticText #end;

	public function new()
	{
		super();
	}

	private override function __createObject(library:AnimateLibrary):#if flash Shape #else StaticText #end
	{
		var staticText = #if flash new flash.text.StaticText.StaticText2() #else new StaticText() #end;
		var graphics = staticText.__graphics;

		if (rendered != null)
		{
			staticText.text = rendered.text;
			graphics.copyFrom(rendered.__graphics);
			return staticText;
		}

		var text = "";

		if (records != null)
		{
			var font:AnimateFontSymbol = null;
			var color = 0xFFFFFF;
			var offsetX = matrix.tx;
			var offsetY = matrix.ty;

			var scale, index;

			for (record in records)
			{
				if (record.fontID != null) font = cast library.symbols.get(record.fontID);
				if (record.offset != null)
				{
					offsetX = matrix.tx + record.offset[0] * 0.05;
					offsetY = matrix.ty + record.offset[1] * 0.05;
				}
				if (record.color != null) color = record.color;

				if (font != null)
				{
					scale = (record.fontHeight / 1024) * 0.05;

					for (i in 0...record.glyphs.length)
					{
						index = record.glyphs[i];
						text += String.fromCharCode(font.codes[index]);

						for (command in font.glyphs[index])
						{
							switch (command)
							{
								case BeginFill(_, alpha):
									graphics.beginFill(color & 0xFFFFFF, ((color >> 24) & 0xFF) / 0xFF);

								case CurveTo(controlX, controlY, anchorX, anchorY):
									graphics.curveTo(controlX * scale + offsetX, controlY * scale + offsetY, anchorX * scale + offsetX,
										anchorY * scale + offsetY);

								case EndFill:
									graphics.endFill();

								case LineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
									if (thickness != null)
									{
										graphics.lineStyle(thickness, color, alpha, pixelHinting, LineScaleMode.fromInt(scaleMode), CapsStyle.fromInt(caps),
											JointStyle.fromInt(joints), miterLimit);
									}
									else
									{
										graphics.lineStyle();
									}

								case LineTo(x, y):
									graphics.lineTo(x * scale + offsetX, y * scale + offsetY);

								case MoveTo(x, y):
									graphics.moveTo(x * scale + offsetX, y * scale + offsetY);

								default:
							}
						}

						offsetX += record.advances[i] * 0.05;
					}
				}
			}
		}

		staticText.text = text;

		records = null;
		rendered = #if flash new flash.text.StaticText.StaticText2() #else new StaticText() #end;
		rendered.text = text;
		rendered.__graphics.copyFrom(staticText.__graphics);

		return staticText;
	}
}

@:keep typedef StaticTextRecord =
{
	public var advances:Array<Int>;
	public var color:Null<Int>;
	public var fontHeight:Int;
	public var fontID:Null<Int>;
	public var glyphs:Array<Int>;
	public var offset:Null<Array<Int>>;
	// public function new() {}
}
