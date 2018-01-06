


import Bitmap from "openfl/display/Bitmap";
import BitmapData from "openfl/display/BitmapData";
import Sprite from "openfl/display/Sprite";
import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";
import Lib from "openfl/Lib";
import * as assert from "assert";


describe ("ES6 | DisplayObject", function () {
	
	
	it ("alpha", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.alpha;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("blendMode", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.blendMode;
		
		//assert.notEqual (exists, null);
		
	});
	
	
	it ("cacheAsBitmap", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.cacheAsBitmap;
		
		//assert.notEqual (exists, null);
		
	});
	
	
	it ("filters", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.filters;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("height", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.height;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("loaderInfo", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.loaderInfo;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("mask", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mask;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("mouseX", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseX;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("mouseY", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseY;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("name", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.name;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("opaqueBackground", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.opaqueBackground;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("parent", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		sprite2.addChild (sprite);
		
		var exists = sprite.parent;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("root", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.root;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("rotation", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseChildren;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("scale9Grid", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.scale9Grid;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("scaleX", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.scaleX;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("scaleY", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.scaleY;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("scrollRect", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		sprite.scrollRect = new Rectangle (0, 0, 100, 100);
		var exists = sprite.scrollRect;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("stage", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.stage;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("transform", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.transform;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("visible", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.visible;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("width", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.width;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("x", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.x;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("y", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.y;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("z", function () {
		
		
		
	});
	
	
	it ("getBounds", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.getBounds;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getRect", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.getRect;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("globalToLocal", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.globalToLocal;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("hitTestObject", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.hitTestObject;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("hitTestPoint", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.hitTestPoint;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("localToGlobal", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.localToGlobal;
		
		assert.notEqual (exists, null);
		
	});
	
	
	/*it ("testRect", function () {
		
		var sprite = new Sprite ();
		sprite.x = 100;
		sprite.y = 100;
		sprite.scaleX = 0.5;
		sprite.scaleY = 0.5;
		
		var bitmap = new Bitmap (new BitmapData (100, 100));
		sprite.addChild (bitmap);
		
		var rect = sprite.getRect (sprite);
		
		assert.equal (0.0, rect.x);
		assert.equal (0.0, rect.y);
		assert.equal (100.0, rect.width);
		assert.equal (100.0, rect.height);
		
		rect = sprite.getRect (Lib.current.stage);
		
		assert.equal (100.0, rect.x);
		assert.equal (100.0, rect.y);
		assert.equal (50.0, rect.width);
		assert.equal (50.0, rect.height);
		
		sprite.removeChild (bitmap);
		sprite.graphics.beginFill (0xFFFFFF);
		sprite.graphics.lineStyle (10);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		var bounds = sprite.getRect (sprite);
		
		assert (bounds.x <= 0);
		assert (bounds.y <= 0);
		assert (bounds.width >= 100);
		assert (bounds.height >= 100);
		
		bounds = sprite.getRect (Lib.current.stage);
		
		assert (bounds.x <= 100);
		assert (bounds.y <= 100);
		assert (bounds.width >= 50);
		assert (bounds.height >= 50);
		
	});
	
	
	it ("testCoordinates", function () {
		
		var sprite = new Sprite ();
		sprite.x = 100;
		sprite.y = 100;
		sprite.scaleX = 0.5;
		sprite.scaleY = 0.5;
		
		var globalPoint = sprite.localToGlobal (new Point ());
		
		assert.equal (100.0, globalPoint.x);
		assert.equal (100.0, globalPoint.y);
		
		var localPoint = sprite.globalToLocal (new Point ());
		
		// It should be -200, not -100, because the scale of the Sprite is reduced
		
		assert.equal (-200.0, localPoint.x);
		assert.equal (-200.0, localPoint.y);
		
		var bitmap = new Bitmap (new BitmapData (100, 100));
		sprite.addChild (bitmap);
		
		assert (sprite.hitTestPoint (100, 100));
		assert (!sprite.hitTestPoint (151, 151));
		
	}*/
	
	
});