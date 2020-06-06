import openfl.display.BitmapData;
import openfl.utils.Assets;

class AssetsTest
{
	public static function __init__()
	{
		Mocha.describe("Assets", function()
		{
			Mocha.it("cachedBitmapData", function() {});

			Mocha.it("id", function() {});

			Mocha.it("library", function() {});

			Mocha.it("path", function() {});

			Mocha.it("type", function() {});

			Mocha.it("getBitmapData", function() {});

			Mocha.it("getBytes", function() {});

			Mocha.it("getFont", function() {});

			Mocha.it("getMovieClip", function() {});

			Mocha.it("getSound", function() {});

			Mocha.it("getText", function() {});

			#if html5
			Mocha.it("embedBitmap", function()
			{
				// When an embedded bitmap is loaded more than once, it should
				// reuse the previously loaded image
				var preload = new BitmapData(1, 1, false, 0);
				MacroPreloadTest.preload = preload.image;
				Assert.equal(1, new MacroPreloadTest(0, 0).width);
			});
			#end
		});
	}
}

#if html5
@:bitmap("assets/1x1.png") class MacroPreloadTest extends BitmapData {}
#end
