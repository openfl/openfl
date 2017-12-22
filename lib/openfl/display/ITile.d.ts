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
		
		private get_alpha ():number;
		private set_alpha (value:number):number;
		private get_colorTransform ():ColorTransform;
		private set_colorTransform (value:ColorTransform):ColorTransform;
		private get_id ():number;
		private set_id (value:number):number;
		private get_matrix ():Matrix;
		private set_matrix (value:Matrix):Matrix;
		private get_rect ():Rectangle;
		private set_rect (value:Rectangle):Rectangle;
		private get_shader ():Shader;
		private set_shader (value:Shader):Shader;
		private get_tileset ():Tileset;
		private set_tileset (value:Tileset):Tileset;
		private get_visible ():boolean;
		private set_visible (value:boolean):boolean;
		
		
	}
	
	
}


export default openfl.display.ITile;