package;

import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import utest.Assert;
import utest.Test;

class URLLoaderTest extends Test
{
	public function test_bytesLoaded()
	{
		// TODO: Confirm functionality

		var urlLoader = new URLLoader();
		var exists = urlLoader.bytesLoaded;

		Assert.notNull(exists);
	}

	public function test_bytesTotal()
	{
		// TODO: Confirm functionality

		var urlLoader = new URLLoader();
		var exists = urlLoader.bytesTotal;

		Assert.notNull(exists);
	}

	public function test_data()
	{
		// TODO: Confirm functionality

		var urlLoader = new URLLoader();
		var exists = urlLoader.data;

		Assert.isNull(exists);
	}

	public function test_dataFormat()
	{
		// TODO: Confirm functionality

		var urlLoader = new URLLoader();
		var exists = urlLoader.dataFormat;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		var loader = new URLLoader();

		Assert.equals(0, loader.bytesLoaded);
		Assert.equals(0, loader.bytesTotal);

		Assert.equals(URLLoaderDataFormat.TEXT, loader.dataFormat);
	}

	public function test_close()
	{
		// TODO: Confirm functionality

		var urlLoader = new URLLoader();
		var exists = urlLoader.close;

		Assert.notNull(exists);
	}

	public function test_load()
	{
		// TODO: Confirm functionality

		var urlLoader = new URLLoader();
		var exists = urlLoader.load;

		Assert.notNull(exists);
	}
}
