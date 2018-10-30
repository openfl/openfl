import BitmapData from "openfl/display/BitmapData";
import ShaderInput from "openfl/display/ShaderInput";
import ByteArray from "openfl/utils/ByteArray";
import * as assert from "assert";


describe ("ES6 | ShaderInput", function () {
	
	
	it ("channels", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput ();
		var exists = shaderInput.channels;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("height", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput ();
		var exists = shaderInput.height;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("index", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput ();
		var exists = shaderInput.index;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("input", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput ();
		var exists = shaderInput.input;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("width", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput ();
		var exists = shaderInput.width;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput ();
		var exists = shaderInput;
		
		assert.notEqual (exists, null);
		
	});
	
	
});