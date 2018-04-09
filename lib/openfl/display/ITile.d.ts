import Shader from "./Shader";
import Tileset from "./Tileset";
import ColorTransform from "./../geom/ColorTransform";
import Matrix from "./../geom/Matrix";
import Rectangle from "./../geom/Rectangle";


declare namespace openfl.display {
	
	
	export class ITile {
		
		
		public alpha:number;
		public colorTransform:ColorTransform;
		public id:number;
		public matrix:Matrix;
		public rect:Rectangle;
		public shader:Shader;
		public tileset:Tileset;
		public visible:boolean;
		
		protected get_alpha ():number;
		protected set_alpha (value:number):number;
		protected get_colorTransform ():ColorTransform;
		protected set_colorTransform (value:ColorTransform):ColorTransform;
		protected get_id ():number;
		protected set_id (value:number):number;
		protected get_matrix ():Matrix;
		protected set_matrix (value:Matrix):Matrix;
		protected get_rect ():Rectangle;
		protected set_rect (value:Rectangle):Rectangle;
		protected get_shader ():Shader;
		protected set_shader (value:Shader):Shader;
		protected get_tileset ():Tileset;
		protected set_tileset (value:Tileset):Tileset;
		protected get_visible ():boolean;
		protected set_visible (value:boolean):boolean;
		
		
	}
	
	
}


export default openfl.display.ITile;