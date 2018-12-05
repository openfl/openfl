import Bitmap from "openfl/display/Bitmap";
import BitmapData from "openfl/display/BitmapData";
import GradientType from "openfl/display/GradientType";
import Shape from "openfl/display/Shape";
import Sprite from "openfl/display/Sprite";
import Matrix from "openfl/geom/Matrix";
import * as assert from "assert";


describe ("ES6 | Graphics", function () {
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		
		assert.notEqual (graphics, null);
		
	});
	
	
	it ("beginBitmapFill", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.beginBitmapFill;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("beginFill", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.beginFill;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("beginGradientFill", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		// #if !neko
		var exists = graphics.beginGradientFill;
		
		assert.notEqual (exists, null);
		// #end
		
	});
	
	
	it ("clear", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.clear;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("curveTo", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.curveTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("drawCircle", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawCircle;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("drawEllipse", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawEllipse;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("drawGraphicsData", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawGraphicsData;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("drawPath", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawPath;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("drawRect", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.drawRect;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("drawRoundRect", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		// #if !neko
		var exists = graphics.drawRoundRect;
		
		assert.notEqual (exists, null);
		// #end
		
	});
	
	
	it ("drawRoundRectComplex", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		// #if !neko
		var exists = graphics.drawRoundRectComplex;
		
		assert.notEqual (exists, null);
		// #end
		
	});
	
	
	it ("drawTriangles", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		// #if !neko
		var exists = graphics.drawTriangles;
		
		assert.notEqual (exists, null);
		// #end
		
	});
	
	
	it ("endFill", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.endFill;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("lineBitmapStyle", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.lineBitmapStyle;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("lineGradientStyle", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		// #if !neko
		var exists = graphics.lineGradientStyle;
		
		assert.notEqual (exists, null);
		// #end
		
	});
	
	
	it ("lineStyle", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		// #if !neko
		var exists = graphics.lineStyle;
		
		assert.notEqual (exists, null);
		// #end
		
	});
	
	
	it ("lineTo", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.lineTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("moveTo", function () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		var exists = graphics.moveTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("copyFrom", function () {

		// copyFrom of a Graphics with empty bounds shouldn't
		// cause an error

		var emptyGraphics = new Shape().graphics;
		new Shape().graphics.copyFrom(emptyGraphics);

	});
	
	/*private function hex (value:Int) {
		
		return StringTools.hex (value, 8);
		
	});
	
	
	it ("testGeometry", function () {
		
		var sprite = new Sprite ();
		
		assert.equal (0.0, sprite.width);
		assert.equal (0.0, sprite.height);
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		assert.equal (100.0, sprite.width);
		assert.equal (100.0, sprite.height);
		
		sprite.graphics.clear ();
		
		assert.equal (0.0, sprite.width);
		assert.equal (0.0, sprite.height);
		
	});
	
	
	it ("testBitmapFill", function () {
		
		var color = 0xFFFF0000;
		var bitmapData = new BitmapData (100, 100, true, color);
		var sprite = new Sprite ();
		
		sprite.graphics.beginBitmapFill (bitmapData);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		
		assert.equal (hex (0xFF0000), hex (pixel));
		
	});
	
	
	it ("testFill", function () {
		
		var sprite = new Sprite ();
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		
		assert.equal (hex (0xFF0000), hex (pixel));
		
	});
	
	
	it ("testGradientFill", function () {
		
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
		
		assert ((pixel & 0xFFFFFFFF) < 0x22);
		assert (((pixel2 & 0xFF0000) >> 16) > 0xEE);
		assert (((pixel2 & 0x00FF00) >> 8) < 0x22);
		assert ((pixel3 & 0xFFFFFFFF) > 0xFFF0F0F0);
		
	});
	
	
	it ("testCircle", function () {
		
		var sprite = new Sprite ();
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawCircle (50, 50, 50);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		var pixel2 = test.getPixel (50, 50);
		
		assert.equal (hex (0xFFFFFF), hex (pixel));
		assert.equal (hex (0xFF0000), hex (pixel2));
		
	});
	
	
	it ("testEllipse", function () {
		
		var sprite = new Sprite ();
		
		sprite.graphics.beginFill (0xFF0000);
		sprite.graphics.drawEllipse (0, 25, 100, 50);
		
		var test = new BitmapData (100, 100);
		test.draw (sprite);
		
		var pixel = test.getPixel (1, 1);
		var pixel2 = test.getPixel (50, 50);
		var pixel3 = test.getPixel (50, 20);
		
		assert.equal (hex (0xFFFFFF), hex (pixel));
		assert.equal (hex (0xFF0000), hex (pixel2));
		assert.equal (hex (0xFFFFFF), hex (pixel3));
		
	}*/
	
	
});
