package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;


extern class Tile {
	
	
	public var alpha (default, set):Float;
	@:beta public var colorTransform (get, set):ColorTransform;
	public var data:Dynamic;
	public var id (default, set):Int;
	public var matrix (default, set):Matrix;
	public var originX (default, set):Float;
	public var originY (default, set):Float;
	public var parent (default, null):Tilemap;
	public var rotation (get, set):Float;
	public var scaleX (get, set):Float;
	public var scaleY (get, set):Float;
	@:beta public var shader (default, set):Shader;
	public var tileset (default, set):Tileset;
	public var visible (default, set):Bool;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	
	public function new (id:Int = 0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0);
	
	public function clone ():Tile;
	
	
}