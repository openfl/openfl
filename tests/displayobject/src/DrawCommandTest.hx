package;

import openfl.display.BitmapData;
import openfl.display.CapsStyle;
import openfl.display.GradientType;
import openfl.display.InterpolationMethod;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.SpreadMethod;
import openfl.display._internal.DrawCommandBuffer;
import openfl.display._internal.DrawCommandReader;
import openfl.display._internal.DrawCommandType;
import openfl.geom.Matrix;
import utest.Assert;
import utest.Test;

class DrawCommandTest extends Test
{
	public function test_new()
	{
		var buffer = new DrawCommandBuffer();
		Assert.equals(0, buffer.length);
		Assert.equals(0, buffer.types.length);
	}

	public function test_clear()
	{
		var buffer = new DrawCommandBuffer();
		buffer.moveTo(0.0, 0.0);
		buffer.lineTo(10.0, 0.0);
		buffer.lineTo(10.0, 10.0);
		buffer.lineTo(0.0, 10.0);
		buffer.lineTo(0.0, 0.0);

		Assert.equals(5, buffer.length);
		Assert.equals(5, buffer.types.length);

		buffer.clear();

		Assert.equals(0, buffer.length);
		Assert.equals(0, buffer.types.length);
	}

	public function test_moveTo()
	{
		var buffer = new DrawCommandBuffer();
		buffer.moveTo(20.0, 10.0);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.MOVE_TO, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readMoveTo();
		Assert.equals(20.0, view.x);
		Assert.equals(10.0, view.y);
	}

	public function test_lineTo()
	{
		var buffer = new DrawCommandBuffer();
		buffer.lineTo(20.0, 10.0);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.LINE_TO, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readLineTo();
		Assert.equals(20.0, view.x);
		Assert.equals(10.0, view.y);
	}

	public function test_curveTo()
	{
		var buffer = new DrawCommandBuffer();
		buffer.curveTo(15.0, 5.0, 20.0, 10.0);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.CURVE_TO, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readCurveTo();
		Assert.equals(15.0, view.controlX);
		Assert.equals(5.0, view.controlY);
		Assert.equals(20.0, view.anchorX);
		Assert.equals(10.0, view.anchorY);
	}

	public function test_cubicCurveTo()
	{
		var buffer = new DrawCommandBuffer();
		buffer.cubicCurveTo(15.0, 5.0, 25.0, 30.0, 20.0, 10.0);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.CUBIC_CURVE_TO, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readCubicCurveTo();
		Assert.equals(15.0, view.controlX1);
		Assert.equals(5.0, view.controlY1);
		Assert.equals(25.0, view.controlX2);
		Assert.equals(30.0, view.controlY2);
		Assert.equals(20.0, view.anchorX);
		Assert.equals(10.0, view.anchorY);
	}

	public function test_drawRect()
	{
		var buffer = new DrawCommandBuffer();
		buffer.drawRect(10.0, 5.0, 200.0, 150.0);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.DRAW_RECT, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readDrawRect();
		Assert.equals(10.0, view.x);
		Assert.equals(5.0, view.y);
		Assert.equals(200.0, view.width);
		Assert.equals(150.0, view.height);
	}

	public function test_drawCircle()
	{
		var buffer = new DrawCommandBuffer();
		buffer.drawCircle(10.0, 15.0, 5.0);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.DRAW_CIRCLE, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readDrawCircle();
		Assert.equals(10.0, view.x);
		Assert.equals(15.0, view.y);
		Assert.equals(5.0, view.radius);
	}

	public function test_drawEllipse()
	{
		var buffer = new DrawCommandBuffer();
		buffer.drawEllipse(10.0, 5.0, 200.0, 150.0);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.DRAW_ELLIPSE, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readDrawEllipse();
		Assert.equals(10.0, view.x);
		Assert.equals(5.0, view.y);
		Assert.equals(200.0, view.width);
		Assert.equals(150.0, view.height);
	}

	public function test_drawDrawRoundRect()
	{
		var buffer = new DrawCommandBuffer();
		buffer.drawRoundRect(10.0, 5.0, 200.0, 150.0, 15.0, 20.0);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.DRAW_ROUND_RECT, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readDrawRoundRect();
		Assert.equals(10.0, view.x);
		Assert.equals(5.0, view.y);
		Assert.equals(200.0, view.width);
		Assert.equals(150.0, view.height);
		Assert.equals(15.0, view.ellipseWidth);
		Assert.equals(20.0, view.ellipseHeight);

		// ellipseHeight is optional in graphics.drawRoundRect(), so check that
		// null works for this value
		var buffer = new DrawCommandBuffer();
		buffer.drawRoundRect(10.0, 5.0, 200.0, 150.0, 15.0, null);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.DRAW_ROUND_RECT, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readDrawRoundRect();
		Assert.equals(10.0, view.x);
		Assert.equals(5.0, view.y);
		Assert.equals(200.0, view.width);
		Assert.equals(150.0, view.height);
		Assert.equals(15.0, view.ellipseWidth);
		Assert.isNull(view.ellipseHeight);
	}

