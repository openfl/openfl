import PerspectiveProjection from "openfl/geom/PerspectiveProjection";
import * as assert from "assert";


describe ("ES6 | PerspectiveProjection", function () {
	
	
	it ("fieldOfView", function () {
		
		// TODO: Confirm functionality
		
		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection.fieldOfView;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("focalLength", function () {
		
		// TODO: Confirm functionality
		
		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection.focalLength;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("projectionCenter", function () {
		
		// TODO: Confirm functionality
		
		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection.projectionCenter;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("toMatrix3D", function () {
		
		// TODO: Confirm functionality
		
		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection.toMatrix3D;
		
		assert.notEqual (exists, null);
		
	});
	
	
});