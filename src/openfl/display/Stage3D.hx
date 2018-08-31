package openfl.display; #if !flash


import haxe.Timer;
import lime.graphics.opengl.GL;
import lime.graphics.RenderContext;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix3D;
import openfl.Vector;

#if (js && html5)
import js.html.webgl.RenderingContext;
import js.html.CanvasElement;
import js.html.CSSStyleDeclaration;
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(lime.graphics.opengl.GL)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Stage)


class Stage3D extends EventDispatcher {
	
	
	@:noCompletion private static var __active:Bool;
	
	public var context3D (default, null):Context3D;
	public var visible:Bool;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	@:noCompletion private var __contextRequested:Bool;
	@:noCompletion private var __height:Int;
	@:noCompletion private var __indexBuffer:IndexBuffer3D;
	@:noCompletion private var __projectionTransform:Matrix3D;
	@:noCompletion private var __renderTransform:Matrix3D;
	@:noCompletion private var __stage:Stage;
	@:noCompletion private var __vertexBuffer:VertexBuffer3D;
	@:noCompletion private var __width:Int;
	@:noCompletion private var __x:Float;
	@:noCompletion private var __y:Float;
	
	#if (js && html5)
	@:noCompletion private var __canvas:CanvasElement;
	@:noCompletion private var __renderContext:RenderContext;
	@:noCompletion private var __style:CSSStyleDeclaration;
	@:noCompletion private var __webgl:RenderingContext;
	#end
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperties (Stage3D.prototype, {
			"x": { get: untyped __js__ ("function () { return this.get_x (); }"), set: untyped __js__ ("function (v) { return this.set_x (v); }") },
			"y": { get: untyped __js__ ("function () { return this.get_y (); }"), set: untyped __js__ ("function (v) { return this.set_y (v); }") },
		});
		
	}
	#end
	
	
	@:noCompletion private function new (stage:Stage) {
		
		super ();
		
		__stage = stage;
		
		__height = 0;
		__projectionTransform = new Matrix3D ();
		__renderTransform = new Matrix3D ();
		__width = 0;
		__x = 0;
		__y = 0;
		
		visible = true;
		
		if (stage.stageWidth > 0 && stage.stageHeight > 0) {
			__resize (stage.stageWidth, stage.stageHeight);
		}
		
	}
	
	
	public function requestContext3D (context3DRenderMode:Context3DRenderMode = AUTO, profile:Context3DProfile = BASELINE):Void {
		
		if (context3D != null) {
			
			Timer.delay (__dispatchCreate, 1);
			
		} else if (!__contextRequested) {
			
			__contextRequested = true;
			Timer.delay (__createContext, 1);
			
		}
		
	}
	
	
	public function requestContext3DMatchingProfiles (profiles:Vector<Context3DProfile>):Void {
		
		requestContext3D ();
		
	}
	
	
	@:noCompletion private function __createContext ():Void {
		
		var stage = __stage;
		var renderer = stage.__renderer;
		
		if (renderer.__type == CAIRO || renderer.__type == CANVAS) {
			
			__dispatchError ();
			return;
			
		}
		
		if (renderer.__type == OPENGL) {
			
			#if openfl_share_context
			context3D = stage.context3D;
			#else
			context3D = new Context3D (stage, stage.context3D.__contextState, this);
			#end
			__dispatchCreate ();
			
		} else if (renderer.__type == DOM) {
			
			#if (js && html5)
			__canvas = cast Browser.document.createElement ("canvas");
			__canvas.width = stage.stageWidth;
			__canvas.height = stage.stageHeight;
			
			var window = stage.window;
			var attributes = renderer.__context.attributes;
			
			var transparentBackground = Reflect.hasField (attributes, "background") && attributes.background == null;
			var colorDepth = Reflect.hasField (attributes, "colorDepth") ? attributes.colorDepth : 32;
			
			var options = {
				
				alpha: (transparentBackground || colorDepth > 16) ? true : false,
				antialias: Reflect.hasField (attributes, "antialiasing") ? attributes.antialiasing > 0 : false,
				depth: true,
				premultipliedAlpha: true,
				stencil: true,
				preserveDrawingBuffer: false
				
			};
			
			__webgl = cast __canvas.getContextWebGL (options);
			
			if (__webgl != null) {
				
				#if webgl_debug
				__webgl = untyped WebGLDebugUtils.makeDebugContext (__webgl);
				#end
				
				// TODO: Need to handle renderer/context better
				
				// TODO
				
				// __renderContext = new GLRenderContext (cast __webgl);
				// GL.context = __renderContext;
				
				// context3D = new Context3D (stage, this);
				
				// var renderer:DOMRenderer = cast renderer;
				// renderer.element.appendChild (__canvas);
				
				// __style = __canvas.style;
				// __style.setProperty ("position", "absolute", null);
				// __style.setProperty ("top", "0", null);
				// __style.setProperty ("left", "0", null);
				// __style.setProperty (renderer.__transformOriginProperty, "0 0 0", null);
				// __style.setProperty ("z-index", "-1", null);
				
				// __dispatchCreate ();
				__dispatchError ();
				
			} else {
				
				__dispatchError ();
				
			}
			
			#end
			
		}
		
	}
	
	
	@:noCompletion private function __dispatchError ():Void {
		
		__contextRequested = false;
		dispatchEvent (new ErrorEvent (ErrorEvent.ERROR, false, false, "Context3D not available"));
		
	}
	
	
	@:noCompletion private function __dispatchCreate ():Void {
		
		if (__contextRequested) {
			
			__contextRequested = false;
			dispatchEvent (new Event (Event.CONTEXT3D_CREATE));
			
		}
		
	}
	
	
	@:noCompletion private function __resize (width:Int, height:Int):Void {
		
		if (width != __width || height != __height) {
			
			#if (js && html5)
			if (__canvas != null) {
				
				__canvas.width = width;
				__canvas.height = height;
				
			}
			#end
			
			__projectionTransform.copyRawDataFrom (Vector.ofArray ([
				2.0 / (width > 0 ? width : 1), 0.0, 0.0, 0.0,
				0.0, -2.0 / (height > 0 ? height : 1), 0.0, 0.0,
				0.0, 0.0, -2.0 / 2000, 0.0,
				-1.0, 1.0, 0.0, 1.0
			]));
			
			__renderTransform.identity ();
			__renderTransform.appendTranslation (__x, __y, 0);
			__renderTransform.append (__projectionTransform);
			
			__width = width;
			__height = height;
			
		}
		
	}
	
	
	@:noCompletion private function get_x ():Float {
		
		return __x;
		
	}
	
	
	@:noCompletion private function set_x (value:Float):Float {
		
		if (__x == value) return value;
		__x = value;
		__renderTransform.identity ();
		__renderTransform.appendTranslation (__x, __y, 0);
		__renderTransform.append (__projectionTransform);
		return value;
		
	}
	
	
	@:noCompletion private function get_y ():Float {
		
		return __y;
		
	}
	
	
	@:noCompletion private function set_y (value:Float):Float {
		
		if (__y == value) return value;
		__y = value;
		__renderTransform.identity ();
		__renderTransform.appendTranslation (__x, __y, 0);
		__renderTransform.append (__projectionTransform);
		return value;
		
	}
	
	
}


#else
typedef Stage3D = flash.display.Stage3D;
#end