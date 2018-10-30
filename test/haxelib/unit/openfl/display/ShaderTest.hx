package openfl.display;


import massive.munit.Assert;
import openfl.display.Shader;
import openfl.display.ShaderPrecision;
import openfl.utils.ByteArray;


class ShaderTest {
	
	
	@Test public function byteCode () {
		
		// TODO: Confirm functionality
		
		var shader = new Shader ();
		#if !flash
		shader.byteCode = new ByteArray ();
		#end
		
	}
	
	
	@Test public function data () {
		
		// TODO: Confirm functionality
		
		// var shader = new Shader ();
		// var exists = shader.data;
		
		// #if flash
		// Assert.isNull (exists);
		// #else
		// Assert.isNotNull (exists);
		// #end
		
	}
	
	
	@Test public function precisionHint () {
		
		// TODO: Confirm functionality
		
		var shader = new Shader ();
		var exists = shader.precisionHint;
		
		Assert.areEqual (ShaderPrecision.FULL, shader.precisionHint);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var shader = new Shader ();
		var exists = shader;
		
		Assert.isNotNull (exists);
		
	}
	
	
}