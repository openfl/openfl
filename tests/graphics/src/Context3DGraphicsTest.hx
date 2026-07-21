package;

import openfl.display.Shape;
import openfl.display._internal.Context3DGraphics;
import utest.Assert;
import utest.Test;

@:access(openfl.display._internal.Context3DGraphics)
class Context3DGraphicsTest extends Test
{
	public function testDisjointDrawRectsAreCompatible():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.drawRect(20, 0, 10, 10);
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
	}

	public function testTouchingDrawRectsAreCompatible():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.drawRect(10, 0, 10, 10);
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
	}

	public function testOverlappingDrawRectsAreIncompatible():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.drawRect(5, 5, 10, 10);
		shape.graphics.endFill();

		Assert.isFalse(Context3DGraphics.isCompatible(shape.graphics));
	}

	public function testNestedDrawRectsAreIncompatible():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 20, 20);
		shape.graphics.drawRect(5, 5, 5, 5);
		shape.graphics.endFill();

		Assert.isFalse(Context3DGraphics.isCompatible(shape.graphics));
	}

	public function testNegativeSizeDrawRectsUseNormalizedBounds():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(10, 10, -10, -10);
		shape.graphics.drawRect(20, 0, -5, 5);
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
	}
}
