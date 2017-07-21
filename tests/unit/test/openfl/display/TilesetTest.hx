package openfl.display;


import massive.munit.Assert;
import openfl.display.Tileset;


class TilesetTest {
	
	
	@Test public function bitmapData () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset.bitmapData;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function addRect () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset.addRect;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getRect () {
		
		// TODO: Confirm functionality
		
		var tileset = new Tileset (new BitmapData (1, 1));
		var exists = tileset.getRect;
		
		Assert.isNotNull (exists);
		
	}
	
	
}