package openfl.display;

import openfl.geom.Matrix;
import openfl.geom.Transform;
import openfl.filters.DropShadowFilter;
import openfl.filters.BitmapFilter;
import openfl.filters.GlowFilter;
import massive.munit.Assert;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;

class DisplayObjectTest {
	@Test public function alpha() {
		var object = new Sprite ();

		Assert.areEqual(1.0, object.alpha);

		object.alpha = 0.732;

		Assert.areEqual(0.732, object.alpha);

		object.alpha = 1.321;

		Assert.areEqual(1.0, object.alpha);

		object.alpha = -1.432;

		Assert.areEqual(0.0, object.alpha);
	}

	@Test public function blendMode() {
		var object = new Sprite ();

		Assert.areEqual(BlendMode.NORMAL, object.blendMode);

		object.blendMode = BlendMode.DIFFERENCE;

		Assert.areEqual(BlendMode.DIFFERENCE, object.blendMode);

		object.blendMode = null;

		Assert.areEqual(BlendMode.NORMAL, object.blendMode);
	}

	@Test public function cacheAsBitmap() {
		var object = new Sprite ();

		var filter = new GlowFilter();

		Assert.isFalse(object.cacheAsBitmap);

		object.cacheAsBitmap = true;

		Assert.isTrue(object.cacheAsBitmap);

		object.cacheAsBitmap = false;

		Assert.isFalse(object.cacheAsBitmap);

		object.filters = [filter];

		Assert.isTrue(object.cacheAsBitmap);

		object.filters = [];

		Assert.isFalse(object.cacheAsBitmap);
	}

	@Test public function filters() {
		var object = new Sprite ();

		var filter = new GlowFilter();
		var filter2 = new DropShadowFilter();

		var objectFilters = null;

		Assert.areEqual(0, object.filters.length);

		objectFilters = (object.filters = [filter]);

		Assert.areEqual(1, objectFilters.length);
		Assert.areEqual(filter, objectFilters[0]);

		var clonedFilters:Array<BitmapFilter> = object.filters;
		clonedFilters.pop();

		objectFilters = object.filters;

		Assert.areEqual(1, objectFilters.length);
		Assert.areEqual(filter, objectFilters[0]);

		objectFilters = (object.filters = [filter2]);

		Assert.areEqual(1, objectFilters.length);
		Assert.areEqual(filter2, objectFilters[0]);
	}

	@Test public function height() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.height;

