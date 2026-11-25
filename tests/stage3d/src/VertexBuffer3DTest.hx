package;

import openfl.display3D.VertexBuffer3D;
import openfl.Lib;
import openfl.Vector;
import utest.Assert;
import utest.Test;
import Stage3DTest;

@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.VertexBuffer3D)
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
		var buffer = context3D.createVertexBuffer(3, 2);
		Assert.equals(memoryUsage + 24, context3D.totalGPUMemory);

		buffer.uploadFromVector(Vector.ofArray([0.0, 0.0, 1.0, 0.0, 0.0, 1.0]), 0, 3);
		context3D.__bindGLArrayBuffer(buffer.__id);
		Assert.equals(24, gl.getBufferParameter(gl.ARRAY_BUFFER, gl.BUFFER_SIZE));

		buffer.uploadFromVector(Vector.ofArray([1.0, 1.0, 0.0, 1.0, 1.0, 0.0]), 0, 3);
		context3D.__bindGLArrayBuffer(buffer.__id);
		Assert.equals(24, gl.getBufferParameter(gl.ARRAY_BUFFER, gl.BUFFER_SIZE));
		Assert.equals(memoryUsage + 24, context3D.totalGPUMemory);

		buffer.dispose();
		Assert.equals(memoryUsage, context3D.totalGPUMemory);
	}
	#end
}
