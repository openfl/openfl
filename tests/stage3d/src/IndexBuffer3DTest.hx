package;

import openfl.display3D.IndexBuffer3D;
import utest.Assert;
import utest.Test;
import Stage3DTest;

#if integration
@:depends(Stage3DTest)
#end
class IndexBuffer3DTest extends Test
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
			var indexBuffer = context3D.createIndexBuffer(1);
			var exists = indexBuffer.dispose;

			Assert.notNull(exists);
		}
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_uploadFromByteArray()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var indexBuffer = context3D.createIndexBuffer(1);
			var exists = indexBuffer.uploadFromByteArray;

			Assert.notNull(exists);
		}
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_uploadFromTypedArray()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var indexBuffer = context3D.createIndexBuffer(1);
			indexBuffer.uploadFromTypedArray(null);
		}
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_uploadFromVector()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var indexBuffer = context3D.createIndexBuffer(1);
			var exists = indexBuffer.uploadFromVector;

			Assert.notNull(exists);
		}
		#end
	}
}
