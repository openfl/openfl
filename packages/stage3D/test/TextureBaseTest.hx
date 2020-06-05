import openfl.display3D.textures.Texture;
import Stage3DTest;

class TextureBaseTest
{
	public static function __init__()
	{
		Mocha.describe("Haxe | TextureBase", function()
		{
			Mocha.it("dispose", function()
			{
				// TODO: Confirm functionality

				var context3D = Stage3DTest.__getContext3D();

				if (context3D != null)
				{
					var texture = context3D.createTexture(1, 1, BGRA, false);
					var exists = texture.dispose;

					Assert.notEqual(exists, null);
				}
			});
		});
	}
}
