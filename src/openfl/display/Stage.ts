import * as internal from "../_internal/utils/InternalAccess";
import TouchData from "../_internal/utils/TouchData";
import BitmapData from "../display/BitmapData";
import DisplayObject from "../display/DisplayObject";
import DisplayObjectContainer from "../display/DisplayObjectContainer";
import DisplayObjectRenderer from "../display/DisplayObjectRenderer";
import InteractiveObject from "../display/InteractiveObject";
import Sprite from "../display/Sprite";
import Stage3D from "../display/Stage3D";
import StageAlign from "../display/StageAlign";
import StageDisplayState from "../display/StageDisplayState";
import StageQuality from "../display/StageQuality";
import StageScaleMode from "../display/StageScaleMode";
import Context3D from "../display3D/Context3D";
import IllegalOperationError from "../errors/IllegalOperationError";
import Event from "../events/Event";
import EventDispatcher from "../events/EventDispatcher";
import EventPhase from "../events/EventPhase";
import FocusEvent from "../events/FocusEvent";
import KeyboardEvent from "../events/KeyboardEvent";
import MouseEvent from "../events/MouseEvent";
import TouchEvent from "../events/TouchEvent";
import UncaughtErrorEvent from "../events/UncaughtErrorEvent";
import Matrix from "../geom/Matrix";
import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";
import Transform from "../geom/Transform";
import Keyboard from "../ui/Keyboard";
import Mouse from "../ui/Mouse";
import MouseCursor from "../ui/MouseCursor";
import Lib from "../Lib";
import Vector from "../Vector";

/**
	The Stage class represents the main drawing area.

	For SWF content running in the browser(in Flash<sup>®</sup> Player),
	the Stage represents the entire area where Flash content is shown. For
	content running in AIR on desktop operating systems, each NativeWindow
	object has a corresponding Stage object.

	The Stage object is not globally accessible. You need to access it
	through the `stage` property of a DisplayObject instance.

	The Stage class has several ancestor classes  -  DisplayObjectContainer,
	InteractiveObject, DisplayObject, and EventDispatcher  -  from which it
	inherits properties and methods. Many of these properties and methods are
	either inapplicable to Stage objects, or require security checks when
	called on a Stage object. The properties and methods that require security
	checks are documented as part of the Stage class.

	In addition, the following inherited properties are inapplicable to
	Stage objects. If you try to set them, an IllegalOperationError is thrown.
	These properties may always be read, but since they cannot be set, they
	will always contain default values.


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


	Some events that you might expect to be a part of the Stage class, such
	as `enterFrame`, `exitFrame`,
	`frameConstructed`, and `render`, cannot be Stage
	events because a reference to the Stage object cannot be guaranteed to
	exist in every situation where these events are used. Because these events
	cannot be dispatched by the Stage object, they are instead dispatched by
	every DisplayObject instance, which means that you can add an event
	listener to any DisplayObject instance to listen for these events. These
	events, which are part of the DisplayObject class, are called broadcast
	events to differentiate them from events that target a specific
	DisplayObject instance. Two other broadcast events, `activate`
	and `deactivate`, belong to DisplayObject's superclass,
	EventDispatcher. The `activate` and `deactivate`
	events behave similarly to the DisplayObject broadcast events, except that
	these two events are dispatched not only by all DisplayObject instances,
	but also by all EventDispatcher instances and instances of other
	EventDispatcher subclasses. For more information on broadcast events, see
	the DisplayObject class.

	@event fullScreen             Dispatched when the Stage object enters, or
								  leaves, full-screen mode. A change in
								  full-screen mode can be initiated through
								  ActionScript, or the user invoking a keyboard
								  shortcut, or if the current focus leaves the
								  full-screen window.
	@event mouseLeave             Dispatched by the Stage object when the
								  pointer moves out of the stage area. If the
								  mouse button is pressed, the event is not
								  dispatched.
	@event orientationChange      Dispatched by the Stage object when the stage
								  orientation changes.

								  Orientation changes can occur when the
								  user rotates the device, opens a slide-out
								  keyboard, or when the
								  `setAspectRatio()` is called.

								  **Note:** If the
								  `autoOrients` property is
								  `false`, then the stage
								  orientation does not change when a device is
								  rotated. Thus, StageOrientationEvents are
								  only dispatched for device rotation when
								  `autoOrients` is
								  `true`.
	@event orientationChanging    Dispatched by the Stage object when the stage
								  orientation begins changing.

								  **Important:** orientationChanging
								  events are not dispatched on Android
								  devices.

								  **Note:** If the
								  `autoOrients` property is
								  `false`, then the stage
								  orientation does not change when a device is
								  rotated. Thus, StageOrientationEvents are
								  only dispatched for device rotation when
								  `autoOrients` is
								  `true`.
	@event resize                 Dispatched when the `scaleMode`
								  property of the Stage object is set to
								  `StageScaleMode.NO_SCALE` and the
								  SWF file is resized.
	@event stageVideoAvailability Dispatched by the Stage object when the state
								  of the stageVideos property changes.
**/
export default class Stage extends DisplayObjectContainer
{
	/**
		A value from the StageAlign class that specifies the alignment of the
		stage in Flash Player or the browser. The following are valid values:

		The `align` property is only available to an object that is
		in the same security sandbox as the Stage owner(the main SWF file). To
		avoid this, the Stage owner can grant permission to the domain of the
		calling object by calling the `Security.allowDomain()` method
		or the `Security.alowInsecureDomain()` method. For more
		information, see the "Security" chapter in the _ActionScript 3.0
		Developer's Guide_.
	**/
	public align: StageAlign;

	// /** @hidden */ @:dox(hide) @:require(flash15) public browserZoomFactor (default, null):Float;

	/**
		Controls Flash runtime color correction for displays. Color correction
		works only if the main monitor is assigned a valid ICC color profile,
		which specifies the device's particular color attributes. By default,
		the Flash runtime tries to match the color correction of its host
		(usually a browser).
		Use the `Stage.colorCorrectionSupport` property to determine if color
		correction is available on the current system and the default state. .
		If color correction is available, all colors on the stage are assumed
		to be in the sRGB color space, which is the most standard color space.
		Source profiles of input devices are not considered during color
		correction. No input color correction is applied; only the stage
		output is mapped to the main monitor's ICC color profile.

		In general, the benefits of activating color management include
		predictable and consistent color, better conversion, accurate proofing
		and more efficient cross-media output. Be aware, though, that color
		management does not provide perfect conversions due to devices having
		a different gamut from each other or original images. Nor does color
		management eliminate the need for custom or edited profiles. Color
		profiles are dependent on browsers, operating systems (OS), OS
		extensions, output devices, and application support.

		Applying color correction degrades the Flash runtime performance. A
		Flash runtime's color correction is document style color correction
		because all SWF movies are considered documents with implicit sRGB
		profiles. Use the `Stage.colorCorrectionSupport` property to tell the
		Flash runtime to correct colors when displaying the SWF file
		(document) to the display color space. Flash runtimes only compensates
		for differences between monitors, not for differences between input
		devices (camera/scanner/etc.).

		The three possible values are strings with corresponding constants in
		the openfl.display.ColorCorrection class:

		* `"default"`: Use the same color correction as the host system.
		* `"on"`: Always perform color correction.
		* `"off"`: Never perform color correction.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10) public colorCorrection:openfl.display.ColorCorrection;

	/**
		Specifies whether the Flash runtime is running on an operating system
		that supports color correction and whether the color profile of the
		main (primary) monitor can be read and understood by the Flash
		runtime. This property also returns the default state of color
		correction on the host system (usually the browser). Currently the
		return values can be:
		The three possible values are strings with corresponding constants in
		the openfl.display.ColorCorrectionSupport class:

		* `"unsupported"`: Color correction is not available.
		* `"defaultOn"`: Always performs color correction.
		* `"defaultOff"`: Never performs color correction.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10) public colorCorrectionSupport (default, null):openfl.display.ColorCorrectionSupport;

	// /** @hidden */ @:dox(hide) @:require(flash11) public displayContextInfo (default, null):String;

	/**
		The parent HTML element where this Stage is embedded.
	**/
	public element: HTMLElement;

	// /** @hidden */ @:dox(hide) @:require(flash11_2) public mouseLock:Bool;

	/**
		Specifies whether to show or hide the default items in the Flash
		runtime context menu.
		If the `showDefaultContextMenu` property is set to `true` (the
		default), all context menu items appear. If the
		`showDefaultContextMenu` property is set to `false`, only the Settings
		and About... menu items appear.

		@throws SecurityError Calling the `showDefaultContextMenu` property of
							  a Stage object throws an exception for any
							  caller that is not in the same security sandbox
							  as the Stage owner (the main SWF file). To avoid
							  this, the Stage owner can grant permission to
							  the domain of the caller by calling the
							  `Security.allowDomain()` method or the
							  `Security.allowInsecureDomain()` method. For
							  more information, see the "Security" chapter in
							  the _ActionScript 3.0 Developer's Guide_.
	**/
	public showDefaultContextMenu: boolean;

