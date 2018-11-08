import Sprite from "openfl/display/Sprite";
import Transform from "openfl/geom/Transform";
import * as assert from "assert";


describe ("TypeScript | Transform", function () {
	
	
	it ("colorTransform", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.colorTransform;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("concatenatedColorTransform", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.concatenatedColorTransform;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("concatenatedMatrix", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.concatenatedMatrix;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("matrix", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.matrix;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("pixelBounds", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.pixelBounds;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		assert.notEqual (transform, null);
		
	});
	
	
});