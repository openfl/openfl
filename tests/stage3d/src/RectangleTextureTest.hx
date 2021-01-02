package;

import openfl.display3D.textures.RectangleTexture;
import utest.Assert;
import utest.Test;
import Stage3DTest;

#if integration
@:depends(Stage3DTest)
#end
class RectangleTextureTest extends Test
{
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
			var rectangleTexture = context3D.createRectangleTexture(1, 1, BGRA, false);
			var exists = rectangleTexture.uploadFromBitmapData;

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
			var rectangleTexture = context3D.createRectangleTexture(1, 1, BGRA, false);
			var exists = rectangleTexture.uploadFromByteArray;

			Assert.notNull(exists);
		}
		#end
	}
}
