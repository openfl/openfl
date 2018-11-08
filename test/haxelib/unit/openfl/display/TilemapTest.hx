package openfl.display;


import massive.munit.Assert;
import openfl.display.Tilemap;


class TilemapTest {
	
	
	@Test public function numTiles () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.numTiles;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function smoothing () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.smoothing;
		
		Assert.isTrue (exists);
		
	}
	
	
	@Test public function tileset () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.tileset;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function addTile () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.addTile;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function addTileAt () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.addTileAt;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function addTiles () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.addTiles;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function contains () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.contains;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getTileAt () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.getTileAt;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getTileIndex () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.getTileIndex;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function removeTile () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.removeTile;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function removeTileAt () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.removeTileAt;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function removeTiles () {
		
		// TODO: Confirm functionality
		
		var tilemap = new Tilemap (1, 1);
		var exists = tilemap.removeTiles;
		
		Assert.isNotNull (exists);
		
	}
	
	
}