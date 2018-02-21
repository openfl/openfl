import Shader from "./Shader";
import Tilemap from "./Tilemap";
import Tileset from "./Tileset";
import ColorTransform from "./../geom/ColorTransform";
import Matrix from "./../geom/Matrix";


declare namespace openfl.display {
	
	
	export class Tile {
		
		
		alpha:number;
		/*@:beta*/ colorTransform:ColorTransform;
		data:any;
		id:number;
		matrix:Matrix;
		originX:number;
		originY:number;
		readonly parent:Tilemap;
		rotation:number;
		scaleX:number;
		scaleY:number;
		/*@:beta*/ shader:Shader;
		tileset:Tileset;
		visible:boolean;
		x:number;
		y:number;
		
		
		constructor (id?:number, x?:number, y?:number, scaleX?:number, scaleY?:number, rotation?:number);
		
		clone ():Tile;
		
		
	}
	
	
}


export default openfl.display.Tile;