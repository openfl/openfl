package openfl.display;


import lime.graphics.RenderContext;
import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.events.Event;

#if (js && html5 && dom)
import js.html.DivElement;
import js.Browser;
import openfl._internal.renderer.dom.DOMRenderer;
#end

@:access(openfl.display.NativeCairoContext)
@:access(openfl.display.NativeCanvasContext)
@:access(openfl.display.NativeDOMContext)
@:access(openfl.display.NativeFlashContext)
@:access(openfl.display.NativeGLContext)


class NativeSprite extends Sprite #if flash implements IDisplayObject #end {
	
	
	public var context:NativeContext;
	
	#if (js && html5 && dom)
	private var __active:Bool;
	private var __element:DivElement;
	#end
	
	#if !flash
	private var __height:Int;
	private var __width:Int;
	#end
	
	
	public function new () {
		
		super ();
		
		#if (js && html5 && dom)
		__element = cast Browser.document.createElement ("div");
		#end
		
		#if flash
		mouseEnabled = false;
		mouseChildren = false;
		FlashRenderer.register (this);
		#end
		
		addEventListener (Event.RENDER, __this_onRender, false, 2147483647);
		
	}
	
	
	#if !flash
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		__getRenderTransform ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= __width && py <= __height) {
			
			if (stack != null && !interactiveOnly) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	#end
	
	
	private function __render (context:NativeContext):Void {
		
		this.context = context;
		
		dispatchEvent (new Event (Event.RENDER));
		
		this.context = null;
		
	}
	
	
	#if (lime_cairo && !flash)
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		__render (CAIRO (renderSession.cairo));
		
	}
	#end
	
	
	#if (js && html5 && !flash)
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		__render (CANVAS (renderSession.context));
		
	}
	#end
	
	
	#if (js && html5 && dom && !flash)
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		if (stage != null && __worldVisible && __renderable) {
			
			if (!__active) {
				
				DOMRenderer.initializeElement (this, __element, renderSession);
				__active = true;
				
			}
			
			DOMRenderer.updateClip (this, renderSession);
			DOMRenderer.applyStyle (this, renderSession, true, true, true);
			
			__render (DOM (__element));
			
		} else {
			
			if (__active) {
				
				renderSession.element.removeChild (__element);
				__active = false;
				
			}
			
		}
		
		super.__renderDOM (renderSession);
		
	}
	#end
	
	
	#if flash
	private function __renderFlash ():Void {
		
		__render (FLASH (this));
		
	}
	#end
	
	
	#if !flash
	private override function __renderGL (renderSession:RenderSession):Void {
		
		if (__renderable) {
			
			renderSession.shaderManager.setShader (null);
			renderSession.blendModeManager.setBlendMode (null);
			
			__render (OPENGL (renderSession.gl));
			
		}
		
	}
	#end
	
	
	
	
	// Event Handlers
	
	
	
	private function __this_onRender (event:Event):Void {
		
		if (context == null) {
			
			event.stopImmediatePropagation ();
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	#if !flash
	private override function get_height ():Float {
		
		return __height * Math.abs (scaleY);
		
	}
	#end
	
	
	#if !flash
	private override function set_height (value:Float):Float {
		
		__height = Std.int (value);
		return __height * Math.abs (scaleY);
		
	}
	#else
	//@:setter(height) private function set_height (value:Float):Void {
		//
		//if (value != bitmapData.height) {
			//
			//var cacheSmoothing = smoothing;
			//bitmapData = new BitmapData (bitmapData.width, Std.int (value), true, 0);
			//smoothing = cacheSmoothing;
			//
		//}
		//
	//}
	#end
	
	
	#if !flash
	private override function get_width ():Float {
		
		return __width * Math.abs (__scaleX);
		
	}
	#end
	
	
	#if !flash
	private override function set_width (value:Float):Float {
		
		__width = Std.int (value);
		return __width * Math.abs (__scaleX);
		
	}
	#else
	//@:setter(width) private function set_width (value:Float):Void {
		//
		//if (value != bitmapData.width) {
			//
			//var cacheSmoothing = smoothing;
			//bitmapData = new BitmapData (Std.int (value), bitmapData.height, true, 0);
			//smoothing = cacheSmoothing;
			//
		//}
		//
	//}
	#end
	
	
}