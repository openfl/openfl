package openfl.display;


import massive.munit.Assert;
import openfl.display.ShaderData;
import openfl.utils.ByteArray;


class ShaderDataTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		#if !flash
		var shaderData = new ShaderData (new ByteArray ());
		var exists = shaderData;
		
		Assert.isNotNull (exists);
		#end
		
	}
	
	
}