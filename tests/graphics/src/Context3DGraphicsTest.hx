package;

import openfl.display.Shape;
import openfl.display._internal.Context3DGraphics;
import openfl.geom.Rectangle;
import openfl.Vector;
import utest.Assert;
import utest.Test;

@:access(openfl.display._internal.Context3DGraphics)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
class Context3DGraphicsTest extends Test
{
	private function buildEvenOddRectangles(values:Array<Float>):Vector<Float>
	{
		return Context3DGraphics.buildEvenOddRectangles(Vector.ofArray(values));
	}

	private function getArea(rectangles:Vector<Float>):Float
	{
		var area = 0.0;
		var i = 0;
		while (i < rectangles.length)
		{
			area += rectangles[i + 2] * rectangles[i + 3];
			i += 4;
		}
		return area;
	}

	private function isCovered(rectangles:Vector<Float>, x:Float, y:Float):Bool
	{
		var i = 0;
		while (i < rectangles.length)
		{
			if (x >= rectangles[i]
				&& x < rectangles[i] + rectangles[i + 2]
				&& y >= rectangles[i + 1]
				&& y < rectangles[i + 1] + rectangles[i + 3])
			{
				return true;
			}
			i += 4;
		}
		return false;
	}

	private function isEvenOddCovered(source:Array<Float>, x:Float, y:Float):Bool
	{
		var covered = false;
		var i = 0;
		while (i < source.length)
		{
			var right = source[i] + source[i + 2];
			var bottom = source[i + 1] + source[i + 3];
			var left = Math.min(source[i], right);
			var top = Math.min(source[i + 1], bottom);
			right = Math.max(source[i], right);
			bottom = Math.max(source[i + 1], bottom);
			if (x >= left && x < right && y >= top && y < bottom)
			{
				covered = !covered;
			}
			i += 4;
		}
		return covered;
	}

	private function assertRectanglesDoNotOverlap(rectangles:Vector<Float>):Void
	{
		var first = 0;
		while (first < rectangles.length)
		{
			var second = first + 4;
			while (second < rectangles.length)
			{
				var overlaps = rectangles[first] < rectangles[second] + rectangles[second + 2]
					&& rectangles[first] + rectangles[first + 2] > rectangles[second]
					&& rectangles[first + 1] < rectangles[second + 1] + rectangles[second + 3]
					&& rectangles[first + 1] + rectangles[first + 3] > rectangles[second + 1];
				Assert.isFalse(overlaps);
				second += 4;
			}
			first += 4;
		}
	}

