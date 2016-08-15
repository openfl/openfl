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
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
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
	private var __context:CanvasRenderingContext2D;
	private var __style:CSSStyleDeclaration;
	#end
	
	
	public function new () {
		
		super ();
		
		visible = true;
		
	}
	
	
	public function requestContext3D (context3DRenderMode:Context3DRenderMode = AUTO, profile:Context3DProfile = BASELINE):Void {
		
		__contextRequested = true;
		
	}
	
	
	public function requestContext3DMatchingProfiles (profiles:Vector<Context3DProfile>):Void {
		
		requestContext3D ();
		
	}
	
	
	private function __createContext (renderSession:RenderSession):Void {
		
		
		
	}
	
	
	public function __renderDOM (stage:Stage, renderSession:RenderSession):Void {
		
		if (!visible) return;
		
		if (__contextRequested) {
			
			if (context3D == null) {
				
				#if (js && html5)
				
				__canvas = cast Browser.document.createElement ("canvas");
				__canvas.width = stage.stageWidth;
				__canvas.height = stage.stageHeight;
				
				var window = stage.window;
				var options = {
					
					alpha: false, 
					premultipliedAlpha: false, 
					antialias: false, 
					depth: Reflect.hasField (window.config, "depthBuffer") ? window.config.depthBuffer : true, 
					stencil: Reflect.hasField (window.config, "stencilBuffer") ? window.config.stencilBuffer : false
					
				}
				
				__context = cast __canvas.getContext ("webgl", options);
				
				if (__context == null) {
					
					__context = cast __canvas.getContext ("experimental-webgl", options);
					
				}
				
				if (__context != null) {
					
					#if debug
					__context = untyped WebGLDebugUtils.makeDebugContext (__context);
					#end
					
					// TODO: Need to handle renderSession/context better
					
					GL.context = cast __context;
					
					context3D = new Context3D (this, renderSession);
					
					renderSession.element.appendChild (__canvas);
					
					__style = __canvas.style;
					__style.setProperty ("position", "absolute", null);
					__style.setProperty ("top", "0", null);
					__style.setProperty ("left", "0", null);
					__style.setProperty (renderSession.transformOriginProperty, "0 0 0", null);
					__style.setProperty ("z-index", "-1", null);
					
					dispatchEvent (new Event (Event.CONTEXT3D_CREATE));
					
				} else {
					
					dispatchEvent (new ErrorEvent (ErrorEvent.ERROR));
					
				}
				
				#end
				
			}
			
			__contextRequested = false;
			
		}
		
		if (context3D != null) {
			
			__resetContext3DStates ();
			//DOMStage3D.render (this, renderSession);
			
		}
		
	}
	
	
	public function __renderGL (stage:Stage, renderSession:RenderSession):Void {
		
		if (!visible) return;
		
		if (__contextRequested) {
			
			if (context3D == null) {
				
				context3D = new Context3D (this, renderSession);
				dispatchEvent (new Event (Event.CONTEXT3D_CREATE));
				
			}
			
			__contextRequested = false;
			
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
		
		this.x = value;
		context3D.__updateBackbufferViewport ();
		return value;
		
	}
	
	
	private function set_y (value:Float):Float {
		
		this.y = value;
		context3D.__updateBackbufferViewport ();
		return value;
		
	}
	
	
}