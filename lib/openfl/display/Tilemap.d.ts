import DisplayObject from "./DisplayObject";
import Shader from "./Shader";
import Tile from "./Tile";
import TileArray from "./TileArray";
import Tileset from "./Tileset";


declare namespace openfl.display {
	
	
	export class Tilemap extends DisplayObject {
		
		
		public readonly numTiles:number;
		/*@:beta*/ public shader:Shader;
		public smoothing:boolean;
		public readonly tileset:Tileset;
		
		public constructor (width:number, height:number, tileset?:Tileset, smoothing?:boolean);
		
		public addTile (tile:Tile):Tile;
		public addTiles (tiles:Array<Tile>):Array<Tile>;
		public addTileAt (tile:Tile, index:number):Tile;
		public contains (tile:Tile):boolean;
		public getTileAt (index:number):Tile;
		public getTileIndex (tile:Tile):number;
		/*@:beta*/ public getTiles ():TileArray;
		public removeTile (tile:Tile):Tile;
		public removeTileAt (index:number):Tile;
		public removeTiles (beginIndex?:number, endIndex?:number):void;
		/*@:beta*/ public setTiles (tileArray:TileArray):void;
		
		
	}
	
	
}


export default openfl.display.Tilemap;