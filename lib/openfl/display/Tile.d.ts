import Shader from "./Shader";
import Tilemap from "./Tilemap";
import Tileset from "./Tileset";
import ColorTransform from "./../geom/ColorTransform";
import Matrix from "./../geom/Matrix";


declare namespace openfl.display {
	
	
	export class Tile {
		
		
		public alpha:number;
		
		private get_alpha ():number;
		private set_alpha (value:number):number;
		
		public colorTransform:ColorTransform;
		
		private get_colorTransform ():ColorTransform;
		private set_colorTransform (value:ColorTransform):ColorTransform;
		
		public data:any;
		
		public id:number;
		
		private get_id ():number;
		private set_id (value:number):number;
		
		public matrix:Matrix;
		
		private get_matrix ():Matrix;
		private set_matrix (value:Matrix):Matrix;
		
		public originX:number;
		
		private get_originX ():number;
		private set_originX (value:number):number;
		
		public originY:number;
		
		private get_originY ():number;
		private set_originY (value:number):number;
		
		public parent:Tilemap;
		
		public rotation:number;
		
		private get_rotation ():number;
		private set_rotation (value:number):number;
		
		public scaleX:number;
		
		private get_scaleX ():number;
		private set_scaleX (value:number):number;
		
		public scaleY:number;
		
		private get_scaleY ():number;
		private set_scaleY (value:number):number;
		
		public shader:Shader;
		
		private get_shader ():Shader;
		private set_shader (value:Shader):Shader;
		
		public tileset:Tileset;
		
		private get_tileset ():Tileset;
		private set_tileset (value:Tileset):Tileset;
		
		public visible:boolean;
		
		private get_visible ():boolean;
		private set_visible (value:boolean):boolean;
		
		public x:number;
		
		private get_x ():number;
		private set_x (value:number):number;
		
		public y:number;
		
		private get_y ():number;
		private set_y (value:number):number;
		
		
		constructor (id?:number, x?:number, y?:number, scaleX?:number, scaleY?:number, rotation?:number);
		
		clone ():Tile;
		
		
	}
	
	
}


export default openfl.display.Tile;