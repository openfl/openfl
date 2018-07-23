import BitmapFilter from "./BitmapFilter";


declare namespace openfl.filters {
	
	
	export class ConvolutionFilter extends BitmapFilter {
		
		
		public alpha:number;
		public bias:number;
		public clamp:boolean;
		public color:number;
		public divisor:number;
		
		public matrix:Array<number>;
		
		protected get_matrix ():Array<number>;
		protected set_matrix (value:Array<number>):Array<number>;
		
		public matrixX:number;
		public matrixY:number;
		public preserveAlpha:boolean;
		
		public constructor (matrixX?:number, matrixY?:number, matrix?:Array<number>, divisor?:number, bias?:number, preserveAlpha?:boolean, clamp?:boolean, color?:number, alpha?:number);
		
	}
	
	
}


export default openfl.filters.ConvolutionFilter;