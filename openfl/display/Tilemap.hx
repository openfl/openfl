package openfl.display;


import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.renderer.flash.FlashTilemap;
import openfl._internal.renderer.RenderSession;

#if !flash
import openfl._internal.renderer.canvas.CanvasTilemap;
import openfl._internal.renderer.opengl.GLTilemap;
#end


class Tilemap extends #if !flash DisplayObject #else Bitmap implements IDisplayObject #end {
	
	
	// TODO: Handle more properties
	
	public var allowRotation:Bool;
	public var allowScale:Bool;
	public var allowTransform:Bool;
	public var numLayers (default, null):Int;
	
	#if !flash
	public var smoothing:Bool;
	#end
	
	private var __layers:Array<TilemapLayer>;
	
	
	public function new (width:Int, height:Int) {
		
		super ();
		
		#if !flash
		this.width = width;
		this.height = height;
		#else
		bitmapData = new BitmapData (width, height, true, 0);
		FlashRenderer.register (this);
		#end
		
		__layers = new Array ();
		numLayers = 0;
		smoothing = true;
		
	}
	
	
	public function addLayer (layer:TilemapLayer):TilemapLayer {
		
		__layers.push (layer);
		numLayers++;
		
		return layer;
		
	}
	
	
	public function addLayerAt (layer:TilemapLayer, index:Int):TilemapLayer {
		
		__layers.remove (layer);
		__layers.insert (index, layer);
		numLayers = __layers.length;
		
		return layer;
		
	}
	
	
	public function contains (layer:TilemapLayer):Bool {
		
		return (__layers.indexOf (layer) > -1);
		
	}
	
	
	public function getLayerAt (index:Int):TilemapLayer {
		
		if (index >= 0 && index < numLayers) {
			
			return __layers[index];
			
		}
		
		return null;
		
	}
	
	
	public function getLayerIndex (layer:TilemapLayer):Int {
		
		for (i in 0...__layers.length) {
			
			if (__layers[i] == layer) return i;
			
		}
		
		return -1;
		
	}
	
	
	public function removeLayer (layer:TilemapLayer):TilemapLayer {
		
		__layers.remove (layer);
		numLayers = __layers.length;
		
		return layer;
		
	}
	
	
	public function removeLayerAt (index:Int):TilemapLayer {
		
		if (index >= 0 && index < numLayers) {
			
			return removeLayer (__layers[index]);
			
		}
		
		return null;
		
	}
	
	
	#if !flash
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (stage == null) return;
		
		CanvasTilemap.render (this, renderSession);
		
	}
	#end
	
	
	@:noCompletion @:dox(hide) public function __renderFlash ():Void {
		
		if (stage == null) return;
		
		FlashTilemap.render (this);
		
	}
	
	
	#if !flash
	public override function __renderGL (renderSession:RenderSession):Void {
		
		if (stage == null) return;
		
		GLTilemap.render (this, renderSession);
		
	}
	#end
	
	
}