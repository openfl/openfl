package;

import openfl.display.Loader;
import openfl.display.LoaderInfo;
import utest.Assert;
import utest.Test;

class LoaderInfoTest extends Test
{
	@Ignored
	public function test_applicationDomain()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.applicationDomain;

		// Assert.isNull (exists);
	}

	public function test_bytes()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.bytes;

		Assert.isNull(exists);
	}

	public function test_bytesLoaded()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.bytesLoaded;

		Assert.notNull(exists);
	}

	public function test_bytesTotal()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.bytesTotal;

		Assert.notNull(exists);
	}

	public function test_content()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.content;

		Assert.isNull(exists);
	}

	public function test_contentType()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.contentType;

		Assert.isNull(exists);
	}

	@Ignored
	public function test_frameRate()
	{
		#if !flash // throws error until certain types of content are loaded

		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.frameRate;

		// Assert.notNull (exists);
		#end
	}

	@Ignored
	public function test_height()
	{
		#if !flash // throws error until certain types of content are loaded

		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.height;

		// Assert.notNull (exists);
		#end
	}

	public function test_loader()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.loader;

		Assert.notNull(exists);
	}

	@Ignored
	public function test_loaderURL()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.loaderURL;

		// Assert.notNull (exists);
	}

	@Ignored
	public function test_parameters()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.parameters;

		// Assert.notNull (exists);
	}

	@Ignored
	public function test_parentAllowsChild()
	{
		#if !flash // throws error until certain types of content are loaded

		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.parentAllowsChild;

		// Assert.notNull (exists);
		#end
	}

	@Ignored
	public function test_sameDomain()
	{
		#if !flash // throws error until certain types of content are loaded

		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.sameDomain;

		// Assert.notNull (exists);
		#end
	}

	@Ignored
	public function test_sharedEvents()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.sharedEvents;

		// Assert.notNull (exists);
	}

	public function test_url()
	{
		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.url;

		Assert.isNull(exists);
	}

	@Ignored
	public function test_width()
	{
		#if !flash // throws error until certain types of content are loaded

		// TODO: Confirm functionality

		var loader = new Loader();
		var exists = loader.contentLoaderInfo.width;

		// Assert.notNull (exists);
		#end
	}
}
