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
import lime.graphics.opengl.GL;
import lime.graphics.RenderContext;
#end
#if (js && html5)
import js.html.webgl.RenderingContext;
import js.html.CanvasElement;
import js.html.CSSStyleDeclaration;
import js.Browser;
#end

/**
	The Stage3D class provides a display area and a programmable rendering
	context for drawing 2D and 3D graphics.

	Stage3D provides a high-performance rendering surface for content rendered
	using the `Context3D` class. This surface uses the graphics processing unit
	(GPU) when possible. The runtime stage provides a fixed number of `Stage3D`
	objects. The number of instances varies by the type of device. Desktop
	computers typically provide four Stage3D instances.

	Content drawn to the `Stage3D` viewport is composited with other visible
	graphics objects in a predefined order. The most distant are all
	`StageVideo` surfaces. `Stage3D` comes next, with traditional Flash display
	object content being rendered last, on top of all others. StageVideo and
	Stage3D layers are rendered with no transparency; thus a viewport completely
	obscures any other Stage3D or StageVideo viewports positioned underneath it.
	Display list content is rendered with transparency.

	**Note:** You can use the `visible` property of a Stage3D object to remove
	it from the display temporarily, such as when playing a video using the
	StageVideo class.

	A `Stage3D` object is retrieved from the Player stage using its `stage3Ds`
	member. Use the Stage3D instance to request an associated rendering context
	and to position the display on the runtime stage.

	@event context3DCreate      Dispatched when a rendering context is created.
	@event error             	Dispatched when a request for a rendering
								context fails.

	@see `openfl.display.Stage`
	@see `openfl.display3D.Context3D`
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

	/**
		The Context3D object associated with this Stage3D instance.

		This property is initially `null`. To create the Context3D instance for this
		Stage3D object, add an event listener for the `context3DCreate` event and then call
		the `requestContext3D` method. The listener is called once the Context3D object has
		been created.
	**/
	public var context3D(default, null):Context3D;

	/**
		Specifies whether this Stage3D object is visible.

		Use this property to temporarily hide a Stage3D object on the Stage. This property
		defaults to `true`.
	**/
	public var visible:Bool;

	/**
		The horizontal coordinate of the Stage3D display on the stage, in pixels.

		This property defaults to zero.
	**/
	public var x(get, set):Float;

	/**
		The vertical coordinate of the Stage3D display on the stage, in pixels.

		This property defaults to zero.
	**/
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
		untyped Object.defineProperties(Stage3D.prototype, {
			"x": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_x (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_x (v); }")
			},
			"y": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_y (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_y (v); }")
			},
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

	/**
		Request the creation of a Context3D object for this Stage3D instance.

		Before calling this function, add an event listener for the `context3DCreate`
		event. If you do not, the runtime throws an exception.

		**Important note on device loss:**
		GPU device loss occurs when the GPU hardware becomes unavailable to the application.
		The Context3D object is disposed when the GPU device is lost. GPU device loss can
		happen for various reasons, such as, when a mobile device runs out of battery power
		or a Windows device goes to a "lock screen." When the GPU becomes available again,
		the runtime creates a new Context3D instance and dispatches another
		`context3DCreate` event. Your application must reload all assets and reset the
		rendering context state whenever device loss occurs.

		Design your application logic to handle the possibility of device loss and context
		regeneration. Do not remove the `context3DCreate` event listener. Do not perform
		actions in response to the event that should not be repeated in the application.
		For example, do not add anonymous functions to handle timer events because they
		would be duplicated after device loss. To test your application's handling of
		device loss, you can simulate device loss by calling the `dispose()` method of the
		Context3D object.

		The following example illustrates how to request a Context3d rendering context:

		```haxe
		if( stage.stage3Ds.length > 0 )
		{
			var stage3D:Stage3D = stage.stage3Ds[0];
			stage3D.addEventListener( Event.CONTEXT3D_CREATE, myContext3DHandler );
			stage3D.requestContext3D( );
		}

		function myContext3DHandler ( event : Event ) : void
		{
			var targetStage3D : Stage3D = cast event.target;
			InitAll3DResources( targetStage3D.context3D );
			StartRendering( targetStage3D.context3D );
		}
		```

		@param	context3DRenderMode	The type of rendering context to request. The default
		is `Context3DRenderMode.AUTO` for which the runtime will create a
		hardware-accelerated context if possible and fall back to software otherwise. Use
		`Context3DRenderMode.SOFTWARE` to request a software rendering context. Software
		rendering is not available on mobile devices. Software rendering is available only
		for `Context3DProfile.BASELINE` and `Context3DProfile.BASELINE_CONSTRAINED`.
		@param	profile	(AIR 3.4 and higher) Specifies the extent to which Flash Player
		supports lower-level GPUs. The default is `Context3DProfile.BASELINE`, which
		returns a Context3D instance similar to that used in previous releases. To get
		details of all available profiles, see openfl.display3D.Context3DProfile.
		@event	context3DCreate	Dispatched when the requested rendering context is
		successfully completed.
		@event	error	Dispatched when the requested rendering context cannot be created.
		@throws	Error	if no listeners for the `context3DCreate` event have been added to
		this Stage3D object.
		@throws	ArgumentError	if this method is called again with a different
		`context3DRenderMode` before the previous call has completed.
	**/
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

	/**
		Request the creation of a Context3D object for this Stage3D instance.

		Before calling this function, add an event listener for the `context3DCreate`
		event. If you do not, the runtime throws an exception.

		**Important note on device loss:**
		GPU device loss occurs when the GPU hardware becomes unavailable to the
		application. The Context3D object is disposed when the GPU device is lost. GPU
		device loss can happen for various reasons, such as, when a mobile device runs out
		of battery power or a Windows device goes to a "lock screen." When the GPU becomes
		available again, the runtime creates a new Context3D instance and dispatches
		another `context3DCreate` event. Your application must reload all assets and reset
		the rendering context state whenever device loss occurs.

		Design your application logic to handle the possibility of device loss and context
		regeneration. Do not remove the `context3DCreate` event listener. Do not perform
		actions in response to the event that should not be repeated in the application.
		For example, do not add anonymous functions to handle timer events because they
		would be duplicated after device loss. To test your application's handling of
		device loss, you can simulate device loss by calling the `dispose()` method of the
		Context3D object.

		The following example illustrates how to request a Context3d rendering context:

		```haxe
		if( stage.stage3Ds.length > 0 )
		{
			var stage3D:Stage3D = stage.stage3Ds[0];
			stage3D.addEventListener( Event.CONTEXT3D_CREATE, myContext3DHandler );
			stage3D.requestContext3DMatchingProfiles(Vector.ofValues(Context3DProfile.BASELINE, Context3DProfile.BASELINE_EXTENDED));
		}

		function myContext3DHandler ( event : Event ) : Void
		{
			var targetStage3D : Stage3D = cast event.target;
			if(targetStage3D.context3D.profile.localeCompare(Context3DProfile.BASELINE) == 0)
			{
				InitAll3DResources( targetStage3D.context3D );
			}
			StartRendering( targetStage3D.context3D );
		}
		```

		@param	profiles	(AIR 3.4 and higher) a profile arrays that developer want to
		use in their flash program. When developer pass profile array to
		`Stage3D.requestContext3DMatchingProfiles`, he will get a Context3D based on the
		high level profile in that array according to their hardware capability. The
		`rendermode` is set to AUTO, so the parameter is omitted.
		@event	context3DCreate	Dispatched when the requested rendering context is
		successfully completed.
		@event	error	Dispatched when the requested rendering context cannot be created.
		If the hardware is not available, it will not create a software context3d.
		@throws	Error	if no listeners for the context3DCreate event have been added to
		this Stage3D object.
		@throws	ArgumentError	if this method is called before the previous call has
		completed.
		@throws	ArgumentError	if the item in array is not openfl.display3D.Context3DProfile.
	**/
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
			// TODO: Do not set Stage.context3D, create separate canvas elements for each Context3D

			#if (js && html5)
			if (stage.context3D == null)
			{
				__canvas = cast Browser.document.createElement("canvas");
				__canvas.width = stage.stageWidth;
				__canvas.height = stage.stageHeight;

				var window = stage.window;
				var attributes = stage.window.context.attributes;

				var transparentBackground = Reflect.hasField(attributes, "background") && attributes.background == null;
				var colorDepth = Reflect.hasField(attributes, "colorDepth") ? attributes.colorDepth : 32;

				var options = {
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

					if (GL.context == null)
					{
						GL.context = cast __webgl;
						GL.type = WEBGL;
						// GL.version = isWebGL2 ? 2 : 1;
						GL.version = 1;
						// stage.window.context.webgl = GL.context;
					}

					stage.context3D = new Context3D(stage);
					stage.context3D.configureBackBuffer(stage.window.width, stage.window.height, 0, true, true, true);
					stage.context3D.present();

					var renderer:DOMRenderer = cast renderer;
					renderer.element.appendChild(__canvas);

					__style = __canvas.style;
					__style.setProperty("position", "absolute", null);
					__style.setProperty("top", "0", null);
					__style.setProperty("left", "0", null);
					__style.setProperty(renderer.__transformOriginProperty, "0 0 0", null);
					__style.setProperty("z-index", "-1", null);
				}

				if (stage.context3D != null)
				{
					#if openfl_share_context
					context3D = stage.context3D;
					#else
					context3D = new Context3D(stage, stage.context3D.__contextState, this);
					#end
				}

				__dispatchCreate();
				// __dispatchError();
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
				2.0 / (width > 0 ? width : 1),
				0.0,
				0.0,
				0.0,
				0.0,
				-2.0 / (height > 0 ? height : 1),
				0.0,
				0.0,
				0.0,
				0.0,
				-2.0 / 2000,
				0.0,
				-1.0,
				1.0,
				0.0,
				1.0
			]));

			var pixelRatio = __stage.window.scale;
			__renderTransform.identity();
			__renderTransform.appendTranslation(__x * pixelRatio, __y * pixelRatio, 0);
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
		var pixelRatio = __stage.window.scale;
		__renderTransform.identity();
		__renderTransform.appendTranslation(__x * pixelRatio, __y * pixelRatio, 0);
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
		var pixelRatio = __stage.window.scale;
		__renderTransform.identity();
		__renderTransform.appendTranslation(__x * pixelRatio, __y * pixelRatio, 0);
		__renderTransform.append(__projectionTransform);
		return value;
	}
}
#else
typedef Stage3D = flash.display.Stage3D;
#end
