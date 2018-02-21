package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;


@:jsRequire("openfl/display/ITile", "default")

extern interface ITile {
	
	
	public var alpha:Float;
	public var colorTransform:ColorTransform;
	public var id:Int;
	public var matrix:Matrix;
	public var rect:Rectangle;
	public var shader:Shader;
	public var tileset:Tileset;
	public var visible:Bool;
	
	private function get_alpha ():Float;
	private function set_alpha (value:Float):Float;
	private function get_colorTransform ():ColorTransform;
	private function set_colorTransform (value:ColorTransform):ColorTransform;
	private function get_id ():Int;
	private function set_id (value:Int):Int;
	private function get_matrix ():Matrix;
	private function set_matrix (value:Matrix):Matrix;
	private function get_rect ():Rectangle;
	private function set_rect (value:Rectangle):Rectangle;
	private function get_shader ():Shader;
	private function set_shader (value:Shader):Shader;
	private function get_tileset ():Tileset;
	private function set_tileset (value:Tileset):Tileset;
	private function get_visible ():Bool;
	private function set_visible (value:Bool):Bool;
	
	
}