package;

import openfl.display.Sprite;
import utest.Assert;
import utest.Test;

class SpriteTest extends Test
{
	public function test_new_()
	{
		var sprite = new Sprite();

		Assert.isFalse(sprite.buttonMode);
		Assert.isTrue(sprite.useHandCursor);
	}

	public function test_buttonMode()
	{
		var sprite = new Sprite();

		Assert.isFalse(sprite.buttonMode);

		sprite.buttonMode = true;

		Assert.isTrue(sprite.buttonMode);
	}

	public function test_graphics()
	{
		var sprite = new Sprite();

		var g1 = sprite.graphics;
		var g2 = sprite.graphics;

		Assert.notNull(g1);
		Assert.notNull(g2);

		Assert.equals(g1, g2);
	}

	public function test_hitArea()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.hitArea;

		Assert.isNull(exists);
	}

	public function test_useHandCursor()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.useHandCursor;

		Assert.isTrue(exists);
	}

	public function test_startDrag()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.startDrag;

		Assert.notNull(exists);
	}

	public function test_stopDrag()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.stopDrag;

		Assert.notNull(exists);
	}
}
