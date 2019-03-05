package openfl.display3D;

import massive.munit.Assert;
import openfl.display.Stage3DTest;
import openfl.display3D.Context3D;

class Context3DTest
{
	@Test public function driverInfo()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.driverInfo;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function enableErrorChecking()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.enableErrorChecking;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function clear()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			#if !neko
			var exists = context3D.clear;

			Assert.isNotNull(exists);
			#end
		}
		#end
	}

	@Test public function configureBackBuffer()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			#if !neko
			var exists = context3D.configureBackBuffer;

			Assert.isNotNull(exists);
			#end
		}
		#end
	}

	@Test public function createCubeTexture()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.createCubeTexture;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function createIndexBuffer()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.createIndexBuffer;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function createProgram()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			#if !flash
			var exists = context3D.createProgram;

			Assert.isNotNull(exists);
			#end
		}
		#end
	}

	@Test public function createRectangleTexture()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.createRectangleTexture;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function createTexture()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.createTexture;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function createVertexBuffer()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.createVertexBuffer;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function dispose()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.dispose;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function drawToBitmapData()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.drawToBitmapData;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function drawTriangles()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.drawTriangles;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function present()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.present;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setBlendFactors()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setBlendFactors;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setColorMask()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setColorMask;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setCulling()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setCulling;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setDepthTest()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setDepthTest;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setProgram()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setProgram;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setProgramConstantsFromByteArray()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setProgramConstantsFromByteArray;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setProgramConstantsFromMatrix()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setProgramConstantsFromMatrix;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setProgramConstantsFromVector()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setProgramConstantsFromVector;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setRenderToBackBuffer()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setRenderToBackBuffer;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setRenderToTexture()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setRenderToTexture;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setSamplerStateAt()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setSamplerStateAt;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setScissorRectangle()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setStencilActions;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setStencilReferenceValue()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setStencilReferenceValue;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setTextureAt()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setTextureAt;

			Assert.isNotNull(exists);
		}
		#end
	}

	@Test public function setVertexBufferAt()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var exists = context3D.setVertexBufferAt;

			Assert.isNotNull(exists);
		}
		#end
	}
}
