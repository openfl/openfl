import GraphicsPath from "openfl/display/GraphicsPath";
import Vector from "openfl/Vector";
import * as assert from "assert";


describe ("ES6 | GraphicsPath", function () {
	
	
	it ("commands", function () {
		
		// TODO: Confirm functionality
		
		var commands = new Vector ();
		var graphicsPath = new GraphicsPath (commands);
		var exists = graphicsPath.commands;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("data", function () {
		
		// TODO: Confirm functionality
		
		var data = new Vector ();
		var graphicsPath = new GraphicsPath (null, data);
		var exists = graphicsPath.data;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("winding", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.winding;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		
		assert.notEqual (graphicsPath, null);
		
	});
	
	
	it ("curveTo", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.curveTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("lineTo", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.lineTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("moveTo", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.moveTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("wideLineTo", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.wideLineTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("wideMoveTo", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.wideMoveTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
});