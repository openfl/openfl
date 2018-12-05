import BitmapData from "openfl/display/BitmapData";
import Tileset from "openfl/display/Tileset";
import * as assert from "assert";


describe ("TypeScript | Tileset", function () {
	
	
	it ("bitmapData", function () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset.bitmapData;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("addRect", function () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset.addRect;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getRect", function () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset.getRect;
		
		assert.notEqual (exists, null);
		
	});
	
	
});