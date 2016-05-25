package openfl.display;


extern class Tilemap extends DisplayObject {
	
	
	public var numLayers (default, null):Int;
	
	public function new (width:Int, height:Int);
	
	public function addLayer (layer:TilemapLayer):TilemapLayer;
	public function addLayerAt (layer:TilemapLayer, index:Int):TilemapLayer;
	public function contains (layer:TilemapLayer):Bool;
	public function getLayerAt (index:Int):TilemapLayer;
	public function getLayerIndex (layer:TilemapLayer):Int;
	public function removeLayer (layer:TilemapLayer):TilemapLayer;
	public function removeLayerAt (index:Int):TilemapLayer;
	
	
}