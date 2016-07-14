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

@:access(openfl.display.TilemapData)
@:access(openfl.geom.Rectangle)


class Tilemap extends #if !flash DisplayObject #else Bitmap implements IDisplayObject #end {
	
	
	public var tilemapData (default, set):TilemapData;
	
	#if !flash
	public var pixelSnapping:PixelSnapping;
	public var smoothing:Bool;
	#end
	
	
	public function new (tilemapData:TilemapData = null, pixelSnapping:PixelSnapping = AUTO, smoothing:Bool = false) {
		
		super ();
		
		this.tilemapData = tilemapData;
		this.pixelSnapping = pixelSnapping;
		this.smoothing = smoothing;
		
		#if flash
		FlashRenderer.register (this);
		#end
		
	}
	
	
	#if !flash
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (tilemapData != null) {
			
			var bounds = Rectangle.__temp;
			bounds.setTo (0, 0, tilemapData.width, tilemapData.height);
			bounds.__transform (bounds, matrix);
			
			rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
			
		}
		
	}
	#end
	
	
	#if !flash
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask || tilemapData == null) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		__getWorldTransform ();
		
		var px = __worldTransform.__transformInverseX (x, y);
		var py = __worldTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= tilemapData.width && py <= tilemapData.height) {
			
			if (stack != null && !interactiveOnly) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	#end
	
	
	#if !flash
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		CanvasTilemap.render (this, renderSession);
		
	}
	#end
	
	
	public function __renderFlash ():Void {
		
		FlashTilemap.render (this);
		
	}
	
	
	#if !flash
	public override function __renderGL (renderSession:RenderSession):Void {
		
		GLTilemap.render (this, renderSession);
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_tilemapData (value:TilemapData):TilemapData {
		
		#if flash
		bitmapData = value.__bitmapData;
		#end
		
		return this.tilemapData = value;
		
	}
	
	
	#if !flash
	private override function get_height ():Float {
		
		if (tilemapData != null) {
			
			return tilemapData.height;
			
		}
		
		return 0;
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		if (tilemapData != null) {
			
			if (value != tilemapData.height) {
				
				scaleY = value / tilemapData.height;
				
			}
			
			return value;
			
		}
		
		return 0;
		
	}
	#end
	
	
	#if !flash
	private override function get_width ():Float {
		
		if (tilemapData != null) {
			
			return tilemapData.width;
			
		}
		
		return 0;
		
	}
	
	
	private override function set_width (value:Float):Float {
		
		if (tilemapData != null) {
			
			if (value != tilemapData.width) {
				
				scaleX = value / tilemapData.width;
				
			}
			
			return value;
			
		}
		
		return 0;
		
	}
	#end
	
	
}