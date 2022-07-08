package;

import openfl.system.LoaderContext;
import utest.Assert;
import utest.Test;

class LoaderContextTest extends Test
{
	public function testAllowCodeImport()
	{
		// TODO: Confirm functionality

		var loaderContext = new LoaderContext();
		var exists = loaderContext.allowCodeImport;

		Assert.notEquals(exists, null);
	}

	#if flash
	@Ignored
	#end
	public function test_allowLoadBytesCodeExecution()
	{
		// not available in Linux Flash Player
		// TODO: Confirm functionality
		var loaderContext = new LoaderContext();
		var exists = loaderContext.allowLoadBytesCodeExecution;
		Assert.notEquals(exists, null);
	}

	public function test_applicationDomain()
	{
		// TODO: Confirm functionality
		var loaderContext = new LoaderContext();
		var exists = loaderContext.applicationDomain;
		Assert.equals(exists, null);
	}

	public function test_checkPolicyFile()
	{
		// TODO: Confirm functionality
		var loaderContext = new LoaderContext();
		var exists = loaderContext.checkPolicyFile;
		Assert.notEquals(exists, null);
	}

	public function test_securityDomain()
	{
		// TODO: Confirm functionality
		var loaderContext = new LoaderContext();
		var exists = loaderContext.securityDomain;
		Assert.equals(exists, null);
	}

	public function test_new()
	{
		// TODO: Confirm functionality
		var loaderContext = new LoaderContext();
		Assert.notEquals(loaderContext, null);
	}
}
