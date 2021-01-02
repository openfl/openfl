package;

import openfl.display.Tilemap;
import utest.Assert;
import utest.Test;

class TilemapTest extends Test
{
	public function test_numTiles()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.numTiles;

		Assert.notNull(exists);
	}

	public function test_smoothing()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.smoothing;

		Assert.isTrue(exists);
	}

	public function test_tileset()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.tileset;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap;

		Assert.notNull(exists);
	}

	public function test_addTile()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.addTile;

		Assert.notNull(exists);
	}

	public function test_addTileAt()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.addTileAt;

		Assert.notNull(exists);
	}

	public function test_addTiles()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.addTiles;

		Assert.notNull(exists);
	}

	public function test_contains()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.contains;

		Assert.notNull(exists);
	}

	public function test_getTileAt()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.getTileAt;

		Assert.notNull(exists);
	}

	public function test_getTileIndex()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.getTileIndex;

		Assert.notNull(exists);
	}

	public function test_removeTile()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.removeTile;

		Assert.notNull(exists);
	}

	public function test_removeTileAt()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.removeTileAt;

		Assert.notNull(exists);
	}

	public function test_removeTiles()
	{
		// TODO: Confirm functionality

		var tilemap = new Tilemap(1, 1);
		var exists = tilemap.removeTiles;

		Assert.notNull(exists);
	}
}
