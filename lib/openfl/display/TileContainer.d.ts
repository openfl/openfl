import ITileContainer from "./ITileContainer";
import Tile from "./Tile";
import Tileset from "./Tileset";


declare namespace openfl.display {
	
	
	export class TileContainer extends Tile implements ITileContainer {
		
		
		public readonly numTiles:number;
		
		protected get_numTiles ():number;
		
		public constructor (x?:number, y?:number, scaleX?:number, scaleY?:number, rotation?:number);
		
		public addTile (tile:Tile):Tile;
		public addTiles (tiles:Array<Tile>):Array<Tile>;
		public addTileAt (tile:Tile, index:number):Tile;
		public contains (tile:Tile):boolean;
		public getTileAt (index:number):Tile;
		public getTileIndex (tile:Tile):number;
		public removeTile (tile:Tile):Tile;
		public removeTileAt (index:number):Tile;
		public removeTiles (beginIndex?:number, endIndex?:number):void;
		public setTileIndex (tile:Tile, index:number):void;
		public swapTiles (tile1:Tile, tile2:Tile):void;
		public swapTilesAt (index1:number, index2:number):void;
		
		
	}
	
	
}


export default openfl.display.TileContainer;