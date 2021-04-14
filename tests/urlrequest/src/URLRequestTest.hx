package;

import openfl.net.URLRequest;
import utest.Assert;
import utest.Test;

class URLRequestTest extends Test
{
	public function test_contentType()
	{
		// TODO: Confirm functionality

		var urlRequest = new URLRequest();
		var exists = urlRequest.contentType;

		Assert.isNull(exists);
	}

	public function test_data()
	{
		// TODO: Confirm functionality

		var urlRequest = new URLRequest();
		var exists = urlRequest.data;

		Assert.isNull(exists);
	}

	public function test_method()
	{
		// TODO: Confirm functionality

		var urlRequest = new URLRequest();
		var exists = urlRequest.method;

		Assert.notNull(exists);
	}

	public function test_requestHeaders()
	{
		// TODO: Confirm functionality

		var urlRequest = new URLRequest();
		var exists = urlRequest.requestHeaders;

		Assert.notNull(exists);
	}

	public function test_url()
	{
		// TODO: Confirm functionality

		var urlRequest = new URLRequest();
		var exists = urlRequest.url;

		Assert.isNull(exists);
	}

	public function test_userAgent()
	{
		// TODO: Confirm functionality

		#if !flash
		var urlRequest = new URLRequest();
		var exists = urlRequest.userAgent;

		Assert.isNull(exists);
		#end
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var urlRequest = new URLRequest();
		Assert.notNull(urlRequest);
	}
}
