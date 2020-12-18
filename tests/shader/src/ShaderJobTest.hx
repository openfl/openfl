package;

import openfl.display.ShaderJob;
import utest.Assert;
import utest.Test;

class ShaderJobTest extends Test
{
	public function test_height()
	{
		// TODO: Confirm functionality

		var shaderJob = new ShaderJob();
		var exists = shaderJob.height;

		Assert.notNull(exists);
	}

	public function test_progress()
	{
		// TODO: Confirm functionality

		var shaderJob = new ShaderJob();
		var exists = shaderJob.progress;

		Assert.notNull(exists);
	}

	public function test_shader()
	{
		// TODO: Confirm functionality

		var shaderJob = new ShaderJob();
		var exists = shaderJob.shader;

		Assert.isNull(exists);
	}

	public function test_target()
	{
		// TODO: Confirm functionality

		var shaderJob = new ShaderJob();
		var exists = shaderJob.target;

		Assert.isNull(exists);
	}

	public function test_width()
	{
		// TODO: Confirm functionality

		var shaderJob = new ShaderJob();
		var exists = shaderJob.width;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var shaderJob = new ShaderJob();
		var exists = shaderJob;

		Assert.notNull(exists);
	}

	public function test_cancel()
	{
		// TODO: Confirm functionality

		var shaderJob = new ShaderJob();
		var exists = shaderJob.cancel;

		Assert.notNull(exists);
	}

	public function test_start()
	{
		// TODO: Confirm functionality

		var shaderJob = new ShaderJob();
		var exists = shaderJob.start;

		Assert.notNull(exists);
	}
}
