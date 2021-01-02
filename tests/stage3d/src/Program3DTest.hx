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
