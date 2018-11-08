import Bitmap from "openfl/display/Bitmap";
import BitmapData from "openfl/display/BitmapData";
import DisplayObject from "openfl/display/DisplayObject";
import DisplayObjectContainer from "openfl/display/DisplayObjectContainer";
import Sprite from "openfl/display/Sprite";
import Point from "openfl/geom/Point";
import Lib from "openfl/Lib";
import * as assert from "assert";


describe ("TypeScript | DisplayObjectContainer", function () {
	
	
	it ("mouseChildren", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseChildren;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("numChildren", function () {
		
		var sprites = [];
		
		for (var i = 0; i < 4; i++) {
			
			sprites.push (new Sprite ());
			
		}
		
		assert.equal (sprites[0].numChildren, 0);
		
		for (i = 1; i < 4; i++) {
			
			sprites[0].addChild (sprites[i]);
			assert.equal (sprites[0].numChildren, i);
			
		}
		
		for (i = 1; i < 4; i++) {
			
			sprites[0].removeChild (sprites[i]);
			assert.equal (sprites[0].numChildren, 3 - i);
			
		}
		
	});
	
	
	it ("tabChildren", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.tabChildren;
		
		//assert.notEqual (exists, null);
		
	});
	
	
	it ("addChild", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		sprite.addChild (sprite2);
		
		assert.equal (sprite.numChildren, 1);
		assert.equal (sprite.getChildAt (0), sprite2);
		
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite3);
		
		assert.equal (sprite.numChildren, 2);
		assert.equal (sprite.getChildIndex (sprite2), 0);
		assert.equal (sprite.getChildIndex (sprite3), 1);
		
		sprite.addChild (sprite2);
		
		assert.equal (sprite.getChildIndex (sprite3), 0);
		assert.equal (sprite.getChildIndex (sprite2), 1);
		
		sprite2.addChild (sprite3);
		
		assert.equal (sprite3.parent, sprite2);
		
	});
	
	
	it ("addChildAt", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		sprite.addChildAt (sprite2, 0);
		
		assert.equal (sprite.numChildren, 1);
		assert.equal (sprite.getChildAt (0), sprite2);
		
		var sprite3 = new Sprite ();
		
		sprite.addChildAt (sprite3, 1);
		
		assert.equal (sprite.numChildren, 2);
		assert.equal (sprite.getChildIndex (sprite2), 0);
		assert.equal (sprite.getChildIndex (sprite3), 1);
		
		sprite.addChildAt (sprite2, 0);
		
		assert.equal (sprite.getChildIndex (sprite2), 0);
		assert.equal (sprite.getChildIndex (sprite3), 1);
		
		sprite.addChildAt (sprite2, 1);
		
		assert.equal (sprite.getChildIndex (sprite3), 0);
		assert.equal (sprite.getChildIndex (sprite2), 1);
		
	});
	
	
	it ("areInaccessibleObjectsUnderPoint", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.areInaccessibleObjectsUnderPoint;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("contains", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		assert (sprite.contains (sprite));
		assert (!sprite.contains (sprite2));
		
		sprite.addChild (sprite2);
		
		assert (sprite.contains (sprite2));
		
		var sprite3 = new Sprite ();
		var sprite4 = new Sprite ();
		
		sprite3.addChild (sprite4);
		sprite.addChild (sprite3);
		
		assert (sprite.contains (sprite3));
		assert (sprite.contains (sprite4));
		assert (!sprite3.contains (sprite));
		assert (!sprite4.contains (sprite));
		
		sprite.removeChild (sprite3);
		sprite.removeChild (sprite2);
		
		assert (!sprite.contains (sprite2));
		assert (!sprite.contains (sprite3));
		assert (!sprite.contains (sprite4));
		
	});
	
	
	it ("getChildAt", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		
		sprite.addChild (sprite2);
		
		assert.equal (sprite.getChildAt (0), sprite2);
		
		var sprite3 = new Sprite ();
		sprite.addChild (sprite3);
		
		assert.equal (sprite.getChildAt (1), sprite3);
		
		sprite2.addChild (sprite3);
		
		assert.equal (sprite2.getChildAt (0), sprite3);
		
		try {
			
			sprite.getChildAt (2);
			assert.ok (false);
			
		} catch (e) {}
		
	});
	
	
	it ("getChildByName", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite2.name = "a";
		sprite3.name = "a";
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		
		assert.equal (sprite.getChildByName ("b"), null);
		assert.equal (sprite.getChildByName ("a"), sprite2);
		
		sprite3.name = "b";
		
		assert.equal (sprite.getChildByName ("b"), sprite3);
		
	});
	
	
	it ("getChildIndex", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		
		assert.equal (sprite.getChildIndex (sprite2), 0);
		assert.equal (sprite.getChildIndex (sprite3), 1);
		
		try {
			
			sprite2.getChildIndex (sprite3);
			assert.ok (false);
			
		} catch (e) {}
		
	});
	
	
	it ("getObjectsUnderPoint", function () {
		
		// #if (cpp || neko) // TODO: works but sometimes suffers from a race condition when run immediately
		
		var sprite = new Sprite ();
		
		var sprite2 = new Sprite ();
		sprite2.graphics.beginFill (0xFF0000);
		sprite2.graphics.drawRect (0, 0, 100, 100);
		sprite.addChild (sprite2);
		
		assert.equal (sprite.getObjectsUnderPoint (new Point (10, 10))[0], sprite2);
		assert.equal (sprite.getObjectsUnderPoint (new Point ()).length, 0);
		
		sprite.removeChild (sprite2);
		
		assert.equal (sprite.getObjectsUnderPoint (new Point ()).length, 0);
		
		// #end
		
	});
	
	
	it ("removeChild", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		sprite.removeChild (sprite2);
		sprite.removeChild (sprite3);
		
		assert.equal (sprite.numChildren, 0);
		
		try {
			
			sprite.removeChild (sprite2);
			assert.ok (false);
			
		} catch (e) {}
		
	});
	
	
	it ("removeChildAt", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		sprite.removeChildAt (0);
		sprite.removeChildAt (0);
		
		assert.equal (sprite.numChildren, 0);
		
		try {
			
			sprite.removeChildAt (0);
			assert.ok (false);
			
		} catch (e) {}
		
	});
	
	
	it ("removeChildren", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.removeChildren;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("setChildIndex", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		
		sprite.setChildIndex (sprite3, 0);
		
		assert.equal (sprite.getChildIndex (sprite3), 0);
		
		sprite.setChildIndex (sprite2, 0);
		
		assert.equal (sprite.getChildIndex (sprite2), 0);
		
		try {
			
			sprite.removeChild (sprite2);
			sprite.setChildIndex (sprite2, 0);
			assert.ok (false);
			
		} catch (e) {}
		
	});
	
	
	it ("stopAllMovieClips", function () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.stopAllMovieClips;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("swapChildren", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		
		sprite.swapChildren (sprite2, sprite3);
		
		assert.equal (sprite.getChildIndex (sprite3), 0);
		assert.equal (sprite.getChildIndex (sprite2), 1);
		
		try {
			
			sprite.removeChild (sprite2);
			sprite.swapChildren (sprite2, sprite3);
			assert.ok (false);
			
		} catch (e) {}
		
	});
	
	
	it ("swapChildrenAt", function () {
		
		var sprite = new Sprite ();
		var sprite2 = new Sprite ();
		var sprite3 = new Sprite ();
		
		sprite.addChild (sprite2);
		sprite.addChild (sprite3);
		
		sprite.swapChildrenAt (0, 1);
		
		assert.equal (sprite.getChildIndex (sprite3), 0);
		assert.equal (sprite.getChildIndex (sprite2), 1);
		
		try {
			
			sprite.removeChild (sprite2);
			sprite.swapChildrenAt (0, 1);
			assert.ok (false);
			
		} catch (e) {}
		
	});
	
	
});