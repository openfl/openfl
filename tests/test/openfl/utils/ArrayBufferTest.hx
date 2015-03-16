package openfl.utils;


import massive.munit.Assert;


class ArrayBufferTest {
	
	
	@Test public function test () {
		
		// TODO: Confirm functionality
		
		var arrayBuffer = new ArrayBuffer (#if js 0 #end);
		Assert.isNotNull (arrayBuffer);
		
	}
	
	
}