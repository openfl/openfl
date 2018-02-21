package openfl.net;


class URLVariablesTest { public static function __init__ () { Mocha.describe ("Haxe | URLVariables", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var urlVariables = new URLVariables ();
		Assert.notEqual (urlVariables, null);
		
	});
	
	
	Mocha.it ("decode", function () {
		
		// TODO: Confirm functionality
		
		var urlVariables = new URLVariables ();
		var exists = urlVariables.decode;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	/*public function toString", function () {
		
		
		
	}*/
	
	
}); }}