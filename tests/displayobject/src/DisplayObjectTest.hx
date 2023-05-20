package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Sprite;
import openfl.filters.BitmapFilter;
import openfl.filters.DropShadowFilter;
import openfl.filters.GlowFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.Lib;
import utest.Assert;
import utest.Test;

class DisplayObjectTest extends Test
{
	public function test_getBounds()
	{
		var sprite = new Sprite();
		var bounds = sprite.getBounds(sprite);

		Assert.isTrue(bounds.isEmpty());

		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.drawRect(0, 0, 100, 100);

		bounds = sprite.getBounds(sprite);
		Assert.equals(0, bounds.x);
		Assert.equals(0, bounds.y);
		Assert.equals(100, bounds.width);
		Assert.equals(100, bounds.height);

		sprite.x = 100;

		bounds = sprite.getBounds(sprite);
		Assert.equals(0, bounds.x);
		Assert.equals(0, bounds.y);
		Assert.equals(100, bounds.width);
		Assert.equals(100, bounds.height);

		var sprite2 = new Sprite();
		sprite2.addChild(sprite);

		bounds = sprite.getBounds(sprite2);
		Assert.equals(100, bounds.x);
		Assert.equals(0, bounds.y);
		Assert.equals(100, bounds.width);
		Assert.equals(100, bounds.height);

		sprite.rotation = 90;

		bounds = sprite.getBounds(sprite2);
		Assert.equals(0, bounds.x);
		Assert.equals(0, bounds.y);
		Assert.equals(100, bounds.width);
		Assert.equals(100, bounds.height);

		bounds = sprite2.getBounds(sprite2);
		Assert.equals(0, bounds.x);
		Assert.equals(0, bounds.y);
		Assert.equals(100, bounds.width);
		Assert.equals(100, bounds.height);

		sprite.x = 200;

		bounds = sprite.getBounds(sprite);
		Assert.equals(0, bounds.x);
		Assert.equals(0, bounds.y);
		Assert.equals(100, bounds.width);
		Assert.equals(100, bounds.height);

		bounds = sprite2.getBounds(sprite);
		Assert.equals(0, bounds.x);
		Assert.equals(0, bounds.y);
		Assert.equals(100, bounds.width);
		Assert.equals(100, bounds.height);
	}

	public function test_getRect()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.getRect;

