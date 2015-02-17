package openfl.net;


import massive.munit.Assert;


class URLRequestTest {
	
	
	@Test public function contentType () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.contentType;
		
		#if lime_legacy // to be revisited later
		Assert.isNotNull (exists);
		#else
		Assert.isNull (exists);
		#end
		
	}
	
	
	@Test public function data () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.data;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function method () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.method;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function requestHeaders () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.requestHeaders;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function url () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.url;
		
		Assert.isNull (exists);
		
	}

    @Test public function userAgent () {
		
		// TODO: Confirm functionality
		
		#if !flash
		var urlRequest = new URLRequest ();
		var exists = urlRequest.userAgent;
		
		Assert.isNull (exists);
		#end
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		Assert.isNotNull (urlRequest);
		
	}
	
	
}
