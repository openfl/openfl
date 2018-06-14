package flash.display {
	
	
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	/**
	 * @externs
	 */
	public class Tile {
		
		
		public var alpha:Number;
		
		protected function get_alpha ():Number { return 0; }
		protected function set_alpha (value:Number):Number { return 0; }
		
		/*@:beta*/ public var colorTransform:ColorTransform;
		
		protected function get_colorTransform ():ColorTransform { return null; }
		protected function set_colorTransform (value:ColorTransform):ColorTransform { return null; }
		
		public var data:*;
		
		public var id:int;
		
		protected function get_id ():int { return 0; }
		protected function set_id (value:int):int { return 0; }
		
		public var matrix:Matrix;
		
		protected function get_matrix ():Matrix { return null; }
		protected function set_matrix (value:Matrix):Matrix { return null; }
		
		public var originX:Number;
		
		protected function get_originX ():Number { return 0; }
		protected function set_originX (value:Number):Number { return 0; }
		
		public var originY:Number;
		
		protected function get_originY ():Number { return 0; }
		protected function set_originY (value:Number):Number { return 0; }
		
		public function get parent ():Tilemap { return null; }
		
		public var rotation:Number;
		
		protected function get_rotation ():Number { return 0; }
		protected function set_rotation (value:Number):Number { return 0; }
		
		public var scaleX:Number;
		
		protected function get_scaleX ():Number { return 0; }
		protected function set_scaleX (value:Number):Number { return 0; }
		
		public var scaleY:Number;
		
		protected function get_scaleY ():Number { return 0; }
		protected function set_scaleY (value:Number):Number { return 0; }
		
		/*@:beta*/ public var shader:Shader;
		
		protected function get_shader ():Shader { return null; }
		protected function set_shader (value:Shader):Shader { return null; }
		
		public var tileset:Tileset;
		
		protected function get_tileset ():Tileset { return null; }
		protected function set_tileset (value:Tileset):Tileset { return null; }
		
		public var visible:Boolean;
		
		protected function get_visible ():Boolean { return false; }
		protected function set_visible (value:Boolean):Boolean { return false; }
		
		public var x:Number;
		
		protected function get_x ():Number { return 0; }
		protected function set_x (value:Number):Number { return 0; }
		
		public var y:Number;
		
		protected function get_y ():Number { return 0; }
		protected function set_y (value:Number):Number { return 0; }
		
		
		public function Tile (id:int = 0, x:Number = 0, y:Number = 0, scaleX:Number = 1, scaleY:Number = 1, rotation:Number = 0) {}
		
		public function clone ():Tile { return null; }
		
		
	}
	
	
}