		Assert.notNull(exists);
	}

	public function test_globalToLocal()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.globalToLocal;

		Assert.notNull(exists);
	}

	public function test_hitTestObject()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.hitTestObject;

		Assert.notNull(exists);
	}

	public function test_hitTestPoint()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.hitTestPoint;

		Assert.notNull(exists);
	}

	public function test_localToGlobal()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.localToGlobal;

		Assert.notNull(exists);
	}

	/*public function test_testRect () {

			var sprite = new Sprite ();
			sprite.x = 100;
			sprite.y = 100;
			sprite.scaleX = 0.5;
			sprite.scaleY = 0.5;

			var bitmap = new Bitmap (new BitmapData (100, 100));
			sprite.addChild (bitmap);

			var rect = sprite.getRect (sprite);

			Assert.equals (0.0, rect.x);
			Assert.equals (0.0, rect.y);
			Assert.equals (100.0, rect.width);
			Assert.equals (100.0, rect.height);

			rect = sprite.getRect (Lib.current.stage);

			Assert.equals (100.0, rect.x);
			Assert.equals (100.0, rect.y);
			Assert.equals (50.0, rect.width);
			Assert.equals (50.0, rect.height);

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


		public function test_testCoordinates () {

			var sprite = new Sprite ();
			sprite.x = 100;
			sprite.y = 100;
			sprite.scaleX = 0.5;
			sprite.scaleY = 0.5;

			var globalPoint = sprite.localToGlobal (new Point ());

			Assert.equals (100.0, globalPoint.x);
			Assert.equals (100.0, globalPoint.y);

			var localPoint = sprite.globalToLocal (new Point ());

			// It should be -200, not -100, because the scale of the Sprite is reduced

			Assert.equals (-200.0, localPoint.x);
			Assert.equals (-200.0, localPoint.y);

			var bitmap = new Bitmap (new BitmapData (100, 100));
			sprite.addChild (bitmap);

			Assert.isTrue (sprite.hitTestPoint (100, 100));
			Assert.isFalse (sprite.hitTestPoint (151, 151));

	}*/
	// Properties
	public function test_alpha()
	{
		var object = new Sprite();

		Assert.equals(1.0, object.alpha);

		object.alpha = 0.732;

		#if flash
		Assert.equals(Std.int(0.732 * 256) / 256, object.alpha);
		#else
		Assert.equals(0.732, object.alpha);
		#end

		object.alpha = 1.321;

		#if flash
		Assert.equals(Std.int(1.321 * 256) / 256, object.alpha);
		#else
		Assert.equals(1.0, object.alpha);
		#end

		object.alpha = -1.432;

		#if flash
		Assert.equals(Std.int(-1.432 * 256) / 256, object.alpha);
		#else
		Assert.equals(0.0, object.alpha);
		#end
	}

	public function test_blendMode()
	{
		var object = new Sprite();

		Assert.equals(BlendMode.NORMAL, object.blendMode);

		object.blendMode = BlendMode.ADD;

		Assert.equals(BlendMode.ADD, object.blendMode);

		#if !flash
		object.blendMode = null;

		Assert.equals(BlendMode.NORMAL, object.blendMode);
		#end
	}

	public function test_cacheAsBitmap()
	{
		var object = new Sprite();

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

	public function test_filters()
	{
		var sprite = new Sprite();

		var glow_filter = new GlowFilter();
		var drop_shadow_filter = new DropShadowFilter();

		var filters = new Array<BitmapFilter>();

		Assert.equals(0, sprite.filters.length);

		filters.push(glow_filter);

		sprite.filters = filters;

		Assert.equals(1, filters.length);
		Assert.equals(glow_filter, filters[0]);

		var clonedFilters:Array<BitmapFilter> = sprite.filters;
		clonedFilters.pop();

		filters = sprite.filters;

		Assert.equals(1, filters.length);
		Assert.isOfType(filters[0], GlowFilter);

		filters = new Array<BitmapFilter>();
		filters.push(drop_shadow_filter);

		sprite.filters = filters;

		Assert.equals(1, filters.length);
		Assert.isOfType(filters[0], DropShadowFilter);
	}

	public function test_height()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.height;

		Assert.notNull(exists);
	}

	public function test_loaderInfo()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.loaderInfo;

		Assert.isNull(exists);

		// TODO: Isolate so integration is not needed

		#if integration
		openfl.Lib.current.addChild(sprite);

		Assert.notNull(sprite.loaderInfo);

		openfl.Lib.current.removeChild(sprite);
		#end
	}

	public function test_mask()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.mask;

		Assert.isNull(exists);
	}

	#if !integration
	@Ignored
	#end
	public function test_mouseX()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		var sprite = new Sprite();
		var exists = sprite.mouseX;

		Assert.notNull(exists);
	}

	#if !integration
	@Ignored
	#end
	public function test_mouseY()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		var sprite = new Sprite();
		var exists = sprite.mouseY;

		Assert.notNull(exists);
	}

	public function test_name()
	{
		var object = new Sprite();

		Assert.match(new EReg("^(instance)[0-9]+$", "g"), object.name);

		object.name = 'Test Name';

		Assert.equals('Test Name', object.name);
	}

	public function test_opaqueBackground()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.opaqueBackground;

		Assert.isNull(exists);
	}

	public function test_parent()
	{
		var sprite = new Sprite();

		var sprite2 = new Sprite();
		sprite2.addChild(sprite);

		Assert.equals(sprite2, sprite.parent);
	}

	public function test_root()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.root;

		Assert.isNull(exists);
	}

	public function test_rotation()
	{
		var object = new Sprite();

		var rotation:Float = 17.0;

		var scaleX:Float = 0.17;
		var scaleY:Float = 0.19;

		var rads:Float = rotation * (Math.PI / 180.0);

		var sine:Float = Math.sin(rads);
		var sineScaledX:Float = sine * scaleX;
		var sineScaledY:Float = sine * scaleY;

		var cosine:Float = Math.cos(rads);
		var cosineScaledX:Float = cosine * scaleX;
		var cosineScaledY:Float = cosine * scaleY;

		Assert.equals(0.0, object.rotation);

		object.rotation = rotation;

		Assert.equals(rotation, object.rotation);

		var matrix:Matrix = object.transform.matrix;

		// TODO: Radians are OK. Sin/Cos are OK. Matrix has some roundings somewhere
		#if flash
		Assert.equals(Math.round(cosine * 1000.0) / 1000.0, Math.round(matrix.a * 1000.0) / 1000.0);
		Assert.equals(Math.round(sine * 1000.0) / 1000.0, Math.round(matrix.b * 1000.0) / 1000.0);
		Assert.equals(Math.round(-sine * 1000.0) / 1000.0, Math.round(matrix.c * 1000.0) / 1000.0);
		Assert.equals(Math.round(cosine * 1000.0) / 1000.0, Math.round(matrix.d * 1000.0) / 1000.0);
		#else
		Assert.equals(cosine, matrix.a);
		Assert.equals(sine, matrix.b);
		Assert.equals(-sine, matrix.c);
		Assert.equals(cosine, matrix.d);
		#end

		object.scaleX = scaleX;
		object.scaleY = scaleY;

		matrix = object.transform.matrix;

		// TODO: Matrix has some roundings somewhere
		#if flash
		Assert.equals(Math.round(cosineScaledX * 1000.0) / 1000.0, Math.round(matrix.a * 1000.0) / 1000.0);
		Assert.equals(Math.round(sineScaledX * 1000.0) / 1000.0, Math.round(matrix.b * 1000.0) / 1000.0);
		Assert.equals(Math.round(-sineScaledY * 1000.0) / 1000.0, Math.round(matrix.c * 1000.0) / 1000.0);
		Assert.equals(Math.round(cosineScaledY * 1000.0) / 1000.0, Math.round(matrix.d * 1000.0) / 1000.0);
		#else
		Assert.equals(cosineScaledX, matrix.a);
		Assert.equals(sineScaledX, matrix.b);
		Assert.equals(-sineScaledY, matrix.c);
		Assert.equals(cosineScaledY, matrix.d);
		#end
	}

	public function test_scale9Grid()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.scale9Grid;

		Assert.isNull(exists);
	}

	public function test_scaleX()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.scaleX;

		Assert.notNull(exists);
	}

	public function test_scaleY()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.scaleY;

		Assert.notNull(exists);
	}

	public function test_scrollRect()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		sprite.scrollRect = new Rectangle(0, 0, 100, 100);
		var exists = sprite.scrollRect;

		Assert.notNull(exists);
	}

	public function test_stage()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.stage;

		Assert.isNull(exists);
	}

	public function test_transform()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.transform;

		Assert.notNull(exists);
	}

	public function test_visible()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.visible;

		Assert.notNull(exists);
	}

	public function test_width()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.width;

		Assert.notNull(exists);
	}

	public function test_x()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.x;

		Assert.notNull(exists);
	}

	public function test_y()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.y;

		Assert.notNull(exists);
	}

	// public function test_z() {}
}
