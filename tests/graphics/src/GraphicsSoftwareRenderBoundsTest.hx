package;

import openfl.display.Shape;
import openfl.display._internal.Context3DGraphics;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import utest.Assert;
import utest.Test;

@:access(openfl.display.Graphics)
@:access(openfl.display._internal.Context3DGraphics)
@:access(openfl.geom.Rectangle)
class GraphicsSoftwareRenderBoundsTest extends Test
{
	public function testViewportIsClippedToGraphicsLocalBounds():Void
	{
		var graphicsBounds = new Rectangle(-10000, -10000, 21920, 21080);
		var renderBounds = Context3DGraphics.getClippedRenderBounds(graphicsBounds, new Matrix(), new Rectangle(0, 0, 1920, 1080));

		Assert.notNull(renderBounds);
		Assert.equals(0, renderBounds.x);
		Assert.equals(0, renderBounds.y);
		Assert.equals(1920, renderBounds.width);
		Assert.equals(1080, renderBounds.height);
		Rectangle.__pool.release(renderBounds);
	}

	public function testViewportIsConvertedFromWorldToLocalCoordinates():Void
	{
		var graphicsBounds = new Rectangle(-100, -100, 200, 200);
		var transform = new Matrix(2, 0, 0, 2, 10, 20);
		var renderBounds = Context3DGraphics.getClippedRenderBounds(graphicsBounds, transform, new Rectangle(10, 20, 100, 50));

		Assert.notNull(renderBounds);
		Assert.equals(0, renderBounds.x);
		Assert.equals(0, renderBounds.y);
		Assert.equals(50, renderBounds.width);
		Assert.equals(25, renderBounds.height);
		Rectangle.__pool.release(renderBounds);
	}

	public function testUpscaledViewportUsesRendererCoordinates():Void
	{
		var graphicsBounds = new Rectangle(-10000, -10000, 21920, 21080);
		var displayTransform = new Matrix(4 / 3, 0, 0, 4 / 3);
		var logicalViewport = new Rectangle(0, 0, 1920, 1080);
		var rendererViewport = new Rectangle();
		logicalViewport.__transform(rendererViewport, displayTransform);

		var renderBounds = Context3DGraphics.getClippedRenderBounds(graphicsBounds, displayTransform, rendererViewport);

		Assert.notNull(renderBounds);
		Assert.equals(0, renderBounds.x);
		Assert.equals(0, renderBounds.y);
		Assert.equals(1920, renderBounds.width);
		Assert.equals(1080, renderBounds.height);
		Rectangle.__pool.release(renderBounds);
	}

	public function testRenderBoundsLimitRasterSizeAndPreserveOrigin():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(-1000, -1000, 2000, 2000);
		shape.graphics.endFill();

		shape.graphics.__update(null, 1, new Rectangle(20, 30, 100, 50));

		Assert.equals(101, shape.graphics.__width);
		Assert.equals(51, shape.graphics.__height);
		Assert.equals(20, shape.graphics.__worldTransform.tx);
		Assert.equals(30, shape.graphics.__worldTransform.ty);
	}

	public function testEmptyRenderBoundsProduceNoRaster():Void
	{
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(-1000, -1000, 2000, 2000);
		shape.graphics.endFill();

		shape.graphics.__update(null, 1, new Rectangle());

		Assert.equals(0, shape.graphics.__width);
		Assert.equals(0, shape.graphics.__height);
	}

	public function testChangedRenderBoundsInvalidateSoftwareRaster():Void
	{
		var shape = new Shape();
		var bounds = new Rectangle(0, 0, 100, 100);

		shape.graphics.__softwareDirty = false;
		shape.graphics.__setSoftwareRenderBounds(bounds);
		Assert.isTrue(shape.graphics.__softwareDirty);

		shape.graphics.__softwareDirty = false;
		shape.graphics.__setSoftwareRenderBounds(bounds);
		Assert.isFalse(shape.graphics.__softwareDirty);

		shape.graphics.__setSoftwareRenderBounds(new Rectangle(10, 0, 100, 100));
		Assert.isTrue(shape.graphics.__softwareDirty);

		shape.graphics.__softwareDirty = false;
		shape.graphics.__setSoftwareRenderBounds(null);
		Assert.isTrue(shape.graphics.__softwareDirty);
	}
}
