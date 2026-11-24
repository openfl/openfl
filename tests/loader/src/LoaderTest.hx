package;

import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.display.PNGEncoderOptions;
import openfl.events.Event;
import utest.Assert;
import utest.Async;
import utest.Test;

class LoaderTest extends Test
{
	public function test_content()
	{
		Assert.isTrue(true);
	}

	public function test_contentLoaderInfo()
	{
		Assert.isTrue(true);
	}

	#if !flash
	public function test_contentHasItsLoaderInfoOffStage(async:Async)
	{
		// As in Flash, the root of what a Loader loaded reports that load's LoaderInfo (its url,
		// frame rate...), on the display list or not
		var image = new BitmapData(2, 2, false, 0xFF0000);
		var bytes = image.encode(image.rect, new PNGEncoderOptions());
		var loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_)
		{
			var content = loader.content;
			Assert.notNull(content);
			Assert.isNull(content.stage);
			Assert.equals(loader.contentLoaderInfo, content.loaderInfo);
			async.done();
		});
		loader.loadBytes(bytes);
	}
	#end

	public function test_uncaughtErrorEvents()
	{
		Assert.isTrue(true);
	}

	public function test_new_()
	{
		Assert.isTrue(true);
	}

	public function test_close()
	{
		Assert.isTrue(true);
	}

	public function test_load()
	{
		Assert.isTrue(true);
	}

	public function test_loadBytes()
	{
		Assert.isTrue(true);
	}

	public function test_unload()
	{
		Assert.isTrue(true);
	}

	public function test_unloadAndStop()
	{
		Assert.isTrue(true);
	}
}