	/**
		The area of the stage that is currently covered by the software
		keyboard.
		The area has a size of zero (0,0,0,0) when the soft keyboard is not
		visible.

		When the keyboard opens, the `softKeyboardRect` is set at the time the
		softKeyboardActivate event is dispatched. If the keyboard changes size
		while open, the runtime updates the `softKeyboardRect` property and
		dispatches an additional softKeyboardActivate event.

		**Note:** On Android, the area covered by the keyboard is estimated
		when the operating system does not provide the information necessary
		to determine the exact area. This problem occurs in fullscreen mode
		and also when the keyboard opens in response to an InteractiveObject
		receiving focus or invoking the `requestSoftKeyboard()` method.
	**/
	public softKeyboardRect: Rectangle;

	/**
		Specifies whether or not objects display a glowing border when they have
		focus.

		@throws SecurityError Calling the `stageFocusRect` property of
							  a Stage object throws an exception for any caller
							  that is not in the same security sandbox as the
							  Stage owner(the main SWF file). To avoid this, the
							  Stage owner can grant permission to the domain of
							  the caller by calling the
							  `Security.allowDomain()` method or the
							  `Security.allowInsecureDomain()` method.
							  For more information, see the "Security" chapter in
							  the _ActionScript 3.0 Developer's Guide_.
	**/
	public stageFocusRect: boolean;

	/**
		A list of StageVideo objects available for playing external videos.
		You can use only a limited number of StageVideo objects at a time.
		When a SWF begins to run, the number of available StageVideo objects
		depends on the platform and on available hardware.

		To use a StageVideo object, assign a member of the `stageVideos`
		Vector object to a StageVideo variable.

		All StageVideo objects are displayed on the stage behind any display
		objects. The StageVideo objects are displayed on the stage in the
		order they appear in the `stageVideos` Vector object. For example, if
		the `stageVideos` Vector object contains three entries:

		1. The StageVideo object in the 0 index of the `stageVideos` Vector
		object is displayed behind all StageVideo objects.
		2. The StageVideo object at index 1 is displayed in front of the
		StageVideo object at index 0.
		3. The StageVideo object at index 2 is displayed in front of the
		StageVideo object at index 1.

		Use the `StageVideo.depth` property to change this ordering.

		**Note:** AIR for TV devices support only one StageVideo object.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10_2) public stageVideos (default, null):Vector<openfl.media.StageVideo>;

	/**
		Indicates whether GPU compositing is available and in use. The
		`wmodeGPU` value is `true` _only_ when all three of the following
		conditions exist:
		* GPU compositing has been requested.
		* GPU compositing is available.
		* GPU compositing is in use.

		Specifically, the `wmodeGPU` property indicates one of the following:

		1. GPU compositing has not been requested or is unavailable. In this
		case, the `wmodeGPU` property value is `false`.
		2. GPU compositing has been requested (if applicable and available),
		but the environment is operating in "fallback mode" (not optimal
		rendering) due to limitations of the content. In this case, the
		`wmodeGPU` property value is `true`.
		3. GPU compositing has been requested (if applicable and available),
		and the environment is operating in the best mode. In this case, the
		`wmodeGPU` property value is also `true`.

		In other words, the `wmodeGPU` property identifies the capability and
		state of the rendering environment. For runtimes that do not support
		GPU compositing, such as AIR 1.5.2, the value is always `false`,
		because (as stated above) the value is `true` only when GPU
		compositing has been requested, is available, and is in use.

		The `wmodeGPU` property is useful to determine, at runtime, whether or
		not GPU compositing is in use. The value of `wmodeGPU` indicates if
		your content is going to be scaled by hardware, or not, so you can
		present graphics at the correct size. You can also determine if you're
		rendering in a fast path or not, so that you can adjust your content
		complexity accordingly.

		For Flash Player in a browser, GPU compositing can be requested by the
		value of `gpu` for the `wmode` HTML parameter in the page hosting the
		SWF file. For other configurations, GPU compositing can be requested
		in the header of a SWF file (set using SWF authoring tools).

		However, the `wmodeGPU` property does not identify the current
		rendering performance. Even if GPU compositing is "in use" the
		rendering process might not be operating in the best mode. To adjust
		your content for optimal rendering, use a Flash runtime debugger
		version, and set the `DisplayGPUBlendsetting` in your mm.cfg file.

		**Note:** This property is always `false` when referenced from
		ActionScript that runs before the runtime performs its first rendering
		pass. For example, if you examine `wmodeGPU` from a script in Frame 1
		of Adobe Flash Professional, and your SWF file is the first SWF file
		loaded in a new instance of the runtime, then the `wmodeGPU` value is
		`false`. To get an accurate value, wait until at least one rendering
		pass has occurred. If you write an event listener for the `exitFrame`
		event of any `DisplayObject`, the `wmodeGPU` value at is the correct
		value.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10_1) public wmodeGPU (default, null):Bool;

	protected __allowsFullScreen: boolean;
	protected __allowsFullScreenInteractive: boolean;
	protected __cacheFocus: InteractiveObject;
	protected __clearBeforeRender: boolean;
	protected __color: number;
	protected __colorSplit: Array<number>;
	protected __colorString: string;
	protected __contentsScaleFactor: number;
	protected __context3D: Context3D;
	protected __currentTabOrderIndex: number;
	protected __deltaTime: number;
	protected __dirty: boolean;
	protected __displayMatrix: Matrix;
	protected __displayRect: Rectangle;
	protected __displayState: StageDisplayState;
	protected __dragBounds: Rectangle;
	protected __dragObject: Sprite;
	protected __dragOffsetX: number;
	protected __dragOffsetY: number;
	protected __focus: InteractiveObject;
	protected __forceRender: boolean;
	protected __fullscreen: boolean;
	protected __fullScreenSourceRect: Rectangle;
	protected __invalidated: boolean;
	protected __lastClickTime: number;
	protected __logicalWidth: number;
	protected __logicalHeight: number;
	protected __mouseDownLeft: InteractiveObject;
	protected __mouseDownMiddle: InteractiveObject;
	protected __mouseDownRight: InteractiveObject;
	protected __mouseOutStack: Array<DisplayObject>;
	protected __mouseOverTarget: InteractiveObject;
	protected __mouseX: number;
	protected __mouseY: number;
	protected __pendingMouseEvent: boolean;
	protected __pendingMouseX: number;
	protected __pendingMouseY: number;
	protected __primaryTouchID: null | number;
	protected __quality: StageQuality;
	protected __renderer: DisplayObjectRenderer;
	protected __rendering: boolean;
	protected __rollOutStack: Array<DisplayObject>;
	protected __scaleMode: StageScaleMode;
	protected __stack: Array<DisplayObject>;
	protected __stage3Ds: Vector<Stage3D>;
	protected __stageHeight: number;
	protected __stageWidth: number;
	protected __touchData: Map<number, TouchData>;
	protected __transparent: boolean;
	protected __wasDirty: boolean;
	protected __wasFullscreen: boolean;

	public constructor(width: number = 0, height: number = 0, color: null | number = null,
		documentClass: Object = null, windowAttributes: Object = null)
	{
		// 	#if hxtelemetry
		// Telemetry.__initialize();
		// 	#end

		super();

		this.name = null;

		this.__color = 0xFFFFFFFF;
		this.__colorSplit = [0xFF, 0xFF, 0xFF];
		this.__colorString = "#FFFFFF";
		this.__contentsScaleFactor = 1;
		this.__currentTabOrderIndex = 0;
		this.__deltaTime = 0;
		this.__displayState = StageDisplayState.NORMAL;
		this.__mouseX = 0;
		this.__mouseY = 0;
		this.__lastClickTime = 0;
		this.__logicalWidth = 0;
		this.__logicalHeight = 0;
		this.__displayMatrix = new Matrix();
		this.__displayRect = new Rectangle();
		this.__renderDirty = true;

		this.__stage3Ds = new Vector();
		for (let i = 0; i < 4; i++)
		{
			this.__stage3Ds.push(new (<internal.Stage3D><any>Stage3D)(this));
		}

		this.__stage = this;

		this.align = StageAlign.TOP_LEFT;
		this.__allowsFullScreen = true;
		this.__allowsFullScreenInteractive = true;
		this.__quality = StageQuality.HIGH;
		this.__scaleMode = StageScaleMode.NO_SCALE;
		this.showDefaultContextMenu = true;
		this.softKeyboardRect = new Rectangle();
		this.stageFocusRect = true;

		this.__clearBeforeRender = true;
		this.__forceRender = false;
		this.__stack = [];
		this.__rollOutStack = [];
		this.__mouseOutStack = [];
		this.__touchData = new Map<number, TouchData>();

		// __backend = new StageBackend(this, width, height, color, documentClass, windowAttributes);
	}

	/**
		Calling the `invalidate()` method signals Flash runtimes to
		alert display objects on the next opportunity it has to render the display
		list(for example, when the playhead advances to a new frame). After you
		call the `invalidate()` method, when the display list is next
		rendered, the Flash runtime sends a `render` event to each
		display object that has registered to listen for the `render`
		event. You must call the `invalidate()` method each time you
		want the Flash runtime to send `render` events.

		The `render` event gives you an opportunity to make changes
		to the display list immediately before it is actually rendered. This lets
		you defer updates to the display list until the latest opportunity. This
		can increase performance by eliminating unnecessary screen updates.

		The `render` event is dispatched only to display objects
		that are in the same security domain as the code that calls the
		`stage.invalidate()` method, or to display objects from a
		security domain that has been granted permission via the
		`Security.allowDomain()` method.

	**/
	public invalidate(): void
	{
		this.__invalidated = true;

		// TODO: Should this not mark as dirty?
		this.__renderDirty = true;
	}

