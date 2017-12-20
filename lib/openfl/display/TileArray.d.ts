
declare namespace openfl.display {

export class TileArray {

	constructor(length?:any);
	alpha:any;
	colorTransform:any;
	id:any;
	length:any;
	matrix:any;
	position:any;
	rect:any;
	shader:any;
	tileset:any;
	visible:any;
	
	
	__bufferDirty:any;
	__bufferData:any;
	__bufferSkipped:any;
	__cacheAlpha:any;
	__cacheDefaultTileset:any;
	__colorTransform:any;
	__data:any;
	__dirty:any;
	__length:any;
	__matrix:any;
	__rect:any;
	__shaders:any;
	__tilesets:any;
	__visible:any;
	iterator():any;
	__init(position:any):any;
	__updateGLBuffer(gl:any, defaultTileset:any, worldAlpha:any, defaultColorTransform:any):any;
	get_alpha():any;
	set_alpha(value:any):any;
	get_colorTransform():any;
	set_colorTransform(value:any):any;
	get_id():any;
	set_id(value:any):any;
	get_length():any;
	set_length(value:any):any;
	get_matrix():any;
	set_matrix(value:any):any;
	get_rect():any;
	set_rect(value:any):any;
	get_shader():any;
	set_shader(value:any):any;
	get_tileset():any;
	set_tileset(value:any):any;
	get_visible():any;
	set_visible(value:any):any;
	static ID_INDEX:any;
	static RECT_INDEX:any;
	static MATRIX_INDEX:any;
	static ALPHA_INDEX:any;
	static COLOR_TRANSFORM_INDEX:any;
	static DATA_LENGTH:any;
	static SOURCE_DIRTY_INDEX:any;
	static MATRIX_DIRTY_INDEX:any;
	static ALPHA_DIRTY_INDEX:any;
	static COLOR_TRANSFORM_DIRTY_INDEX:any;
	static ALL_DIRTY_INDEX:any;
	static DIRTY_LENGTH:any;


}

}

export default openfl.display.TileArray;