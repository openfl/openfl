package openfl.display;


import openfl.display.Shader;
import openfl.display.ShaderPrecision;
import openfl.utils.ByteArray;


class ShaderTest { public static function __init__ () { Mocha.describe ("Haxe | Shader", function () {
	
	
	Mocha.it ("byteCode", function () {
		
		// TODO: Confirm functionality
		
		var shader = new Shader ();
		#if !flash
		shader.byteCode = new ByteArray ();
		#end
		
	});
	
	
	Mocha.it ("data", function () {
		
		// TODO: Confirm functionality
		
		var shader = new Shader ();
		var exists = shader.data;
		
		shader.data.testIsDynamic = true;
		
		#if flash
		Assert.equal (exists, null);
		#else
		Assert.notEqual (exists, null);
		#end
		
	});
	
	
	Mocha.it ("precisionHint", function () {
		
		// TODO: Confirm functionality
		
		var shader = new Shader ();
		var exists = shader.precisionHint;
		
		Assert.equal (shader.precisionHint, ShaderPrecision.FULL);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var shader = new Shader ();
		var exists = shader;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}