	// /** @hidden */ @:dox(hide) public isFocusInaccessible ():Bool;
	public localToGlobal(pos: Point): Point
	{
		return pos.clone();
	}

	protected __broadcastEvent(event: Event): void
	{
		if ((<internal.DisplayObject><any>DisplayObject).__broadcastEvents.has(event.type))
		{
			var dispatchers = (<internal.DisplayObject><any>DisplayObject).__broadcastEvents.get(event.type);

			for (let dispatcher of dispatchers)
			{
				// TODO: Way to resolve dispatching occurring if object not on stage
				// and there are multiple stage objects running in HTML5?

				if (dispatcher.stage == this || dispatcher.stage == null)
				{
					// #if!openfl_disable_handle_error
					try
					{
						(<internal.DisplayObject><any>dispatcher).__dispatch(event);
					}
					catch (e)
					{
						this.__handleError(e);
					}
					// #else
					// dispatcher.__dispatch(event);
					// #end
				}
			}
		}
	}

	protected __dispatchEvent(event: Event): boolean
	{
		// #if!openfl_disable_handle_error
		try
		{
			// #end

			return super.__dispatchEvent(event);

			// #if!openfl_disable_handle_error
		}
		catch (e)
		{
			this.__handleError(e);
			return false;
		}
		// #end
	}

	protected __dispatchPendingMouseEvent(): void
	{
		if (this.__pendingMouseEvent)
		{
			this.__onMouse(MouseEvent.MOUSE_MOVE, this.__pendingMouseX, this.__pendingMouseY, 0);
			this.__pendingMouseEvent = false;
		}
	}

	protected __dispatchStack(event: Event, stack: Array<DisplayObject>): void
	{
		// #if!openfl_disable_handle_error
		try
		{
			// #end

			var target: DisplayObject;
			var length = stack.length;

			if (length == 0)
			{
				(<internal.Event><any>event).__eventPhase = EventPhase.AT_TARGET;
				target = event.target as InteractiveObject;
				(<internal.DisplayObject><any>target).__dispatch(event);
			}
			else
			{
				(<internal.Event><any>event).__eventPhase = EventPhase.CAPTURING_PHASE;
				(<internal.Event><any>event).__target = stack[stack.length - 1];

				for (let i = 0; i < length - 1; i++)
				{
					(<internal.DisplayObject><any>stack[i]).__dispatch(event);

					if ((<internal.Event><any>Event).__isCanceled)
					{
						return;
					}
				}

				(<internal.Event><any>event).__eventPhase = EventPhase.AT_TARGET;
				target = event.target as InteractiveObject;
				(<internal.DisplayObject><any>target).__dispatch(event);

				if ((<internal.Event><any>Event).__isCanceled)
				{
					return;
				}

				if (event.bubbles)
				{
					(<internal.Event><any>event).__eventPhase = EventPhase.BUBBLING_PHASE;
					var i = length - 2;

					while (i >= 0)
					{
						(<internal.DisplayObject><any>stack[i]).__dispatch(event);

						if ((<internal.Event><any>Event).__isCanceled)
						{
							return;
						}

						i--;
					}
				}
			}

			// #if!openfl_disable_handle_error
		}
		catch (e)
		{
			this.__handleError(e);
		}
		// #end
	}

	protected __dispatchTarget(target: EventDispatcher, event: Event): boolean
	{
		// #if!openfl_disable_handle_error
		try
		{
			return (<internal.EventDispatcher><any>target).__dispatchEvent(event);
		}
		catch (e)
		{
			this.__handleError(e);
			return false;
		}
		// #else
		// return (<internal.DisplayObject><any>target).__dispatchEvent(event);
		// #end
	}

	protected __drag(mouse: Point): void
	{
		var parent = this.__dragObject.parent;
		if (parent != null)
		{
			(<internal.Matrix><any>(<internal.DisplayObject><any>parent).__getWorldTransform()).__transformInversePoint(mouse);
		}

		var x = mouse.x + this.__dragOffsetX;
		var y = mouse.y + this.__dragOffsetY;

		if (this.__dragBounds != null)
		{
			if (x < this.__dragBounds.x)
			{
				x = this.__dragBounds.x;
			}
			else if (x > this.__dragBounds.right)
			{
				x = this.__dragBounds.right;
			}

			if (y < this.__dragBounds.y)
			{
				y = this.__dragBounds.y;
			}
			else if (y > this.__dragBounds.bottom)
			{
				y = this.__dragBounds.bottom;
			}
		}

		this.__dragObject.x = x;
		this.__dragObject.y = y;
	}

	protected __getInteractive(stack: Array<DisplayObject>): boolean
	{
		if (stack != null)
		{
			stack.push(this);
		}

		return true;
	}

	protected __globalToLocal(global: Point, local: Point): Point
	{
		if (global != local)
		{
			local.copyFrom(global);
		}

		return local;
	}

	protected __handleError(e: any): void
	{
		var event = new UncaughtErrorEvent(UncaughtErrorEvent.UNCAUGHT_ERROR, true, true, e);

		try
		{
			(<internal.DisplayObject><any>Lib.current).__loaderInfo.uncaughtErrorEvents.dispatchEvent(event);
		}
		catch (e) { }

		if (!(<internal.Event><any>event).__preventDefault)
		{
			// try
			// {
			// 	var exc = @: privateAccess haxe.CallStack.lastException;
			// 	if (exc != null && Reflect.hasField(exc, "stack") && exc.stack != null && exc.stack != "")
			// 	{
			// 		untyped __js__("console.log")(exc.stack);
			// 		e.stack = exc.stack;
			// 	}
			// 	else
			// 	{
			// 		var msg = CallStack.toString(CallStack.callStack());
			// 		untyped __js__("console.log")(msg);
			// 	}
			// }
			// catch (e2: Dynamic) { }
			// untyped __js__("throw e");
			throw e;
		}
	}

	protected __onKey(event: KeyboardEvent): boolean
	{
		this.__dispatchPendingMouseEvent();

		(<internal.MouseEvent><any>MouseEvent).__altKey = event.altKey;
		// #if!openfl_doc_gen
		(<internal.MouseEvent><any>MouseEvent).__commandKey = event.commandKey;
		// #end
		(<internal.MouseEvent><any>MouseEvent).__ctrlKey = event.ctrlKey;
		(<internal.MouseEvent><any>MouseEvent).__shiftKey = event.shiftKey;

		var preventDefault = false;
		var stack = new Array<DisplayObject>();

		if (this.__focus == null)
		{
			this.__getInteractive(stack);
		}
		else
		{
			(<internal.DisplayObject><any>this.__focus).__getInteractive(stack);
		}

		if (stack.length > 0)
		{
			// Flash Player events are not cancelable, should we make only some events (like APP_CONTROL_BACK) cancelable?

			stack.reverse();
			this.__dispatchStack(event, stack);

			if ((<internal.Event><any>event).__preventDefault)
			{
				preventDefault = true;
			}
			else
			{
				if (event.type == KeyboardEvent.KEY_DOWN && event.keyCode == Keyboard.TAB)
				{
					var tabStack = new Array<InteractiveObject>();

					this.__tabTest(tabStack);

					var nextIndex = -1;
					var nextObject: InteractiveObject = null;
					var nextOffset = event.shiftKey ? -1 : 1;

					if (tabStack.length > 1)
					{
						tabStack.sort((a, b) => a.tabIndex - b.tabIndex);

						if (tabStack[tabStack.length - 1].tabIndex == -1)
						{
							// all tabIndices are equal to -1
							if (this.focus != null) nextIndex = 0;
							else
								nextIndex = this.__currentTabOrderIndex;
						}
						else
						{
							var i = 0;
							while (i < tabStack.length)
							{
								if (tabStack[i].tabIndex > -1)
								{
									if (i > 0) tabStack.splice(0, i);
									break;
								}

								i++;
							}

							if (this.focus != null)
							{
								var index = tabStack.indexOf(this.focus);

								if (index < 0) nextIndex = 0;
								else
									nextIndex = index + nextOffset;
							}
							else
							{
								nextIndex = this.__currentTabOrderIndex;
							}
						}
					}
					else if (tabStack.length == 1)
					{
						nextObject = tabStack[0];

						if (this.focus == nextObject) nextObject = null;
					}

					if (tabStack.length == 1 || tabStack.length == 0 && this.focus != null)
					{
						nextIndex = 0;
					}
					else if (tabStack.length > 1)
					{
						if (nextIndex < 0) nextIndex += tabStack.length;

						nextIndex %= tabStack.length;
						nextObject = tabStack[nextIndex];

						if (nextObject == this.focus)
						{
							nextIndex += nextOffset;

							if (nextIndex < 0) nextIndex += tabStack.length;

							nextIndex %= tabStack.length;
							nextObject = tabStack[nextIndex];
						}
					}

					var focusEvent = null;

					if (focus != null)
					{
						focusEvent = new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE, true, true, nextObject, event.shiftKey, 0);

						stack = [];

						(<internal.DisplayObject><any>focus).__getInteractive(stack);
						stack.reverse();

						this.__dispatchStack(focusEvent, stack);
					}

					if (focusEvent == null || !focusEvent.isDefaultPrevented())
					{
						this.__currentTabOrderIndex = nextIndex;
						if (nextObject != null) this.focus = nextObject;

						// TODO: handle border around focus
					}
				}

				// TODO: handle arrow keys changing the focus
			}
		}

