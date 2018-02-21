import GraphicsGradientFill from "openfl/display/GraphicsGradientFill";
import Matrix from "openfl/geom/Matrix";
import * as assert from "assert";


describe ("TypeScript | GraphicsGradientFill", function () {
	
	
	it ("alphas", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.alphas = [];
		var exists = gradientFill.alphas;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("colors", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.colors = [];
		var exists = gradientFill.colors;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("focalPointRatio", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.focalPointRatio;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("interpolationMethod", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.interpolationMethod;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("matrix", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.matrix = new Matrix ();
		var exists = gradientFill.matrix;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("ratios", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.ratios = [];
		var exists = gradientFill.ratios;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("spreadMethod", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.spreadMethod;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("type", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.type;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		
		assert.notEqual (gradientFill, null);
		
	});
	
	
});