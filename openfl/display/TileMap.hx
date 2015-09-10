package openfl.display;


import openfl._internal.renderer.opengl.GLTileMap;
import openfl._internal.renderer.RenderSession;


class TileMap extends DisplayObject {
	
	
	// TODO: Handle more properties
	
	public var allowRotation:Bool;
	public var allowScale:Bool;
	public var allowTransform:Bool;
	
	private var __layers:Array<TileMapLayer>;
	
	
	public function new (width:Int, height:Int) {
		
		super ();
		
		this.width = width;
		this.height = height;
		
	}
	
	
	public function addLayer (layer:TileMapLayer):Void {
		
		if (__layers == null) {
			
			__layers = new Array ();
			
		}
		
		__layers.push (layer);
		
	}
	
	
	public function removeLayer (layer:TileMapLayer):Void {
		
		if (__layers != null) {
			
			__layers.remove (layer);
			
		}
		
	}
	
	
	public override function __renderGL (renderSession:RenderSession):Void {
		
		if (stage == null) return;
		
		GLTileMap.render (this, renderSession);
		
	}
	
	
}