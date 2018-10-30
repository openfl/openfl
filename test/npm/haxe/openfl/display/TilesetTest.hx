package openfl.display;


import openfl.display.Tileset;


class TilesetTest { public static function __init__ () { Mocha.describe ("Haxe | Tileset", function () {
	
	
	Mocha.it ("bitmapData", function () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset.bitmapData;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("addRect", function () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset.addRect;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getRect", function () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset.getRect;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}