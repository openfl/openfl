import BitmapFilter from "./BitmapFilter";

declare namespace openfl.filters {

export class GlowFilter extends BitmapFilter {

	constructor(color?:any, alpha?:any, blurX?:any, blurY?:any, strength?:any, quality?:any, inner?:any, knockout?:any);
	alpha:any;
	blurX:any;
	blurY:any;
	color:any;
	inner:any;
	knockout:any;
	quality:any;
	strength:any;
	horizontalPasses:any;
	verticalPasses:any;
	clone():any;
	__applyFilter(bitmapData:any, sourceBitmapData:any, sourceRect:any, destPoint:any):any;
	__initShader(renderSession:any, pass:any):any;
	set_alpha(value:any):any;
	set_blurX(value:any):any;
	set_blurY(value:any):any;
	set_color(value:any):any;
	set_inner(value:any):any;
	set_knockout(value:any):any;
	set_quality(value:any):any;
	set_strength(value:any):any;


}

}

export default openfl.filters.GlowFilter;