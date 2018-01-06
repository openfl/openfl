package openfl.display;


import openfl.display.GraphicsGradientFill;
import openfl.geom.Matrix;


class GraphicsGradientFillTest { public static function __init__ () { Mocha.describe ("Haxe | GraphicsGradientFill", function () {
	
	
	Mocha.it ("alphas", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.alphas = [];
		var exists = gradientFill.alphas;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("colors", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.colors = [];
		var exists = gradientFill.colors;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("focalPointRatio", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.focalPointRatio;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("interpolationMethod", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.interpolationMethod;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("matrix", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.matrix = new Matrix ();
		var exists = gradientFill.matrix;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("ratios", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.ratios = [];
		var exists = gradientFill.ratios;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("spreadMethod", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.spreadMethod;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("type", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.type;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		
		Assert.notEqual (gradientFill, null);
		
	});
	
	
}); }}