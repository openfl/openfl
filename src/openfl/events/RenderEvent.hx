package openfl.events;


import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.CairoRenderContext;
import lime.graphics.CanvasRenderContext;
import lime.graphics.GLRenderContext;
import lime.math.Matrix4;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.events.Event;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

@:access(openfl.geom.ColorTransform)

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class RenderEvent extends Event {
	
	
	public static inline var RENDER_CAIRO = "renderCairo";
	public static inline var RENDER_CANVAS = "renderCanvas";
	public static inline var RENDER_OPENGL = "renderOpenGL";
	
	public var allowSmoothing:Bool;
	public var cairo (default, null):CairoRenderContext;
	public var context (default, null):CanvasRenderContext;
	public var gl (default, null):GLRenderContext;
	public var renderTransform:Matrix;
	public var worldColorTransform:ColorTransform;
	public var worldTransform:Matrix;
	
	private var __projectionMatrix:Matrix4;
	private var __renderSession:RenderSession;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false):Void {
		
		super (type, bubbles, cancelable);
		
		renderTransform = new Matrix ();
		worldColorTransform = new ColorTransform ();
		worldTransform = new Matrix ();
		__projectionMatrix = new Matrix4 ();
		
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
	
	
	public function getProjectionMatrix (transform:Matrix):Matrix4 {
		
		if (gl != null) {
			
			var renderer:GLRenderer = cast __renderSession.renderer;
			var values = renderer.getMatrix (transform);
			
			for (i in 0...16) {
				
				__projectionMatrix[i] = values[i];
				
			}
			
			return __projectionMatrix;
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("RenderEvent",  [ "type", "bubbles", "cancelable" ]);
		
	}
	
	
}