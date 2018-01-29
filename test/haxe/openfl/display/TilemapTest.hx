package openfl.display;


import openfl.display.Tilemap;


class TilemapTest { public static function __init__ () { Mocha.describe ("Haxe | Tilemap", function () {
	
	
	Mocha.it ("numTiles", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.numTiles;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("smoothing", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.smoothing;
		
		Assert.assert (exists);
		
	});
	
	
	Mocha.it ("tileset", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.tileset;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("addTile", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.addTile;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("addTileAt", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.addTileAt;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("addTiles", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.addTiles;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("contains", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.contains;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getTileAt", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.getTileAt;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getTileIndex", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.getTileIndex;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("removeTile", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.removeTile;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("removeTileAt", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.removeTileAt;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("removeTiles", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.removeTiles;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}