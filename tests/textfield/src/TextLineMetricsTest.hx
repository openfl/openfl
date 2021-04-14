package;

import openfl.text.TextLineMetrics;
import utest.Assert;
import utest.Test;

class TextLineMetricsTest extends Test
{
	public function test_ascent()
	{
		// TODO: Confirm functionality

		var textLineMetrics = new TextLineMetrics(0, 0, 0, 0, 0, 0);
		var exists = textLineMetrics.ascent;

		Assert.notNull(exists);
	}

	public function test_descent()
	{
		// TODO: Confirm functionality

		var textLineMetrics = new TextLineMetrics(0, 0, 0, 0, 0, 0);
		var exists = textLineMetrics.descent;

		Assert.notNull(exists);
	}

	public function test_height()
	{
		// TODO: Confirm functionality

		var textLineMetrics = new TextLineMetrics(0, 0, 0, 0, 0, 0);
		var exists = textLineMetrics.height;

		Assert.notNull(exists);
	}

	public function test_leading()
	{
		// TODO: Confirm functionality

		var textLineMetrics = new TextLineMetrics(0, 0, 0, 0, 0, 0);
		var exists = textLineMetrics.leading;

		Assert.notNull(exists);
	}

	public function test_width()
	{
		// TODO: Confirm functionality

		var textLineMetrics = new TextLineMetrics(0, 0, 0, 0, 0, 0);
		var exists = textLineMetrics.width;

		Assert.notNull(exists);
	}

	public function test_x()
	{
		// TODO: Confirm functionality

		var textLineMetrics = new TextLineMetrics(0, 0, 0, 0, 0, 0);
		var exists = textLineMetrics.x;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var textLineMetrics = new TextLineMetrics(0, 0, 0, 0, 0, 0);
		Assert.notNull(textLineMetrics);
	}
}
