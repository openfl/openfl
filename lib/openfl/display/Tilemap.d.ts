import DisplayObject from "./DisplayObject";
import Shader from "./Shader";
import Tile from "./Tile";
import TileGroup from "./TileGroup";
import Tileset from "./Tileset";


declare namespace openfl.display {
	
	
	export class Tilemap extends DisplayObject {
		
		
		public readonly numTiles:number;
		public smoothing:boolean;
		public tileAlphaEnabled:Boolean;
		public tileColorTransformEnabled:Boolean;
		public tileset:Tileset;
		
		public constructor (width:number, height:number, tileset?:Tileset, smoothing?:boolean);
		
		public addTile (tile:Tile):Tile;
		public addTiles (tiles:Array<Tile>):Array<Tile>;
		public addTileAt (tile:Tile, index:number):Tile;
		public contains (tile:Tile):boolean;
		public getTileAt (index:number):Tile;
		public getTileIndex (tile:Tile):number;
		public getTiles ():TileGroup;
		public removeTile (tile:Tile):Tile;
		public removeTileAt (index:number):Tile;
		public removeTiles (beginIndex?:number, endIndex?:number):void;
		public setTiles (tileArray:TileGroup):void;
		
		
	}
	
	
}


export default openfl.display.Tilemap;