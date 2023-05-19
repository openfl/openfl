package;

import openfl.display.Stage;
import openfl.Lib;
import utest.Assert;
import utest.Test;

class StageTest extends Test
{
	#if !integration
	@Ignored
	#end
	public function test_align()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.align;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_allowsFullScreen()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.allowsFullScreen;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_allowsFullScreenInteractive()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.allowsFullScreenInteractive;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_application()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.application;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_color()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.color;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_displayState()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.displayState;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_focus()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.focus;

		Assert.isNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_frameRate()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.frameRate;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_quality()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.quality;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_scaleMode()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.scaleMode;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_stage3Ds()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stage3Ds;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_stageFocusRect()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stageFocusRect;

		Assert.isTrue(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_stageHeight()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stageHeight;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_stageWidth()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stageWidth;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_window()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.window;

		Assert.notNull(exists);
		#end
	}

	#if (flash || !integration)
	@Ignored
	#end
	public function test_invalidate()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if (integration && !flash)
		var exists = Lib.current.stage.invalidate;

		Assert.notNull(exists);
		#end
	}
}
