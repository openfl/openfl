package openfl.display;


import openfl.display.ShaderInput;
import openfl.utils.ByteArray;


class ShaderInputTest { public static function __init__ () { Mocha.describe ("Haxe | ShaderInput", function () {
	
	
	Mocha.it ("channels", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput.channels;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("height", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput.height;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("index", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput.index;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("input", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput.input;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("width", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput.width;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}