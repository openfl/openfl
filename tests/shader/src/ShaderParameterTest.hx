package;

import openfl.display.ShaderParameter;
import utest.Assert;
import utest.Test;

class ShaderParameterTest extends Test
{
	public function test_index()
	{
		// TODO: Confirm functionality

		var shaderParameter = new ShaderParameter<Float>();
		var exists = shaderParameter.index;

		Assert.notNull(exists);
	}

	public function test_type()
	{
		// TODO: Confirm functionality

		var shaderParameter = new ShaderParameter<Float>();
		var exists = shaderParameter.type;

		Assert.isNull(exists);
	}

	public function test_value()
	{
		// TODO: Confirm functionality

		var shaderParameter = new ShaderParameter<Float>();
		var exists = shaderParameter.value;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var shaderParameter = new ShaderParameter<Float>();
		var exists = shaderParameter;

		Assert.notNull(exists);
	}
}
