package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

@:jsRequire("openfl/display/TileArray", "default")


@:beta extern class TileArray {
	
	
	public var alpha:Float;
	public var id:Int;
	public var length:Int;
	public var position:Int;
	public var shader:Shader;
	public var tileset:Tileset;
	public var visible:Bool;
	
	public function new (length:Int = 0);
	
    public function getColorTransform (colorTransform:ColorTransform = null):ColorTransform;
	public function getMatrix (matrix:Matrix = null):Matrix;
	public function getRect (rect:Rectangle = null):Rectangle;
	public function setColorTransform (redMultiplier:Float, greenMultiplier:Float, blueMultiplier:Float, alphaMultiplier:Float, redOffset:Float, greenOffset:Float, blueOffset:Float, alphaOffset:Float):Void;
	public function setMatrix (a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void;
	public function setRect (x:Float, y:Float, width:Float, height:Float):Void;
	
	
}