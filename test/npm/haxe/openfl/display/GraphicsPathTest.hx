package openfl.display;


import openfl.display.GraphicsPath;
import openfl.Vector;


class GraphicsPathTest { public static function __init__ () { Mocha.describe ("Haxe | GraphicsPath", function () {
	
	
	Mocha.it ("commands", function () {
		
		// TODO: Confirm functionality
		
		var commands = new Vector<Int> ();
		var graphicsPath = new GraphicsPath (commands);
		var exists = graphicsPath.commands;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("data", function () {
		
		// TODO: Confirm functionality
		
		var data = new Vector<Float> ();
		var graphicsPath = new GraphicsPath (null, data);
		var exists = graphicsPath.data;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("winding", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.winding;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		
		Assert.notEqual (graphicsPath, null);
		
	});
	
	
	Mocha.it ("curveTo", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.curveTo;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("lineTo", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.lineTo;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("moveTo", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.moveTo;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("wideLineTo", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.wideLineTo;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("wideMoveTo", function () {
		
		// TODO: Confirm functionality
		
		var graphicsPath = new GraphicsPath ();
		var exists = graphicsPath.wideMoveTo;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}