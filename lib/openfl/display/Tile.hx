package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

@:jsRequire("openfl/display/Tile", "default")


extern class Tile {
	
	
	public var alpha:Float;
	@:beta public var colorTransform:ColorTransform;
	public var data:Dynamic;
	public var id:Int;
	public var matrix:Matrix;
	public var originX:Float;
	public var originY:Float;
	public var parent (default, null):Tilemap;
	public var rotation:Float;
	public var scaleX:Float;
	public var scaleY:Float;
	@:beta public var shader:Shader;
	public var tileset:Tileset;
	public var visible:Bool;
	public var x:Float;
	public var y:Float;
	
	
	public function new (id:Int = 0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0);
	
	public function clone ():Tile;
	
	
}