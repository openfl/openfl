package openfl.display;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;


class DisplayObjectTest { public static function __init__ () { Mocha.describe ("Haxe | DisplayObject", function () {
	
	
	Mocha.it ("alpha", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.alpha;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("blendMode", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.blendMode;
		
		//Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("cacheAsBitmap", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.cacheAsBitmap;
		
		//Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("filters", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.filters;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("height", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.height;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	@Ignore Mocha.it ("loaderInfo", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.loaderInfo;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("mask", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mask;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("mouseX", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseX;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("mouseY", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseY;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("name", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.name;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("opaqueBackground", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.opaqueBackground;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("parent", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		sprite2.addChild (sprite);
		
		var exists = sprite.parent;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("root", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.root;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("rotation", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseChildren;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("scale9Grid", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.scale9Grid;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("scaleX", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.scaleX;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("scaleY", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.scaleY;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("scrollRect", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		sprite.scrollRect = new Rectangle (0, 0, 100, 100);
		var exists = sprite.scrollRect;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("stage", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.stage;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("transform", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.transform;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("visible", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.visible;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("width", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.width;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("x", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.x;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("y", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.y;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("z", function () {
		
		
		
	});
	
	
	Mocha.it ("getBounds", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.getBounds;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getRect", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.getRect;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("globalToLocal", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.globalToLocal;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("hitTestObject", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.hitTestObject;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("hitTestPoint", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.hitTestPoint;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("localToGlobal", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.localToGlobal;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	/*Mocha.it ("testRect", function () {
		
		var sprite = new Sprite ();
		sprite.x = 100;
		sprite.y = 100;
		sprite.scaleX = 0.5;
		sprite.scaleY = 0.5;
		
		var bitmap = new Bitmap (new BitmapData (100, 100));
		sprite.addChild (bitmap);
		
		var rect = sprite.getRect (sprite);
		
		Assert.equal (0.0, rect.x);
		Assert.equal (0.0, rect.y);
		Assert.equal (100.0, rect.width);
		Assert.equal (100.0, rect.height);
		
		rect = sprite.getRect (Lib.current.stage);
		
		Assert.equal (100.0, rect.x);
		Assert.equal (100.0, rect.y);
		Assert.equal (50.0, rect.width);
		Assert.equal (50.0, rect.height);
		
		sprite.removeChild (bitmap);
		sprite.graphics.beginFill (0xFFFFFF);
		sprite.graphics.lineStyle (10);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		var bounds = sprite.getRect (sprite);
		
		Assert.assert (bounds.x <= 0);
		Assert.assert (bounds.y <= 0);
		Assert.assert (bounds.width >= 100);
		Assert.assert (bounds.height >= 100);
		
		bounds = sprite.getRect (Lib.current.stage);
		
		Assert.assert (bounds.x <= 100);
		Assert.assert (bounds.y <= 100);
		Assert.assert (bounds.width >= 50);
		Assert.assert (bounds.height >= 50);
		
	});
	
	
	Mocha.it ("testCoordinates", function () {
		
		var sprite = new Sprite ();
		sprite.x = 100;
		sprite.y = 100;
		sprite.scaleX = 0.5;
		sprite.scaleY = 0.5;
		
		var globalPoint = sprite.localToGlobal (new Point ());
		
		Assert.equal (100.0, globalPoint.x);
		Assert.equal (100.0, globalPoint.y);
		
		var localPoint = sprite.globalToLocal (new Point ());
		
		// It should be -200, not -100, because the scale of the Sprite is reduced
		
		Assert.equal (-200.0, localPoint.x);
		Assert.equal (-200.0, localPoint.y);
		
		var bitmap = new Bitmap (new BitmapData (100, 100));
		sprite.addChild (bitmap);
		
		Assert.assert (sprite.hitTestPoint (100, 100));
		Assert.assert (!sprite.hitTestPoint (151, 151));
		
	}*/
	
	
}); }}