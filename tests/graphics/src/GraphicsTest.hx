package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.GradientType;
import openfl.display.Graphics;
#if (lime && !flash)
import openfl.display.GraphicsShader;
#end
import openfl.display.Shape;
import openfl.display.LineScaleMode;
import openfl.display.JointStyle;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import utest.Assert;
import utest.Test;

#if !flash
@:access(openfl.display.Graphics)
#end
class GraphicsTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;

		Assert.notNull(graphics);
	}

	#if !flash
	public function testShaderStateIsLazy()
	{
		var graphics = new Shape().graphics;

		Assert.isNull(graphics.__shaderBufferPool);
		Assert.isNull(graphics.__usedShaderBuffers);

		graphics.clear();

		Assert.isNull(graphics.__shaderBufferPool);
		Assert.isNull(graphics.__usedShaderBuffers);
	}
	#end

	#if (lime && !flash)
	public function testBeginShaderFillInitializesShaderState()
	{
		var graphics = new Shape().graphics;

		graphics.beginShaderFill(new GraphicsShader());

		Assert.notNull(graphics.__shaderBufferPool);
		Assert.notNull(graphics.__usedShaderBuffers);
		Assert.equals(1, graphics.__usedShaderBuffers.length);

		var shaderBufferPool = graphics.__shaderBufferPool;
		graphics.clear();

		Assert.equals(shaderBufferPool, graphics.__shaderBufferPool);
		Assert.equals(0, graphics.__usedShaderBuffers.length);

		graphics.beginShaderFill(new GraphicsShader());

		Assert.equals(shaderBufferPool, graphics.__shaderBufferPool);
		Assert.equals(1, graphics.__usedShaderBuffers.length);
	}
	#end

	#if flash
	@Ignored
	#end
	public function test_beginBitmapFill()
	{
		// TODO: Confirm functionality

		#if !flash
		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.beginBitmapFill;

		Assert.notNull(exists);
		#end
	}

	#if flash
	@Ignored
	#end
	public function test_beginFill()
	{
		// TODO: Confirm functionality

		#if !flash
		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.beginFill;

		Assert.notNull(exists);
		#end
	}

	#if (flash || neko)
	@Ignored
	#end
	public function test_beginGradientFill()
	{
		// TODO: Confirm functionality

		#if !flash
		var shape = new Shape();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.beginGradientFill;

		Assert.notNull(exists);
		#end
		#end
	}

	public function test_beginGradientFillSkewedMatrix()
	{
		// as in Flash, a linear gradient follows the first coordinate of the inverse of its matrix: this
		// skewed matrix, from a SWF, gives a vertical gradient whatever the x
		var shape = new Shape();
		shape.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0x000000], [1, 1], [0, 255],
			new Matrix(0.0016326904296875, -0.00323486328125, 0.431838989257812, 0, -5246.2, 11.9));
		shape.graphics.drawRect(50, 10, 280, 14);
		shape.graphics.endFill();

		var bitmapData = new BitmapData(400, 30, true, 0);
		bitmapData.draw(shape);

		// above y = 11.9, a grey that only depends on y
		var grey = bitmapData.getPixel(60, 10) & 0xFF;
		Assert.isTrue(grey > 0x10 && grey < 0xF0, "not a grey: " + StringTools.hex(bitmapData.getPixel32(60, 10)));
		Assert.equals(StringTools.hex(bitmapData.getPixel32(60, 10)), StringTools.hex(bitmapData.getPixel32(320, 10)));
		// below it, the first colour
		Assert.equals(StringTools.hex(0xFFFFFFFF), StringTools.hex(bitmapData.getPixel32(60, 20)));
		Assert.equals(StringTools.hex(0xFFFFFFFF), StringTools.hex(bitmapData.getPixel32(320, 20)));
	}

	public function test_beginGradientFillRadialEllipse()
	{
		// a radial gradient whose box is wider than tall is an ellipse, as in Flash: 35 pixels under its centre,
		// past its 25 pixel vertical radius, is its last colour although it is within its horizontal radius
		var matrix = new Matrix();
		matrix.createGradientBox(200, 50, 0, 0, 0);
		var shape = new Shape();
		shape.graphics.beginGradientFill(GradientType.RADIAL, [0xFF0000, 0x0000FF], [1, 1], [0, 255], matrix);
		shape.graphics.drawRect(0, 0, 200, 100);
		shape.graphics.endFill();

		var bitmapData = new BitmapData(200, 100, false, 0xFFFFFF);
		bitmapData.draw(shape);

		Assert.equals(StringTools.hex(0x0000FF, 6), StringTools.hex(bitmapData.getPixel(100, 60), 6));
		Assert.isTrue((bitmapData.getPixel(100, 25) >> 16) > 0xF0, "the centre is red: " + StringTools.hex(bitmapData.getPixel(100, 25), 6));
	}

	public function test_beginGradientFillDuplicateEndRatios()
	{
		// as in Flash, a gradient ends with the first of its records at ratio 255: the ones after it
		// never show, not even where the gradient pads past its end
		var matrix = new Matrix();
		matrix.createGradientBox(100, 10, 0, 50, 0);
		var shape = new Shape();
		shape.graphics.beginGradientFill(GradientType.LINEAR, [0xFF0000, 0x00FF00, 0x000000], [1, 1, 1], [0, 255, 255], matrix);
		shape.graphics.drawRect(0, 0, 200, 10);
		shape.graphics.endFill();

		var bitmapData = new BitmapData(200, 10, false, 0xFFFFFF);
		bitmapData.draw(shape);

		Assert.equals(StringTools.hex(0xFF0000, 6), StringTools.hex(bitmapData.getPixel(5, 5), 6));
		Assert.equals(StringTools.hex(0x00FF00, 6), StringTools.hex(bitmapData.getPixel(195, 5), 6));
	}

	public function test_getBoundsStroke()
	{
		// as in Flash: half the thickness rounded to a whole pixel, half to even, on each side and
		// whatever the joints
		var cases:Array<Array<Dynamic>> = [
			[2.5, JointStyle.ROUND, 9, 102], [2.5, JointStyle.MITER, 9, 102], [4, JointStyle.ROUND, 8, 104], [1, JointStyle.ROUND, 9.5, 101],
			[0.5, JointStyle.ROUND, 10, 100], [2.75, JointStyle.ROUND, 8.5, 103], [0, JointStyle.ROUND, 10, 100]
		];
		for (c in cases)
		{
			var shape = new Shape();
			shape.graphics.lineStyle(c[0], 0, 1, false, LineScaleMode.NORMAL, null, c[1]);
			shape.graphics.moveTo(10, 20);
			shape.graphics.lineTo(110, 20);
			shape.graphics.lineTo(110, 80);
			shape.graphics.lineTo(10, 80);
			shape.graphics.lineTo(10, 20);
			var bounds = shape.getBounds(shape);
			Assert.equals(c[2], bounds.x, "x for a thickness of " + c[0]);
			Assert.equals(c[3], bounds.width, "width for a thickness of " + c[0]);
		}
	}

	public function test_clear()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.clear;

		Assert.notNull(exists);
	}

	public function test_curveTo()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.curveTo;

		Assert.notNull(exists);
	}

	public function test_drawCircle()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.drawCircle;

		Assert.notNull(exists);
	}

	public function test_drawEllipse()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.drawEllipse;

		Assert.notNull(exists);
	}

	#if flash
	@Ignored
	#end
	public function test_drawGraphicsData()
	{
		// TODO: Confirm functionality

		#if !flash
		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.drawGraphicsData;

		Assert.notNull(exists);
		#end
	}

	public function test_drawPath()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.drawPath;

		Assert.notNull(exists);
	}

	public function test_drawRect()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.drawRect;

		Assert.notNull(exists);
	}

	@Ignored
	public function test_drawRoundRect()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.drawRoundRect;

		Assert.notNull(exists);
		#end
	}

	@Ignored
	public function test_drawRoundRectComplex()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.drawRoundRectComplex;

		Assert.notNull(exists);
		#end
	}

	@Ignored
	public function test_drawTriangles()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.drawTriangles;

		Assert.notNull(exists);
		#end
	}

	#if flash
	@Ignored
	#end
	public function test_endFill()
	{
		// TODO: Confirm functionality

		#if !flash
		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.endFill;

		Assert.notNull(exists);
		#end
	}

	public function test_lineBitmapStyle()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.lineBitmapStyle;

		Assert.notNull(exists);
	}

	@Ignored
	public function test_lineGradientStyle()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.lineGradientStyle;

		Assert.notNull(exists);
		#end
	}

	@Ignored
	public function test_lineStyle()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.lineStyle;

		Assert.notNull(exists);
		#end
	}

	public function test_lineTo()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.lineTo;

		Assert.notNull(exists);
	}

	public function test_moveTo()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;
		var exists = graphics.moveTo;

		Assert.notNull(exists);
	}

	public function test_copyFrom()
	{
		// copyFrom of a Graphics with empty bounds shouldn't
		// cause an error

		var emptyGraphics = new Shape().graphics;
		new Shape().graphics.copyFrom(emptyGraphics);
		Assert.isTrue(true);
	}
	/*private function hex (value:Int):String {

			return StringTools.hex (value, 8);

		}


		public function test_testGeometry () {

			var sprite = new Sprite ();

			Assert.equals (0.0, sprite.width);
			Assert.equals (0.0, sprite.height);

			sprite.graphics.beginFill (0xFF0000);
			sprite.graphics.drawRect (0, 0, 100, 100);

			Assert.equals (100.0, sprite.width);
			Assert.equals (100.0, sprite.height);

			sprite.graphics.clear ();

			Assert.equals (0.0, sprite.width);
			Assert.equals (0.0, sprite.height);

		}


		public function test_testBitmapFill () {

			var color = 0xFFFF0000;
			var bitmapData = new BitmapData (100, 100, true, color);
			var sprite = new Sprite ();

			sprite.graphics.beginBitmapFill (bitmapData);
			sprite.graphics.drawRect (0, 0, 100, 100);

			var test = new BitmapData (100, 100);
			test.draw (sprite);

			var pixel = test.getPixel (1, 1);

			Assert.equals (hex (0xFF0000), hex (pixel));

		}


		public function test_testFill () {

			var sprite = new Sprite ();

			sprite.graphics.beginFill (0xFF0000);
			sprite.graphics.drawRect (0, 0, 100, 100);

			var test = new BitmapData (100, 100);
			test.draw (sprite);

			var pixel = test.getPixel (1, 1);

			Assert.equals (hex (0xFF0000), hex (pixel));

		}


		public function test_testGradientFill () {

			var sprite = new Sprite ();

			var colors = [ 0x000000, 0xFF0000, 0xFFFFFF ];
			var alphas = [ 0xFF, 0xFF, 0xFF ];
			var ratios = [ 0x00, 0x88, 0xFF ];

			var matrix = new Matrix ();
			matrix.createGradientBox (256, 256);

			sprite.graphics.beginGradientFill (GradientType.LINEAR, colors, alphas, ratios, matrix);
			sprite.graphics.drawRect (0, 0, 256, 256);

			var test = new BitmapData (256, 256);
			test.draw (sprite);

			var pixel = test.getPixel32 (1, 0);
			var pixel2 = test.getPixel32 (128, 1);
			var pixel3 = test.getPixel32 (255, 1);

			// Not perfect, but should work alright to check for the gradient

			Assert.isTrue ((pixel & 0xFFFFFFFF) < 0x22);
			Assert.isTrue (((pixel2 & 0xFF0000) >> 16) > 0xEE);
			Assert.isTrue (((pixel2 & 0x00FF00) >> 8) < 0x22);
			Assert.isTrue ((pixel3 & 0xFFFFFFFF) > 0xFFF0F0F0);

		}


		public function test_testCircle () {

			var sprite = new Sprite ();

			sprite.graphics.beginFill (0xFF0000);
			sprite.graphics.drawCircle (50, 50, 50);

			var test = new BitmapData (100, 100);
			test.draw (sprite);

			var pixel = test.getPixel (1, 1);
			var pixel2 = test.getPixel (50, 50);

			Assert.equals (hex (0xFFFFFF), hex (pixel));
			Assert.equals (hex (0xFF0000), hex (pixel2));

		}


		public function test_testEllipse () {

			var sprite = new Sprite ();

			sprite.graphics.beginFill (0xFF0000);
			sprite.graphics.drawEllipse (0, 25, 100, 50);

			var test = new BitmapData (100, 100);
			test.draw (sprite);

			var pixel = test.getPixel (1, 1);
			var pixel2 = test.getPixel (50, 50);
			var pixel3 = test.getPixel (50, 20);

			Assert.equals (hex (0xFFFFFF), hex (pixel));
			Assert.equals (hex (0xFF0000), hex (pixel2));
			Assert.equals (hex (0xFFFFFF), hex (pixel3));

	}*/
}
