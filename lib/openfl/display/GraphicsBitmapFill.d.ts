import BitmapData from "./BitmapData";
import IGraphicsData from "./IGraphicsData";
import IGraphicsFill from "./IGraphicsFill";
import Matrix from "./../geom/Matrix";


declare namespace openfl.display {
	
	
	/*@:final*/ export class GraphicsBitmapFill implements IGraphicsData, IGraphicsFill {
	
	
		public bitmapData:BitmapData;
		public matrix:Matrix;
		public repeat:boolean;
		public smooth:boolean;
		
		
		public constructor (bitmapData?:BitmapData, matrix?:Matrix, repeat?:boolean, smooth?:boolean);
		
		
	}
	
	
}


export default openfl.display.GraphicsBitmapFill;