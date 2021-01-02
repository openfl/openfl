package;

import openfl.net.URLRequestHeader;
import utest.Assert;
import utest.Test;

class URLRequestHeaderTest extends Test
{
	public function test_name()
	{
		// TODO: Confirm functionality

		var urlRequestHeader = new URLRequestHeader();
		var exists = urlRequestHeader.name;

		Assert.notNull(exists);
	}

	public function test_value()
	{
		// TODO: Confirm functionality

		var urlRequestHeader = new URLRequestHeader();
		var exists = urlRequestHeader.value;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var urlRequestHeader = new URLRequestHeader();
		Assert.notNull(urlRequestHeader);
	}
}
