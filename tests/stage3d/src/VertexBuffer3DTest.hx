package;

import openfl.display3D.VertexBuffer3D;
import utest.Assert;
import utest.Test;
import Stage3DTest;

#if integration
@:depends(Stage3DTest)
#end
class VertexBuffer3DTest extends Test
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
			var vertexBuffer = context3D.createVertexBuffer(1, 1);
			var exists = vertexBuffer.dispose;

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
			var vertexBuffer = context3D.createVertexBuffer(1, 1);
			var exists = vertexBuffer.uploadFromByteArray;

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
			var vertexBuffer = context3D.createVertexBuffer(1, 1);
			vertexBuffer.uploadFromTypedArray(null);
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
			var vertexBuffer = context3D.createVertexBuffer(1, 1);
			var exists = vertexBuffer.uploadFromVector;

			Assert.notNull(exists);
		}
		#end
	}
}
