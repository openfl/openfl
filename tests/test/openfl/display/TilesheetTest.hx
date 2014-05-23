package openfl.display;


import massive.munit.Assert;


class TilesheetTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var tilesheet = new Tilesheet (new BitmapData (100, 100));
		
		Assert.isNotNull (tilesheet);
		
	}
	
	
	@Test public function addTileRect () {
		
		// TODO: Confirm functionality
		
		var tilesheet = new Tilesheet (new BitmapData (100, 100));
		var exists = tilesheet.addTileRect;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function drawTiles () {
		
		// TODO: Confirm functionality
		
		var tilesheet = new Tilesheet (new BitmapData (100, 100));
		var exists = tilesheet.drawTiles;
		
		Assert.isNotNull (exists);
		
	}
	
	
}