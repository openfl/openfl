package;

import openfl.display.FrameLabel;
import utest.Assert;
import utest.Test;

class FrameLabelTest extends Test
{
	public function test_frame()
	{
		var frameLabel = new FrameLabel(null, 0);
		Assert.equals(0, frameLabel.frame);
		var frameLabel = new FrameLabel(null, 100);
		Assert.equals(100, frameLabel.frame);
	}

	public function test_name()
	{
		var frameLabel = new FrameLabel("abc", 0);
		Assert.equals("abc", frameLabel.name);
		var frameLabel = new FrameLabel(null, 0);
		Assert.isNull(frameLabel.name);
	}

	public function test_frameLabel()
	{
		var frameLabel = new FrameLabel(null, 0);
		Assert.isNull(frameLabel.name);
		Assert.equals(0, frameLabel.frame);
	}
}
