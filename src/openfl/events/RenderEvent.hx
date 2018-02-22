package openfl.events;


import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.CairoRenderContext;
import lime.graphics.CanvasRenderContext;
import lime.graphics.GLRenderContext;
import lime.math.Matrix3;
import lime.math.Matrix4;
import openfl._internal.renderer.dom.DOMRenderer;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

#if (js && html5 && !display)
import js.html.Element;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.ColorTransform)

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class RenderEvent extends Event {
	
	
	public static inline var CLEAR_DOM = "clearDOM";
	public static inline var RENDER_CAIRO = "renderCairo";
	public static inline var RENDER_CANVAS = "renderCanvas";
	public static inline var RENDER_DOM = "renderDOM";
	public static inline var RENDER_OPENGL = "renderOpenGL";
	
	public var allowSmoothing:Bool;
	public var cairo (default, null):CairoRenderContext;
	public var context (default, null):CanvasRenderContext;
	public var element (default, null):#if (js && html5 && !display) Element #else Dynamic #end;
	public var gl (default, null):GLRenderContext;
	public var renderTransform:Matrix;
	public var worldColorTransform:ColorTransform;
	public var worldTransform:Matrix;
	
	private var __matrix3:Matrix3;
	private var __matrix4:Matrix4;
	private var __renderSession:RenderSession;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false):Void {
		
		super (type, bubbles, cancelable);
		
		renderTransform = new Matrix ();
		worldColorTransform = new ColorTransform ();
		worldTransform = new Matrix ();
		
		__matrix3 = new Matrix3 ();
		__matrix4 = new Matrix4 ();
		
	}
	
	
	public function applyDOMStyle (childElement:#if (js && html5 && !display) Element #else Dynamic #end):Void {
		
		#if (js && html5)
		if (target != null && childElement != null) {
			
			var parent:DisplayObject = cast target;
			var renderer:DOMRenderer = cast __renderSession.renderer;
			
			if (parent.__style == null || childElement.parentElement != element) {
				
				DOMRenderer.initializeElement (parent, childElement, __renderSession);
				
			}
			
			parent.__style = childElement.style;
			
			DOMRenderer.updateClip (parent, __renderSession);
			DOMRenderer.applyStyle (parent, __renderSession, true, true, true);
			
		}
		#end
		
	}
	
	
	public function clearDOMStyle (childElement:#if (js && html5 && !display) Element #else Dynamic #end):Void {
		
		#if (js && html5)
		if (childElement != null && childElement.parentElement == element) {
			
			element.removeChild (childElement);
			
		}
		#end
		
	}
	
	
	public override function clone ():Event {
		
		var event = new RenderEvent (type, bubbles, cancelable);
		event.allowSmoothing = allowSmoothing;
		event.cairo = cairo;
		event.context = context;
		event.gl = gl;
		event.renderTransform.copyFrom (renderTransform);
		event.worldColorTransform.__copyFrom (worldColorTransform);
		event.worldTransform.copyFrom (worldTransform);
		event.__renderSession = __renderSession;
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public function getCairoMatrix (transform:Matrix):Matrix3 {
		
		__matrix3.setTo (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
		return __matrix3;
		
	}
	
	
	public function getOpenGLMatrix (transform:Matrix):Matrix4 {
		
		if (gl != null) {
			
			var renderer:GLRenderer = cast __renderSession.renderer;
			var values = renderer.getMatrix (transform);
			
			for (i in 0...16) {
				
				__matrix4[i] = values[i];
				
			}
			
			return __matrix4;
			
		} else {
			
			__matrix4.identity ();
			__matrix4[0] = transform.a;
			__matrix4[1] = transform.b;
			__matrix4[4] = transform.c;
			__matrix4[5] = transform.d;
			__matrix4[12] = transform.tx;
			__matrix4[13] = transform.ty;
			
			return __matrix4;
			
		}
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("RenderEvent",  [ "type", "bubbles", "cancelable" ]);
		
	}
	
	
}