package openfl.display;

import massive.munit.Assert;
import openfl.Lib;

class StageTest
{
	@Test public function align()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.align;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function allowsFullScreen()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.allowsFullScreen;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function allowsFullScreenInteractive()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.allowsFullScreenInteractive;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function application()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.application;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function color()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.color;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function displayState()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.displayState;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function focus()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.focus;

		Assert.isNull(exists);
		#end
	}

	@Test public function frameRate()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.frameRate;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function quality()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.quality;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function scaleMode()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.scaleMode;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function stage3Ds()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stage3Ds;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function stageFocusRect()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stageFocusRect;

		Assert.isTrue(exists);
		#end
	}

	@Test public function stageHeight()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stageHeight;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function stageWidth()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stageWidth;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function window()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.window;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function invalidate()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.invalidate;

		Assert.isNotNull(exists);
		#end
	}
}
