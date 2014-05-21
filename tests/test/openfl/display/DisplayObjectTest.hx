package openfl.display;


import massive.munit.Assert;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.Lib;


class DisplayObjectTest {
	
	
	/*@Ignore @Test*/ public function accessibilityProperties () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function alpha () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function blendMode () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function blendShader () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function cacheAsBitmap () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function filters () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function height () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function loaderInfo () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function mask () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function mouseX () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function mouseY () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function name () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function opaqueBackground () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function parent () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function root () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function rotation () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function rotationX () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function rotationY () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function rotationZ () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function scale9Grid () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function scaleX () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function scaleY () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function scaleZ () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function scrollRect () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function stage () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function transform () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function visible () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function width () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function x () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function y () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function z () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getBounds () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getRect () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function globalToLocal () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function globalToLocal3D () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function hitTestObject () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function hitTestPoint () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function local3DToGlobal () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function localToGlobal () {
		
		
		
	}
	
	
	/*@Test public function testRect () {
		
		var sprite = new Sprite ();
		sprite.x = 100;
		sprite.y = 100;
		sprite.scaleX = 0.5;
		sprite.scaleY = 0.5;
		
		var bitmap = new Bitmap (new BitmapData (100, 100));
		sprite.addChild (bitmap);
		
		var rect = sprite.getRect (sprite);
		
		Assert.areEqual (0.0, rect.x);
		Assert.areEqual (0.0, rect.y);
		Assert.areEqual (100.0, rect.width);
		Assert.areEqual (100.0, rect.height);
		
		rect = sprite.getRect (Lib.current.stage);
		
		Assert.areEqual (100.0, rect.x);
		Assert.areEqual (100.0, rect.y);
		Assert.areEqual (50.0, rect.width);
		Assert.areEqual (50.0, rect.height);
		
		sprite.removeChild (bitmap);
		sprite.graphics.beginFill (0xFFFFFF);
		sprite.graphics.lineStyle (10);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		var bounds = sprite.getRect (sprite);
		
		Assert.isTrue (bounds.x <= 0);
		Assert.isTrue (bounds.y <= 0);
		Assert.isTrue (bounds.width >= 100);
		Assert.isTrue (bounds.height >= 100);
		
		bounds = sprite.getRect (Lib.current.stage);
		
		Assert.isTrue (bounds.x <= 100);
		Assert.isTrue (bounds.y <= 100);
		Assert.isTrue (bounds.width >= 50);
		Assert.isTrue (bounds.height >= 50);
		
	}
	
	
	@Test public function testCoordinates () {
		
		var sprite = new Sprite ();
		sprite.x = 100;
		sprite.y = 100;
		sprite.scaleX = 0.5;
		sprite.scaleY = 0.5;
		
		var globalPoint = sprite.localToGlobal (new Point ());
		
		Assert.areEqual (100.0, globalPoint.x);
		Assert.areEqual (100.0, globalPoint.y);
		
		var localPoint = sprite.globalToLocal (new Point ());
		
		// It should be -200, not -100, because the scale of the Sprite is reduced
		
		Assert.areEqual (-200.0, localPoint.x);
		Assert.areEqual (-200.0, localPoint.y);
		
		var bitmap = new Bitmap (new BitmapData (100, 100));
		sprite.addChild (bitmap);
		
		Assert.isTrue (sprite.hitTestPoint (100, 100));
		Assert.isFalse (sprite.hitTestPoint (151, 151));
		
	}*/
	

}