		Assert.isNotNull(exists);

	}

	@Ignore @Test public function loaderInfo() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.loaderInfo;

		Assert.isNull(exists);

	}

	@Test public function mask() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.mask;

		Assert.isNull(exists);

	}

	@Test public function mouseX() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.mouseX;

		Assert.isNotNull(exists);

	}

	@Test public function mouseY() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.mouseY;

		Assert.isNotNull(exists);

	}

	@Test public function name() {
		var object = new Sprite ();

		Assert.doesMatch(object.name, new EReg("^(instance)[0-9]+$", "g"));

		object.name = 'Test Name';

		Assert.areEqual('Test Name', object.name);
	}

	@Test public function opaqueBackground() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.opaqueBackground;

		Assert.isNull(exists);
	}

	@Test public function parent() {
		var sprite = new Sprite ();

		var sprite2 = new Sprite ();
		sprite2.addChild(sprite);

		Assert.areEqual(sprite2, sprite.parent);
	}

	@Test public function root() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.root;

		Assert.isNull(exists);

	}

	@Test public function rotation() {
		var object = new Sprite ();

		var rotation:Float = 17.5;

		var scaleX:Float = 0.17;
		var scaleY:Float = 0.19;

		var rads:Float = rotation * (Math.PI / 180.0);

		var sine:Float = Math.sin(rads);
		var sineScaledX:Float = sine * scaleX;
		var sineScaledY:Float = sine * scaleY;

		var cosine:Float = Math.cos(rads);
		var cosineScaledX:Float = cosine * scaleX;
		var cosineScaledY:Float = cosine * scaleY;

		Assert.areEqual(0.0, object.rotation);

		object.rotation = rotation;

		Assert.areEqual(rotation, object.rotation);

		var matrix:Matrix = object.transform.matrix;

		Assert.areEqual(cosine, matrix.a);
		Assert.areEqual(sine, matrix.b);
		Assert.areEqual(-sine, matrix.c);
		Assert.areEqual(cosine, matrix.d);

		object.scaleX = scaleX;
		object.scaleY = scaleY;

		matrix = object.transform.matrix;

		Assert.areEqual(cosineScaledX, matrix.a);
		Assert.areEqual(sineScaledX, matrix.b);
		Assert.areEqual(-sineScaledY, matrix.c);
		Assert.areEqual(cosineScaledY, matrix.d);
	}

	@Test public function scale9Grid() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.scale9Grid;

		Assert.isNull(exists);

	}

	@Test public function scaleX() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.scaleX;

		Assert.isNotNull(exists);

	}

	@Test public function scaleY() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.scaleY;

		Assert.isNotNull(exists);

	}

	@Test public function scrollRect() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		sprite.scrollRect = new Rectangle (0, 0, 100, 100);
		var exists = sprite.scrollRect;

		Assert.isNotNull(exists);

	}

	@Test public function stage() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.stage;

		Assert.isNull(exists);

	}

	@Test public function transform() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.transform;

		Assert.isNotNull(exists);

	}

	@Test public function visible() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.visible;

		Assert.isNotNull(exists);

	}

	@Test public function width() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.width;

		Assert.isNotNull(exists);

	}

	@Test public function x() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.x;

		Assert.isNotNull(exists);

	}

	@Test public function y() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.y;

		Assert.isNotNull(exists);

	}

	@Test public function z() {

	}

	@Test public function getBounds() {

		var sprite = new Sprite ();
		var bounds = sprite.getBounds(sprite);

		Assert.isTrue(bounds.isEmpty());

		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.drawRect(0, 0, 100, 100);

		bounds = sprite.getBounds(sprite);
		Assert.areEqual(0, bounds.x);
		Assert.areEqual(0, bounds.y);
		Assert.areEqual(100, bounds.width);
		Assert.areEqual(100, bounds.height);

		sprite.x = 100;

		bounds = sprite.getBounds(sprite);
		Assert.areEqual(0, bounds.x);
		Assert.areEqual(0, bounds.y);
		Assert.areEqual(100, bounds.width);
		Assert.areEqual(100, bounds.height);

		var sprite2 = new Sprite ();
		sprite2.addChild(sprite);

		bounds = sprite.getBounds(sprite2);
		Assert.areEqual(100, bounds.x);
		Assert.areEqual(0, bounds.y);
		Assert.areEqual(100, bounds.width);
		Assert.areEqual(100, bounds.height);

		sprite.rotation = 90;

		bounds = sprite.getBounds(sprite2);
		Assert.areEqual(0, bounds.x);
		Assert.areEqual(0, bounds.y);
		Assert.areEqual(100, bounds.width);
		Assert.areEqual(100, bounds.height);

		bounds = sprite2.getBounds(sprite2);
		Assert.areEqual(0, bounds.x);
		Assert.areEqual(0, bounds.y);
		Assert.areEqual(100, bounds.width);
		Assert.areEqual(100, bounds.height);

		sprite.x = 200;

		bounds = sprite.getBounds(sprite);
		Assert.areEqual(0, bounds.x);
		Assert.areEqual(0, bounds.y);
		Assert.areEqual(100, bounds.width);
		Assert.areEqual(100, bounds.height);

		bounds = sprite2.getBounds(sprite);
		Assert.areEqual(0, bounds.x);
		Assert.areEqual(0, bounds.y);
		Assert.areEqual(100, bounds.width);
		Assert.areEqual(100, bounds.height);

	}

	@Test public function getRect() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.getRect;

		Assert.isNotNull(exists);

	}

	@Test public function globalToLocal() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.globalToLocal;

		Assert.isNotNull(exists);

	}

	@Test public function hitTestObject() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.hitTestObject;

		Assert.isNotNull(exists);

	}

	@Test public function hitTestPoint() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.hitTestPoint;

		Assert.isNotNull(exists);

	}

	@Test public function localToGlobal() {

		// TODO: Confirm functionality

		var sprite = new Sprite ();
		var exists = sprite.localToGlobal;

		Assert.isNotNull(exists);

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
