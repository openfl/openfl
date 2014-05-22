package openfl.display;


import massive.munit.Assert;
import openfl.display.GraphicsGradientFill;
import openfl.geom.Matrix;


class GraphicsGradientFillTest {
	
	
	@Test public function alphas () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.alphas = [];
		var exists = gradientFill.alphas;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function colors () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.colors = [];
		var exists = gradientFill.colors;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function focalPointRatio () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.focalPointRatio;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function interpolationMethod () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.interpolationMethod;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function matrix () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.matrix = new Matrix ();
		var exists = gradientFill.matrix;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function ratios () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		gradientFill.ratios = [];
		var exists = gradientFill.ratios;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function spreadMethod () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.spreadMethod;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function type () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		var exists = gradientFill.type;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var gradientFill = new GraphicsGradientFill ();
		
		Assert.isNotNull (gradientFill);
		
	}
	
	
}