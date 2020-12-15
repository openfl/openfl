package;

import openfl.display.BitmapData;
import utest.Assert;
import utest.Test;

class AssetsTest extends Test
{
	// public function test_cachedBitmapData() {}
	// public function test_id() {}
	// public function test_library() {}
	// public function test_path() {}
	// public function test_type() {}
	// public function test_getBitmapData() {}
	// public function test_getBytes() {}
	// public function test_getFont() {}
	// public function test_getMovieClip() {}
	// public function test_getSound() {}
	// public function test_getText() {}
	public function testEmbedBitmap()
	{
		var bitmapData = new MacroPreloadTest(0, 0);
		Assert.equals(1, bitmapData.width);
		Assert.equals(1, bitmapData.height);
	}
}

@:bitmap("assets/1x1.png") class MacroPreloadTest extends BitmapData {}
