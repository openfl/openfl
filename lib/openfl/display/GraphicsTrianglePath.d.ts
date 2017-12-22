import IGraphicsData from "./IGraphicsData";
import IGraphicsPath from "./IGraphicsPath";
import TriangleCulling from "./TriangleCulling";

type Vector<T> = any;


declare namespace openfl.display {
	
	
	/*@:final*/ export class GraphicsTrianglePath implements IGraphicsData, IGraphicsPath {
		
		
		public culling:TriangleCulling;
		public indices:Vector<number>;
		public uvtData:Vector<number>;
		public vertices:Vector<number>;
		
		public constructor (vertices?:Vector<number>, indices?:Vector<number>, uvtData?:Vector<number>, culling?:TriangleCulling);
		
	}
	
	
}


export default openfl.display.GraphicsTrianglePath;