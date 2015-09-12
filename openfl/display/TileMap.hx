package openfl.display;


import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.renderer.flash.FlashTileMap;
import openfl._internal.renderer.RenderSession;

#if !flash
import openfl._internal.renderer.canvas.CanvasTileMap;
import openfl._internal.renderer.opengl.GLTileMap;
#end


class TileMap extends #if !flash DisplayObject #else Bitmap implements IDisplayObject #end {
	
	
	// TODO: Handle more properties
	
	public var allowRotation:Bool;
	public var allowScale:Bool;
	public var allowTransform:Bool;
	
	#if !flash
	public var smoothing:Bool;
	#end
	
	private var __layers:Array<TileLayer>;
	
	
	public function new (width:Int, height:Int) {
		
		super ();
		
		#if !flash
		this.width = width;
		this.height = height;
		#else
		bitmapData = new BitmapData (width, height, true, 0);
		FlashRenderer.register (this);
		#end
		
		smoothing = true;
		
	}
	
	
	public function addLayer (layer:TileLayer):Void {
		
		if (__layers == null) {
			
			__layers = new Array ();
			
		}
		
		__layers.push (layer);
		
	}
	
	
	public function removeLayer (layer:TileLayer):Void {
		
		if (__layers != null) {
			
			__layers.remove (layer);
			
		}
		
	}
	
	
	#if !flash
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (stage == null) return;
		
		CanvasTileMap.render (this, renderSession);
		
	}
	#end
	
	
	@:noCompletion @:dox(hide) public function __renderFlash ():Void {
		
		if (stage == null) return;
		
		FlashTileMap.render (this);
		
	}
	
	
	#if !flash
	public override function __renderGL (renderSession:RenderSession):Void {
		
		if (stage == null) return;
		
		GLTileMap.render (this, renderSession);
		
	}
	#end
	
	
}