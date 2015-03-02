package openfl.display;


import massive.munit.Assert;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;


class DisplayObjectTest {
	
	
	@Test public function alpha () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.alpha;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function blendMode () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.blendMode;
		
		//Assert.isNotNull (exists);
		
	}
	
	
	@Test public function cacheAsBitmap () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.cacheAsBitmap;
		
		//Assert.isNotNull (exists);
		
	}
	
	
	@Test public function filters () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.filters;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function height () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.height;
		
		Assert.isNotNull (exists);
		
	}
	
	
	#if !lime_legacy @Ignore #end @Test public function loaderInfo () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.loaderInfo;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function mask () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mask;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function mouseX () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseX;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function mouseY () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseY;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function name () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.name;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function opaqueBackground () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.opaqueBackground;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function parent () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		sprite2.addChild (sprite);
		
		var exists = sprite.parent;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function root () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.root;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function rotation () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseChildren;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function scale9Grid () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.scale9Grid;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function scaleX () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.scaleX;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function scaleY () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.scaleY;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function scrollRect () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		sprite.scrollRect = new Rectangle (0, 0, 100, 100);
		var exists = sprite.scrollRect;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stage () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.stage;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function transform () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.transform;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function visible () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.visible;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function width () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.width;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function x () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.x;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function y () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.y;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function z () {
		
		
		
	}
	
	
	@Test public function getBounds () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.getBounds;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getRect () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.getRect;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function globalToLocal () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.globalToLocal;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function hitTestObject () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.hitTestObject;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function hitTestPoint () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.hitTestPoint;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function localToGlobal () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.localToGlobal;
		
		Assert.isNotNull (exists);
		
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
