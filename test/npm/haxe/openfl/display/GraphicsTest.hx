package openfl.display;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.GradientType;
import openfl.display.Sprite;
import openfl.geom.Matrix;


class GraphicsTest { public static function __init__ () { Mocha.describe ("Haxe | Graphics", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		
		Assert.notEqual (graphics, null);
		
	});
	
	
	Mocha.it ("beginBitmapFill", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.beginBitmapFill;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("beginFill", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.beginFill;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("beginGradientFill", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.beginGradientFill;
		
		Assert.notEqual (exists, null);
		#end
		
	});
	
	
	Mocha.it ("clear", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.clear;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("curveTo", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.curveTo;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("drawCircle", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawCircle;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("drawEllipse", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawEllipse;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("drawGraphicsData", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawGraphicsData;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("drawPath", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawPath;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("drawRect", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawRect;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("drawRoundRect", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.drawRoundRect;
		
		Assert.notEqual (exists, null);
		#end
		
	});
	
	
	Mocha.it ("drawRoundRectComplex", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.drawRoundRectComplex;
		
		Assert.notEqual (exists, null);
		#end
		
	});
	
	
	Mocha.it ("drawTriangles", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.drawTriangles;
		
		Assert.notEqual (exists, null);
		#end
		
	});
	
	
	Mocha.it ("endFill", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.endFill;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("lineBitmapStyle", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.lineBitmapStyle;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("lineGradientStyle", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.lineGradientStyle;
		
		Assert.notEqual (exists, null);
		#end
		
	});
	
	
	Mocha.it ("lineStyle", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		#if !neko
		var exists = graphics.lineStyle;
		
		Assert.notEqual (exists, null);
		#end
		
	});
	
	
	Mocha.it ("lineTo", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.lineTo;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("moveTo", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.moveTo;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("copyFrom", function () {

		// copyFrom of a Graphics with empty bounds shouldn't
		// cause an error

		var emptyGraphics = new Shape().graphics;
		new Shape().graphics.copyFrom(emptyGraphics);

	});
	
	/*private function hex (value:Int):String {
		
		return StringTools.hex (value, 8);
		
	});
	
	
	Mocha.it ("testGeometry", function () {
		
		var sprite = new Sprite ();
		
		Assert.equal (0.0, sprite.width);
		Assert.equal (0.0, sprite.height);
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		Assert.equal (100.0, sprite.width);
		Assert.equal (100.0, sprite.height);
		
		sprite.graphics.clear ();
		
		Assert.equal (0.0, sprite.width);
		Assert.equal (0.0, sprite.height);
		
	});
	
	
	Mocha.it ("testBitmapFill", function () {
		
		var color = 0xFFFF0000;
		var bitmapData = new BitmapData (100, 100, true, color);
		var sprite = new Sprite ();
		
		sprite.graphics.beginBitmapFill (bitmapData);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		
		Assert.equal (hex (0xFF0000), hex (pixel));
		
	});
	
	
	Mocha.it ("testFill", function () {
		
		var sprite = new Sprite ();
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		
		Assert.equal (hex (0xFF0000), hex (pixel));
		
	});
	
	
	Mocha.it ("testGradientFill", function () {
		
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
		
		Assert.assert ((pixel & 0xFFFFFFFF) < 0x22);
		Assert.assert (((pixel2 & 0xFF0000) >> 16) > 0xEE);
		Assert.assert (((pixel2 & 0x00FF00) >> 8) < 0x22);
		Assert.assert ((pixel3 & 0xFFFFFFFF) > 0xFFF0F0F0);
		
	});
	
	
	Mocha.it ("testCircle", function () {
		
		var sprite = new Sprite ();
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawCircle (50, 50, 50);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		var pixel2 = test.getPixel (50, 50);
		
		Assert.equal (hex (0xFFFFFF), hex (pixel));
		Assert.equal (hex (0xFF0000), hex (pixel2));
		
	});
	
	
	Mocha.it ("testEllipse", function () {
		
		var sprite = new Sprite ();
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawEllipse (0, 25, 100, 50);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		var pixel2 = test.getPixel (50, 50);
		var pixel3 = test.getPixel (50, 20);
		
		Assert.equal (hex (0xFFFFFF), hex (pixel));
		Assert.equal (hex (0xFF0000), hex (pixel2));
		Assert.equal (hex (0xFFFFFF), hex (pixel3));
		
	}*/
	
	
}); }}
