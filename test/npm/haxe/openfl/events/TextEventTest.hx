package openfl.events;


class TextEventTest { public static function __init__ () { Mocha.describe ("Haxe | TextEvent", function () {
	
	
	Mocha.it ("text", function () {
		
		// TODO: Confirm functionality
		
		var textEvent = new TextEvent (TextEvent.LINK);
		var exists = textEvent.text;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var textEvent = new TextEvent (TextEvent.LINK);
		Assert.notEqual (textEvent, null);
		
	});
	
	
}); }}