	public function test_beginFill()
	{
		var buffer = new DrawCommandBuffer();
		buffer.beginFill(0xcc66aa, 0.5);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.BEGIN_FILL, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readBeginFill();
		Assert.equals(0xcc66aa, view.color);
		Assert.equals(0.5, view.alpha);
	}

	public function test_beginGradientFill()
	{
		var buffer = new DrawCommandBuffer();
		var matrix = new Matrix(2.0, 1.0, 0.75, 0.5, 10.0, 20.0);
		buffer.beginGradientFill(GradientType.RADIAL, [0xff0000, 0x0000ff], [0.5, 0.75], [0x08, 0xf2], matrix, SpreadMethod.REPEAT, InterpolationMethod.RGB,
			0.5);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.BEGIN_GRADIENT_FILL, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readBeginGradientFill();
		Assert.equals(GradientType.RADIAL, view.type);
		Assert.equals(2, view.colors.length);
		Assert.equals(0xff0000, view.colors[0]);
		Assert.equals(0x0000ff, view.colors[1]);
		Assert.equals(2, view.alphas.length);
		Assert.equals(0.5, view.alphas[0]);
		Assert.equals(0.75, view.alphas[1]);
		Assert.equals(2, view.ratios.length);
		Assert.equals(0x08, view.ratios[0]);
		Assert.equals(0xf2, view.ratios[1]);
		Assert.notNull(view.matrix);
		// users are allowed to reuse their matrix for multiple commands, and
		// modifying the matrix should not affect previous commands, so the
		// instances cannot be equal.
		Assert.notEquals(matrix, view.matrix);
		Assert.equals(2.0, view.matrix.a);
		Assert.equals(1.0, view.matrix.b);
		Assert.equals(0.75, view.matrix.c);
		Assert.equals(0.5, view.matrix.d);
		Assert.equals(10.0, view.matrix.tx);
		Assert.equals(20.0, view.matrix.ty);
		Assert.equals(SpreadMethod.REPEAT, view.spreadMethod);
		Assert.equals(InterpolationMethod.RGB, view.interpolationMethod);
		Assert.equals(0.5, view.focalPointRatio);

		// the matrix may be null
		var buffer = new DrawCommandBuffer();
		buffer.beginGradientFill(GradientType.LINEAR, [0x00ffff, 0xff00ff, 0xffff00], [1.0, 0.65, 0.0], [0x1, 0x63, 0xff], null, SpreadMethod.REFLECT,
			InterpolationMethod.LINEAR_RGB, 1.0);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.BEGIN_GRADIENT_FILL, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readBeginGradientFill();
		Assert.equals(GradientType.LINEAR, view.type);
		Assert.equals(3, view.colors.length);
		Assert.equals(0x00ffff, view.colors[0]);
		Assert.equals(0xff00ff, view.colors[1]);
		Assert.equals(0xffff00, view.colors[2]);
		Assert.equals(3, view.alphas.length);
		Assert.equals(1.0, view.alphas[0]);
		Assert.equals(0.65, view.alphas[1]);
		Assert.equals(0.0, view.alphas[2]);
		Assert.equals(3, view.ratios.length);
		Assert.equals(0x1, view.ratios[0]);
		Assert.equals(0x63, view.ratios[1]);
		Assert.equals(0xff, view.ratios[2]);
		Assert.isNull(view.matrix);
		Assert.equals(SpreadMethod.REFLECT, view.spreadMethod);
		Assert.equals(InterpolationMethod.LINEAR_RGB, view.interpolationMethod);
		Assert.equals(1.0, view.focalPointRatio);
	}

	public function test_beginBitmapFill()
	{
		var bitmapData = new BitmapData(10, 10, false, 0xffff0000);

		var buffer = new DrawCommandBuffer();
		var matrix = new Matrix(2.0, 1.0, 0.75, 0.5, 10.0, 20.0);
		buffer.beginBitmapFill(bitmapData, matrix, false, true);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.BEGIN_BITMAP_FILL, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readBeginBitmapFill();
		Assert.equals(bitmapData, view.bitmap);
		Assert.notNull(view.matrix);
		// users are allowed to reuse their matrix for multiple commands, and
		// modifying the matrix should not affect previous commands, so the
		// instances cannot be equal.
		Assert.notEquals(matrix, view.matrix);
		Assert.equals(2.0, view.matrix.a);
		Assert.equals(1.0, view.matrix.b);
		Assert.equals(0.75, view.matrix.c);
		Assert.equals(0.5, view.matrix.d);
		Assert.equals(10.0, view.matrix.tx);
		Assert.equals(20.0, view.matrix.ty);
		Assert.isFalse(view.repeat);
		Assert.isTrue(view.smooth);

		// the matrix may be null
		var buffer = new DrawCommandBuffer();
		buffer.beginBitmapFill(bitmapData, null, true, false);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.BEGIN_BITMAP_FILL, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readBeginBitmapFill();
		Assert.equals(bitmapData, view.bitmap);
		Assert.isNull(view.matrix);
		Assert.isTrue(view.repeat);
		Assert.isFalse(view.smooth);

		bitmapData.dispose();
	}

