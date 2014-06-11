package openfl.display;


import js.html.webgl.RenderingContext;
import js.html.CanvasElement;
import js.Browser;
import openfl.display.Stage;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.Lib;


@:access(lime.graphics.opengl.GL)
class OpenGLView extends DirectRenderer {
	
	
	public static inline var CONTEXT_LOST = "glcontextlost";
	public static inline var CONTEXT_RESTORED = "glcontextrestored";
	
	public static var isSupported (get_isSupported, null):Bool;
	
	private var __added:Bool;
	private var __canvas:CanvasElement;
	private var __context:RenderingContext;
	
	
	public function new () {
		
		super ("OpenGLView");
		
		#if dom
		
		//__canvas = cast Browser.document.createElement ("canvas");
		//__canvas.width = Lib.current.stage.stageWidth;
		//__canvas.height = Lib.current.stage.stageHeight;
		
		//__context = cast __canvas.getContext ("webgl");
		
		//if (__context == null) {
			
			//__context = cast __canvas.getContext ("experimental-webgl");
			
		//}
		
		#if debug
		//__context = untyped WebGLDebugUtils.makeDebugContext (__context);
		#end
		
		//GL.__context = __context;
		
		#end
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (!__added) {
			
			__added = true;
			
			trace ("Warning: openfl-html5 only can run OpenGLView content using the DOM rendering mode");
			trace ("Please compile your project using -Ddom (on the command-line) or <haxedef name=\"dom\" /> to enable");
			
		}
		
	}
	
	
	public override function __renderDOM (renderSession:RenderSession):Void {
		
		if (stage != null && __worldVisible && __renderable) {
			
			if (!__added) {
				
				renderSession.element.appendChild (__canvas);
				__added = true;
				
				__initializeElement (__canvas, renderSession);
				
			}
			
			if (__context != null) {
				
				//GL.__context = __context;
				
				var rect = null;
				
				if (scrollRect == null) {
					
					rect = new Rectangle (0, 0, stage.stageWidth, stage.stageHeight);
					
				} else {
					
					rect = new Rectangle (x + scrollRect.x, y + scrollRect.y, scrollRect.width, scrollRect.height);
					
				}
				
				if (__render != null) __render (rect);
				
			}
			
			//__applyStyle (renderSession, true, false, true);
			
		} else {
			
			if (__added) {
				
				renderSession.element.removeChild (__canvas);
				__added = false;
				
			}
			
		}
		
	}
	
	
	public override function __renderGL (renderSession:RenderSession):Void {
		
		if (stage != null && __renderable) {
			
			var rect = null;
			
			if (scrollRect == null) {
				
				rect = new Rectangle (0, 0, stage.stageWidth, stage.stageHeight);
				
			} else {
				
				rect = new Rectangle (x + scrollRect.x, y + scrollRect.y, scrollRect.width, scrollRect.height);
				
			}
			
			if (__render != null) __render (rect);	
			
		}
		
	}
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_isSupported ():Bool {
		
		if (untyped (!window.WebGLRenderingContext)) {
			
			return false;
			
		}
		
		#if dom
		
		var view = new OpenGLView ();
		
		if (view.__context == null) {
			
			return false;
			
		}
		
		#else
		
		return (GL.context != null);
		
		#end
		
		return true;
		
	}
	
	
}