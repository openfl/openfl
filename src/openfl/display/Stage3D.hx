package openfl.display;

#if !flash
import haxe.Timer;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix3D;
import openfl.Vector;
#if lime
import lime.graphics.RenderContext;
#end
#if (js && html5)
import js.html.webgl.RenderingContext;
import js.html.CanvasElement;
import js.html.CSSStyleDeclaration;
import js.Browser;
#end

/**
	The Stage class represents the main drawing area.
	For SWF content running in the browser (in Flash<sup>஼/sup> Player), the
	Stage represents the entire area where Flash content is shown. For content
	running in AIR on desktop operating systems, each NativeWindow object has
	a corresponding Stage object.

	The Stage object is not globally accessible. You need to access it through
	the `stage` property of a DisplayObject instance.

	The Stage class has several ancestor classes נDisplayObjectContainer,
	InteractiveObject, DisplayObject, and EventDispatcher נfrom which it
	inherits properties and methods. Many of these properties and methods are
	either inapplicable to Stage objects, or require security checks when
	called on a Stage object. The properties and methods that require security
	checks are documented as part of the Stage class.

	In addition, the following inherited properties are inapplicable to Stage
	objects. If you try to set them, an IllegalOperationError is thrown. These
	properties may always be read, but since they cannot be set, they will
	always contain default values.

	* `accessibilityProperties`
	* `alpha`
	* `blendMode`
	* `cacheAsBitmap`
	* `contextMenu`
	* `filters`
	* `focusRect`
	* `loaderInfo`
	* `mask`
	* `mouseEnabled`
	* `name`
	* `opaqueBackground`
	* `rotation`
	* `scale9Grid`
	* `scaleX`
	* `scaleY`
	* `scrollRect`
	* `tabEnabled`
	* `tabIndex`
	* `transform`
	* `visible`
	* `x`
	* `y`

	Some events that you might expect to be a part of the Stage class, such as
	`enterFrame`, `exitFrame`, `frameConstructed`, and `render`, cannot be
	Stage events because a reference to the Stage object cannot be guaranteed
	to exist in every situation where these events are used. Because these
	events cannot be dispatched by the Stage object, they are instead
	dispatched by every DisplayObject instance, which means that you can add
	an event listener to any DisplayObject instance to listen for these
	events. These events, which are part of the DisplayObject class, are
	called broadcast events to differentiate them from events that target a
	specific DisplayObject instance. Two other broadcast events, `activate`
	and `deactivate`, belong to DisplayObject's superclass, EventDispatcher.
	The `activate` and `deactivate` events behave similarly to the
	DisplayObject broadcast events, except that these two events are
	dispatched not only by all DisplayObject instances, but also by all
	EventDispatcher instances and instances of other EventDispatcher
	subclasses. For more information on broadcast events, see the
	DisplayObject class.

	@event fullScreen             Dispatched when the Stage object enters, or
								  leaves, full-screen mode. A change in
								  full-screen mode can be initiated through
								  ActionScript, or the user invoking a
								  keyboard shortcut, or if the current focus
								  leaves the full-screen window.
	@event mouseLeave             Dispatched by the Stage object when the
								  pointer moves out of the stage area. If the
								  mouse button is pressed, the event is not
								  dispatched.
	@event orientationChange      Dispatched by the Stage object when the
								  stage orientation changes.
								  Orientation changes can occur when the user
								  rotates the device, opens a slide-out
								  keyboard, or when the `setAspectRatio()` is
								  called.

								  **Note:** If the `autoOrients` property is
								  `false`, then the stage orientation does not
								  change when a device is rotated. Thus,
								  StageOrientationEvents are only dispatched
								  for device rotation when `autoOrients` is
								  `true`.
	@event orientationChanging    Dispatched by the Stage object when the
								  stage orientation begins changing.
								  **Important:** orientationChanging events
								  are not dispatched on Android devices.

								  **Note:** If the `autoOrients` property is
								  `false`, then the stage orientation does not
								  change when a device is rotated. Thus,
								  StageOrientationEvents are only dispatched
								  for device rotation when `autoOrients` is
								  `true`.
	@event resize                 Dispatched when the `scaleMode` property of
								  the Stage object is set to
								  `StageScaleMode.NO_SCALE` and the SWF file
								  is resized.
	@event stageVideoAvailability Dispatched by the Stage object when the
								  state of the stageVideos property changes.
**/
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
class Stage3D extends EventDispatcher
{
	@:noCompletion private static var __active:Bool;

