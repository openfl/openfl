package system;

import openfl.display.BitmapData;
import openfl.utils.ByteArray;

class FileIOTest
{
	#if flash
	@Ignore
	#end
	@AsyncTest public function BitmapData_fromBase64(factory:AsyncFactory)
	{
		var handler = factory.createHandler(this, function(logoBytes)
		{
			var logo = logoBytes.readUTFBytes(logoBytes.length);
			var type = 'image';

			// three different colors from OpenFL logo
			var color145x160 = 0x24afc4;
			var color200x45 = 0x8ed5e0;
			var color100x35 = 0xffffff;

			var bitmapData = BitmapData.fromBase64(logo, type);

			#if (js && html5)
			Assert.isNull(bitmapData);
			#else
			Assert.areEqual(color145x160, bitmapData.getPixel(145, 160));
			Assert.areEqual(color200x45, bitmapData.getPixel(200, 45));
			Assert.areEqual(color100x35, bitmapData.getPixel(100, 35));
			#end
		});

		ByteArray.loadFromFile("openfl-base64.txt").onComplete(handler);
	}

	@Test public function BitmapData_fromBytes()
	{
		// TODO: Confirm functionality

		var exists = BitmapData.fromBytes;
		Assert.isNotNull(exists);
	}

	#if (!js || !html5)
	@Ignore
	#end
	@Test public function BitmapData_fromCanvas()
	{
		// TODO: Confirm functionality

		#if (js && html5)
		var exists = BitmapData.fromCanvas;
		Assert.isNotNull(exists);
		#end
	}

	@Test public function BitmapData_fromFile()
	{
		// TODO: Confirm functionality

		var exists = BitmapData.fromFile;
		Assert.isNotNull(exists);
	}

	@Test public function BitmapData_fromImage()
	{
		// TODO: Confirm functionality

		var exists = BitmapData.fromImage;
		Assert.isNotNull(exists);
	}
}
