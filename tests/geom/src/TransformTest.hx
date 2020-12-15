package;

import openfl.display.Sprite;
import openfl.geom.Transform;
import utest.Assert;
import utest.Test;

class TransformTest extends Test
{
	public function test_colorTransform()
	{
		// TODO: Confirm functionality

		var transform = new Sprite().transform;
		var exists = transform.colorTransform;

		Assert.notNull(exists);
	}

	public function test_concatenatedColorTransform()
	{
		// TODO: Confirm functionality

		var transform = new Sprite().transform;
		var exists = transform.concatenatedColorTransform;

		Assert.notNull(exists);
	}

	public function test_concatenatedMatrix()
	{
		// TODO: Confirm functionality

		var transform = new Sprite().transform;
		var exists = transform.concatenatedMatrix;

		Assert.notNull(exists);
	}

	public function test_matrix()
	{
		// TODO: Confirm functionality

		var transform = new Sprite().transform;
		var exists = transform.matrix;

		Assert.notNull(exists);
	}

	public function test_pixelBounds()
	{
		// TODO: Confirm functionality

		var transform = new Sprite().transform;
		var exists = transform.pixelBounds;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var transform = new Sprite().transform;
		Assert.notNull(transform);
	}
}
