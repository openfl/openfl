package openfl.display;


import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.renderer.flash.FlashTilemap;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !flash
import openfl._internal.renderer.canvas.CanvasTilemap;
import openfl._internal.renderer.opengl.GLTilemap;
#end

@:access(openfl.geom.Rectangle)


class Tilemap extends #if !flash DisplayObject #else Bitmap implements IDisplayObject #end {
	
	
	// TODO: Handle more properties
	
	public var allowRotation:Bool;
	public var allowScale:Bool;
	public var allowTransform:Bool;
	public var numLayers (default, null):Int;
	
	#if !flash
	public var smoothing:Bool;
	private var __width:Int;
	private var __height:Int;
	#end
	
	@:noCompletion @:dox(hide) private var __layers:Array<TilemapLayer>;
	
	
	public function new (width:Int, height:Int) {
		
		super ();
		
		#if !flash
		__width = width;
		__height = height;
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
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		var bounds = Rectangle.__temp;
		bounds.setTo (0, 0, __width, __height);
		bounds.__transform (bounds, matrix);
		
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	#end
	
	
	#if !flash
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		__getWorldTransform ();
		
		var px = __worldTransform.__transformInverseX (x, y);
		var py = __worldTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= __width && py <= __height) {
			
			if (stack != null && !interactiveOnly) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	#end
	
	
	#if !flash
	@:noCompletion @:dox(hide) public override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (stage == null) return;
		
		CanvasTilemap.render (this, renderSession);
		
	}
	#end
	
	
	@:noCompletion @:dox(hide) public function __renderFlash ():Void {
		
		if (stage == null) return;
		
		FlashTilemap.render (this);
		
	}
	
	
	#if !flash
	@:noCompletion @:dox(hide) public override function __renderGL (renderSession:RenderSession):Void {
		
		if (stage == null) return;
		
		GLTilemap.render (this, renderSession);
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	#if !flash
	private override function get_height ():Float {
		
		return __height;
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		return __height = Std.int (value);
		
	}
	
	
	private override function get_width ():Float {
		
		return __width;
		
	}
	
	
	private override function set_width (value:Float):Float {
		
		return __width = Std.int (value);
		
	}
	#end
	
	
}