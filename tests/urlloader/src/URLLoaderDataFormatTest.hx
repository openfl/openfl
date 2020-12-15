package;

import openfl.net.URLLoaderDataFormat;
import utest.Assert;
import utest.Test;

class URLLoaderDataFormatTest extends Test
{
	public function test_test()
	{
		switch (URLLoaderDataFormat.BINARY)
		{
			case URLLoaderDataFormat.BINARY, URLLoaderDataFormat.TEXT, URLLoaderDataFormat.VARIABLES:
				Assert.isTrue(true);
		}
	}
}
