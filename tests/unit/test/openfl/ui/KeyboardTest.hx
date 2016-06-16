package openfl.ui;


import massive.munit.Assert;


class KeyboardTest {
	
	
	@Test public function test () {
		
		var exists = Keyboard.A;
		
		Assert.isNotNull (exists);
		
	}
	
	
}