package openfl.net;


class URLVariablesTest { public static function __init__ () { Mocha.describe ("Haxe | URLVariables", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var urlVariables = new URLVariables ();
		Assert.notEqual (urlVariables, null);
		
	});
	
	
	Mocha.it ("decode", function () {
		
		var urlVariables = new URLVariables ("firstName=Tom&lastName=Jones");
		urlVariables.decode ("firstName=Tom&lastName=Jones");
		Assert.equal ("Tom", urlVariables.firstName);
		Assert.equal ("Jones", urlVariables.lastName);
		
		var urlVariables = new URLVariables ();
		urlVariables.decode ("firstName=Tom&lastName=Jones");
		Assert.equal ("Tom", urlVariables.firstName);
		Assert.equal ("Jones", urlVariables.lastName);
		
	});
	
	
	Mocha.it ("toString", function () {
		
		var urlVariables = new URLVariables ("firstName=Tom&lastName=Jones");
		Assert.equal ("firstName=Tom&lastName=Jones", urlVariables.toString ());
		
	});
	
	
}); }}