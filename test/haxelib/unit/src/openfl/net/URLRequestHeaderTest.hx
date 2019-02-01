package openfl.net;


import massive.munit.Assert;


class URLRequestHeaderTest {
	
	
	@Test public function name () {
		
		// TODO: Confirm functionality
		
		var urlRequestHeader = new URLRequestHeader ();
		var exists = urlRequestHeader.name;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function value () {
		
		// TODO: Confirm functionality
		
		var urlRequestHeader = new URLRequestHeader ();
		var exists = urlRequestHeader.value;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var urlRequestHeader = new URLRequestHeader ();
		Assert.isNotNull (urlRequestHeader);
		
	}
	
	
}