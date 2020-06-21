package openfl.display;

import haxe.Timer;
import openfl.display._internal.DisplayObjectRenderData;
import openfl.display3D.Context3D;
import openfl.display3D._Context3D;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events._EventDispatcher;
import openfl.geom.Matrix3D;
import openfl.Vector;
#if lime
import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
#elseif openfl_html5
import openfl._internal.backend.lime_standalone.RenderContext;
import openfl._internal.backend.lime_standalone.WebGLRenderContext in WebGLRenderingContext;
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
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.display.Stage)
@:noCompletion
class _Stage3D extends _EventDispatcher
{
	public static var __active:Bool;

	public var context3D:Context3D;
	public var visible:Bool;
	public var x(get, set):Float;
	public var y(get, set):Float;

	public var __contextLost:Bool;
	public var __contextRequested:Bool;
	public var __height:Int;
	public var __projectionTransform:Matrix3D;
	public var __renderData:DisplayObjectRenderData;
	public var __renderTransform:Matrix3D;
	public var __stage:Stage;
	public var __width:Int;
	public var __x:Float;
	public var __y:Float;
	#if openfl_html5
	public var __webgl:WebGLRenderContext;
	#end
	#if (lime || openfl_html5)
	public var __renderContext:RenderContext;
	#end

	private var stage3D:Stage3D;

	public function new(stage3D:Stage3D, stage:Stage)
	{
		this.stage3D = stage3D;

		super(stage3D);

		__stage = stage;

		__height = 0;
		__projectionTransform = new Matrix3D();
		__renderTransform = new Matrix3D();
		__width = 0;
		__x = 0;
		__y = 0;

		visible = true;
		__renderData = new DisplayObjectRenderData();

		if (stage.stageWidth > 0 && stage.stageHeight > 0)
		{
			__resize(stage.stageWidth, stage.stageHeight);
		}
	}

	public function requestContext3D(context3DRenderMode:Context3DRenderMode = AUTO, profile:Context3DProfile = BASELINE):Void
	{
		if (__contextLost)
		{
			__contextRequested = true;
			return;
		}

		if (context3D != null)
		{
			__contextRequested = true;
			Timer.delay(__dispatchCreate, 1);
		}
		else if (!__contextRequested)
		{
			__contextRequested = true;
			Timer.delay(__createContext, 1);
		}
	}

	public function requestContext3DMatchingProfiles(profiles:Vector<Context3DProfile>):Void
	{
		requestContext3D();
	}

	public function __createContext():Void
	{
		if (__stage.context3D != null)
		{
			#if openfl_share_context
			context3D = __stage.context3D;
			#else
			context3D = new Context3D(__stage, (__stage.context3D._ : _Context3D).__contextState, stage3D);
			#end
			__dispatchCreate();
		}
		#if (lime && openfl_html5)
		else if (false && __stage.limeWindow.context.type == DOM)
		{
			// TODO

			// __canvas = cast Browser.document.createElement("canvas");
			// __canvas.width = stage.stageWidth;
			// __canvas.height = stage.stageHeight;

			// var window = stage.limeWindow;
			// var attributes = @:privateAccess window._.__attributes;

			// var transparentBackground = Reflect.hasField(attributes, "background") && attributes.background == null;
			// var colorDepth = Reflect.hasField(attributes, "colorDepth") ? attributes.colorDepth : 32;

			// var options = {
			// 	alpha: (transparentBackground || colorDepth > 16) ? true : false,
			// 	antialias: Reflect.hasField(attributes, "antialiasing") ? attributes.antialiasing > 0 : false,
			// 	depth: true,
			// 	premultipliedAlpha: true,
			// 	stencil: true,
			// 	preserveDrawingBuffer: false
			// };

			// __webgl = cast __canvas.getContextWebGL(options);

			// if (__webgl != null)
			// {
			// 	#if webgl_debug
			// 	__webgl = untyped WebGLDebugUtils.makeDebugContext(__webgl);
			// 	#end

			// 	// TODO: Need to handle renderer/context better

			// 	// TODO

			// 	// __renderContext = new GLRenderContext (cast __webgl);
			// 	// GL.context = __renderContext;

			// 	// context3D = new Context3D (stage, this);

			// 	// var renderer:DOMRenderer = cast renderer;
			// 	// renderer.element.appendChild (__canvas);

			// 	// __style = __canvas.style;
			// 	// __style.setProperty ("position", "absolute", null);
			// 	// __style.setProperty ("top", "0", null);
			// 	// __style.setProperty ("left", "0", null);
			// 	// __style.setProperty (renderer._.__transformOriginProperty, "0 0 0", null);
			// 	// __style.setProperty ("z-index", "-1", null);

			// 	// __dispatchCreate ();
			// 	__dispatchError();
			// }
		}
		#end
	else
	{
		__dispatchError();
	}
	}

	public function __dispatchError():Void
	{
		__contextRequested = false;
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Context3D not available"));
	}

	public function __dispatchCreate():Void
	{
		if (__contextRequested)
		{
			__contextRequested = false;
			dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
		}
	}

	public function __lostContext():Void
	{
		__contextLost = true;

		if (context3D != null)
		{
			context3D.dispose();
			__contextRequested = true;
		}
	}

	public function __resize(width:Int, height:Int):Void
	{
		if (width != __width || height != __height)
		{
			#if openfl_html5
			if (__renderData.canvas != null)
			{
				__renderData.canvas.width = width;
				__renderData.canvas.height = height;
			}
			#end

			__projectionTransform.copyRawDataFrom(new Vector<Float>([
				2.0 / (width > 0 ? width : 1), 0.0, 0.0, 0.0, 0.0, -2.0 / (height > 0 ? height : 1), 0.0, 0.0, 0.0, 0.0, -2.0 / 2000, 0.0, -1.0, 1.0, 0.0, 1.0
			]));

			__renderTransform.identity();
			__renderTransform.appendTranslation(__x, __y, 0);
			__renderTransform.append(__projectionTransform);

			__width = width;
			__height = height;
		}
	}

	public function __restoreContext():Void
	{
		__contextLost = false;
		__createContext();
	}

	private function get_x():Float
	{
		return __x;
	}

	private function set_x(value:Float):Float
	{
		if (__x == value) return value;
		__x = value;
		__renderTransform.identity();
		__renderTransform.appendTranslation(__x, __y, 0);
		__renderTransform.append(__projectionTransform);
		return value;
	}

	private function get_y():Float
	{
		return __y;
	}

	private function set_y(value:Float):Float
	{
		if (__y == value) return value;
		__y = value;
		__renderTransform.identity();
		__renderTransform.appendTranslation(__x, __y, 0);
		__renderTransform.append(__projectionTransform);
		return value;
	}
}
