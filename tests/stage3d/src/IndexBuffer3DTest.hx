package;

import openfl.display3D.IndexBuffer3D;
import openfl.Lib;
import openfl.Vector;
import utest.Assert;
import utest.Test;
import Stage3DTest;

@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.IndexBuffer3D)
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

	#if !flash
	// A new buffer has no data store until its first upload, even when that upload fills it
	public function test_uploadFillsANewBuffer()
	{
		var stage = Lib.current.stage;
		var context3D = (stage != null) ? stage.context3D : null;

		if (context3D == null)
		{
			Assert.pass();
			return;
		}

		var gl = context3D.gl;
		var memoryUsage = context3D.totalGPUMemory;
		var buffer = context3D.createIndexBuffer(3);
		Assert.equals(memoryUsage + 6, context3D.totalGPUMemory);

		buffer.uploadFromVector(Vector.ofArray(([0, 1, 2] : Array<UInt>)), 0, 3);
		context3D.__bindGLElementArrayBuffer(buffer.__id);
		Assert.equals(6, gl.getBufferParameter(gl.ELEMENT_ARRAY_BUFFER, gl.BUFFER_SIZE));

		buffer.uploadFromVector(Vector.ofArray(([2, 1, 0] : Array<UInt>)), 0, 3);
		context3D.__bindGLElementArrayBuffer(buffer.__id);
		Assert.equals(6, gl.getBufferParameter(gl.ELEMENT_ARRAY_BUFFER, gl.BUFFER_SIZE));
		Assert.equals(memoryUsage + 6, context3D.totalGPUMemory);

		buffer.dispose();
		Assert.equals(memoryUsage, context3D.totalGPUMemory);
	}
	#end
}
