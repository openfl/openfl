import Shader from "./Shader";
import Tileset from "./Tileset";
import ColorTransform from "./../geom/ColorTransform";
import Matrix from "./../geom/Matrix";
import Rectangle from "./../geom/Rectangle";


declare namespace openfl.display {
	
	
	/*@:beta*/ export class TileArray {
		
		
		public alpha:number;
		public id:number;
		public length:number;
		public position:number;
		public shader:Shader;
		public tileset:Tileset;
		public visible:boolean;
		
		public constructor (length?:number);
		
		public getColorTransform (colorTransform?:ColorTransform):ColorTransform;
		public getMatrix (matrix?:Matrix):Matrix;
		public getRect (rect?:Rectangle):Rectangle;
		public setColorTransform (redMultiplier:number, greenMultiplier:number, blueMultiplier:number, alphaMultiplier:number, redOffset:number, greenOffset:number, blueOffset:number, alphaOffset:number):void;
		public setMatrix (a:number, b:number, c:number, d:number, tx:number, ty:number):void;
		public setRect (x:number, y:number, width:number, height:number):void;
		
		
	}
	
	
}


export default openfl.display.TileArray;