	public var context3D(default, null):Context3D;
	public var visible:Bool;
	public var x(get, set):Float;
	public var y(get, set):Float;

	@:noCompletion private var __contextLost:Bool;
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
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(Stage3D.prototype,
			{
				"x": {get: untyped __js__("function () { return this.get_x (); }"), set: untyped __js__("function (v) { return this.set_x (v); }")},
				"y": {get: untyped __js__("function () { return this.get_y (); }"), set: untyped __js__("function (v) { return this.set_y (v); }")},
			});
	}
	#end

	@:noCompletion private function new(stage:Stage)
	{
		super();

		__stage = stage;

		__height = 0;
		__projectionTransform = new Matrix3D();
		__renderTransform = new Matrix3D();
		__width = 0;
		__x = 0;
		__y = 0;

		visible = true;

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

	@:noCompletion private function __createContext():Void
	{
		#if lime
		var stage = __stage;
		var renderer = stage.__renderer;

		if (renderer.__type == CAIRO || renderer.__type == CANVAS)
		{
			__dispatchError();
			return;
		}

		if (renderer.__type == OPENGL)
		{
			#if openfl_share_context
			context3D = stage.context3D;
			#else
			context3D = new Context3D(stage, stage.context3D.__contextState, this);
			#end
			__dispatchCreate();
		}
		else if (renderer.__type == DOM)
		{
			#if (js && html5)
			__canvas = cast Browser.document.createElement("canvas");
			__canvas.width = stage.stageWidth;
			__canvas.height = stage.stageHeight;

			var window = stage.window;
			var attributes = renderer.__context.attributes;

			var transparentBackground = Reflect.hasField(attributes, "background") && attributes.background == null;
			var colorDepth = Reflect.hasField(attributes, "colorDepth") ? attributes.colorDepth : 32;

			var options =
				{
					alpha: (transparentBackground || colorDepth > 16) ? true : false,
					antialias: Reflect.hasField(attributes, "antialiasing") ? attributes.antialiasing > 0 : false,
					depth: true,
					premultipliedAlpha: true,
					stencil: true,
					preserveDrawingBuffer: false
				};

			__webgl = cast __canvas.getContextWebGL(options);

			if (__webgl != null)
			{
				#if webgl_debug
				__webgl = untyped WebGLDebugUtils.makeDebugContext(__webgl);
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
				__dispatchError();
			}
			else
			{
				__dispatchError();
			}
			#end
		}
		#end
	}

	@:noCompletion private function __dispatchError():Void
	{
		__contextRequested = false;
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Context3D not available"));
	}

	@:noCompletion private function __dispatchCreate():Void
	{
		if (__contextRequested)
		{
			__contextRequested = false;
			dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
		}
	}

	@:noCompletion private function __lostContext():Void
	{
		__contextLost = true;

		if (context3D != null)
		{
			context3D.__dispose();
			__contextRequested = true;
		}
	}

	@:noCompletion private function __resize(width:Int, height:Int):Void
	{
		if (width != __width || height != __height)
		{
			#if (js && html5)
			if (__canvas != null)
			{
				__canvas.width = width;
				__canvas.height = height;
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

	@:noCompletion private function __restoreContext():Void
	{
		__contextLost = false;
		__createContext();
	}

	@:noCompletion private function get_x():Float
	{
		return __x;
	}

	@:noCompletion private function set_x(value:Float):Float
	{
		if (__x == value) return value;
		__x = value;
		__renderTransform.identity();
		__renderTransform.appendTranslation(__x, __y, 0);
		__renderTransform.append(__projectionTransform);
		return value;
	}

	@:noCompletion private function get_y():Float
	{
		return __y;
	}

	@:noCompletion private function set_y(value:Float):Float
	{
		if (__y == value) return value;
		__y = value;
		__renderTransform.identity();
		__renderTransform.appendTranslation(__x, __y, 0);
		__renderTransform.append(__projectionTransform);
		return value;
	}
}
#else
typedef Stage3D = flash.display.Stage3D;
#end
