package;

import openfl.display3D.textures.Texture;
import utest.Assert;
import utest.Test;
import Stage3DTest;

#if integration
@:depends(Stage3DTest)
#end
class TextureTest extends Test
{
	#if !integration
	@Ignored
	#end
	public function test_uploadCompressedTextureFromByteArray()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var texture = context3D.createTexture(1, 1, BGRA, false);
			var exists = texture.uploadCompressedTextureFromByteArray;

			Assert.notNull(exists);
		}
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_uploadFromBitmapData()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var context3D = Stage3DTest.__getContext3D();

		if (context3D != null)
		{
			var texture = context3D.createTexture(1, 1, BGRA, false);
			var exists = texture.uploadFromBitmapData;

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
			var texture = context3D.createTexture(1, 1, BGRA, false);
			var exists = texture.uploadFromByteArray;

			Assert.notNull(exists);
		}
		#end
	}
}
