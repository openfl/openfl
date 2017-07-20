package openfl.display;


import lime.graphics.opengl.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Vector;

@:access(openfl.display.TileArrayAccess)
@:access(openfl.display.TileArrayData)
@:forward()


abstract TileArray(TileArrayData) from TileArrayData to TileArrayData {
	
	
	public var length (get, set):Int;
	
	
	public inline function new (length:Int = 0) {
		
		this = new TileArrayData (length);
		
	}
	
	
	@:arrayAccess @:noCompletion private inline function get (index:Int):TileArrayAccess {
		
		this.__access.index = index;
		return this.__access;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private inline function get_length ():Int {
		
		return this.getLength ();
		
	}
	
	
	private inline function set_length (value:Int):Int {
		
		return this.setLength (value);
		
	}
	
	
}


@:access(openfl.display.TileArrayData)


@:dox(hide) @:noCompletion class TileArrayAccess {
	
	
	public var alpha (get, set):Float;
	public var id (get, set):Int;
	public var matrix (get, set):Matrix;
	//public var originX (get, set):Float;
	//public var originY (get, set):Float;
	public var rect (get, set):Rectangle;
	//public var rotation (get, set):Float;
	//public var scaleX (get, set):Float;
	//public var scaleY (get, set):Float;
	//public var visible (get, set):Bool;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	private var data:TileArrayData;
	private var index:Int;
	
	
	private function new (data:TileArrayData) {
		
		this.data = data;
		index = 0;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_alpha ():Float {
		
		return data.getAlpha (index);
		
	}
	
	
	private function set_alpha (value:Float):Float {
		
		return data.setAlpha (index, value);
		
	}
	
	
	private function get_id ():Int {
		
		return data.getID (index);
		
	}
	
	
	private function set_id (value:Int):Int {
		
		return data.setID (index, value);
		
	}
	
	
	private function get_matrix ():Matrix {
		
		return data.getMatrix (index);
		
	}
	
	
	private function set_matrix (value:Matrix):Matrix {
		
		return data.setMatrix (index, value);
		
	}
	
	
	private function get_originX ():Float {
		
		return data.getOriginX (index);
		
	}
	
	
	private function set_originX (value:Float):Float {
		
		return data.setOriginX (index, value);
		
	}
	
	
	private function get_originY ():Float {
		
		return data.getOriginY (index);
		
	}
	
	
	private function set_originY (value:Float):Float {
		
		return data.setOriginY (index, value);
		
	}
	
	
	private function get_rect ():Rectangle {
		
		return data.getRect (index);
		
	}
	
	
	private function set_rect (value:Rectangle):Rectangle {
		
		return data.setRect (index, value);
		
	}
	
	
	private function get_rotation ():Float {
		
		return data.getRotation (index);
		
	}
	
	
	private function set_rotation (value:Float):Float {
		
		return data.setRotation (index, value);
		
	}
	
	
	private function get_scaleX ():Float {
		
		return data.getScaleX (index);
		
	}
	
	
	private function set_scaleX (value:Float):Float {
		
		return data.setScaleX (index, value);
		
	}
	
	
	private function get_scaleY ():Float {
		
		return data.getScaleY (index);
		
	}
	
	
	private function set_scaleY (value:Float):Float {
		
		return data.setScaleY (index, value);
		
	}
	
	
	private function get_x ():Float {
		
		return data.getX (index);
		
	}
	
	
	private function set_x (value:Float):Float {
		
		return data.setX (index, value);
		
	}
	
	
	private function get_y ():Float {
		
		return data.getY (index);
		
	}
	
	
	private function set_y (value:Float):Float {
		
		return data.setY (index, value);
		
	}
	
	
}


@:access(openfl.display.TileArrayAccess)


@:dox(hide) @:noCompletion class TileArrayData extends Tile {
	
	
	private static inline var ID_INDEX = 0;
	private static inline var RECT_INDEX = 1;
	private static inline var MATRIX_INDEX = 5;
	private static inline var ALPHA_INDEX = 11;
	private static inline var ITEM_LENGTH = 12;
	
	private var __access:TileArrayAccess;
	private var __buffer:GLBuffer;
	private var __bufferContext:GLRenderContext;
	private var __bufferData:Float32Array;
	private var __data:Vector<Float>;
	private var __length:Int;
	private var __matrix:Matrix;
	private var __rect:Rectangle;
	
	
	private function new (length:Int = 0) {
		
		super ();
		
		// TODO: Init with identity matrix values?
		
		__type = TILE_ARRAY;
		
		__access = new TileArrayAccess (this);
		__data = new Vector<Float> (length * ITEM_LENGTH);
		
	}
	
	
	private inline function getAlpha (index:Int):Float {
		
		return __data[ALPHA_INDEX + (index * ITEM_LENGTH)];
		
	}
	
	
	private inline function getID (index:Int):Int {
		
		return Std.int (__data[ID_INDEX + (index * ITEM_LENGTH)]);
		
	}
	
	
	private inline function getLength ():Int {
		
		return __length;
		
	}
	
	
	private function getMatrix (index:Int):Matrix {
		
		if (__matrix == null) __matrix = new Matrix ();
		var i = MATRIX_INDEX + (index * ITEM_LENGTH);
		__matrix.a = __data[i];
		__matrix.b = __data[i + 1];
		__matrix.c = __data[i + 2];
		__matrix.d = __data[i + 3];
		__matrix.tx = __data[i + 4];
		__matrix.ty = __data[i + 5];
		return __matrix;
		
	}
	
	
	private inline function getOriginX (index:Int):Float {
		
		return 0;
		
	}
	
	
	private inline function getOriginY (index:Int):Float {
		
		return 0;
		
	}
	
	
	private function getRect (index:Int):Rectangle {
		
		if (__rect == null) __rect = new Rectangle ();
		var i = RECT_INDEX + (index * ITEM_LENGTH);
		__rect.x = __data[i];
		__rect.y = __data[i + 1];
		__rect.width = __data[i + 2];
		__rect.height = __data[i + 3];
		return __rect;
		
	}
	
	
	private inline function getRotation (index:Int):Float {
		
		return 0;
		
	}
	
	
	private inline function getScaleX (index:Int):Float {
		
		return 0;
		
	}
	
	
	private inline function getScaleY (index:Int):Float {
		
		return 0;
		
	}
	
	
	private inline function getX (index:Int):Float {
		
		return __data[MATRIX_INDEX + 4 + (index * ITEM_LENGTH)];
		
	}
	
	
	private inline function getY (index:Int):Float {
		
		return __data[MATRIX_INDEX + 5 + (index * ITEM_LENGTH)];
		
	}
	
	
	private inline function setAlpha (index:Int, value:Float):Float {
		
		return __data[ALPHA_INDEX + (index * ITEM_LENGTH)] = value;
		
	}
	
	
	private inline function setID (index:Int, value:Int):Int {
		
		__data[ID_INDEX + (index * ITEM_LENGTH)] = value;
		return value;
		
	}
	
	
	private inline function setLength (value:Int):Int {
		
		__length = value;
		__data.length = value * ITEM_LENGTH;
		return value;
		
	}
	
	
	private function setMatrix (index:Int, value:Matrix):Matrix {
		
		var i = MATRIX_INDEX + (index * ITEM_LENGTH);
		__data[i] = value.a;
		__data[i + 1] = value.b;
		__data[i + 2] = value.c;
		__data[i + 3] = value.d;
		__data[i + 4] = value.tx;
		__data[i + 5] = value.ty;
		return value;
		
	}
	
	
	private inline function setOriginX (index:Int, value:Float):Float {
		
		return 0;
		
	}
	
	
	private inline function setOriginY (index:Int, value:Float):Float {
		
		return 0;
		
	}
	
	
	private function setRect (index:Int, value:Rectangle):Rectangle {
		
		__data[ID_INDEX + (index * ITEM_LENGTH)] = -1;
		var i = RECT_INDEX + (index * ITEM_LENGTH);
		__data[i] = value.x;
		__data[i + 1] = value.y;
		__data[i + 2] = value.width;
		__data[i + 3] = value.height;
		return value;
		
	}
	
	
	private inline function setRotation (index:Int, value:Float):Float {
		
		return 0;
		
	}
	
	
	private inline function setScaleX (index:Int, value:Float):Float {
		
		return 0;
		
	}
	
	
	private inline function setScaleY (index:Int, value:Float):Float {
		
		return 0;
		
	}
	
	
	private inline function setX (index:Int, value:Float):Float {
		
		return __data[MATRIX_INDEX + 4 + (index * ITEM_LENGTH)] = value;
		
	}
	
	
	private inline function setY (index:Int, value:Float):Float {
		
		return __data[MATRIX_INDEX + 5 + (index * ITEM_LENGTH)] = value;
		
	}
	
	
}