package openfl.display; #if !flash


import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl._internal.renderer.dom.DOMRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if js
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
#end

@:access(openfl.display.Graphics)


class Shape extends DisplayObject {
	
	
	public var graphics (get, null):Graphics;
	
	private var __graphics:Graphics;
	
	#if js
	private var __canvas:CanvasElement;
	private var __canvasContext:CanvasRenderingContext2D;
	#end
	
	
	public function new () {
		
		super ();
		
	}
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__graphics != null) {
			
			__graphics.__getBounds (rect, __worldTransform);
			
		}
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (visible && __graphics != null && __graphics.__hitTest (x, y, shapeFlag, __worldTransform)) {
			
			if (!interactiveOnly) {
				
				stack.push (this);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		CanvasRenderer.renderShape (this, renderSession);
		
	}
	
	
	public override function __renderDOM (renderSession:RenderSession):Void {
		
		DOMRenderer.renderShape (this, renderSession);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_graphics ():Graphics {
		
		if (__graphics == null) {
			
			__graphics = new Graphics ();
			
		}
		
		return __graphics;
		
	}
	
	
}


#else
typedef Shape = flash.display.Shape;
#end