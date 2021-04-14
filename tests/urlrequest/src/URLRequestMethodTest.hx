package;

import openfl.net.URLRequestMethod;
import utest.Assert;
import utest.Test;

class URLRequestMethodTest extends Test
{
	public function test_test()
	{
		switch (URLRequestMethod.DELETE)
		{
			case URLRequestMethod.DELETE, URLRequestMethod.GET, URLRequestMethod.HEAD, URLRequestMethod.OPTIONS, URLRequestMethod.POST, URLRequestMethod.PUT:
				Assert.isTrue(true);
		}
	}
}
