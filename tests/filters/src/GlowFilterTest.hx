package;

import openfl.filters.GlowFilter;
import utest.Assert;
import utest.Test;

class GlowFilterTest extends Test
{
	public function test_alpha()
	{
		// TODO: Confirm functionality

		var glowFilter = new GlowFilter();
		var exists = glowFilter.alpha;

		Assert.notNull(exists);
	}

	#if flash
	@Ignored
	#end
	public function test_alphaAppliedOnTheLastBlurPass()
	{
		#if !flash
		// applied on every pass, the alpha would be raised to the power of the number of passes
		var glowFilter = new GlowFilter(0xFF0000, 0.5, 8, 8, 2, 2);
		var passes:Int = @:privateAccess (glowFilter.__horizontalPasses + glowFilter.__verticalPasses);
		Assert.isTrue(passes > 1);

		for (pass in 0...passes)
		{
			var shader:Dynamic = @:privateAccess glowFilter.__initShader(null, pass, null);
			Assert.equals(pass == passes - 1 ? 0.5 : 1.0, shader.uColor.value[3], "pass " + pass);
		}
		#end
	}

	public function test_blurX()
	{
		// TODO: Confirm functionality

		var glowFilter = new GlowFilter();
		var exists = glowFilter.blurX;

		Assert.notNull(exists);
	}

	public function test_blurY()
	{
		// TODO: Confirm functionality

		var glowFilter = new GlowFilter();
		var exists = glowFilter.blurY;

		Assert.notNull(exists);
	}

	public function test_color()
	{
		// TODO: Confirm functionality

		var glowFilter = new GlowFilter();
		var exists = glowFilter.color;

		Assert.notNull(exists);
	}

	public function test_inner()
	{
		// TODO: Confirm functionality

		var glowFilter = new GlowFilter();
		var exists = glowFilter.inner;

		Assert.notNull(exists);
	}

	public function test_knockout()
	{
		// TODO: Confirm functionality

		var glowFilter = new GlowFilter();
		var exists = glowFilter.knockout;

		Assert.notNull(exists);
	}

	public function test_quality()
	{
		// TODO: Confirm functionality

		var glowFilter = new GlowFilter();
		var exists = glowFilter.quality;

		Assert.notNull(exists);
	}

	public function test_strength()
	{
		// TODO: Confirm functionality

		var glowFilter = new GlowFilter();
		var exists = glowFilter.strength;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var glowFilter = new GlowFilter();
		Assert.notNull(glowFilter);
	}
}
