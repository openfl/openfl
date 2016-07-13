package openfl.events;


import massive.munit.Assert;


class TextEventTest {
	
	
	@Test public function text () {
		
		// TODO: Confirm functionality
		
		var textEvent = new TextEvent (TextEvent.LINK);
		var exists = textEvent.text;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var textEvent = new TextEvent (TextEvent.LINK);
		Assert.isNotNull (textEvent);
		
	}
	
	
}