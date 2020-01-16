package openfl.display;

import massive.munit.Assert;
import openfl.display.Shader;
import openfl.display.ShaderPrecision;
import openfl.utils.ByteArray;

class ShaderTest
{
	@Test public function new_()
	{
		var shader = new Shader();

		Assert.areEqual(ShaderPrecision.FULL, shader.precisionHint);
	}

	@Test public function byteCode()
	{
		// TODO: Confirm functionality

		var shader = new Shader();
		#if !flash
		shader.byteCode = new ByteArray();
		#end
	}

	@Test public function data()
	{
		// TODO: Confirm functionality

		// var shader = new Shader ();
		// var exists = shader.data;

		// #if flash
		// Assert.isNull (exists);
		// #else
		// Assert.isNotNull (exists);
		// #end
	}

	@Test public function precisionHint()
	{
		var shader = new Shader();

		Assert.areEqual(ShaderPrecision.FULL, shader.precisionHint);

		shader.precisionHint = ShaderPrecision.FAST;

		Assert.areEqual(ShaderPrecision.FAST, shader.precisionHint);
	}
}
