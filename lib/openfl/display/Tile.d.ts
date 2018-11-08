import Shader from "./Shader";
import Tilemap from "./Tilemap";
import Tileset from "./Tileset";
import ColorTransform from "./../geom/ColorTransform";
import Matrix from "./../geom/Matrix";


declare namespace openfl.display {
	
	
	export class Tile {
		
		
		public alpha:number;
		
		protected get_alpha ():number;
		protected set_alpha (value:number):number;
		
		public colorTransform:ColorTransform;
		
		protected get_colorTransform ():ColorTransform;
		protected set_colorTransform (value:ColorTransform):ColorTransform;
		
		public data:any;
		
		public id:number;
		
		protected get_id ():number;
		protected set_id (value:number):number;
		
		public matrix:Matrix;
		
		protected get_matrix ():Matrix;
		protected set_matrix (value:Matrix):Matrix;
		
		public originX:number;
		
		protected get_originX ():number;
		protected set_originX (value:number):number;
		
		public originY:number;
		
		protected get_originY ():number;
		protected set_originY (value:number):number;
		
		public parent:Tilemap;
		
		public rotation:number;
		
		protected get_rotation ():number;
		protected set_rotation (value:number):number;
		
		public scaleX:number;
		
		protected get_scaleX ():number;
		protected set_scaleX (value:number):number;
		
		public scaleY:number;
		
		protected get_scaleY ():number;
		protected set_scaleY (value:number):number;
		
		public shader:Shader;
		
		protected get_shader ():Shader;
		protected set_shader (value:Shader):Shader;
		
		public tileset:Tileset;
		
		protected get_tileset ():Tileset;
		protected set_tileset (value:Tileset):Tileset;
		
		public visible:boolean;
		
		protected get_visible ():boolean;
		protected set_visible (value:boolean):boolean;
		
		public x:number;
		
		protected get_x ():number;
		protected set_x (value:number):number;
		
		public y:number;
		
		protected get_y ():number;
		protected set_y (value:number):number;
		
		
		constructor (id?:number, x?:number, y?:number, scaleX?:number, scaleY?:number, rotation?:number);
		
		clone ():Tile;
		
		
	}
	
	
}


export default openfl.display.Tile;