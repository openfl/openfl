package;

import openfl.display.MovieClip;
import utest.Assert;
import utest.Test;

class MovieClipTest extends Test
{
	public function test_currentFrame()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.currentFrame;

		Assert.notNull(exists);
	}

	public function test_currentFrameLabel()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.currentFrameLabel;

		Assert.isNull(exists);
	}

	public function test_currentLabel()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.currentLabel;

		Assert.isNull(exists);
	}

	public function test_currentLabels()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.currentLabels;

		Assert.notNull(exists);
	}

	public function test_enabled()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.enabled;

		Assert.isTrue(exists);
	}

	public function test_framesLoaded()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.framesLoaded;

		Assert.notNull(exists);
	}

	public function test_totalFrames()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.totalFrames;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		var clip = new MovieClip();

		#if flash
		Assert.equals(0, clip.currentFrame);
		Assert.equals(1, clip.totalFrames);
		#else
		Assert.equals(1, clip.currentFrame);
		Assert.equals(1, clip.totalFrames);
		#end

		Assert.equals(0, clip.currentLabels.length);

		Assert.equals(true, clip.enabled);
	}

	public function test_gotoAndPlay()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.gotoAndPlay;

		Assert.notNull(exists);
	}

	public function test_gotoAndStop()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.gotoAndStop;

		Assert.notNull(exists);
	}

	public function test_nextFrame()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.nextFrame;

		Assert.notNull(exists);
	}

	public function test_play()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.play;

		Assert.notNull(exists);
	}

	public function test_prevFrame()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.prevFrame;

		Assert.notNull(exists);
	}

	public function test_stop()
	{
		// TODO: Confirm functionality

		var movieClip = new MovieClip();
		var exists = movieClip.stop;

		Assert.notNull(exists);
	}
}
