import BitmapFilter from "./BitmapFilter";

declare namespace openfl.filters {

export class BlurFilter extends BitmapFilter {

	constructor(blurX?:any, blurY?:any, quality?:any);
	blurX:any;
	blurY:any;
	quality:any;
	horizontalPasses:any;
	verticalPasses:any;
	clone():any;
	__applyFilter(bitmapData:any, sourceBitmapData:any, sourceRect:any, destPoint:any):any;
	__initShader(renderSession:any, pass:any):any;
	set_blurX(value:any):any;
	set_blurY(value:any):any;
	set_quality(value:any):any;


}

}

export default openfl.filters.BlurFilter;