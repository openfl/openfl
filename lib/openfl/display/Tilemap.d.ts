import DisplayObject from "./DisplayObject";
import ITileContainer from "./ITileContainer";
import Shader from "./Shader";
import Tile from "./Tile";
import TileContainer from "./TileContainer";
import Tileset from "./Tileset";


declare namespace openfl.display {
	
	
	export class Tilemap extends DisplayObject implements ITileContainer {
		
		
		public readonly numTiles:number;
		
		protected get_numTiles ():number;
		
		public smoothing:boolean;
		public tileAlphaEnabled:Boolean;
		public tileColorTransformEnabled:Boolean;
		public tileset:Tileset;
		
		protected get_tileset ():Tileset;
		protected set_tileset (value:Tileset):Tileset;
		
		public constructor (width:number, height:number, tileset?:Tileset, smoothing?:boolean);
		
		public addTile (tile:Tile):Tile;
		public addTiles (tiles:Array<Tile>):Array<Tile>;
		public addTileAt (tile:Tile, index:number):Tile;
		public contains (tile:Tile):boolean;
		public getTileAt (index:number):Tile;
		public getTileIndex (tile:Tile):number;
		public getTiles ():TileContainer;
		public removeTile (tile:Tile):Tile;
		public removeTileAt (index:number):Tile;
		public removeTiles (beginIndex?:number, endIndex?:number):void;
		public setTileIndex (tile:Tile, index:number):void;
		public setTiles (group:TileContainer):void;
		public swapTiles (tile1:Tile, tile2:Tile):void;
		public swapTilesAt (index1:number, index2:number):void;
		
		
	}
	
	
}


export default openfl.display.Tilemap;