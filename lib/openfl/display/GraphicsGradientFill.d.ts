import GradientType from "./GradientType";
import IGraphicsData from "./IGraphicsData";
import IGraphicsFill from "./IGraphicsFill";
import InterpolationMethod from "./InterpolationMethod";
import SpreadMethod from "./SpreadMethod";
import Matrix from "./../geom/Matrix";


declare namespace openfl.display {
	
	
	/*@:final*/ export class GraphicsGradientFill implements IGraphicsData, IGraphicsFill {
		
		
		public alphas:Array<number>;
		public colors:Array<number>;
		public focalPointRatio:number;
		public interpolationMethod:InterpolationMethod;
		public matrix:Matrix;
		public ratios:Array<number>;
		public spreadMethod:SpreadMethod;
		public type:GradientType;
		
		
		public constructor (type?:GradientType, colors?:Array<number>, alphas?:Array<number>, ratios?:Array<number>, matrix?:Matrix, spreadMethod?:SpreadMethod, interpolationMethod?:InterpolationMethod, focalPointRatio?:number);
		
		
	}
	
	
}


export default openfl.display.GraphicsGradientFill;