package openfl.display;


import massive.munit.Assert;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.GradientType;
import openfl.display.Sprite;
import openfl.geom.Matrix;


class GraphicsTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		
		Assert.isNotNull (graphics);
		
	}
	
	
	@Test public function beginBitmapFill () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.beginBitmapFill;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function beginFill () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.beginFill;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function beginGradientFill () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.beginGradientFill;
		
		Assert.isNotNull (exists);
		#end
		
	}
	
	
	@Test public function clear () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.clear;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function curveTo () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.curveTo;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function drawCircle () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawCircle;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function drawEllipse () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawEllipse;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function drawGraphicsData () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawGraphicsData;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function drawPath () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawPath;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function drawRect () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawRect;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function drawRoundRect () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.drawRoundRect;
		
		Assert.isNotNull (exists);
		#end
		
	}
	
	
	@Test public function drawRoundRectComplex () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.drawRoundRectComplex;
		
		Assert.isNotNull (exists);
		#end
		
	}
	
	
	@Test public function drawTriangles () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.drawTriangles;
		
		Assert.isNotNull (exists);
		#end
		
	}
	
	
	@Test public function endFill () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.endFill;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function lineBitmapStyle () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.lineBitmapStyle;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function lineGradientStyle () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.lineGradientStyle;
		
		Assert.isNotNull (exists);
		#end
		
	}
	
	
	@Test public function lineStyle () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.lineStyle;
		
		Assert.isNotNull (exists);
		#end
		
	}
	
	
	@Test public function lineTo () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.lineTo;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function moveTo () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.moveTo;
		
		Assert.isNotNull (exists);
		
	}
	
	
	/*private function hex (value:Int):String {
		
		return StringTools.hex (value, 8);
		
	}
	
	
	@Test public function testGeometry () {
		
		var sprite = new Sprite ();
		
		Assert.areEqual (0.0, sprite.width);
		Assert.areEqual (0.0, sprite.height);
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		Assert.areEqual (100.0, sprite.width);
		Assert.areEqual (100.0, sprite.height);
		
		sprite.graphics.clear ();
		
		Assert.areEqual (0.0, sprite.width);
		Assert.areEqual (0.0, sprite.height);
		
	}
	
	
	@Test public function testBitmapFill () {
		
		var color = 0xFFFF0000;
		var bitmapData = new BitmapData (100, 100, true, color);
		var sprite = new Sprite ();
		
		sprite.graphics.beginBitmapFill (bitmapData);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		
		Assert.areEqual (hex (0xFF0000), hex (pixel));
		
	}
	
	
	@Test public function testFill () {
		
		var sprite = new Sprite ();
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		
		Assert.areEqual (hex (0xFF0000), hex (pixel));
		
	}
	
	
	@Test public function testGradientFill () {
		
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
	
	
	@Test public function testCircle () {
		
		var sprite = new Sprite ();
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawCircle (50, 50, 50);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		var pixel2 = test.getPixel (50, 50);
		
		Assert.areEqual (hex (0xFFFFFF), hex (pixel));
		Assert.areEqual (hex (0xFF0000), hex (pixel2));
		
	}
	
	
	@Test public function testEllipse () {
		
		var sprite = new Sprite ();
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawEllipse (0, 25, 100, 50);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		var pixel2 = test.getPixel (50, 50);
		var pixel3 = test.getPixel (50, 20);
		
		Assert.areEqual (hex (0xFFFFFF), hex (pixel));
		Assert.areEqual (hex (0xFF0000), hex (pixel2));
		Assert.areEqual (hex (0xFFFFFF), hex (pixel3));
		
	}*/
	
	
}
