package ftests;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class BitmapTest extends FunctionalTest {

	@:functionalTest("bitmap/test1.png")
	function test1 (sprite:Sprite) {

		var bitmap = new Bitmap (Assets.getBitmapData ("assets/openfl.png"));
		sprite.addChild (bitmap);

		bitmap.x = (sprite.stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (sprite.stage.stageHeight - bitmap.height) / 2;

	}

	@:functionalTest("bitmap/test2.png")
	function test2 (sprite:Sprite) {

		var bitmap = new Bitmap (Assets.getBitmapData ("assets/openflLogo.png"));
		sprite.addChild (bitmap);

		bitmap.x = (sprite.stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (sprite.stage.stageHeight - bitmap.height) / 2;

	}

}
