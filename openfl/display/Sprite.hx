package openfl.display; #if !flash


import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if js
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
import js.Browser;
#end


@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
class Sprite extends DisplayObjectContainer {
	
	
	public var buttonMode:Bool;
	public var graphics (get, null):Graphics;
	public var useHandCursor:Bool;
	
	private var __graphics:Graphics;
	
	#if js
	private var __canvas:CanvasElement;
	private var __canvasContext:CanvasRenderingContext2D;
	#end
	
	
	public function new () {
		
		super ();
		
		buttonMode = false;
		useHandCursor = true;
		
	}
	
	
	public function startDrag (lockCenter:Bool = false, bounds:Rectangle = null):Void {
		
		if (stage != null) {
			
			stage.__startDrag (this, lockCenter, bounds);
			
		}
		
	}
	
	
	public function stopDrag ():Void {
		
		if (stage != null) {
			
			stage.__stopDrag (this);
			
		}
		
	}
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		super.__getBounds (rect, matrix);
		
		if (__graphics != null) {
			
			__graphics.__getBounds (rect, matrix != null ? matrix : __worldTransform);
			
		}
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (!visible || (interactiveOnly && !mouseEnabled)) return false;
		
		var length = 0;
		
		if (stack != null) {
			
			length = stack.length;
			
		}
		
		if (super.__hitTest (x, y, shapeFlag, stack, interactiveOnly)) {
			
			return true;
			
		} else if (__graphics != null && __graphics.__hitTest (x, y, shapeFlag, __worldTransform)) {
			
			if (stack != null) {
				
				stack.insert (length, this);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		#if js
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (__graphics != null) {
			
			__graphics.__render ();
			
			if (__graphics.__canvas != null) {
				
				if (__mask != null) {
					
					renderSession.maskManager.pushMask (__mask);
					
				}
				
				var context = renderSession.context;
				
				context.globalAlpha = __worldAlpha;
				var transform = __worldTransform;
				
				if (renderSession.roundPixels) {
					
					context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
					
				} else {
					
					context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
					
				}
				
				if (scrollRect == null) {
					
					context.drawImage (__graphics.__canvas, __graphics.__bounds.x, __graphics.__bounds.y);
					
				} else {
					
					context.drawImage (__graphics.__canvas, scrollRect.x - __graphics.__bounds.x, scrollRect.y - __graphics.__bounds.y, scrollRect.width, scrollRect.height, __graphics.__bounds.x + scrollRect.x, __graphics.__bounds.y + scrollRect.y, scrollRect.width, scrollRect.height);
					
				}
				
				if (__mask != null) {
					
					renderSession.maskManager.popMask ();
					
				}
				
			}
			
		}
		
		super.__renderCanvas (renderSession);
		#end
		
	}
	
	
	public override function __renderDOM (renderSession:RenderSession):Void {
		
		#if js
		if (stage != null && __worldVisible && __renderable && __graphics != null) {
			
			if (__graphics.__dirty || __worldAlphaChanged || (__canvas == null && __graphics.__canvas != null)) {
				
				__graphics.__render ();
				
				if (__graphics.__canvas != null) {
					
					if (__canvas == null) {
						
						__canvas = cast Browser.document.createElement ("canvas");	
						__canvasContext = __canvas.getContext ("2d");
						__initializeElement (__canvas, renderSession);
						
					}
					
					__canvas.width = __graphics.__canvas.width;
					__canvas.height = __graphics.__canvas.height;
					
					__canvasContext.globalAlpha = __worldAlpha;
					__canvasContext.drawImage (__graphics.__canvas, 0, 0);
					
				} else {
					
					if (__canvas != null) {
						
						renderSession.element.removeChild (__canvas);
						__canvas = null;
						__style = null;
						
					}
					
				}
				
			}
			
			if (__canvas != null) {
				
				if (__worldTransformChanged) {
					
					var transform = new Matrix ();
					transform.translate (__graphics.__bounds.x, __graphics.__bounds.y);
					transform = transform.mult (__worldTransform);
					
					__style.setProperty (renderSession.transformProperty, transform.to3DString (renderSession.roundPixels), null);
					
				}
				
				__applyStyle (renderSession, false, false, true);
				
			}
			
		} else {
				
			if (__canvas != null) {
				
				renderSession.element.removeChild (__canvas);
				__canvas = null;
				__style = null;
				
			}
			
		}
		
		super.__renderDOM (renderSession);
		#end
		
	}
	
	
	public override function __renderMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			__graphics.__renderMask (renderSession);
				
		} else {
			
			super.__renderMask (renderSession);
			
		}
		
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
typedef Sprite = flash.display.Sprite;
#end