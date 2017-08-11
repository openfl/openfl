package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;


@:beta extern class TileArray {
	
	
	public var alpha (get, set):Float;
	public var id (get, set):Int;
	public var length (get, set):Int;
	public var position:Int;
	public var shader (get, set):Shader;
	public var tileset (get, set):Tileset;
	public var visible (get, set):Bool;
	
	public function new (length:Int = 0);
	
    public function getColorTransform (colorTransform:ColorTransform = null):ColorTransform;
	public function getMatrix (matrix:Matrix = null):Matrix;
	public function getRect (rect:Rectangle = null):Rectangle;
	public function setColorTransform (redMultiplier:Float, greenMultiplier:Float, blueMultiplier:Float, alphaMultiplier:Float, redOffset:Float, greenOffset:Float, blueOffset:Float, alphaOffset:Float):Void;
	public function setMatrix (a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void;
	public function setRect (x:Float, y:Float, width:Float, height:Float):Void;
	
	
}