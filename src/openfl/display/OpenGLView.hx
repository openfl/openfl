package openfl.display; #if ((lime < "7.0.0") || (openfl < "8.4.0"))


import lime.graphics.opengl.GL;
import lime.graphics.GLRenderContext;
import openfl._internal.Lib;
import openfl.display.Stage;
import openfl.geom.Rectangle;

#if (js && html5)
import js.html.CanvasElement;
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

#if (lime < "7.0.0")
@:access(lime._backend.html5.HTML5GLRenderContext)
@:access(lime._backend.native.NativeGLRenderContext)
#end

@:access(lime.graphics.opengl.GL)


@:deprecated class OpenGLView extends DirectRenderer {
	
	
	public static inline var CONTEXT_LOST = "glcontextlost";
	public static inline var CONTEXT_RESTORED = "glcontextrestored";
	
	public static var isSupported (get, never):Bool;
	
	@:noCompletion private var __added:Bool;
	@:noCompletion private var __initialized:Bool;
	
	
	public function new () {
		
		super ("OpenGLView");
		
		#if (js && html5)
		#if dom
		if (!__initialized) {
			
			__canvas = cast Browser.document.createElement ("canvas");
			__canvas.width = Lib.current.stage.stageWidth;
			__canvas.height = Lib.current.stage.stageHeight;
			
			var window = Lib.current.stage.window;
			
			var options = {
				
				alpha: (Reflect.hasField (window.config, "background") && window.config.background == null) ? true : false,
				antialias: Reflect.hasField (window.config, "antialiasing") ? window.config.antialiasing > 0 : false,
				depth: Reflect.hasField (window.config, "depthBuffer") ? window.config.depthBuffer : true,
				premultipliedAlpha: true,
				stencil: Reflect.hasField (window.config, "stencilBuffer") ? window.config.stencilBuffer : false,
				preserveDrawingBuffer: false
				
			};
			
			__context = cast __canvas.getContextWebGL (options);
			
			#if webgl_debug
			__context = untyped WebGLDebugUtils.makeDebugContext (__context);
			#end
			
			GL.context = new GLRenderContext (cast __context);
			__initialized = true;
			
		}
		#elseif canvas
		if (!__added) {
			
			__added = true;
			
			trace ("Warning: OpenGLView is not available in HTML5 canvas rendering mode");
			trace ("Please compile your project using -Ddom or -Dwebgl (beta) to enable");
			
		}
		#end
		#end
		
	}
	
	
	#if !flash
	@:noCompletion private override function __enterFrame (deltaTime:Int):Void {
		
		if (__render != null) __setRenderDirty ();
		
	}
	#end
	
	
	#if !flash
	@:noCompletion private override function __renderCanvas (renderer:CanvasRenderer):Void {
		
		/*if (!__added) {
			
			__added = true;
			
			trace ("Warning: openfl-html5 only can run OpenGLView content using the DOM rendering mode");
			trace ("Please compile your project using -Ddom (on the command-line) or <haxedef name=\"dom\" /> to enable");
			
		}*/
		
	}
	#end
	
	
	#if !flash
	@:noCompletion private override function __renderDOM (renderer:DOMRenderer):Void {
		
		#if (js && html5)
		if (stage != null && __worldVisible && __renderable) {
			
			if (!__added) {
				
				/*if (!__initialized) {
					
					__canvas = cast Browser.document.createElement ("canvas");
					__canvas.width = Lib.current.stage.stageWidth;
					__canvas.height = Lib.current.stage.stageHeight;
					
					__context = cast __canvas.getContext ("webgl");
					
					if (__context == null) {
						
						__context = cast __canvas.getContext ("experimental-webgl");
						
					}
					
					#if webgl_debug
					__context = untyped WebGLDebugUtils.makeDebugContext (__context);
					#end
					
					//GL.__context = __context;
					__initialized = true;
					
				}*/
				
				renderer.element.appendChild (__canvas);
				__added = true;
				
				renderer.__initializeElement (this, __canvas);
				
			}
			
			if (__context != null) {
				
				//GL.__context = __context;
				
				var rect = null;
				
				if (__scrollRect == null) {
					
					rect = new Rectangle (0, 0, stage.stageWidth, stage.stageHeight);
					
				} else {
					
					rect = new Rectangle (x + __scrollRect.x, y + __scrollRect.y, __scrollRect.width, __scrollRect.height);
					
				}
				
				if (__render != null) __render (rect);
				
			}
			
			//__applyStyle (renderer, true, false, true);
			
		} else {
			
			if (__added) {
				
				renderer.element.removeChild (__canvas);
				__added = false;
				
			}
			
		}
		#end
		
	}
	#end
	
	
	#if !flash
	@:noCompletion private override function __renderGL (renderer:OpenGLRenderer):Void {
		
		if (stage != null && __renderable) {
			
			var rect = null;
			
			if (__scrollRect == null) {
				
				rect = new Rectangle (0, 0, stage.stageWidth, stage.stageHeight);
				
			} else {
				
				rect = new Rectangle (x + __scrollRect.x, y + __scrollRect.y, __scrollRect.width, __scrollRect.height);
				
			}
			
			renderer.setShader (null);
			renderer.__setBlendMode (null);
			
			if (__render != null) __render (rect);
			
		}
		
	}
	
	
	@:noCompletion private override function __renderGLMask (renderer:OpenGLRenderer):Void {
		
		
		
	}
	#end
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private static function get_isSupported ():Bool {
		
		#if flash
		
		return false;
		
		#elseif (js && html5)
		
		#if (canvas && !dom)
		return false;
		#else
		
		if (untyped (!window.WebGLRenderingContext)) {
			
			return false;
			
		}
		
		if (GL.context != null) {
			
			return true;
			
		} else {
			
			var canvas:CanvasElement = cast Browser.document.createElement ("canvas");
			var context = cast canvas.getContext ("webgl");
			
			if (context == null) {
				
				context = cast canvas.getContext ("experimental-webgl");
				
			}
			
			return (context != null);
			
		}
		#end
		
		#else
		
		return true;
		
		#end
		
	}
	
	
	#if (js && html5 && dom)
	@:noCompletion private override function set_width (value:Float):Float {
		
		super.set_width (value);
		
		__canvas.width = Std.int (value);
		return value;
		
	}
	
	
	@:noCompletion private override function set_height (value:Float):Float {
		
		super.set_height (value);
		
		__canvas.height = Std.int (value); 
		return value;
		
	}
	#end
	
	
}


#end