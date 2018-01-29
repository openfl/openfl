import Tilemap from "openfl/display/Tilemap";
import * as assert from "assert";


describe ("ES6 | Tilemap", function () {
	
	
	it ("numTiles", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.numTiles;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("smoothing", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.smoothing;
		
		assert (exists);
		
	});
	
	
	it ("tileset", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.tileset;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("addTile", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.addTile;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("addTileAt", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.addTileAt;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("addTiles", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.addTiles;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("contains", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.contains;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getTileAt", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.getTileAt;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getTileIndex", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.getTileIndex;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("removeTile", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.removeTile;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("removeTileAt", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.removeTileAt;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("removeTiles", function () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.removeTiles;
		
		assert.notEqual (exists, null);
		
	});
	
	
});