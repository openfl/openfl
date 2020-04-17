import DisplayObjectRenderData from "../_internal/renderer/DisplayObjectRenderData";
import * as internal from "../_internal/utils/InternalAccess";
import Stage from "../display/Stage";
import Context3D from "../display3D/Context3D";
import Context3DProfile from "../display3D/Context3DProfile";
import Context3DRenderMode from "../display3D/Context3DRenderMode";
import ErrorEvent from "../events/ErrorEvent";
import Event from "../events/Event";
import EventDispatcher from "../events/EventDispatcher";
import Matrix3D from "../geom/Matrix3D";
import Vector from "../Vector";

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
export default class Stage3D extends EventDispatcher
{
	protected static __active: boolean;

	/**
		Specifies whether this Stage3D object is visible.

		Use this property to temporarily hide a Stage3D object on the Stage. This property
		defaults to `true`.
	**/
	public visible: boolean;

	protected __context3D: Context3D;
	protected __contextLost: boolean;
	protected __contextRequested: boolean;
	protected __height: number;
	protected __projectionTransform: Matrix3D;
	protected __renderData: DisplayObjectRenderData;
	protected __renderTransform: Matrix3D;
	protected __stage: Stage;
	protected __width: number;
	protected __x: number;
	protected __y: number;
	protected __webgl: WebGLRenderingContext;

	protected constructor(stage: Stage)
	{
		super();

		this.__stage = stage;

		this.__height = 0;
		this.__projectionTransform = new Matrix3D();
		this.__renderTransform = new Matrix3D();
		this.__width = 0;
		this.__x = 0;
		this.__y = 0;

		this.visible = true;
		this.__renderData = new DisplayObjectRenderData();

		if (stage.stageWidth > 0 && stage.stageHeight > 0)
		{
			this.__resize(stage.stageWidth, stage.stageHeight);
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
	public requestContext3D(context3DRenderMode: Context3DRenderMode = Context3DRenderMode.AUTO, profile: Context3DProfile = Context3DProfile.BASELINE): void
	{
		if (this.__contextLost)
		{
			this.__contextRequested = true;
			return;
		}

		if (this.__context3D != null)
		{
			this.__contextRequested = true;
			setTimeout(this.__dispatchCreate, 1);
		}
		else if (!this.__contextRequested)
		{
			this.__contextRequested = true;
			setTimeout(this.__createContext, 1);
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
			stage3D.requestContext3DMatchingProfiles(Vector.<string>([Context3DProfile.BASELINE, Context3DProfile.BASELINE_EXTENDED]));
		}

		function myContext3DHandler ( event : Event ) : void
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
	public requestContext3DMatchingProfiles(profiles: Vector<Context3DProfile>): void
	{
		this.requestContext3D();
	}

	protected __createContext(): void
	{
		if (this.__stage.context3D != null)
		{
			// #if openfl_share_context
			// context3D = __stage.context3D;
			// #else
			this.__context3D = new (<internal.Context3D><any>Context3D)(this.__stage, (<internal.Context3D><any>this.__stage.context3D).__contextState, this);
			this.__dispatchCreate();
		}
		else if (false /*&& __stage.limeWindow.context.type == DOM*/)
		{
			// TODO

			// __canvas = cast Browser.document.createElement("canvas");
			// __canvas.width = stage.stageWidth;
			// __canvas.height = stage.stageHeight;

			// window = stage.limeWindow;
			// attributes = @:privateAccess window.__attributes;

			// transparentBackground = Reflect.hasField(attributes, "background") && attributes.background == null;
			// colorDepth = Reflect.hasField(attributes, "colorDepth") ? attributes.colorDepth : 32;

			// options = {
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

			// 	// renderer:DOMRenderer = cast renderer;
			// 	// renderer.element.appendChild (__canvas);

			// 	// __style = __canvas.style;
			// 	// __style.setProperty ("position", "absolute", null);
			// 	// __style.setProperty ("top", "0", null);
			// 	// __style.setProperty ("left", "0", null);
			// 	// __style.setProperty (renderer.__transformOriginProperty, "0 0 0", null);
			// 	// __style.setProperty ("z-index", "-1", null);

			// 	// __dispatchCreate ();
			// 	__dispatchError();
			// }
		}
		else
		{
			this.__dispatchError();
		}
	}

	protected __dispatchError(): void
	{
		this.__contextRequested = false;
		this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Context3D not available"));
	}

	protected __dispatchCreate(): void
	{
		if (this.__contextRequested)
		{
			this.__contextRequested = false;
			this.dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
		}
	}

	protected __lostContext(): void
	{
		this.__contextLost = true;

		if (this.__context3D != null)
		{
			this.__context3D.dispose();
			this.__contextRequested = true;
		}
	}

	protected __resize(width: number, height: number): void
	{
		if (width != this.__width || height != this.__height)
		{
			if (this.__renderData.canvas != null)
			{
				this.__renderData.canvas.width = width;
				this.__renderData.canvas.height = height;
			}

			this.__projectionTransform.copyRawDataFrom(Vector.ofArray([
				2.0 / (width > 0 ? width : 1), 0.0, 0.0, 0.0, 0.0, -2.0 / (height > 0 ? height : 1), 0.0, 0.0, 0.0, 0.0, -2.0 / 2000, 0.0, -1.0, 1.0, 0.0, 1.0
			]));

			this.__renderTransform.identity();
			this.__renderTransform.appendTranslation(this.__x, this.__y, 0);
			this.__renderTransform.append(this.__projectionTransform);

			this.__width = width;
			this.__height = height;
		}
	}

	protected __restoreContext(): void
	{
		this.__contextLost = false;
		this.__createContext();
	}

	// Get & Set Methods

	/**
		The Context3D object associated with this Stage3D instance.

		This property is initially `null`. To create the Context3D instance for this
		Stage3D object, add an event listener for the `context3DCreate` event and then call
		the `requestContext3D` method. The listener is called once the Context3D object has
		been created.
	**/
	public get context3D(): Context3D
	{
		return this.__context3D;
	}

	/**
		The horizontal coordinate of the Stage3D display on the stage, in pixels.

		This property defaults to zero.
	**/
	public get x(): number
	{
		return this.__x;
	}

	public set x(value: number)
	{
		if (this.__x != value)
		{
			this.__x = value;
			this.__renderTransform.identity();
			this.__renderTransform.appendTranslation(this.__x, this.__y, 0);
			this.__renderTransform.append(this.__projectionTransform);
		}
	}

	/**
		The vertical coordinate of the Stage3D display on the stage, in pixels.

		This property defaults to zero.
	**/
	public get y(): number
	{
		return this.__y;
	}

	public set y(value: number)
	{
		if (this.__y == value)
		{
			this.__y = value;
			this.__renderTransform.identity();
			this.__renderTransform.appendTranslation(this.__x, this.__y, 0);
			this.__renderTransform.append(this.__projectionTransform);
		}
	}
}
