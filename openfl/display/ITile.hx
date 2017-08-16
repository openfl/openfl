package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;


@:beta interface ITile {
	
	public var alpha (get, set):Float;
	public var colorTransform (get, set):ColorTransform;
	public var id (get, set):Int;
	public var matrix (get, set):Matrix;
	public var rect (get, set):Rectangle;
	public var shader (get, set):Shader;
	public var tileset (get, set):Tileset;
	public var visible (get, set):Bool;
	
}