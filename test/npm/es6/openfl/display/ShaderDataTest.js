import ShaderData from "openfl/display/ShaderData";
import ByteArray from "openfl/utils/ByteArray";
import * as assert from "assert";


describe ("ES6 | ShaderData", function () {
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		// #if !flash
		var shaderData = new ShaderData (new ByteArray ());
		var exists = shaderData;
		
		assert.notEqual (exists, null);
		// #end
		
	});
	
	
});