		return preventDefault;
	}

	protected __onMouse(type: string, x: number, y: number, button: number): void
	{
		if (button > 2) return;

		var targetPoint = (<internal.Point><any>Point).__pool.get();
		targetPoint.setTo(x, y);
		(<internal.Matrix><any>this.__displayMatrix).__transformInversePoint(targetPoint);

		this.__mouseX = targetPoint.x;
		this.__mouseY = targetPoint.y;

		var stack = [];
		var target: InteractiveObject = null;

		if (this.__hitTest(this.__mouseX, this.__mouseY, true, stack, true, this))
		{
			target = stack[stack.length - 1] as InteractiveObject;
		}
		else
		{
			target = this;
			stack = [this];
		}

		if (target == null) target = this;

		var clickType = null;
		var event: MouseEvent = null;

		switch (type)
		{
			case MouseEvent.MOUSE_DOWN:
				if ((<internal.InteractiveObject><any>target).__allowMouseFocus())
				{
					if (focus != null)
					{
						var focusEvent = new FocusEvent(FocusEvent.MOUSE_FOCUS_CHANGE, true, true, target, false, 0);

						this.__dispatchStack(focusEvent, stack);

						if (!focusEvent.isDefaultPrevented())
						{
							this.focus = target;
						}
					}
					else
					{
						this.focus = target;
					}
				}
				else
				{
					this.focus = null;
				}

				this.__mouseDownLeft = target;
				(<internal.MouseEvent><any>MouseEvent).__buttonDown = true;
				break;

			case MouseEvent.MIDDLE_MOUSE_DOWN:
				this.__mouseDownMiddle = target;
				break;

			case MouseEvent.RIGHT_MOUSE_DOWN:
				this.__mouseDownRight = target;
				break;

			case MouseEvent.MOUSE_UP:
				if (this.__mouseDownLeft != null)
				{
					(<internal.MouseEvent><any>MouseEvent).__buttonDown = false;

					if (this.__mouseDownLeft == target)
					{
						clickType = MouseEvent.CLICK;
					}
					else
					{
						// event = null;

						// #if openfl_pool_events
						// event = (<internal.MouseEvent><any>MouseEvent).__pool.get(MouseEvent.RELEASE_OUTSIDE, this.__mouseX, this.__mouseY, new Point(this.__mouseX, this.__mouseY), this);
						// #else
						event = (<internal.MouseEvent><any>MouseEvent).__create(MouseEvent.RELEASE_OUTSIDE, 1, this.__mouseX, this.__mouseY, new Point(this.__mouseX, this.__mouseY), this);
						// #end

						this.__mouseDownLeft.dispatchEvent(event);

						// #if openfl_pool_events
						// (<internal.MouseEvent><any>MouseEvent).__pool.release(event);
						// #end
					}

					this.__mouseDownLeft = null;
				}
				break;

			case MouseEvent.MIDDLE_MOUSE_UP:
				if (this.__mouseDownMiddle == target)
				{
					clickType = MouseEvent.MIDDLE_CLICK;
				}

				this.__mouseDownMiddle = null;
				break;

			case MouseEvent.RIGHT_MOUSE_UP:
				if (this.__mouseDownRight == target)
				{
					clickType = MouseEvent.RIGHT_CLICK;
				}

				this.__mouseDownRight = null;
				break;

			default:
		}

		var localPoint = (<internal.Point><any>Point).__pool.get();
		event = null;

		// #if openfl_pool_events
		// event = (<internal.MouseEvent><any>MouseEvent).__pool.get(type, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), target);
		// #else
		event = (<internal.MouseEvent><any>MouseEvent).__create(type, button, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), target);
		// #end

		this.__dispatchStack(event, stack);

		// #if openfl_pool_events
		// (<internal.MouseEvent><any>MouseEvent).__pool.release(event);
		// #end

		if (clickType != null)
		{
			// #if openfl_pool_events
			// event = (<internal.MouseEvent><any>MouseEvent).__pool.get(clickType, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), target);
			// #else
			event = (<internal.MouseEvent><any>MouseEvent).__create(clickType, button, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), target);
			// #end

			this.__dispatchStack(event, stack);

			// #if openfl_pool_events
			// (<internal.MouseEvent><any>MouseEvent).__pool.release(event);
			// #end

			if (type == MouseEvent.MOUSE_UP && (target as InteractiveObject).doubleClickEnabled)
			{
				var currentTime = Lib.getTimer();
				if (currentTime - this.__lastClickTime < 500)
				{
					// #if openfl_pool_events
					// event = (<internal.MouseEvent><any>MouseEvent).__pool.get(MouseEvent.DOUBLE_CLICK, __mouseX, __mouseY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), target);
					// #else
					event = (<internal.MouseEvent><any>MouseEvent).__create(MouseEvent.DOUBLE_CLICK, button, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), target);
					// #end

					this.__dispatchStack(event, stack);

					// #if openfl_pool_events
					// (<internal.MouseEvent><any>MouseEvent).__pool.release(event);
					// #end

					this.__lastClickTime = 0;
				}
				else
				{
					this.__lastClickTime = currentTime;
				}
			}
		}

		if ((<internal.Mouse><any>Mouse).__cursor == MouseCursor.AUTO && !(<internal.Mouse><any>Mouse).__hidden)
		{
			var cursor = null;

			if (this.__mouseDownLeft != null)
			{
				cursor = (<internal.DisplayObject><any>this.__mouseDownLeft).__getCursor();
			}
			else
			{
				for (let target of stack)
				{
					cursor = (<internal.DisplayObject><any>target).__getCursor();

					if (cursor != null)
					{
						(<internal.Mouse><any>Mouse).__setStageCursor(this, cursor);
					}
				}
			}

			if (cursor == null)
			{
				(<internal.Mouse><any>Mouse).__setStageCursor(this, MouseCursor.ARROW);
			}
		}

		event = null;

		if (target != this.__mouseOverTarget)
		{
			if (this.__mouseOverTarget != null)
			{
				// #if openfl_pool_events
				// event = (<internal.MouseEvent><any>MouseEvent).__pool.get(MouseEvent.MOUSE_OUT, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>this.__mouseOverTarget).__globalToLocal(targetPoint, localPoint),
				// this.__mouseOverTarget as InteractiveObject);
				// #else
				event = (<internal.MouseEvent><any>MouseEvent).__create(MouseEvent.MOUSE_OUT, button, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>this.__mouseOverTarget).__globalToLocal(targetPoint, localPoint),
					this.__mouseOverTarget as InteractiveObject);
				// #end

				this.__dispatchStack(event, this.__mouseOutStack);

				// #if openfl_pool_events
				// (<internal.MouseEvent><any>MouseEvent).__pool.release(event);
				// #end
			}
		}

		var item, i = 0;
		while (i < this.__rollOutStack.length)
		{
			item = this.__rollOutStack[i];
			if (stack.indexOf(item) == -1)
			{
				var index = this.__rollOutStack.indexOf(item);
				if (index > -1) this.__rollOutStack.splice(index, 1);

				// #if openfl_pool_events
				// event = (<internal.MouseEvent><any>MouseEvent).__pool.get(MouseEvent.ROLL_OUT, __mouseX, __mouseY, __mouseOver(<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint),
				// 	__mouseOverTarget as InteractiveObject);
				// #else
				event = (<internal.MouseEvent><any>MouseEvent).__create(MouseEvent.ROLL_OUT, button, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>this.__mouseOverTarget).__globalToLocal(targetPoint, localPoint),
					this.__mouseOverTarget as InteractiveObject);
				// #end
				(<internal.Event><any>event).__bubbles = false;

				this.__dispatchTarget(item, event);

				// #if openfl_pool_events
				// (<internal.MouseEvent><any>MouseEvent).__pool.release(event);
				// #end
			}
			else
			{
				i++;
			}
		}

		for (item in stack)
		{
			if (this.__rollOutStack.indexOf(item) == -1 && this.__mouseOverTarget != null)
			{
				if (item.hasEventListener(MouseEvent.ROLL_OVER))
				{
					// // #if openfl_pool_events
					// event = (<internal.MouseEvent><any>MouseEvent).__pool.get(MouseEvent.ROLL_OVER, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>this.__mouseOverTarget).__globalToLocal(targetPoint, localPoint),
					// 	item as InteractiveObject);
					// #else
					event = (<internal.MouseEvent><any>MouseEvent).__create(MouseEvent.ROLL_OVER, button, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>this.__mouseOverTarget).__globalToLocal(targetPoint, localPoint),
						item as InteractiveObject);
					// #end
					(<internal.Event><any>event).__bubbles = false;

					this.__dispatchTarget(item, event);

					// #if openfl_pool_events
					// (<internal.MouseEvent><any>MouseEvent).__pool.release(event);
					// #end
				}

				if (item.hasEventListener(MouseEvent.ROLL_OUT) || item.hasEventListener(MouseEvent.ROLL_OVER))
				{
					this.__rollOutStack.push(item);
				}
			}
		}

		if (target != this.__mouseOverTarget)
		{
			if (target != null)
			{
				// #if openfl_pool_events
				// event = (<internal.MouseEvent><any>MouseEvent).__pool.get(MouseEvent.MOUSE_OVER, __mouseX, __mouseY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), cast target);
				// #else
				event = (<internal.MouseEvent><any>MouseEvent).__create(MouseEvent.MOUSE_OVER, button, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), target as InteractiveObject);
				// #end

				this.__dispatchStack(event, stack);

				// #if openfl_pool_events
				// (<internal.MouseEvent><any>MouseEvent).__pool.release(event);
				// #end
			}

			this.__mouseOverTarget = target;
			this.__mouseOutStack = stack;
		}

		if (this.__dragObject != null)
		{
			this.__drag(targetPoint);

			var dropTarget = null;

			if (this.__mouseOverTarget == this.__dragObject)
			{
				var cacheMouseEnabled = this.__dragObject.mouseEnabled;
				var cacheMouseChildren = this.__dragObject.mouseChildren;

				this.__dragObject.mouseEnabled = false;
				this.__dragObject.mouseChildren = false;

				var stack = [];

				if (this.__hitTest(this.__mouseX, this.__mouseY, true, stack, true, this))
				{
					dropTarget = stack[stack.length - 1];
				}

				this.__dragObject.mouseEnabled = cacheMouseEnabled;
				this.__dragObject.mouseChildren = cacheMouseChildren;
			}
			else if (this.__mouseOverTarget != this)
			{
				dropTarget = this.__mouseOverTarget;
			}

			(<internal.Sprite><any>this.__dragObject).__dropTarget = dropTarget;
		}

		(<internal.Point><any>Point).__pool.release(targetPoint);
		(<internal.Point><any>Point).__pool.release(localPoint);
	}

	protected __onMouseWheel(deltaX: number, deltaY: number): boolean
	{
		// TODO: Support delta modes

		var x = this.__mouseX;
		var y = this.__mouseY;

		var stack = [];
		var target: InteractiveObject = null;

		if (this.__hitTest(this.__mouseX, this.__mouseY, true, stack, true, this))
		{
			target = stack[stack.length - 1] as InteractiveObject;
		}
		else
		{
			target = this;
			stack = [this];
		}

		if (target == null) target = this;
		var targetPoint = (<internal.Point><any>Point).__pool.get();
		targetPoint.setTo(x, y);
		(<internal.Matrix><any>this.__displayMatrix).__transformInversePoint(targetPoint);
		var delta = Math.round(deltaY);

		var event = (<internal.MouseEvent><any>MouseEvent).__create(MouseEvent.MOUSE_WHEEL, 0, this.__mouseX, this.__mouseY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, targetPoint), target, delta);
		(<internal.Event><any>event).__cancelable = true;
		this.__dispatchStack(event, stack);

		(<internal.Point><any>Point).__pool.release(targetPoint);

		return event.isDefaultPrevented();
	}

	protected __onTouch(type: string, id: number, x: number, y: number, pressure: number, isPrimaryTouchPoint: boolean): void
	{
		var targetPoint = (<internal.Point><any>Point).__pool.get();
		targetPoint.setTo(x, y);
		(<internal.Matrix><any>this.__displayMatrix).__transformInversePoint(targetPoint);

		var touchX = targetPoint.x;
		var touchY = targetPoint.y;

		var stack = [];
		var target: InteractiveObject = null;

		if (this.__hitTest(touchX, touchY, false, stack, true, this))
		{
			target = stack[stack.length - 1] as InteractiveObject;
		}
		else
		{
			target = this;
			stack = [this];
		}

		if (target == null) target = this;

		var touchData: TouchData = null;

		if (this.__touchData.has(id))
		{
			touchData = this.__touchData.get(id);
		}
		else
		{
			touchData = TouchData.__pool.get();
			touchData.reset();
			this.__touchData.set(id, touchData);
		}

		var touchType = null;
		var releaseTouchData: boolean = false;

		switch (type)
		{
			case TouchEvent.TOUCH_BEGIN:
				touchData.touchDownTarget = target;
				break;

			case TouchEvent.TOUCH_END:
				if (touchData.touchDownTarget == target)
				{
					touchType = TouchEvent.TOUCH_TAP;
				}

				touchData.touchDownTarget = null;
				releaseTouchData = true;
				break;

			default:
		}

		var localPoint = (<internal.Point><any>Point).__pool.get();
		var touchEvent = (<internal.TouchEvent><any>TouchEvent).__create(type, null, touchX, touchY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), target);
		touchEvent.touchPointID = id;
		touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
		touchEvent.pressure = pressure;

		this.__dispatchStack(touchEvent, stack);

		if (touchType != null)
		{
			touchEvent = (<internal.TouchEvent><any>TouchEvent).__create(touchType, null, touchX, touchY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), target);
			touchEvent.touchPointID = id;
			touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.pressure = pressure;

			this.__dispatchStack(touchEvent, stack);
		}

		var touchOverTarget = touchData.touchOverTarget;

		if (target != touchOverTarget && touchOverTarget != null)
		{
			touchEvent = (<internal.TouchEvent><any>TouchEvent).__create(TouchEvent.TOUCH_OUT, null, touchX, touchY, (<internal.DisplayObject><any>touchOverTarget).__globalToLocal(targetPoint, localPoint),
				touchOverTarget as InteractiveObject);
			touchEvent.touchPointID = id;
			touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.pressure = pressure;

			this.__dispatchTarget(touchOverTarget, touchEvent);
		}

		var touchOutStack = touchData.rollOutStack;
		var item, i = 0;
		while (i < touchOutStack.length)
		{
			item = touchOutStack[i];
			if (stack.indexOf(item) == -1)
			{
				var index = touchOutStack.indexOf(item);
				if (index > -1) touchOutStack.splice(index, 1);

				touchEvent = (<internal.TouchEvent><any>TouchEvent).__create(TouchEvent.TOUCH_ROLL_OUT, null, touchX, touchY, (<internal.DisplayObject><any>touchOverTarget).__globalToLocal(targetPoint, localPoint),
					touchOverTarget as InteractiveObject);
				touchEvent.touchPointID = id;
				touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
				(<internal.Event><any>touchEvent).__bubbles = false;
				touchEvent.pressure = pressure;

				this.__dispatchTarget(item, touchEvent);
			}
			else
			{
				i++;
			}
		}

		for (item in stack)
		{
			if (touchOutStack.indexOf(item) == -1)
			{
				if (item.hasEventListener(TouchEvent.TOUCH_ROLL_OVER))
				{
					touchEvent = (<internal.TouchEvent><any>TouchEvent).__create(TouchEvent.TOUCH_ROLL_OVER, null, touchX, touchY,
						(<internal.DisplayObject><any>touchOverTarget).__globalToLocal(targetPoint, localPoint), item as InteractiveObject);
					touchEvent.touchPointID = id;
					touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
					(<internal.Event><any>touchEvent).__bubbles = false;
					touchEvent.pressure = pressure;

					this.__dispatchTarget(item, touchEvent);
				}

				if (item.hasEventListener(TouchEvent.TOUCH_ROLL_OUT))
				{
					touchOutStack.push(item);
				}
			}
		}

		if (target != touchOverTarget)
		{
			if (target != null)
			{
				touchEvent = (<internal.TouchEvent><any>TouchEvent).__create(TouchEvent.TOUCH_OVER, null, touchX, touchY, (<internal.DisplayObject><any>target).__globalToLocal(targetPoint, localPoint), target);
				touchEvent.touchPointID = id;
				touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
				(<internal.Event><any>touchEvent).__bubbles = true;
				touchEvent.pressure = pressure;

				this.__dispatchTarget(target, touchEvent);
			}

			touchData.touchOverTarget = target;
		}

		(<internal.Point><any>Point).__pool.release(targetPoint);
		(<internal.Point><any>Point).__pool.release(localPoint);

		if (releaseTouchData)
		{
			this.__touchData.delete(id);
			touchData.reset();
			TouchData.__pool.release(touchData);
		}
	}

	protected __render(): void
	{
		if (this.__rendering) return;
		this.__rendering = true;

		// #if hxtelemetry
		// Telemetry.__advanceFrame();
		// #end

		// #if gl_stats
		// Context3DStats.resetDrawCalls();
		// #end

		var event = null;

		// #if openfl_pool_events
		// event = (<internal.Event><any>Event).__pool.get(Event.ENTER_FRAME);

		// this.__broadcastEvent(event);

		// (<internal.Event><any>Event).__pool.release(event);
		// event = (<internal.Event><any>Event).__pool.get(Event.FRAME_CONSTRUCTED);

		// this.__broadcastEvent(event);

		// (<internal.Event><any>Event).__pool.release(event);
		// event = (<internal.Event><any>Event).__pool.get(Event.EXIT_FRAME);

		// this.__broadcastEvent(event);

		// (<internal.Event><any>Event).__pool.release(event);
		// #else
		this.__broadcastEvent(new Event(Event.ENTER_FRAME));
		this.__broadcastEvent(new Event(Event.FRAME_CONSTRUCTED));
		this.__broadcastEvent(new Event(Event.EXIT_FRAME));
		// #end

		this.__renderable = true;
		if (this.__renderer != null)
		{
			(<internal.DisplayObjectRenderer><any>this.__renderer).__enterFrame(this, this.__deltaTime);
		}
		this.__deltaTime = 0;

		var shouldRender = (this.__renderer != null && (this.__renderDirty || this.__forceRender));
		var shouldUpdate = shouldRender || this.__transformDirty;

		if (this.__invalidated && shouldRender)
		{
			this.__invalidated = false;

			// #if openfl_pool_events
			// event = (<internal.Event><any>Event).__pool.get(Event.RENDER);
			// #else
			event = new Event(Event.RENDER);
			// #end

			this.__broadcastEvent(event);

			// #if openfl_pool_events
			// (<internal.Event><any>Event).__pool.release(event);
			// #end
		}

		// #if hxtelemetry
		// var stack = Telemetry.__unwindStack();
		// Telemetry.__startTiming(TelemetryCommandName.RENDER);
		// #end

		if ((<internal.DisplayObject><any>DisplayObject).__supportDOM)
		{
			if (shouldUpdate || this.__wasDirty)
			{
				// If we were dirty last time, we need at least one more
				// update in order to clear "changed" properties
				this.__update(false, true);
				this.__wasDirty = shouldUpdate;
			}
		}
		else if (shouldUpdate)
		{
			this.__update(false, true);
		}

		// #if(lime || openfl_html5)
		if (this.__renderer != null)
		{
			if (this.__context3D != null)
			{
				for (let stage3D of this.__stage3Ds)
				{
					(<internal.Context3D><any>this.__context3D).__renderStage3D(stage3D);
				}

				// #if!openfl_disable_display_render
				if ((<internal.Context3D><any>this.__context3D).__present) shouldRender = true;
				// #end
			}

			if (shouldRender)
			{
				if (this.__context3D == null)
				{
					(<internal.DisplayObjectRenderer><any>this.__renderer).__clear();
				}

				(<internal.DisplayObjectRenderer><any>this.__renderer).__render(this);
			}
			else if (this.__context3D == null)
			{
				// __backend.cancelRender();
			}

			if (this.__context3D != null)
			{
				if (!(<internal.Context3D><any>this.__context3D).__present)
				{
					// __backend.cancelRender();
				}
				else
				{
					if (!(<internal.DisplayObjectRenderer><any>this.__renderer).__cleared)
					{
						(<internal.DisplayObjectRenderer><any>this.__renderer).__clear();
					}

					(<internal.Context3D><any>this.__context3D).__present = false;
					(<internal.Context3D><any>this.__context3D).__cleared = false;
				}

				(<internal.Context3D><any>this.__context3D).__bitmapDataPool.cleanup();
			}

			(<internal.DisplayObjectRenderer><any>this.__renderer).__cleared = false;

			// TODO: Run once for multi-stage application
			(<internal.BitmapData><any>BitmapData).__pool.cleanup();
		}
		// #end

		// #if hxtelemetry
		// Telemetry.__endTiming(TelemetryCommandName.RENDER);
		// Telemetry.__rewindStack(stack);
		// #end

		this.__rendering = false;
	}

	protected __resize(): void
	{
		var cacheWidth = this.__stageWidth;
		var cacheHeight = this.__stageHeight;

		var windowWidth = 0; //__backend.getWindowWidth();
		var windowHeight = 0; //__backend.getWindowHeight();

		// #if openfl_html5
		this.__logicalWidth = windowWidth;
		this.__logicalHeight = windowHeight;
		// #end

		this.__displayMatrix.identity();

		if (this.__fullScreenSourceRect != null && !false /*__backend.getWindowFullscreen()*/)
		{
			this.__stageWidth = Math.round(this.__fullScreenSourceRect.width);
			this.__stageHeight = Math.round(this.__fullScreenSourceRect.height);

			var displayScaleX = windowWidth / this.__stageWidth;
			var displayScaleY = windowHeight / this.__stageHeight;

			this.__displayMatrix.translate(-this.__fullScreenSourceRect.x, -this.__fullScreenSourceRect.y);
			this.__displayMatrix.scale(displayScaleX, displayScaleY);

			this.__displayRect.setTo(this.__fullScreenSourceRect.left, this.__fullScreenSourceRect.right, this.__fullScreenSourceRect.top, this.__fullScreenSourceRect.bottom);
		}
		else
		{
			if (this.__logicalWidth == 0 && this.__logicalHeight == 0)
			{
				this.__stageWidth = windowWidth;
				this.__stageHeight = windowHeight;
			}
			else
			{
				this.__stageWidth = this.__logicalWidth;
				this.__stageHeight = this.__logicalHeight;

				var scaleX = windowWidth / this.__stageWidth;
				var scaleY = windowHeight / this.__stageHeight;
				var targetScale = Math.min(scaleX, scaleY);

				var offsetX = Math.round((windowWidth - (this.__stageWidth * targetScale)) / 2);
				var offsetY = Math.round((windowHeight - (this.__stageHeight * targetScale)) / 2);

				this.__displayMatrix.scale(targetScale, targetScale);
				this.__displayMatrix.translate(offsetX, offsetY);
			}

			this.__displayRect.setTo(0, 0, this.__stageWidth, this.__stageHeight);
		}

		if (this.__context3D != null)
		{
			this.__context3D.configureBackBuffer(windowWidth, windowHeight, 0, true, true, true);
		}

		for (let stage3D of this.__stage3Ds)
		{
			(<internal.Stage3D><any>stage3D).__resize(windowWidth, windowHeight);
		}

		if (this.__renderer != null)
		{
			(<internal.DisplayObjectRenderer><any>this.__renderer).__resize(windowWidth, windowHeight);
		}

		if (this.__stageWidth != cacheWidth || this.__stageHeight != cacheHeight)
		{
			this.__renderDirty = true;
			this.__setTransformDirty();

			var event: Event = null;

			// #if openfl_pool_events
			// event = (<internal.Event><any>Event).__pool.get(Event.RESIZE);
			// #else
			event = new Event(Event.RESIZE);
			// #end

			this.__dispatchEvent(event);

			// #if openfl_pool_events
			// (<internal.Event><any>Event).__pool.release(event);
			// #end
		}
	}

	protected __setLogicalSize(width: number, height: number): void
	{
		this.__logicalWidth = width;
		this.__logicalHeight = height;

		this.__resize();
	}

	protected __startDrag(sprite: Sprite, lockCenter: boolean, bounds: Rectangle): void
	{
		if (bounds == null)
		{
			this.__dragBounds = null;
		}
		else
		{
			this.__dragBounds = new Rectangle();

			var right = bounds.right;
			var bottom = bounds.bottom;
			this.__dragBounds.x = right < bounds.x ? right : bounds.x;
			this.__dragBounds.y = bottom < bounds.y ? bottom : bounds.y;
			this.__dragBounds.width = Math.abs(bounds.width);
			this.__dragBounds.height = Math.abs(bounds.height);
		}

		this.__dragObject = sprite;

		if (this.__dragObject != null)
		{
			if (lockCenter)
			{
				this.__dragOffsetX = 0;
				this.__dragOffsetY = 0;
			}
			else
			{
				var mouse = (<internal.Point><any>Point).__pool.get();
				mouse.setTo(this.mouseX, this.mouseY);
				var parent = this.__dragObject.parent;

				if (parent != null)
				{
					(<internal.Matrix><any>(<internal.DisplayObject><any>parent).__getWorldTransform()).__transformInversePoint(mouse);
				}

				this.__dragOffsetX = this.__dragObject.x - mouse.x;
				this.__dragOffsetY = this.__dragObject.y - mouse.y;
				(<internal.Point><any>Point).__pool.release(mouse);
			}
		}
	}

	protected __stopDrag(sprite: Sprite): void
	{
		this.__dragBounds = null;
		this.__dragObject = null;
	}

	// Get & Set Methods

	/**
		Specifies whether this stage allows the use of the full screen mode
	**/
	public get allowsFullScreen(): boolean
	{
		return this.__allowsFullScreen;
	}

	/**
		Specifies whether this stage allows the use of the full screen with text input mode
	**/
	public get allowsFullScreenInteractive(): boolean
	{
		return this.__allowsFullScreenInteractive;
	}

	/**
		The window background color.
	**/
	public get color(): null | number
	{
		return this.__color;
	}

	public set color(value: null | number)
	{
		if (value == null)
		{
			this.__transparent = true;
			value = 0x000000;
		}
		else
		{
			this.__transparent = false;
		}

		if (this.__color != value)
		{
			var r = (value & 0xFF0000) >>> 16;
			var g = (value & 0x00FF00) >>> 8;
			var b = (value & 0x0000FF);

			this.__colorSplit[0] = r / 0xFF;
			this.__colorSplit[1] = g / 0xFF;
			this.__colorSplit[2] = b / 0xFF;
			this.__colorString = "#" + (value & 0xFFFFFF).toString(16);
			this.__renderDirty = true;
			this.__color = (0xFF << 24) | (value & 0xFFFFFF);
		}
	}

	/**
		Specifies the effective pixel scaling factor of the stage. This
		value is 1 on standard screens and HiDPI (Retina display)
		screens. When the stage is rendered on HiDPI screens the pixel
		resolution is doubled; even if the stage scaling mode is set to
		`StageScaleMode.NO_SCALE`. `Stage.stageWidth` and `Stage.stageHeight`
		continue to be reported in classic pixel units.
	**/
	public get contentsScaleFactor(): number
	{
		return this.__contentsScaleFactor;
	}

	/**
		**BETA**

		The current Context3D the default display renderer.

		This property is supported only when using hardware rendering.
	**/
	public get context3D(): Context3D
	{
		return this.__context3D;
	}

	/**
		A value from the StageDisplayState class that specifies which display
		state to use. The following are valid values:

		* `StageDisplayState.FULL_SCREEN` Sets AIR application or
		Flash runtime to expand the stage over the user's entire screen, with
		keyboard input disabled.
		* `StageDisplayState.FULL_SCREEN_INTERACTIVE` Sets the AIR
		application to expand the stage over the user's entire screen, with
		keyboard input allowed.(Not available for content running in Flash
		Player.)
		* `StageDisplayState.NORMAL` Sets the Flash runtime back to
		the standard stage display mode.


		The scaling behavior of the movie in full-screen mode is determined by
		the `scaleMode` setting(set using the
		`Stage.scaleMode` property or the SWF file's `embed`
		tag settings in the HTML file). If the `scaleMode` property is
		set to `noScale` while the application transitions to
		full-screen mode, the Stage `width` and `height`
		properties are updated, and the Stage dispatches a `resize`
		event. If any other scale mode is set, the stage and its contents are
		scaled to fill the new screen dimensions. The Stage object retains its
		original `width` and `height` values and does not
		dispatch a `resize` event.

		The following restrictions apply to SWF files that play within an HTML
		page(not those using the stand-alone Flash Player or not running in the
		AIR runtime):


		* To enable full-screen mode, add the `allowFullScreen`
		parameter to the `object` and `embed` tags in the
		HTML page that includes the SWF file, with `allowFullScreen`
		set to `"true"`, as shown in the following example:
		* Full-screen mode is initiated in response to a mouse click or key
		press by the user; the movie cannot change `Stage.displayState`
		without user input. Flash runtimes restrict keyboard input in full-screen
		mode. Acceptable keys include keyboard shortcuts that terminate
		full-screen mode and non-printing keys such as arrows, space, Shift, and
		Tab keys. Keyboard shortcuts that terminate full-screen mode are: Escape
		(Windows, Linux, and Mac), Control+W(Windows), Command+W(Mac), and
		Alt+F4.

		A Flash runtime dialog box appears over the movie when users enter
		full-screen mode to inform the users they are in full-screen mode and that
		they can press the Escape key to end full-screen mode.

		* Starting with Flash Player 9.0.115.0, full-screen works the same in
		windowless mode as it does in window mode. If you set the Window Mode
		(`wmode` in the HTML) to Opaque Windowless
		(`opaque`) or Transparent Windowless
		(`transparent`), full-screen can be initiated, but the
		full-screen window will always be opaque.

		These restrictions are _not_ present for SWF content running in
		the stand-alone Flash Player or in AIR. AIR supports an interactive
		full-screen mode which allows keyboard input.

		For AIR content running in full-screen mode, the system screen saver
		and power saving options are disabled while video content is playing and
		until either the video stops or full-screen mode is exited.

		On Linux, setting `displayState` to
		`StageDisplayState.FULL_SCREEN` or
		`StageDisplayState.FULL_SCREEN_INTERACTIVE` is an asynchronous
		operation.

		@throws SecurityError Calling the `displayState` property of a
							  Stage object throws an exception for any caller that
							  is not in the same security sandbox as the Stage
							  owner(the main SWF file). To avoid this, the Stage
							  owner can grant permission to the domain of the
							  caller by calling the
							  `Security.allowDomain()` method or the
							  `Security.allowInsecureDomain()` method.
							  For more information, see the "Security" chapter in
							  the _ActionScript 3.0 Developer's Guide_.
							  Trying to set the `displayState` property
							  while the settings dialog is displayed, without a
							  user response, or if the `param` or
							  `embed` HTML tag's
							  `allowFullScreen` attribute is not set to
							  `true` throws a security error.
	**/
	public get displayState(): StageDisplayState
	{
		return this.__displayState;
	}

	public set displayState(value: StageDisplayState)
	{
		// __backend.setDisplayState(value);
		this.__displayState = value;
	}

	/**
		The interactive object with keyboard focus; or `null` if focus
		is not set or if the focused object belongs to a security sandbox to which
		the calling object does not have access.

		@throws Error Throws an error if focus cannot be set to the target.
	**/
	public get focus(): InteractiveObject
	{
		return this.__focus;
	}

	public set focus(value: InteractiveObject)
	{
		if (value != this.__focus)
		{
			var oldFocus = this.__focus;
			this.__focus = value;
			this.__cacheFocus = value;

			if (oldFocus != null)
			{
				var event = new FocusEvent(FocusEvent.FOCUS_OUT, true, false, value, false, 0);
				var stack = new Array<DisplayObject>();
				(<internal.DisplayObject><any>oldFocus).__getInteractive(stack);
				stack.reverse();
				this.__dispatchStack(event, stack);
			}

			if (value != null)
			{
				var event = new FocusEvent(FocusEvent.FOCUS_IN, true, false, oldFocus, false, 0);
				var stack = new Array<DisplayObject>();
				(<internal.DisplayObject><any>value).__getInteractive(stack);
				stack.reverse();
				this.__dispatchStack(event, stack);
			}
		}
	}

	/**
		Gets and sets the frame rate of the stage. The frame rate is defined as
		frames per second. By default the rate is set to the frame rate of the
		first SWF file loaded. Valid range for the frame rate is from 0.01 to 1000
		frames per second.

		**Note:** An application might not be able to follow high frame rate
		settings, either because the target platform is not fast enough or the
		player is synchronized to the vertical blank timing of the display device
		(usually 60 Hz on LCD devices). In some cases, a target platform might
		also choose to lower the maximum frame rate if it anticipates high CPU
		usage.

		For content running in Adobe AIR, setting the `frameRate`
		property of one Stage object changes the frame rate for all Stage objects
		(used by different NativeWindow objects).

		@throws SecurityError Calling the `frameRate` property of a
							  Stage object throws an exception for any caller that
							  is not in the same security sandbox as the Stage
							  owner(the main SWF file). To avoid this, the Stage
							  owner can grant permission to the domain of the
							  caller by calling the
							  `Security.allowDomain()` method or the
							  `Security.allowInsecureDomain()` method.
							  For more information, see the "Security" chapter in
							  the _ActionScript 3.0 Developer's Guide_.
	**/
	public get frameRate(): number
	{
		// return __backend.getFrameRate();
		return 0;
	}

	public set frameRate(value: number)
	{
		// __backend.setFrameRate(value);
	}

	/**
		Returns the height of the monitor that will be used when going to full
		screen size, if that state is entered immediately. If the user has
		multiple monitors, the monitor that's used is the monitor that most of
		the stage is on at the time.
		**Note**: If the user has the opportunity to move the browser from one
		monitor to another between retrieving the value and going to full
		screen size, the value could be incorrect. If you retrieve the value
		in an event handler that sets `Stage.displayState` to
		`StageDisplayState.FULL_SCREEN`, the value will be correct.

		This is the pixel height of the monitor and is the same as the stage
		height would be if `Stage.align` is set to `StageAlign.TOP_LEFT` and
		`Stage.scaleMode` is set to `StageScaleMode.NO_SCALE`.
	**/
	public get fullScreenHeight(): number
	{
		// return __backend.getFullScreenHeight();
		return 0;
	}

	/**
		Sets the Flash runtime to scale a specific region of the stage to
		full-screen mode. If available, the Flash runtime scales in hardware,
		which uses the graphics and video card on a user's computer, and
		generally displays content more quickly than software scaling.
		When this property is set to a valid rectangle and the `displayState`
		property is set to full-screen mode, the Flash runtime scales the
		specified area. The actual Stage size in pixels within ActionScript
		does not change. The Flash runtime enforces a minimum limit for the
		size of the rectangle to accommodate the standard "Press Esc to exit
		full-screen mode" message. This limit is usually around 260 by 30
		pixels but can vary on platform and Flash runtime version.

		This property can only be set when the Flash runtime is not in
		full-screen mode. To use this property correctly, set this property
		first, then set the `displayState` property to full-screen mode, as
		shown in the code examples.

		To enable scaling, set the `fullScreenSourceRect` property to a
		rectangle object:

		```haxe
		// valid, will enable hardware scaling
		stage.fullScreenSourceRect = new Rectangle(0,0,320,240);
		```

		To disable scaling, set `fullScreenSourceRect=null`.

		```haxe
		stage.fullScreenSourceRect = null;
		```

		The end user also can select within Flash Player Display Settings to
		turn off hardware scaling, which is enabled by default. For more
		information, see <a href="http://www.adobe.com/go/display_settings"
		scope="external">www.adobe.com/go/display_settings</a>.
	**/
	public get fullScreenSourceRect(): Rectangle
	{
		return this.__fullScreenSourceRect == null ? null : this.__fullScreenSourceRect.clone();
	}

	public set fullScreenSourceRect(value: Rectangle)
	{
		if (value == null)
		{
			if (this.__fullScreenSourceRect != null)
			{
				this.__fullScreenSourceRect = null;
				this.__resize();
			}
		}
		else if (!value.equals(this.__fullScreenSourceRect))
		{
			this.__fullScreenSourceRect = value.clone();
			this.__resize();
		}
	}

	/**
		Returns the width of the monitor that will be used when going to full
		screen size, if that state is entered immediately. If the user has
		multiple monitors, the monitor that's used is the monitor that most of
		the stage is on at the time.
		**Note**: If the user has the opportunity to move the browser from one
		monitor to another between retrieving the value and going to full
		screen size, the value could be incorrect. If you retrieve the value
		in an event handler that sets `Stage.displayState` to
		`StageDisplayState.FULL_SCREEN`, the value will be correct.

		This is the pixel width of the monitor and is the same as the stage
		width would be if `Stage.align` is set to `StageAlign.TOP_LEFT` and
		`Stage.scaleMode` is set to `StageScaleMode.NO_SCALE`.
	**/
	public get fullScreenWidth(): number
	{
		// return __backend.getFullScreenWidth();
		return 0;
	}

	public set height(value: number)
	{

	}

	public get mouseX(): number
	{
		return this.__mouseX;
	}

	public get mouseY(): number
	{
		return this.__mouseY;
	}

	/**
		A value from the StageQuality class that specifies which rendering quality
		is used. The following are valid values:

		* `StageQuality.LOW` - Low rendering quality. Graphics are
		not anti-aliased, and bitmaps are not smoothed, but runtimes still use
		mip-mapping.
		* `StageQuality.MEDIUM` - Medium rendering quality.
		Graphics are anti-aliased using a 2 x 2 pixel grid, bitmap smoothing is
		dependent on the `Bitmap.smoothing` setting. Runtimes use
		mip-mapping. This setting is suitable for movies that do not contain
		text.
		* `StageQuality.HIGH` - High rendering quality. Graphics
		are anti-aliased using a 4 x 4 pixel grid, and bitmap smoothing is
		dependent on the `Bitmap.smoothing` setting. Runtimes use
		mip-mapping. This is the default rendering quality setting that Flash
		Player uses.
		* `StageQuality.BEST` - Very high rendering quality.
		Graphics are anti-aliased using a 4 x 4 pixel grid. If
		`Bitmap.smoothing` is `true` the runtime uses a high
		quality downscale algorithm that produces fewer artifacts(however, using
		`StageQuality.BEST` with `Bitmap.smoothing` set to
		`true` slows performance significantly and is not a recommended
		setting).


		Higher quality settings produce better rendering of scaled bitmaps.
		However, higher quality settings are computationally more expensive. In
		particular, when rendering scaled video, using higher quality settings can
		reduce the frame rate.

		In the desktop profile of Adobe AIR, `quality` can be set to
		`StageQuality.BEST` or `StageQuality.HIGH`(and the
		default value is `StageQuality.HIGH`). Attempting to set it to
		another value has no effect(and the property remains unchanged). In the
		moble profile of AIR, all four quality settings are available. The default
		value on mobile devices is `StageQuality.MEDIUM`.

		For content running in Adobe AIR, setting the `quality`
		property of one Stage object changes the rendering quality for all Stage
		objects(used by different NativeWindow objects).
		**_Note:_** The operating system draws the device fonts, which are
		therefore unaffected by the `quality` property.

		@throws SecurityError Calling the `quality` property of a Stage
							  object throws an exception for any caller that is
							  not in the same security sandbox as the Stage owner
							 (the main SWF file). To avoid this, the Stage owner
							  can grant permission to the domain of the caller by
							  calling the `Security.allowDomain()`
							  method or the
							  `Security.allowInsecureDomain()` method.
							  For more information, see the "Security" chapter in
							  the _ActionScript 3.0 Developer's Guide_.
	**/
	public get quality(): StageQuality
	{
		return this.__quality;
	}

	public set quality(value: StageQuality)
	{
		this.__quality = value;

		if (this.__renderer != null)
		{
			(<internal.DisplayObjectRenderer><any>this.__renderer).__allowSmoothing = (this.quality != StageQuality.LOW);
		}
	}

	public set rotation(value: number) { }

	/**
		A value from the StageScaleMode class that specifies which scale mode to
		use. The following are valid values:

		* `StageScaleMode.EXACT_FIT` - The entire application is
		visible in the specified area without trying to preserve the original
		aspect ratio. Distortion can occur, and the application may appear
		stretched or compressed.
		* `StageScaleMode.SHOW_ALL` - The entire application is
		visible in the specified area without distortion while maintaining the
		original aspect ratio of the application. Borders can appear on two sides
		of the application.
		* `StageScaleMode.NO_BORDER` - The entire application fills
		the specified area, without distortion but possibly with some cropping,
		while maintaining the original aspect ratio of the application.
		* `StageScaleMode.NO_SCALE` - The entire application is
		fixed, so that it remains unchanged even as the size of the player window
		changes. Cropping might occur if the player window is smaller than the
		content.


		@throws SecurityError Calling the `scaleMode` property of a
							  Stage object throws an exception for any caller that
							  is not in the same security sandbox as the Stage
							  owner(the main SWF file). To avoid this, the Stage
							  owner can grant permission to the domain of the
							  caller by calling the
							  `Security.allowDomain()` method or the
							  `Security.allowInsecureDomain()` method.
							  For more information, see the "Security" chapter in
							  the _ActionScript 3.0 Developer's Guide_.
	**/
	public get scaleMode(): StageScaleMode
	{
		return this.__scaleMode;
	}

	public set scaleMode(value: StageScaleMode)
	{
		// TODO

		this.__scaleMode = value;
	}

	public set scaleX(value: number) { }
	public set scaleY(value: number) { }

	/**
		A list of Stage3D objects available for displaying 3-dimensional content.

		You can use only a limited number of Stage3D objects at a time. The number of
		available Stage3D objects depends on the platform and on the available hardware.

		A Stage3D object draws in front of a StageVideo object and behind the OpenFL
		display list.
	**/
	public get stage3Ds(): Vector<Stage3D>
	{
		return this.__stage3Ds;
	}

	/**
		The current height, in pixels, of the Stage.

		If the value of the `Stage.scaleMode` property is set to
		`StageScaleMode.NO_SCALE` when the user resizes the window, the
		Stage content maintains its size while the `stageHeight`
		property changes to reflect the new height size of the screen area
		occupied by the SWF file.(In the other scale modes, the
		`stageHeight` property always reflects the original height of
		the SWF file.) You can add an event listener for the `resize`
		event and then use the `stageHeight` property of the Stage
		class to determine the actual pixel dimension of the resized Flash runtime
		window. The event listener allows you to control how the screen content
		adjusts when the user resizes the window.

		Air for TV devices have slightly different behavior than desktop
		devices when you set the `stageHeight` property. If the
		`Stage.scaleMode` property is set to
		`StageScaleMode.NO_SCALE` and you set the
		`stageHeight` property, the stage height does not change until
		the next frame of the SWF.

		**Note:** In an HTML page hosting the SWF file, both the
		`object` and `embed` tags' `height`
		attributes must be set to a percentage(such as `100%`), not
		pixels. If the settings are generated by JavaScript code, the
		`height` parameter of the `AC_FL_RunContent() `
		method must be set to a percentage, too. This percentage is applied to the
		`stageHeight` value.

		@throws SecurityError Calling the `stageHeight` property of a
							  Stage object throws an exception for any caller that
							  is not in the same security sandbox as the Stage
							  owner(the main SWF file). To avoid this, the Stage
							  owner can grant permission to the domain of the
							  caller by calling the
							  `Security.allowDomain()` method or the
							  `Security.allowInsecureDomain()` method.
							  For more information, see the "Security" chapter in
							  the _ActionScript 3.0 Developer's Guide_.
	**/
	public get stageHeight(): number
	{
		return this.__stageHeight;
	}

	/**
		Specifies the current width, in pixels, of the Stage.

		If the value of the `Stage.scaleMode` property is set to
		`StageScaleMode.NO_SCALE` when the user resizes the window, the
		Stage content maintains its defined size while the `stageWidth`
		property changes to reflect the new width size of the screen area occupied
		by the SWF file.(In the other scale modes, the `stageWidth`
		property always reflects the original width of the SWF file.) You can add
		an event listener for the `resize` event and then use the
		`stageWidth` property of the Stage class to determine the
		actual pixel dimension of the resized Flash runtime window. The event
		listener allows you to control how the screen content adjusts when the
		user resizes the window.

		Air for TV devices have slightly different behavior than desktop
		devices when you set the `stageWidth` property. If the
		`Stage.scaleMode` property is set to
		`StageScaleMode.NO_SCALE` and you set the
		`stageWidth` property, the stage width does not change until
		the next frame of the SWF.

		**Note:** In an HTML page hosting the SWF file, both the
		`object` and `embed` tags' `width`
		attributes must be set to a percentage(such as `100%`), not
		pixels. If the settings are generated by JavaScript code, the
		`width` parameter of the `AC_FL_RunContent() `
		method must be set to a percentage, too. This percentage is applied to the
		`stageWidth` value.

		@throws SecurityError Calling the `stageWidth` property of a
							  Stage object throws an exception for any caller that
							  is not in the same security sandbox as the Stage
							  owner (the main SWF file). To avoid this, the Stage
							  owner can grant permission to the domain of the
							  caller by calling the
							  `Security.allowDomain()` method or the
							  `Security.allowInsecureDomain()` method.
							  For more information, see the "Security" chapter in
							  the _ActionScript 3.0 Developer's Guide_.
	**/
	public get stageWidth(): number
	{
		return this.__stageWidth;
	}

	public get tabEnabled(): boolean
	{
		return false;
	}

	public set tabEnabled(value: boolean)
	{
		throw new IllegalOperationError("Error: The Stage class does not implement this property or method.");
	}

	public get tabIndex(): number
	{
		return -1;
	}

	public set tabIndex(value: number)
	{
		throw new IllegalOperationError("Error: The Stage class does not implement this property or method.");
	}

	public set transform(value: Transform) { }
	public set width(value: number) { }
	public set x(value: number) { }
	public set y(value: number) { }
}
