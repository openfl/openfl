package;

import openfl.display.ShaderData;
import openfl.utils.ByteArray;
import utest.Assert;
import utest.Test;

class ShaderDataTest extends Test
{
	#if flash
	@Ignored
	#end
	public function test_new_()
	{
		// TODO: Confirm functionality

		#if !flash
		var shaderData = new ShaderData(new ByteArray());
		var exists = shaderData;

		Assert.notNull(exists);
		#end
	}
}
