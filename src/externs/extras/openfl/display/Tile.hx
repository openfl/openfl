package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;


extern class Tile {
	
	
	public var alpha (get, set):Float;
	
	@:dox(hide) @:noCompletion private function get_alpha ():Float;
	@:dox(hide) @:noCompletion private function set_alpha (value:Float):Float;
	
	@:beta public var colorTransform (get, set):ColorTransform;
	
	@:dox(hide) @:noCompletion private function get_colorTransform ():ColorTransform;
	@:dox(hide) @:noCompletion private function set_colorTransform (value:ColorTransform):ColorTransform;
	
	public var data:Dynamic;
	
	public var id (get, set):Int;
	
	@:dox(hide) @:noCompletion private function get_id ():Int;
	@:dox(hide) @:noCompletion private function set_id (value:Int):Int;
	
	public var matrix (get, set):Matrix;
	
	@:dox(hide) @:noCompletion private function get_matrix ():Matrix;
	@:dox(hide) @:noCompletion private function set_matrix (value:Matrix):Matrix;
	
	public var originX (get, set):Float;
	
	@:dox(hide) @:noCompletion private function get_originX ():Float;
	@:dox(hide) @:noCompletion private function set_originX (value:Float):Float;
	
	public var originY (get, set):Float;
	
	@:dox(hide) @:noCompletion private function get_originY ():Float;
	@:dox(hide) @:noCompletion private function set_originY (value:Float):Float;
	
	public var parent (default, null):Tilemap;
	
	public var rotation (get, set):Float;
	
	@:dox(hide) @:noCompletion private function get_rotation ():Float;
	@:dox(hide) @:noCompletion private function set_rotation (value:Float):Float;
	
	public var scaleX (get, set):Float;
	
	@:dox(hide) @:noCompletion private function get_scaleX ():Float;
	@:dox(hide) @:noCompletion private function set_scaleX (value:Float):Float;
	
	public var scaleY (get, set):Float;
	
	@:dox(hide) @:noCompletion private function get_scaleY ():Float;
	@:dox(hide) @:noCompletion private function set_scaleY (value:Float):Float;
	
	@:beta public var shader (get, set):Shader;
	
	@:dox(hide) @:noCompletion private function get_shader ():Shader;
	@:dox(hide) @:noCompletion private function set_shader (value:Shader):Shader;
	
	public var tileset (get, set):Tileset;
	
	@:dox(hide) @:noCompletion private function get_tileset ():Tileset;
	@:dox(hide) @:noCompletion private function set_tileset (value:Tileset):Tileset;
	
	public var visible (get, set):Bool;
	
	@:dox(hide) @:noCompletion private function get_visible ():Bool;
	@:dox(hide) @:noCompletion private function set_visible (value:Bool):Bool;
	
	public var x (get, set):Float;
	
	@:dox(hide) @:noCompletion private function get_x ():Float;
	@:dox(hide) @:noCompletion private function set_x (value:Float):Float;
	
	public var y (get, set):Float;
	
	@:dox(hide) @:noCompletion private function get_y ():Float;
	@:dox(hide) @:noCompletion private function set_y (value:Float):Float;
	
	
	public function new (id:Int = 0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0);
	
	public function clone ():Tile;
	
	
}