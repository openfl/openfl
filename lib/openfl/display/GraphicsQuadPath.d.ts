import Vector from "./../Vector";
import IGraphicsData from "./IGraphicsData";
import IGraphicsPath from "./IGraphicsPath";


declare namespace openfl.display {
	
	
	export class GraphicsQuadPath implements IGraphicsData, IGraphicsPath {
		
		
		public indices:Vector<number>;
		public rects:Vector<number>;
		public transforms:Vector<number>;
		
		public constructor (rects?:Vector<number>, indices?:Vector<number>, transforms?:Vector<number>);
		
		
	}
	
	
}


export default openfl.display.GraphicsQuadPath;