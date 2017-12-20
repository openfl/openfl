package openfl.display;


import massive.munit.Assert;
import openfl.display.ShaderParameter;


class ShaderParameterTest {
	
	
	@Test public function index () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<Float> ();
		var exists = shaderParameter.index;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function type () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<Float> ();
		var exists = shaderParameter.type;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function value () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<Float> ();
		var exists = shaderParameter.value;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var shaderParameter = new ShaderParameter<Float> ();
		var exists = shaderParameter;
		
		Assert.isNotNull (exists);
		
	}
	
	
}