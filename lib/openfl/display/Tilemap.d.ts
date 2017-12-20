import DisplayObject from "./DisplayObject";

declare namespace openfl.display {

export class Tilemap extends DisplayObject {

	constructor(width:any, height:any, tileset?:any, smoothing?:any);
	numTiles:any;
	shader:any;
	tileset:any;
	smoothing:any;
	__tiles:any;
	__tileArray:any;
	__tileArrayDirty:any;
	__height:any;
	__width:any;
	addTile(tile:any):any;
	addTileAt(tile:any, index:any):any;
	addTiles(tiles:any):any;
	contains(tile:any):any;
	getTileAt(index:any):any;
	getTileIndex(tile:any):any;
	getTiles():any;
	removeTile(tile:any):any;
	removeTileAt(index:any):any;
	removeTiles(beginIndex?:any, endIndex?:any):any;
	setTiles(tileArray:any):any;
	__getBounds(rect:any, matrix:any):any;
	__hitTest(x:any, y:any, shapeFlag:any, stack:any, interactiveOnly:any, hitObject:any):any;
	__renderCairo(renderSession:any):any;
	__renderCanvas(renderSession:any):any;
	__renderDOM(renderSession:any):any;
	__renderDOMClear(renderSession:any):any;
	__renderFlash():any;
	__renderGL(renderSession:any):any;
	__renderGLMask(renderSession:any):any;
	__updateCacheBitmap(renderSession:any, force:any):any;
	__updateTileArray():any;
	get_height():any;
	set_height(value:any):any;
	set_tileset(value:any):any;
	get_width():any;
	set_width(value:any):any;


}

}

export default openfl.display.Tilemap;