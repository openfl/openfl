package openfl.display;


import openfl.display.ShaderParameter;


class ShaderParameterTest { public static function __init__ () { Mocha.describe ("Haxe | ShaderParameter", function () {
	
	
	Mocha.it ("index", function () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<Float> ();
		var exists = shaderParameter.index;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("type", function () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<Float> ();
		var exists = shaderParameter.type;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("value", function () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<Float> ();
		var exists = shaderParameter.value;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<Float> ();
		var exists = shaderParameter;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}