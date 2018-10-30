package openfl.display;



import openfl.display.JPEGEncoderOptions;


class JPEGEncoderOptionsTest { public static function __init__ () { Mocha.describe ("Haxe | JPEGEncoderOptions", function () {
	
	
	Mocha.it ("quality", function () {
		
		var jpegEncoderOptions = new JPEGEncoderOptions ();
		var exists = jpegEncoderOptions;
		
		Assert.notEqual (exists, null);
		Assert.equal (jpegEncoderOptions.quality, 80);
		
		var jpegEncoderOptions = new JPEGEncoderOptions (100);
		Assert.equal (jpegEncoderOptions.quality, 100);
		
	});
	
	
}); }}