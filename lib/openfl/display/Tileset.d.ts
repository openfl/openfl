import BitmapData from "./BitmapData";
import Rectangle from "./../geom/Rectangle";


declare namespace openfl.display {
	
	
	export class Tileset {
		
		
		public bitmapData:BitmapData;
		
		public constructor (bitmapData:BitmapData, rects?:Array<Rectangle>);
		
		public addRect (rect:Rectangle):number;
		public getRect (id:number):Rectangle;
		
		
	}
	
	
}


export default openfl.display.Tileset;