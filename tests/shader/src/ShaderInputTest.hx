package;

import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.utils.ByteArray;
import utest.Assert;
import utest.Test;

class ShaderInputTest extends Test
{
	public function test_channels()
	{
		// TODO: Confirm functionality

		var shaderInput = new ShaderInput<BitmapData>();
		var exists = shaderInput.channels;

		Assert.notNull(exists);
	}

	public function test_height()
	{
		// TODO: Confirm functionality

		var shaderInput = new ShaderInput<BitmapData>();
		var exists = shaderInput.height;

		Assert.notNull(exists);
	}

	public function test_index()
	{
		// TODO: Confirm functionality

		var shaderInput = new ShaderInput<BitmapData>();
		var exists = shaderInput.index;

		Assert.notNull(exists);
	}

	public function test_input()
	{
		// TODO: Confirm functionality

		var shaderInput = new ShaderInput<BitmapData>();
		var exists = shaderInput.input;

		Assert.isNull(exists);
	}

	public function test_width()
	{
		// TODO: Confirm functionality

		var shaderInput = new ShaderInput<BitmapData>();
		var exists = shaderInput.width;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var shaderInput = new ShaderInput<BitmapData>();
		var exists = shaderInput;

		Assert.notNull(exists);
	}
}
