import BitmapFilter from "./BitmapFilter";

declare namespace openfl.filters {

export class ColorMatrixFilter extends BitmapFilter {

	constructor(matrix?:any);
	matrix:any;
	clone():any;
	__applyFilter(destBitmapData:any, sourceBitmapData:any, sourceRect:any, destPoint:any):any;
	__initShader(renderSession:any, pass:any):any;
	set_matrix(value:any):any;


}

}

export default openfl.filters.ColorMatrixFilter;