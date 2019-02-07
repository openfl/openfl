package openfl.display3D;

import massive.munit.Assert;
import openfl.display.Stage3DTest;
import openfl.display3D.IndexBuffer3D;

class IndexBuffer3DTest
{
	@Test public function dispose()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var indexBuffer = context3D.createIndexBuffer(1);
			var exists = indexBuffer.dispose;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function uploadFromByteArray()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var indexBuffer = context3D.createIndexBuffer(1);
			var exists = indexBuffer.uploadFromByteArray;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function uploadFromTypedArray()
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

	@Test public function uploadFromVector()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var indexBuffer = context3D.createIndexBuffer(1);
			var exists = indexBuffer.uploadFromVector;

			Assert.isNotNull(exists);
		}
		#end
	}
}
