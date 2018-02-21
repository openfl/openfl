import BitmapFilter from "./BitmapFilter";


declare namespace openfl.filters {
	
	
	/*@:final*/ export class ColorMatrixFilter extends BitmapFilter {
		
		
		public matrix:Array<number>;
		
		
		public constructor (matrix?:Array<number>);
		
		
	}
	
	
}


export default openfl.filters.ColorMatrixFilter;