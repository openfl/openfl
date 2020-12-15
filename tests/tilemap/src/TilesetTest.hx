package;

import openfl.display.BitmapData;
import openfl.display.Tileset;
import utest.Assert;
import utest.Test;

class TilesetTest extends Test
{
	public function test_bitmapData()
	{
		// TODO: Confirm functionality

		var tileset = new Tileset(new BitmapData(1, 1));
		var exists = tileset.bitmapData;

		Assert.notNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var tileset = new Tileset(new BitmapData(1, 1));
		var exists = tileset;

		Assert.notNull(exists);
	}

	public function test_addRect()
	{
		// TODO: Confirm functionality

		var tileset = new Tileset(new BitmapData(1, 1));
		var exists = tileset.addRect;

		Assert.notNull(exists);
	}

	public function test_getRect()
	{
		// TODO: Confirm functionality

		var tileset = new Tileset(new BitmapData(1, 1));
		var exists = tileset.getRect;

		Assert.notNull(exists);
	}
}
