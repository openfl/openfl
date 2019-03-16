package openfl.display;

import massive.munit.Assert;

class SpriteTest
{
	@Test public function new_()
	{
		var sprite = new Sprite();

		Assert.isFalse(sprite.buttonMode);
		Assert.isTrue(sprite.useHandCursor);
	}

	@Test public function buttonMode()
	{
		var sprite = new Sprite();

		Assert.isFalse(sprite.buttonMode);

		sprite.buttonMode = true;

		Assert.isTrue(sprite.buttonMode);
	}

	@Test public function graphics()
	{
		var sprite = new Sprite();

		var g1 = sprite.graphics;
		var g2 = sprite.graphics;

		Assert.isNotNull(g1);
		Assert.isNotNull(g2);

		Assert.areSame(g1, g2);
	}

	@Test public function hitArea()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.hitArea;

		Assert.isNull(exists);
	}

	@Test public function useHandCursor()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.useHandCursor;

		Assert.isTrue(exists);
	}

	@Test public function startDrag()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.startDrag;

		Assert.isNotNull(exists);
	}

	@Test public function stopDrag()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.stopDrag;

		Assert.isNotNull(exists);
	}
}
