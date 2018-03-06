import BitmapData from "./BitmapData";
import Rectangle from "./../geom/Rectangle";
import Vector from "./../Vector";


declare namespace openfl.display {
	
	
	export class Tileset {
		
		
		public bitmapData:BitmapData;
		public rectData:Vector<number>;
		public readonly numRects:number;
		
		public constructor (bitmapData:BitmapData, rects?:Array<Rectangle>);
		
		public addRect (rect:Rectangle):number;
		public clone ():Tileset;
		public hasRect (rect:Rectangle):boolean;
		public getRect (id:number):Rectangle;
		public getRectID (rect:Rectangle):null | number;
		
		
	}
	
	
}


export default openfl.display.Tileset;