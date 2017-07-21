package openfl.display;


import openfl.geom.Matrix;


extern class Tile {
	
	
	public var alpha:Float;
	public var data:Dynamic;
	public var id (default, set):Int;
	public var matrix:Matrix;
	public var originX (default, set):Int;
	public var originY (default, set):Int;
	public var rotation (get, set):Float;
	public var scaleX (get, set):Float;
	public var scaleY (get, set):Float;
	public var tileset (default, set):Tileset;
	public var visible:Bool;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	
	public function new (id:Int = 0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0);
	
	
}