import GraphicsSolidFill from "openfl/display/GraphicsSolidFill";
import GraphicsStroke from "openfl/display/GraphicsStroke";
import * as assert from "assert";


describe ("ES6 | GraphicsStroke", function () {
	
	
	it ("caps", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.caps;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("fill", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		stroke.fill = new GraphicsSolidFill ();
		var exists = stroke.fill;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("joints", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.joints;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("miterLimit", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.miterLimit;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("pixelHinting", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.pixelHinting;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("scaleMode", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.scaleMode;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("thickness", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		var exists = stroke.thickness;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var stroke = new GraphicsStroke ();
		
		assert.notEqual (stroke, null);
		
	});
	
	
});