	public function test_lineStyle()
	{
		var buffer = new DrawCommandBuffer();
		buffer.lineStyle(1.0, 0, 1.0, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND, 3);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.LINE_STYLE, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readLineStyle();
		Assert.equals(1.0, view.thickness);
		Assert.equals(0, view.color);
		Assert.equals(1.0, view.alpha);
		Assert.isFalse(view.pixelHinting);
		Assert.equals(LineScaleMode.NORMAL, view.scaleMode);
		Assert.equals(CapsStyle.ROUND, view.caps);
		Assert.equals(JointStyle.ROUND, view.joints);
		Assert.equals(3, view.miterLimit);
	}

	public function test_lineGradientStyle()
	{
		var buffer = new DrawCommandBuffer();
		var matrix = new Matrix(2.0, 1.0, 0.75, 0.5, 10.0, 20.0);
		buffer.lineGradientStyle(GradientType.RADIAL, [0xff0000, 0x0000ff], [0.5, 0.75], [0x08, 0xf2], matrix, SpreadMethod.REPEAT, InterpolationMethod.RGB,
			0.5);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.LINE_GRADIENT_STYLE, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readLineGradientStyle();
		Assert.equals(GradientType.RADIAL, view.type);
		Assert.equals(2, view.colors.length);
		Assert.equals(0xff0000, view.colors[0]);
		Assert.equals(0x0000ff, view.colors[1]);
		Assert.equals(2, view.alphas.length);
		Assert.equals(0.5, view.alphas[0]);
		Assert.equals(0.75, view.alphas[1]);
		Assert.equals(2, view.ratios.length);
		Assert.equals(0x08, view.ratios[0]);
		Assert.equals(0xf2, view.ratios[1]);
		Assert.notNull(view.matrix);
		// users are allowed to reuse their matrix for multiple commands, and
		// modifying the matrix should not affect previous commands, so the
		// instances cannot be equal.
		Assert.notEquals(matrix, view.matrix);
		Assert.equals(2.0, view.matrix.a);
		Assert.equals(1.0, view.matrix.b);
		Assert.equals(0.75, view.matrix.c);
		Assert.equals(0.5, view.matrix.d);
		Assert.equals(10.0, view.matrix.tx);
		Assert.equals(20.0, view.matrix.ty);
		Assert.equals(SpreadMethod.REPEAT, view.spreadMethod);
		Assert.equals(InterpolationMethod.RGB, view.interpolationMethod);
		Assert.equals(0.5, view.focalPointRatio);

		// the matrix may be null
		var buffer = new DrawCommandBuffer();
		buffer.lineGradientStyle(GradientType.LINEAR, [0x00ffff, 0xff00ff, 0xffff00], [1.0, 0.65, 0.0], [0x1, 0x63, 0xff], null, SpreadMethod.REFLECT,
			InterpolationMethod.LINEAR_RGB, 1.0);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.LINE_GRADIENT_STYLE, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readLineGradientStyle();
		Assert.equals(GradientType.LINEAR, view.type);
		Assert.equals(3, view.colors.length);
		Assert.equals(0x00ffff, view.colors[0]);
		Assert.equals(0xff00ff, view.colors[1]);
		Assert.equals(0xffff00, view.colors[2]);
		Assert.equals(3, view.alphas.length);
		Assert.equals(1.0, view.alphas[0]);
		Assert.equals(0.65, view.alphas[1]);
		Assert.equals(0.0, view.alphas[2]);
		Assert.equals(3, view.ratios.length);
		Assert.equals(0x1, view.ratios[0]);
		Assert.equals(0x63, view.ratios[1]);
		Assert.equals(0xff, view.ratios[2]);
		Assert.isNull(view.matrix);
		Assert.equals(SpreadMethod.REFLECT, view.spreadMethod);
		Assert.equals(InterpolationMethod.LINEAR_RGB, view.interpolationMethod);
		Assert.equals(1.0, view.focalPointRatio);
	}