	public function testOrdinaryHardwareGraphicsDoNotRequireRectangleBatchPreparation():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawTriangles(Vector.ofArray([0.0, 0.0, 10.0, 0.0, 0.0, 10.0]));
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
		Assert.isFalse(shape.graphics.__rectangleBatchesRequired);
	}

	public function testSingleDrawRectDoesNotRequireRectangleBatchPreparation():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
		Assert.isFalse(shape.graphics.__rectangleBatchesRequired);
	}

	public function testDisjointDrawRectsAreCompatible():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.drawRect(20, 0, 10, 10);
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
		Assert.isTrue(shape.graphics.__rectangleBatchesRequired);
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

	public function testRectangleBatchRequirementIsClearedWhenCommandsChange():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.drawRect(20, 0, 10, 10);
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
		Assert.isTrue(shape.graphics.__rectangleBatchesRequired);

		shape.graphics.clear();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawTriangles(Vector.ofArray([0.0, 0.0, 10.0, 0.0, 0.0, 10.0]));
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
		Assert.isFalse(shape.graphics.__rectangleBatchesRequired);
	}

	public function testOverlappingDrawRectsAreCompatible():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.drawRect(5, 5, 10, 10);
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
	}

	public function testNestedDrawRectsAreCompatible():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 20, 20);
		shape.graphics.drawRect(5, 5, 5, 5);
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
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

	public function testCompatibilityCacheIsInvalidatedWhenCommandsChange():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.drawRect(20, 0, 10, 10);
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
		shape.graphics.__hardwareDirty = false;
		Assert.isTrue(shape.graphics.__hardwareCompatibilityKnown);
		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
		shape.graphics.lineStyle(1);
		shape.graphics.lineTo(30, 10);
		Assert.isFalse(shape.graphics.__hardwareCompatibilityKnown);
		Assert.isFalse(Context3DGraphics.isCompatible(shape.graphics));
	}

	public function testScale9GridIsNotStoredInCommandCompatibilityCache():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.drawRect(20, 0, 10, 10);
		shape.graphics.endFill();

		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
		shape.graphics.__hardwareDirty = false;
		shape.__worldScale9Grid = new Rectangle(0, 0, 10, 10);
		Assert.isFalse(Context3DGraphics.isCompatible(shape.graphics));
		shape.__worldScale9Grid = null;
		Assert.isTrue(Context3DGraphics.isCompatible(shape.graphics));
	}

	public function testSolidRectangleBatchMetadataAvoidsCommandTraversal():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0x123456, 0.5);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.drawRect(10, 0, 10, 10);
		shape.graphics.endFill();

		Context3DGraphics.prepareRectangleBatches(shape.graphics);

		Assert.isTrue(shape.graphics.__solidRectangleBatchesOnly);
		Assert.equals(1, shape.graphics.__rectangleBatchRects.length);
		Assert.equals(4, shape.graphics.__rectangleBatchRects[0].length);
		Assert.equals(0x7F123456, shape.graphics.__rectangleBatchFills[0]);
	}

	public function testSingleRectangleDoesNotUseBatchOnlyFastPath():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 10, 10);
		shape.graphics.endFill();

		Context3DGraphics.prepareRectangleBatches(shape.graphics);

		Assert.isFalse(shape.graphics.__solidRectangleBatchesOnly);
	}

	public function testTouchingDrawRectsMergeIntoOneQuad():Void
	{
		var rectangles = buildEvenOddRectangles([0, 0, 10, 10, 10, 0, 10, 10]);

		Assert.equals(4, rectangles.length);
		Assert.equals(200.0, getArea(rectangles));
		Assert.isTrue(isCovered(rectangles, 5, 5));
		Assert.isTrue(isCovered(rectangles, 15, 5));
	}

	public function testOverlappingDrawRectsPreserveEvenOddCutout():Void
	{
		var rectangles = buildEvenOddRectangles([0, 0, 10, 10, 5, 0, 10, 10]);

		Assert.equals(8, rectangles.length);
		Assert.equals(100.0, getArea(rectangles));
		Assert.isTrue(isCovered(rectangles, 2, 5));
		Assert.isFalse(isCovered(rectangles, 7, 5));
		Assert.isTrue(isCovered(rectangles, 12, 5));
	}

	public function testNestedDrawRectsPreserveEvenOddHole():Void
	{
		var rectangles = buildEvenOddRectangles([0, 0, 20, 20, 5, 5, 5, 5]);

		Assert.equals(16, rectangles.length);
		Assert.equals(375.0, getArea(rectangles));
		Assert.isTrue(isCovered(rectangles, 2, 2));
		Assert.isFalse(isCovered(rectangles, 7, 7));
		Assert.isTrue(isCovered(rectangles, 15, 15));
	}

	public function testIdenticalDrawRectsCancel():Void
	{
		var rectangles = buildEvenOddRectangles([0, 0, 10, 10, 0, 0, 10, 10]);

		Assert.equals(0, rectangles.length);
	}

	public function testThreeIdenticalDrawRectsRemainFilled():Void
	{
		var rectangles = buildEvenOddRectangles([0, 0, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10]);

		Assert.equals(4, rectangles.length);
		Assert.equals(100.0, getArea(rectangles));
	}

	public function testNegativeDrawRectDimensionsAreNormalized():Void
	{
		var rectangles = buildEvenOddRectangles([10, 10, -10, -10, 20, 0, -5, 5]);

		Assert.equals(8, rectangles.length);
		Assert.equals(125.0, getArea(rectangles));
		Assert.isTrue(isCovered(rectangles, 5, 5));
		Assert.isTrue(isCovered(rectangles, 17, 2));
	}

	public function testMixedRectanglesPreserveExactEvenOddCoverageWithoutOverlap():Void
	{
		var source = [0.0, 0.0, 8.0, 8.0, 3.0, -2.0, 8.0, 6.0, 2.0, 2.0, 3.0, 9.0, 12.0, 8.0, -7.0, -5.0];
		var rectangles = buildEvenOddRectangles(source);

		for (y in -3...12)
		{
			for (x in -1...14)
			{
				Assert.equals(isEvenOddCovered(source, x + 0.5, y + 0.5), isCovered(rectangles, x + 0.5, y + 0.5));
			}
		}
		assertRectanglesDoNotOverlap(rectangles);
	}

	public function testLetterboxRectanglesPreserveOffscreenCutouts():Void
	{
		var size = 10000.0;
		var viewWidth = 1920.0;
		var viewHeight = 1080.0;
		var rectangles = buildEvenOddRectangles([
			-size, -size, size + viewWidth + size, size,
			-size, viewHeight, size + viewWidth + size, size,
			-size, 0, size, size,
			viewWidth, 0, size, size
		]);

		Assert.isTrue(isCovered(rectangles, 100, -1));
		Assert.isTrue(isCovered(rectangles, -1, 100));
		Assert.isFalse(isCovered(rectangles, 100, 100));
		Assert.isTrue(isCovered(rectangles, 100, viewHeight + 1));
		Assert.isFalse(isCovered(rectangles, -1, viewHeight + 1));
		Assert.isFalse(isCovered(rectangles, viewWidth + 1, viewHeight + 1));
	}
}
