package openfl.display;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.Lib;


class DisplayObjectContainerTest { public static function __init__ () { Mocha.describe ("Haxe | DisplayObjectContainer", function () {
	
	
	Mocha.it ("mouseChildren", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseChildren;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("numChildren", function () {
		
		var sprites = [];
		
		for (i in 0...4) {
			
			sprites.push (new Sprite ());
			
		}
		
		Assert.equal (sprites[0].numChildren, 0);
		
		for (i in 1...4) {
			
			sprites[0].addChild (sprites[i]);
			Assert.equal (sprites[0].numChildren, i);
			
		}
		
		for (i in 1...4) {
			
			sprites[0].removeChild (sprites[i]);
			Assert.equal (sprites[0].numChildren, 3 - i);
			
		}
		
	});
	
	
	Mocha.it ("tabChildren", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.tabChildren;
		
		//Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("addChild", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		sprite.addChild (sprite2);
		
		Assert.equal (sprite.numChildren, 1);
		Assert.equal (sprite.getChildAt (0), sprite2);
		
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite3);
		
		Assert.equal (sprite.numChildren, 2);
		Assert.equal (sprite.getChildIndex (sprite2), 0);
		Assert.equal (sprite.getChildIndex (sprite3), 1);
		
		sprite.addChild (sprite2);
		
		Assert.equal (sprite.getChildIndex (sprite3), 0);
		Assert.equal (sprite.getChildIndex (sprite2), 1);
		
		sprite2.addChild (sprite3);
		
		Assert.equal (sprite3.parent, sprite2);
		
	});
	
	
	Mocha.it ("addChildAt", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		sprite.addChildAt (sprite2, 0);
		
		Assert.equal (sprite.numChildren, 1);
		Assert.equal (sprite.getChildAt (0), sprite2);
		
		var sprite3 = new Sprite ();
		
		sprite.addChildAt (sprite3, 1);
		
		Assert.equal (sprite.numChildren, 2);
		Assert.equal (sprite.getChildIndex (sprite2), 0);
		Assert.equal (sprite.getChildIndex (sprite3), 1);
		
		sprite.addChildAt (sprite2, 0);
		
		Assert.equal (sprite.getChildIndex (sprite2), 0);
		Assert.equal (sprite.getChildIndex (sprite3), 1);
		
		sprite.addChildAt (sprite2, 1);
		
		Assert.equal (sprite.getChildIndex (sprite3), 0);
		Assert.equal (sprite.getChildIndex (sprite2), 1);
		
	});
	
	
	Mocha.it ("areInaccessibleObjectsUnderPoint", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.areInaccessibleObjectsUnderPoint;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("contains", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		Assert.assert (sprite.contains (sprite));
		Assert.assert (!sprite.contains (sprite2));
		
		sprite.addChild (sprite2);
		
		Assert.assert (sprite.contains (sprite2));
		
		var sprite3 = new Sprite ();
		var sprite4 = new Sprite ();
		
		sprite3.addChild (sprite4);
		sprite.addChild (sprite3);
		
		Assert.assert (sprite.contains (sprite3));
		Assert.assert (sprite.contains (sprite4));
		Assert.assert (!sprite3.contains (sprite));
		Assert.assert (!sprite4.contains (sprite));
		
		sprite.removeChild (sprite3);
		sprite.removeChild (sprite2);
		
		Assert.assert (!sprite.contains (sprite2));
		Assert.assert (!sprite.contains (sprite3));
		Assert.assert (!sprite.contains (sprite4));
		
	});
	
	
	Mocha.it ("getChildAt", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		sprite.addChild (sprite2);
		
		Assert.equal (sprite.getChildAt (0), sprite2);
		
		var sprite3 = new Sprite ();
		sprite.addChild (sprite3);
		
		Assert.equal (sprite.getChildAt (1), sprite3);
		
		sprite2.addChild (sprite3);
		
		Assert.equal (sprite2.getChildAt (0), sprite3);
		
		try {
			
			sprite.getChildAt (2);
			Assert.ok (false);
			
		} catch (e:Dynamic) {}
		
	});
	
	
	Mocha.it ("getChildByName", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite2.name = "a";
		sprite3.name = "a";
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		
		Assert.equal (sprite.getChildByName ("b"), null);
		Assert.equal (sprite.getChildByName ("a"), sprite2);
		
		sprite3.name = "b";
		
		Assert.equal (sprite.getChildByName ("b"), sprite3);
		
	});
	
	
	Mocha.it ("getChildIndex", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		
		Assert.equal (sprite.getChildIndex (sprite2), 0);
		Assert.equal (sprite.getChildIndex (sprite3), 1);
		
		try {
			
			sprite2.getChildIndex (sprite3);
			Assert.ok (false);
			
		} catch (e:Dynamic) {}
		
	});
	
	
	Mocha.it ("getObjectsUnderPoint", function () {
		
		// #if (cpp || neko) // TODO: works but sometimes suffers from a race condition when run immediately
		
		var sprite = new Sprite ();
		
		var sprite2 = new Sprite ();
		sprite2.graphics.beginFill (0xFF0000);
		sprite2.graphics.drawRect (0, 0, 100, 100);
		sprite.addChild (sprite2);
		
		Assert.equal (sprite.getObjectsUnderPoint (new Point (10, 10))[0], sprite2);
		Assert.equal (sprite.getObjectsUnderPoint (new Point ()).length, 0);
		
		sprite.removeChild (sprite2);
		
		Assert.equal (sprite.getObjectsUnderPoint (new Point ()).length, 0);
		
		// #end
		
	});
	
	
	Mocha.it ("removeChild", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		sprite.removeChild (sprite2);
		sprite.removeChild (sprite3);
		
		Assert.equal (sprite.numChildren, 0);
		
		try {
			
			sprite.removeChild (sprite2);
			Assert.ok (false);
			
		} catch (e:Dynamic) {}
		
	});
	
	
	Mocha.it ("removeChildAt", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		sprite.removeChildAt (0);
		sprite.removeChildAt (0);
		
		Assert.equal (sprite.numChildren, 0);
		
		try {
			
			sprite.removeChildAt (0);
			Assert.ok (false);
			
		} catch (e:Dynamic) {}
		
	});
	
	
	Mocha.it ("removeChildren", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.removeChildren;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("setChildIndex", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		
		sprite.setChildIndex (sprite3, 0);
		
		Assert.equal (sprite.getChildIndex (sprite3), 0);
		
		sprite.setChildIndex (sprite2, 0);
		
		Assert.equal (sprite.getChildIndex (sprite2), 0);
		
		try {
			
			sprite.removeChild (sprite2);
			sprite.setChildIndex (sprite2, 0);
			Assert.ok (false);
			
		} catch (e:Dynamic) {}
		
	});
	
	
	Mocha.it ("stopAllMovieClips", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.stopAllMovieClips;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("swapChildren", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		
		sprite.swapChildren (sprite2, sprite3);
		
		Assert.equal (sprite.getChildIndex (sprite3), 0);
		Assert.equal (sprite.getChildIndex (sprite2), 1);
		
		try {
			
			sprite.removeChild (sprite2);
			sprite.swapChildren (sprite2, sprite3);
			Assert.ok (false);
			
		} catch (e:Dynamic) {}
		
	});
	
	
	Mocha.it ("swapChildrenAt", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		
		sprite.swapChildrenAt (0, 1);
		
		Assert.equal (sprite.getChildIndex (sprite3), 0);
		Assert.equal (sprite.getChildIndex (sprite2), 1);
		
		try {
			
			sprite.removeChild (sprite2);
			sprite.swapChildrenAt (0, 1);
			Assert.ok (false);
			
		} catch (e:Dynamic) {}
		
	});
	
	
}); }}