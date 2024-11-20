package;

import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import utest.Assert;
import utest.Async;
import utest.Test;

class BitmapDataFileIOTest extends Test
{
	// ByteArray.loadFromFile and BitmapData.fromBase64 don't exist on flash target
	#if flash
	@Ignored
	#end
	@:timeout(1000)
	public function test_BitmapData_fromBase64(async:Async)
	{
		ByteArray.loadFromFile("openfl-base64.txt").onComplete(function(logoBytes)
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
			Assert.equals(color145x160, bitmapData.getPixel(145, 160));
			Assert.equals(color200x45, bitmapData.getPixel(200, 45));
			Assert.equals(color100x35, bitmapData.getPixel(100, 35));
			#end

			async.done();
		}).onError(function(result)
		{
				Assert.fail(result);
				async.done();
		});
	}

	public function test_BitmapData_fromBytes()
	{
		// TODO: Confirm functionality

		var exists = BitmapData.fromBytes;
		Assert.notNull(exists);
	}

	#if (!js || !html5)
	@Ignored
	#end
	public function test_BitmapData_fromCanvas()
	{
		// TODO: Confirm functionality

		#if (js && html5)
		var exists = BitmapData.fromCanvas;
		Assert.notNull(exists);
		#end
	}

	public function test_BitmapData_fromFile()
	{
		// TODO: Confirm functionality

		var exists = BitmapData.fromFile;
		Assert.notNull(exists);
	}

	public function test_BitmapData_fromImage()
	{
		// TODO: Confirm functionality

		var exists = BitmapData.fromImage;
		Assert.notNull(exists);
	}
}
