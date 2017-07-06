package openfl.display; #if !display #if !openfl_legacy


#if !flash
import openfl._internal.renderer.RenderSession;
#end
import openfl.display.Stage;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.Lib;

#if (js && html5)
import js.html.CanvasElement;
import js.Browser;
#end

@:access(lime.graphics.opengl.GL)


class OpenGLView extends DirectRenderer {
	
	
	public static inline var CONTEXT_LOST = "glcontextlost";
	public static inline var CONTEXT_RESTORED = "glcontextrestored";
	
	public static var isSupported (get, null):Bool;
	
	private var __added:Bool;
	private var __initialized:Bool;
	
	
	public function new () {
		
		super ("OpenGLView");
		
	}
	
	
	#if !flash
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		/*if (!__added) {
			
			__added = true;
			
			trace ("Warning: openfl-html5 only can run OpenGLView content using the DOM rendering mode");
			trace ("Please compile your project using -Ddom (on the command-line) or <haxedef name=\"dom\" /> to enable");
			
		}*/
		
	}
	#end
	
	
	#if !flash
	public override function __renderGL (renderSession:RenderSession):Void {
		
		if (stage != null && __renderable) {
			
			var rect = Rectangle.pool.get();
			var renderer = @:privateAccess stage.__renderer;
			var width = Std.int(renderer != null ? renderer.width : stage.stageWidth * stage.scaleX);
			var height = Std.int(renderer != null ? renderer.height : stage.stageHeight * stage.scaleY);
			
			if (__scrollRect == null) {
				
				rect.setTo (0, 0, width, height);
				
			} else {
				
				rect.setTo (x + __scrollRect.x, y + __scrollRect.y, __scrollRect.width, __scrollRect.height);
				
			}
			
			if (__render != null) __render (rect);
			Rectangle.pool.put(rect);
			
			renderSession.shaderManager.setShader(null);
			renderSession.blendModeManager.setBlendMode(null);
			renderSession.renderer.setViewport(0,0,width, height, true);
			openfl._internal.renderer.opengl.shaders2.Shader.resetCache ();
		}
		
	}
	#end
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_isSupported ():Bool {
		
		#if flash
		
		return false;
		
		#elseif (js && html5)
		
		#if (!dom && !webgl)
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
	
	
	#if (html5 && dom)
	private override function set_width (value:Float):Float {
		
		super.set_width (value);
		
		__canvas.width = Std.int (value);
		return value;
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		super.set_height (value);
		
		__canvas.height = Std.int (value); 
		return value;
		
	}
	#end
	
	
}


#else
typedef OpenGLView = openfl._legacy.display.OpenGLView;
#end
#elseif !flash


extern class OpenGLView extends DirectRenderer {
	
	
	public static inline var CONTEXT_LOST = "glcontextlost";
	public static inline var CONTEXT_RESTORED = "glcontextrestored";
	
	public static var isSupported (get, null):Bool;
	
	public function new ();
	
	
}


#end
