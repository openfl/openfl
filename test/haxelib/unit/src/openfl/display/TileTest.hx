package openfl.display;

import massive.munit.Assert;
import openfl.geom.Rectangle;
import openfl.display.Tile;

class TileTest
{
	@Test public function newDefault()
	{
		var tile = new Tile();

		Assert.areEqual(0, tile.id);

		Assert.areEqual(0.0, tile.x);
		Assert.areEqual(0.0, tile.y);

		Assert.areEqual(1.0, tile.scaleX);
		Assert.areEqual(1.0, tile.scaleY);

		Assert.areEqual(0.0, tile.rotation);

		Assert.areEqual(0.0, tile.originX);
		Assert.areEqual(0.0, tile.originY);

		Assert.isTrue(tile.visible);
	}

	@Test public function new_()
	{
		var tile = new Tile(123, 7.3, 2.2, 1.3, 1.5, 32.1, 31.2, 0.12);

		Assert.areEqual(123, tile.id);

		Assert.areEqual(7.3, tile.x);
		Assert.areEqual(2.2, tile.y);

		Assert.areEqual(1.3, tile.scaleX);
		Assert.areEqual(1.5, tile.scaleY);

		Assert.areEqual(32.1, tile.rotation);

		Assert.areEqual(31.2, tile.originX);
		Assert.areEqual(0.12, tile.originY);

		Assert.isTrue(tile.visible);
	}

	@Test public function clone()
	{
		var tile = new Tile(123, 7.3, 2.2, 1.3, 1.5, 32.1, 31.2, 0.12);
		var tile_cloned = tile.clone();

		Assert.areEqual(123, tile.id);
		Assert.areEqual(31.2, tile.originX);
		Assert.areEqual(0.12, tile.originY);

		Assert.areEqual(123, tile_cloned.id);
		Assert.areEqual(31.2, tile_cloned.originX);
		Assert.areEqual(0.12, tile_cloned.originY);

		Assert.areNotSame(tile.matrix, tile_cloned.matrix);
		Assert.areEqual(tile.matrix.a, tile_cloned.matrix.a);
		Assert.areEqual(tile.matrix.b, tile_cloned.matrix.b);
		Assert.areEqual(tile.matrix.c, tile_cloned.matrix.c);
		Assert.areEqual(tile.matrix.d, tile_cloned.matrix.d);
		Assert.areEqual(tile.matrix.tx, tile_cloned.matrix.tx);
		Assert.areEqual(tile.matrix.ty, tile_cloned.matrix.ty);

		tile.matrix.identity();
		tile.scaleX = tile.scaleY = 2.0;
		tile.x = tile.y = 5.0;

		Assert.areNotEqual(tile.matrix.a, tile_cloned.matrix.a);
		Assert.areNotEqual(tile.matrix.b, tile_cloned.matrix.b);
		Assert.areNotEqual(tile.matrix.c, tile_cloned.matrix.c);
		Assert.areNotEqual(tile.matrix.d, tile_cloned.matrix.d);
		Assert.areNotEqual(tile.matrix.tx, tile_cloned.matrix.tx);
		Assert.areNotEqual(tile.matrix.ty, tile_cloned.matrix.ty);

		Assert.areNotEqual(tile.x, tile_cloned.x);
		Assert.areNotEqual(tile.y, tile_cloned.y);
		Assert.areNotEqual(tile.scaleX, tile_cloned.scaleX);
		Assert.areNotEqual(tile.scaleY, tile_cloned.scaleY);
	}

	@Test public function alpha()
	{
		var tile = new Tile();

		Assert.areEqual(1.0, tile.alpha);

		tile.alpha = 0.5;

		Assert.areEqual(0.5, tile.alpha);
	}

	@Test public function data()
	{
		var tile = new Tile();

		var stringData:String = 'Data String';
		var arrayData:Array<String> = ['Array String 1', 'Array String 2',];

		tile.data = stringData;

		Assert.areSame(stringData, tile.data);

		tile.data = arrayData;

		Assert.areSame(arrayData, tile.data);
	}

	@Test public function id()
	{
		var tile = new Tile();

		Assert.areEqual(0, tile.id);

		tile.id = 123;

		Assert.areEqual(123, tile.id);
	}

	@Test public function matrix()
	{
		var tile = new Tile();

		Assert.areEqual(1.0, tile.matrix.a);
		Assert.areEqual(0.0, tile.matrix.b);
		Assert.areEqual(0.0, tile.matrix.c);
		Assert.areEqual(1.0, tile.matrix.d);
		Assert.areEqual(0.0, tile.matrix.tx);
		Assert.areEqual(0.0, tile.matrix.ty);
	}

	@Test public function rotation()
	{
		var tile = new Tile();

		Assert.areEqual(0.0, tile.rotation);

		tile.rotation = 15.0;

		Assert.areEqual(15.0, tile.rotation);
	}

	@Test public function scaleX()
	{
		var tile = new Tile();

		Assert.areEqual(1.0, tile.scaleX);

		tile.scaleX = 7.0;

		Assert.areEqual(7.0, tile.scaleX);
	}

	@Test public function scaleY()
	{
		var tile = new Tile();

		Assert.areEqual(1.0, tile.scaleY);

		tile.scaleY = 10.0;

		Assert.areEqual(10.0, tile.scaleY);
	}

	@Test public function tileset()
	{
		var tileset = new Tileset(new BitmapData(100, 100), new Array<Rectangle>());
		var tile = new Tile();

		Assert.areEqual(null, tile.tileset);

		tile.tileset = tileset;

		Assert.areSame(tileset, tile.tileset);
	}

	@Test public function visible()
	{
		var tile = new Tile();

		Assert.isTrue(tile.visible);

		tile.visible = false;

		Assert.isFalse(tile.visible);
	}

	@Test public function x()
	{
		var tile = new Tile();

		Assert.areEqual(0.0, tile.x);

		tile.x = 7.0;

		Assert.areEqual(7.0, tile.x);
	}

	@Test public function y()
	{
		var tile = new Tile();

		Assert.areEqual(0.0, tile.y);

		tile.y = 10.0;

		Assert.areEqual(10.0, tile.y);
	}
}
