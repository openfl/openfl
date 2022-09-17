package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import utest.Assert;
import utest.Test;

class GraphicsTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var shape = new Shape();
		var graphics = shape.graphics;

		Assert.notNull(graphics);
	}

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
