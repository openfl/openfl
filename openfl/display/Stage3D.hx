package openfl.display;


import haxe.Timer;
import lime.graphics.opengl.GL;
import openfl._internal.renderer.opengl.GLStage3D;
import openfl._internal.renderer.RenderSession;
import openfl.display.OpenGLView;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.Vector;

#if (js && html5)
import js.html.webgl.RenderingContext;
import js.html.CanvasElement;
import js.html.CSSStyleDeclaration;
import js.Browser;
#end

@:access(lime.graphics.opengl.GL)
@:access(openfl.display3D.Context3D)


class Stage3D extends EventDispatcher {
	
	
	public var context3D (default, null):Context3D;
	public var visible:Bool;
	public var x (default, set):Float;
	public var y (default, set):Float;
	
	private var __contextRequested:Bool;
	
	#if (js && html5)
	private var __canvas:CanvasElement;
	private var __style:CSSStyleDeclaration;
	private var __webgl:RenderingContext;
	#end
	
	
	private function new () {
		
		super ();
		
		this.x = 0;
		this.y = 0;
		
		visible = true;
		
	}
	
	
	public function requestContext3D (context3DRenderMode:Context3DRenderMode = AUTO, profile:Context3DProfile = BASELINE):Void {
		
		__contextRequested = true;
		
		if (context3D != null) {
			
			Timer.delay (__dispatchCreate, 1);
			
		}
		
	}
	
	
	public function requestContext3DMatchingProfiles (profiles:Vector<Context3DProfile>):Void {
		
		requestContext3D ();
		
	}
	
	
	private function __createContext (stage:Stage, renderSession:RenderSession):Void {
		
		if (renderSession.gl != null) {
			
			context3D = new Context3D (this, renderSession);
			__dispatchCreate ();
			
		} else {
			
			#if (js && html5)
			
			__canvas = cast Browser.document.createElement ("canvas");
			__canvas.width = stage.stageWidth;
			__canvas.height = stage.stageHeight;
			
			var window = stage.window;
			
			var options = {
				
				alpha: (Reflect.hasField (window.config, "background") && window.config.background == null) ? true : false,
				antialias: Reflect.hasField (window.config, "antialiasing") ? window.config.antialiasing > 0 : false,
				depth: Reflect.hasField (window.config, "depthBuffer") ? window.config.depthBuffer : true,
				premultipliedAlpha: true,
				stencil: Reflect.hasField (window.config, "stencilBuffer") ? window.config.stencilBuffer : false,
				preserveDrawingBuffer: false
				
			};
			
			__webgl = cast __canvas.getContextWebGL (options);
			
			if (__webgl != null) {
				
				#if webgl_debug
				__webgl = untyped WebGLDebugUtils.makeDebugContext (__webgl);
				#end
				
				// TODO: Need to handle renderSession/context better
				
				GL.context = cast __webgl;
				
				context3D = new Context3D (this, renderSession);
				
				renderSession.element.appendChild (__canvas);
				
				__style = __canvas.style;
				__style.setProperty ("position", "absolute", null);
				__style.setProperty ("top", "0", null);
				__style.setProperty ("left", "0", null);
				__style.setProperty (renderSession.transformOriginProperty, "0 0 0", null);
				__style.setProperty ("z-index", "-1", null);
				
				__dispatchCreate ();
				
			} else {
				
				__dispatchError ();
				
			}
			
			#end
			
		}
		
	}
	
	
	private function __dispatchError ():Void {
		
		__contextRequested = false;
		dispatchEvent (new ErrorEvent (ErrorEvent.ERROR, false, false, "Context3D not available"));
		
	}
	
	
	private function __dispatchCreate ():Void {
		
		if (__contextRequested) {
			
			__contextRequested = false;
			dispatchEvent (new Event (Event.CONTEXT3D_CREATE));
			
		}
		
	}
	
	
	private function __renderCairo (stage:Stage, renderSession:RenderSession):Void {
		
		if (!visible) return;
		
		if (__contextRequested) {
			
			__dispatchError ();
			__contextRequested = false;
			
		}
		
	}
	
	
	private function __renderCanvas (stage:Stage, renderSession:RenderSession):Void {
		
		if (!visible) return;
		
		if (__contextRequested) {
			
			__dispatchError ();
			__contextRequested = false;
			
		}
		
	}
	
	
	private function __renderDOM (stage:Stage, renderSession:RenderSession):Void {
		
		if (!visible) return;
		
		if (__contextRequested && context3D == null) {
			
			__createContext (stage, renderSession);
			
		}
		
		if (context3D != null) {
			
			#if (js && html5)
			GL.context = cast __webgl;
			#end
			
			__resetContext3DStates ();
			//DOMStage3D.render (this, renderSession);
			
		}
		
	}
	
	
	private function __renderGL (stage:Stage, renderSession:RenderSession):Void {
		
		if (!visible) return;
		
		if (__contextRequested && context3D == null) {
			
			__createContext (stage, renderSession);
			
		}
		
		if (context3D != null) {
			
			__resetContext3DStates ();
			GLStage3D.render (this, renderSession);
			
		}
		
	}
	
	
	public function __resize (width:Int, height:Int):Void {
		
		#if (js && html5)
		if (__canvas != null) {
			
			__canvas.width = width;
			__canvas.height = height;
			
		}
		#end
		
	}
	
	
	private function __resetContext3DStates ():Void {
		
		// TODO: Better blend mode fix
		context3D.__updateBlendFactors ();
		// TODO: Better viewport fix
		context3D.__updateBackbufferViewport ();
		
	}
	
	
	private function set_x (value:Float):Float {
		
		if (this.x == value) return value;
		
		this.x = value;
		
		if (context3D != null) {
			
			context3D.__updateBackbufferViewport ();
			
		}
		
		return value;
		
	}
	
	
	private function set_y (value:Float):Float {
		
		if (this.y == value) return value;
		
		this.y = value;
		
		if (context3D != null) {
			
			context3D.__updateBackbufferViewport ();
			
		}
		
		return value;
		
	}
	
	
}