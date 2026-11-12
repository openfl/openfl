package;

#if (!flash && lime_cairo)
import lime.graphics.cairo.CairoImageSurface;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;
import utest.Assert;
import utest.Test;

// BitmapData.draw() into a readable bitmap uses the software renderer
class SoftwareBitmapSurfaceTest extends Test
{
	public function testFillWithBitmapThatGivesASurface()
	{
		var source = new SurfaceBitmapData(8, 8, 0xFF336699);
		Assert.isFalse(source.readable);

		var shape = new Shape();
		shape.graphics.beginBitmapFill(source);
		shape.graphics.drawRect(0, 0, 8, 8);
		shape.graphics.endFill();

		var target = new BitmapData(8, 8, true, 0);
		target.draw(shape);

		Assert.equals(0xFF336699, target.getPixel32(4, 4));
	}

	public function testStrokeWithBitmapThatGivesASurface()
	{
		var source = new SurfaceBitmapData(8, 8, 0xFF336699);

		var shape = new Shape();
		shape.graphics.lineStyle(4);
		shape.graphics.lineBitmapStyle(source);
		shape.graphics.moveTo(0, 4);
		shape.graphics.lineTo(8, 4);

		var target = new BitmapData(8, 8, true, 0);
		target.draw(shape);

		Assert.equals(0xFF336699, target.getPixel32(4, 4));
	}

	public function testBitmapThatGivesASurfaceAsSource()
	{
		var source = new SurfaceBitmapData(8, 8, 0xFF336699);

		var target = new BitmapData(8, 8, true, 0);
		target.draw(source);
		Assert.equals(0xFF336699, target.getPixel32(4, 4));

		// A Bitmap of it was drawn already
		target = new BitmapData(8, 8, true, 0);
		target.draw(new Bitmap(source));
		Assert.equals(0xFF336699, target.getPixel32(4, 4));
	}

	public function testBitmapWithoutASurfaceIsStillBlack()
	{
		var source = new BitmapData(8, 8, true, 0xFF336699);
		source.disposeImage();
		Assert.isNull(source.getSurface());

		var shape = new Shape();
		shape.graphics.beginBitmapFill(source);
		shape.graphics.drawRect(0, 0, 8, 8);
		shape.graphics.endFill();

		var target = new BitmapData(8, 8, true, 0);
		target.draw(shape);
		Assert.equals(0xFF000000, target.getPixel32(4, 4));

		target = new BitmapData(8, 8, true, 0);
		target.draw(source);
		Assert.equals(0, target.getPixel32(4, 4));
	}

	public function testHitTestDoesNotAskForTheSurface()
	{
		var source = new SurfaceBitmapData(8, 8, 0xFF336699);

		var shape = new Shape();
		shape.graphics.beginBitmapFill(source);
		shape.graphics.moveTo(0, 0);
		shape.graphics.lineTo(8, 0);
		shape.graphics.lineTo(0, 8);
		shape.graphics.endFill();

		// A hit test reads the outline of a fill, not its pixels
		Assert.isTrue(@:privateAccess shape.__hitTest(2, 2, true, null, false, shape));
		Assert.isFalse(@:privateAccess shape.__hitTest(7, 7, true, null, false, shape));
		Assert.equals(0, source.surfaceRequests);
	}
}

// A bitmap that is not readable, as after disposeImage(), and can still give its pixels
private class SurfaceBitmapData extends BitmapData
{
	public var surfaceRequests:Int = 0;

	private var pixels:BitmapData;

	public function new(width:Int, height:Int, color:UInt)
	{
		super(width, height, true, color);

		pixels = clone();
		disposeImage();
	}

	public override function getSurface():CairoImageSurface
	{
		surfaceRequests++;
		return pixels.getSurface();
	}
}
#end