	public function test_lineBitmapStyle()
	{
		var bitmapData = new BitmapData(10, 10, false, 0xffff0000);

		var buffer = new DrawCommandBuffer();
		var matrix = new Matrix(2.0, 1.0, 0.75, 0.5, 10.0, 20.0);
		buffer.lineBitmapStyle(bitmapData, matrix, false, true);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.LINE_BITMAP_STYLE, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readLineBitmapStyle();
		Assert.equals(bitmapData, view.bitmap);
		Assert.notNull(view.matrix);
		// users are allowed to reuse their matrix for multiple commands, and
		// modifying the matrix should not affect previous commands, so the
		// instances cannot be equal.
		Assert.notEquals(matrix, view.matrix);
		Assert.equals(2.0, view.matrix.a);
		Assert.equals(1.0, view.matrix.b);
		Assert.equals(0.75, view.matrix.c);
		Assert.equals(0.5, view.matrix.d);
		Assert.equals(10.0, view.matrix.tx);
		Assert.equals(20.0, view.matrix.ty);
		Assert.isFalse(view.repeat);
		Assert.isTrue(view.smooth);

		// the matrix may be null
		var buffer = new DrawCommandBuffer();
		buffer.lineBitmapStyle(bitmapData, null, true, false);
		Assert.equals(1, buffer.length);
		Assert.equals(1, buffer.types.length);
		Assert.equals(DrawCommandType.LINE_BITMAP_STYLE, buffer.types[0]);

		var reader = new DrawCommandReader(buffer);
		var view = reader.readLineBitmapStyle();
		Assert.equals(bitmapData, view.bitmap);
		Assert.isNull(view.matrix);
		Assert.isTrue(view.repeat);
		Assert.isFalse(view.smooth);

		bitmapData.dispose();
	}

	public function test_readerAdvance()
	{
		var bitmapData = new BitmapData(10, 10, false, 0xffff0000);
		var matrix = new Matrix(2.0, 1.0, 0.75, 0.5, 10.0, 20.0);

		var readCommands:Array<Void->Dynamic> = [];
		var buffer = new DrawCommandBuffer();
		var reader = new DrawCommandReader(buffer);
		for (i in 0...2)
		{
			buffer.lineStyle(1.0, 0, 1.0, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND, 3);
			readCommands.push(reader.readLineStyle);

			buffer.lineGradientStyle(GradientType.RADIAL, [0xff0000, 0x0000ff], [0.5, 0.75], [0x08, 0xf2], matrix, SpreadMethod.REPEAT,
				InterpolationMethod.RGB, 0.5);
			readCommands.push(reader.readLineGradientStyle);

			buffer.lineBitmapStyle(bitmapData, matrix, false, true);
			readCommands.push(reader.readLineBitmapStyle);

			buffer.beginFill(0xcc66aa, 0.5);
			readCommands.push(reader.readBeginFill);

			buffer.beginGradientFill(GradientType.RADIAL, [0xff0000, 0x0000ff], [0.5, 0.75], [0x08, 0xf2], matrix, SpreadMethod.REPEAT,
				InterpolationMethod.RGB, 0.5);
			readCommands.push(reader.readBeginGradientFill);

			buffer.beginBitmapFill(bitmapData, matrix, false, true);
			readCommands.push(reader.readBeginBitmapFill);

			buffer.moveTo(20.0, 10.0);
			readCommands.push(reader.readMoveTo);

			buffer.lineTo(15.0, 5.0);
			readCommands.push(reader.readLineTo);

			buffer.curveTo(15.0, 5.0, 20.0, 10.0);
			readCommands.push(reader.readCurveTo);

			buffer.cubicCurveTo(15.0, 5.0, 25.0, 30.0, 20.0, 10.0);
			readCommands.push(reader.readCubicCurveTo);

			buffer.drawRect(10.0, 5.0, 200.0, 150.0);
			readCommands.push(reader.readDrawRect);

			buffer.drawCircle(10.0, 15.0, 5.0);
			readCommands.push(reader.readDrawCircle);

			buffer.drawEllipse(10.0, 5.0, 200.0, 150.0);
			readCommands.push(reader.readDrawEllipse);

			buffer.drawRoundRect(10.0, 5.0, 200.0, 150.0, 15.0, 20.0);
			readCommands.push(reader.readDrawRoundRect);
		}
		// the final command is the one that we'll check,
		// so don't add it to the array of read commands
		buffer.moveTo(123.4, 987.6);

		for (readCommand in readCommands)
		{
			readCommand();
		}

		// if these assertions pass, the reader advanced to the correct new
		// position every time it read one of the commands.
		var view = reader.readMoveTo();
		Assert.equals(123.4, view.x);
		Assert.equals(987.6, view.y);

		bitmapData.dispose();
	}
}
