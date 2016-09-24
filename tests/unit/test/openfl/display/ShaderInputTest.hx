package openfl.display;


import massive.munit.Assert;
import openfl.display.ShaderInput;
import openfl.utils.ByteArray;


class ShaderInputTest {
	
	
	@Test public function channels () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput.channels;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function height () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput.height;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function index () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput.index;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function input () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput.input;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function width () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput.width;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var shaderInput = new ShaderInput<BitmapData> ();
		var exists = shaderInput;
		
		Assert.isNotNull (exists);
		
	}
	
	
}