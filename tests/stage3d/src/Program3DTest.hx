package;

import openfl.display3D.Program3D;
import utest.Assert;
import utest.Test;
import Stage3DTest;

#if integration
@:depends(Stage3DTest)
#end
class Program3DTest extends Test
{
	#if flash
	@Ignored
	#end
	public function test_alphaSamplerUnits()
	{
		#if !flash
		// separate alpha textures get the units after the highest sampler in use, in sampler order
		var units = @:privateAccess Program3D.__getAlphaSamplerUnits(0x7, [2, 0]);
		Assert.equals(3, units.get(0));
		Assert.equals(4, units.get(2));

		units = @:privateAccess Program3D.__getAlphaSamplerUnits(0x9, [0]);
		Assert.equals(4, units.get(0));

		units = @:privateAccess Program3D.__getAlphaSamplerUnits(0xFFFF, [0, 15]);
		Assert.equals(16, units.get(0));
		Assert.equals(17, units.get(15));
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_dispose()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var program = context3D.createProgram();
			var exists = program.dispose;

			Assert.notNull(exists);
		}
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_upload()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var program = context3D.createProgram();
			var exists = program.upload;

			Assert.notNull(exists);
		}
		#end
	}
}
