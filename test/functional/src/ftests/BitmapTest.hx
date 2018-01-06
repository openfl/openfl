package ftests;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Point;

class BitmapTest extends FunctionalTest {

	function sameSourceAndDest_helper (sprite:Sprite) {

		var image = Assets.getBitmapData ("assets/openflLogo.png");

		var bd:BitmapData = new BitmapData(100, 400);
		bd.copyPixels(image, image.rect, new Point());

		var bitmap = new Bitmap(bd);
		sprite.addChild(bitmap);

		return bd;

	}

	@:functionalTest
	function copyPixelSameSourceAndDest (sprite:Sprite) {

		var bd = sameSourceAndDest_helper (sprite);
		bd.copyPixels (bd, bd.rect, new Point (0, 100));

	}

	@:functionalTest
	function drawSameSourceAndDest (sprite:Sprite) {

		var bd = sameSourceAndDest_helper (sprite);
		bd.draw (bd, new Matrix (1, 0, 0, 1, 0, 100));

	}

	@:functionalTest @:ignore
	function scroll (sprite:Sprite) {

		sameSourceAndDest_helper (sprite).scroll (0, 100);

	}

	@:functionalTest
	function test1 (sprite:Sprite) {

		var bitmap = new Bitmap (Assets.getBitmapData ("assets/openfl.png"));
		sprite.addChild (bitmap);

		bitmap.x = (sprite.stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (sprite.stage.stageHeight - bitmap.height) / 2;

	}

	@:functionalTest
	function test2 (sprite:Sprite) {

		var bitmap = new Bitmap (Assets.getBitmapData ("assets/openflLogo.png"));
		sprite.addChild (bitmap);

		bitmap.x = (sprite.stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (sprite.stage.stageHeight - bitmap.height) / 2;

	}

}
