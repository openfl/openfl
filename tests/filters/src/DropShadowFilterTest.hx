package;

import openfl.filters.DropShadowFilter;
import utest.Assert;
import utest.Test;

class DropShadowFilterTest extends Test
{
	public function test_alpha()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.alpha;

		Assert.notNull(exists);
	}

	#if flash
	@Ignored
	#end
	public function test_alphaAppliedOnTheLastBlurPass()
	{
		#if !flash
		// applied on every pass, the alpha would be raised to the power of the number of passes
		var dropShadowFilter = new DropShadowFilter(4, 45, 0, 0.5, 8, 8, 1, 2);
		var passes:Int = @:privateAccess (dropShadowFilter.__horizontalPasses + dropShadowFilter.__verticalPasses);
		Assert.isTrue(passes > 1);

		for (pass in 0...passes)
		{
			var shader:Dynamic = @:privateAccess dropShadowFilter.__initShader(null, pass, null);
			Assert.equals(pass == passes - 1 ? 0.5 : 1.0, shader.uColor.value[3], "pass " + pass);
		}
		#end
	}

	public function test_angle()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.angle;

		Assert.notNull(exists);
	}

	public function test_blurX()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.blurX;

		Assert.notNull(exists);
	}

	public function test_blurY()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.blurY;

		Assert.notNull(exists);
	}

	public function test_color()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.color;

		Assert.notNull(exists);
	}

	public function test_distance()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.distance;

		Assert.notNull(exists);
	}

	public function test_hideObject()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.hideObject;

		Assert.notNull(exists);
	}

	public function test_inner()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.inner;

		Assert.notNull(exists);
	}

	public function test_knockout()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.knockout;

		Assert.notNull(exists);
	}

	public function test_quality()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.quality;

		Assert.notNull(exists);
	}

	public function test_strength()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		var exists = dropShadowFilter.strength;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var dropShadowFilter = new DropShadowFilter();
		Assert.notNull(dropShadowFilter);
	}
}
