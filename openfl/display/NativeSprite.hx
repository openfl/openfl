package openfl.display;


import lime.graphics.RenderContext;
import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.events.NativeRenderEvent;
import openfl.geom.Matrix;
import openfl.geom.Transform;

#if !flash
import openfl._internal.renderer.opengl.GLRenderer;
#end

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
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)


class NativeSprite extends Sprite #if flash implements IDisplayObject #end {
	
	
	public var context (default, null):NativeRenderContext;
	public var renderTransform (default, null):Matrix;
	public var shader (get, set):Shader;
	
	private var __shader:Shader;
	
	#if (js && html5 && dom)
	private var __active:Bool;
	private var __element:DivElement;
	#end
	
	#if !flash
	private var __height:Int;
	private var __renderSession:RenderSession;
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
		
	}
	
	
	public function bindShader ():Void {
		
		#if !flash
		if (__renderSession != null) {
			
			__renderSession.shaderManager.setShader (__shader);
			
		}
		#end
		
	}
	
	
	public function shaderMatrixArray (matrix:Matrix):Array<Float> {
		
		#if !flash
		if (__renderSession != null) {
			
			var renderer:GLRenderer = cast __renderSession.renderer;
			return renderer.getMatrix (matrix);
			
		}
		#end
		
		return null;
		
	}
	
	
	private function __afterRender ():Bool {
		
		var event = new NativeRenderEvent (NativeRenderEvent.AFTER_NATIVE_RENDER);
		dispatchEvent (event);
		
		this.context = null;
		renderTransform = null;
		
		return !event.isDefaultPrevented ();
		
	}
	
	
	private function __beforeRender (context:NativeRenderContext):Bool {
		
		this.context = context;
		
		#if flash
		
		renderTransform = transform.concatenatedMatrix;
		
		#else
		
		renderTransform = __renderTransform;
		
		// TODO: Implement transform.concatenatedColorTransform
		
		if (__objectTransform == null) {
			
			__objectTransform = new Transform (this);
			
		}
		
		__objectTransform.concatenatedColorTransform.__copyFrom (__worldColorTransform);
		
		#end
		
		var event = new NativeRenderEvent (NativeRenderEvent.BEFORE_NATIVE_RENDER);
		dispatchEvent (event);
		
		return !event.isDefaultPrevented ();
		
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
	
	
	private function __render ():Void {
		
		dispatchEvent (new NativeRenderEvent (NativeRenderEvent.NATIVE_RENDER));
		
	}
	
	
	#if (lime_cairo && !flash)
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		super.__renderCairo (renderSession);
		
		if (__beforeRender (CAIRO (renderSession.cairo))) {
			
			var cairo = renderSession.cairo;
			
			renderSession.maskManager.pushObject (this);
			
			var transform = __renderTransform;
			
			if (renderSession.roundPixels) {
				
				var matrix = transform.__toMatrix3 ();
				matrix.tx = Math.round (matrix.tx);
				matrix.ty = Math.round (matrix.ty);
				cairo.matrix = matrix;
				
			} else {
				
				cairo.matrix = transform.__toMatrix3 ();
				
			}
			
		}
		
		__render ();
		
		if (__afterRender ()) {
			
			renderSession.maskManager.popObject (this);
			
		}
		
	}
	#end
	
	
	#if (js && html5 && !flash)
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		super.__renderCanvas (renderSession);
		
		if (__beforeRender (CANVAS (renderSession.context))) {
			
			var context = renderSession.context;
			
			renderSession.maskManager.pushObject (this, false);
			
			context.globalAlpha = __worldAlpha;
			var transform = __renderTransform;
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
				
			} else {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				
			}
			
			if (!renderSession.allowSmoothing) {
				
				untyped (context).mozImageSmoothingEnabled = false;
				//untyped (context).webkitImageSmoothingEnabled = false;
				untyped (context).msImageSmoothingEnabled = false;
				untyped (context).imageSmoothingEnabled = false;
				
			}
			
		}
		
		__render ();
		
		if (__afterRender ()) {
			
			if (!renderSession.allowSmoothing) {
				
				untyped (context).mozImageSmoothingEnabled = true;
				//untyped (context).webkitImageSmoothingEnabled = true;
				untyped (context).msImageSmoothingEnabled = true;
				untyped (context).imageSmoothingEnabled = true;
				
			}
			
			renderSession.maskManager.popObject (this, false);
			
		}
		
	}
	#end
	
	
	#if (js && html5 && dom && !flash)
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		if (stage != null && __worldVisible && __renderable) {
			
			if (__beforeRender (DOM (__element))) {
				
				if (!__active) {
					
					DOMRenderer.initializeElement (this, __element, renderSession);
					__active = true;
					
				}
				
				DOMRenderer.updateClip (this, renderSession);
				DOMRenderer.applyStyle (this, renderSession, true, true, true);
				
			}
			
			__render ();
			__afterRender ();
			
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
		
		__beforeRender (FLASH (this));
		__render ();
		__afterRender ();
		
	}
	#end
	
	
	#if !flash
	private override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		super.__renderGL (renderSession);
		
		__renderSession = renderSession;
		
		if (__beforeRender (OPENGL (renderSession.gl))) {
			
			var renderer:GLRenderer = cast renderSession.renderer;
			var gl = renderSession.gl;
			
			renderSession.blendModeManager.setBlendMode (__worldBlendMode);
			renderSession.maskManager.pushObject (this);
			
			__shader = renderSession.filterManager.pushObject (this);
			
		} else {
			
			renderSession.shaderManager.setShader (__shader);
			renderSession.blendModeManager.setBlendMode (null);
			
		}
		
		__render ();
		
		if (__afterRender ()) {
			
			renderSession.filterManager.popObject (this);
			renderSession.maskManager.popObject (this);
			
		}
		
		__renderSession = null;
		
	}
	#end
	
	
	
	
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
	
	
	private function get_shader ():Shader {
		
		return __shader;
		
	}
	
	
	private function set_shader (value:Shader):Shader {
		
		#if !flash
		if (__renderSession != null) {
			
			__renderSession.shaderManager.setShader (value);
			
		}
		#end
		
		return __shader = value;
		
	}
	
	
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