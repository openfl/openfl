package;

import openfl.display.BitmapData;
import openfl.display.Tile;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
import utest.Assert;
import utest.Test;

class TileTest extends Test
{
	public function test_newDefault()
	{
		var tile = new Tile();

		Assert.equals(0, tile.id);

		Assert.equals(0.0, tile.x);
		Assert.equals(0.0, tile.y);

		Assert.equals(1.0, tile.scaleX);
		Assert.equals(1.0, tile.scaleY);

		Assert.equals(0.0, tile.rotation);

		Assert.equals(0.0, tile.originX);
		Assert.equals(0.0, tile.originY);

		Assert.isTrue(tile.visible);
	}

	public function test_new_()
	{
		var tile = new Tile(123, 7.3, 2.2, 1.3, 1.5, 32.1, 31.2, 0.12);

		Assert.equals(123, tile.id);

		Assert.equals(7.3, tile.x);
		Assert.equals(2.2, tile.y);

		Assert.equals(1.3, tile.scaleX);
		Assert.equals(1.5, tile.scaleY);

		Assert.equals(32.1, tile.rotation);

		Assert.equals(31.2, tile.originX);
		Assert.equals(0.12, tile.originY);

		Assert.isTrue(tile.visible);
	}

	public function test_clone()
	{
		var tile = new Tile(123, 7.3, 2.2, 1.3, 1.5, 32.1, 31.2, 0.12);
		var tile_cloned = tile.clone();

		Assert.equals(123, tile.id);
		Assert.equals(31.2, tile.originX);
		Assert.equals(0.12, tile.originY);

		Assert.equals(123, tile_cloned.id);
		Assert.equals(31.2, tile_cloned.originX);
		Assert.equals(0.12, tile_cloned.originY);

		Assert.notEquals(tile.matrix, tile_cloned.matrix);
		Assert.equals(tile.matrix.a, tile_cloned.matrix.a);
		Assert.equals(tile.matrix.b, tile_cloned.matrix.b);
		Assert.equals(tile.matrix.c, tile_cloned.matrix.c);
		Assert.equals(tile.matrix.d, tile_cloned.matrix.d);
		Assert.equals(tile.matrix.tx, tile_cloned.matrix.tx);
		Assert.equals(tile.matrix.ty, tile_cloned.matrix.ty);

		tile.matrix.identity();
		tile.scaleX = tile.scaleY = 2.0;
		tile.x = tile.y = 5.0;

		Assert.notEquals(tile.matrix.a, tile_cloned.matrix.a);
		Assert.notEquals(tile.matrix.b, tile_cloned.matrix.b);
		Assert.notEquals(tile.matrix.c, tile_cloned.matrix.c);
		Assert.notEquals(tile.matrix.d, tile_cloned.matrix.d);
		Assert.notEquals(tile.matrix.tx, tile_cloned.matrix.tx);
		Assert.notEquals(tile.matrix.ty, tile_cloned.matrix.ty);

		Assert.notEquals(tile.x, tile_cloned.x);
		Assert.notEquals(tile.y, tile_cloned.y);
		Assert.notEquals(tile.scaleX, tile_cloned.scaleX);
		Assert.notEquals(tile.scaleY, tile_cloned.scaleY);
	}

	public function test_alpha()
	{
		var tile = new Tile();

		Assert.equals(1.0, tile.alpha);

		tile.alpha = 0.5;

		Assert.equals(0.5, tile.alpha);
	}

	public function test_data()
	{
		var tile = new Tile();

		var stringData:String = 'Data String';
		var arrayData:Array<String> = ['Array String 1', 'Array String 2',];

		tile.data = stringData;

		Assert.equals(stringData, tile.data);

		tile.data = arrayData;

		Assert.equals(arrayData, tile.data);
	}

	public function test_id()
	{
		var tile = new Tile();

		Assert.equals(0, tile.id);

		tile.id = 123;

		Assert.equals(123, tile.id);
	}

	public function test_matrix()
	{
		var tile = new Tile();

		Assert.equals(1.0, tile.matrix.a);
		Assert.equals(0.0, tile.matrix.b);
		Assert.equals(0.0, tile.matrix.c);
		Assert.equals(1.0, tile.matrix.d);
		Assert.equals(0.0, tile.matrix.tx);
		Assert.equals(0.0, tile.matrix.ty);
	}

	public function test_rotation()
	{
		var tile = new Tile();

		Assert.equals(0.0, tile.rotation);

		tile.rotation = 15.0;

		Assert.equals(15.0, tile.rotation);
	}

	public function test_scaleX()
	{
		var tile = new Tile();

		Assert.equals(1.0, tile.scaleX);

		tile.scaleX = 7.0;

		Assert.equals(7.0, tile.scaleX);
	}

	public function test_scaleY()
	{
		var tile = new Tile();

		Assert.equals(1.0, tile.scaleY);

		tile.scaleY = 10.0;

		Assert.equals(10.0, tile.scaleY);
	}

	public function test_tileset()
	{
		var tileset = new Tileset(new BitmapData(100, 100), new Array<Rectangle>());
		var tile = new Tile();

		Assert.equals(null, tile.tileset);

		tile.tileset = tileset;

		Assert.equals(tileset, tile.tileset);
	}

	public function test_visible()
	{
		var tile = new Tile();

		Assert.isTrue(tile.visible);

		tile.visible = false;

		Assert.isFalse(tile.visible);
	}

	public function test_x()
	{
		var tile = new Tile();

		Assert.equals(0.0, tile.x);

		tile.x = 7.0;

		Assert.equals(7.0, tile.x);
	}

	public function test_y()
	{
		var tile = new Tile();

		Assert.equals(0.0, tile.y);

		tile.y = 10.0;

		Assert.equals(10.0, tile.y);
	}
}
