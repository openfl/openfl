import ShaderParameter from "openfl/display/ShaderParameter";
import * as assert from "assert";


describe ("TypeScript | ShaderParameter", function () {
	
	
	it ("index", function () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<number> ();
		var exists = shaderParameter.index;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("type", function () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<number> ();
		var exists = shaderParameter.type;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("value", function () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<number> ();
		var exists = shaderParameter.value;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<number> ();
		var exists = shaderParameter;
		
		assert.notEqual (exists, null);
		
	});
	
	
});