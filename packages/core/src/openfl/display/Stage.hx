package openfl.display;

#if !flash
import haxe.CallStack;
import haxe.ds.ArraySort;
import openfl._internal.utils.Log;
import openfl._internal.utils.TouchData;
import openfl.display3D.Context3D;
import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.EventPhase;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.ui.Keyboard;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
#if lime
import lime.app.Application;
import lime.app.IModule;
#end
#if openfl_html5
import js.html.Element;
#end
#if hxtelemetry
import openfl.profiler.Telemetry;
#end
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
#end

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
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.renderer)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Sprite)
@:access(openfl.display.Stage3D)
@:access(openfl.events.Event)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Point)
@:access(openfl.ui.Keyboard)
@:access(openfl.ui.Mouse)
class Stage extends DisplayObjectContainer #if lime implements IModule #end
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
	public var align:StageAlign;

	/**
		Specifies whether this stage allows the use of the full screen mode
	**/
	public var allowsFullScreen(default, null):Bool;

	/**
		Specifies whether this stage allows the use of the full screen with text input mode
	**/
	public var allowsFullScreenInteractive(default, null):Bool;

	#if lime
	@:noCompletion @:dox(hide) @SuppressWarnings("checkstyle:FieldDocComment")
	@:deprecated("Stage.application is deprecated. Use Stage.limeApplication instead.")
	public var application(get, never):Application;

	@:noCompletion private inline function get_application():Application
	{
		return this.limeApplication;
	}
	#end

	// @:noCompletion @:dox(hide) @:require(flash15) public var browserZoomFactor (default, null):Float;

	/**
		The window background color.
	**/
	public var color(get, set):Null<Int>;

	#if false
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
	// @:noCompletion @:dox(hide) @:require(flash10) public var colorCorrection:openfl.display.ColorCorrection;
	#end

	#if false
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
	// @:noCompletion @:dox(hide) @:require(flash10) public var colorCorrectionSupport (default, null):openfl.display.ColorCorrectionSupport;
	#end

	/**
		Specifies the effective pixel scaling factor of the stage. This
		value is 1 on standard screens and HiDPI (Retina display)
		screens. When the stage is rendered on HiDPI screens the pixel
		resolution is doubled; even if the stage scaling mode is set to
		`StageScaleMode.NO_SCALE`. `Stage.stageWidth` and `Stage.stageHeight`
		continue to be reported in classic pixel units.
	**/
	public var contentsScaleFactor(get, never):Float;

	/**
		**BETA**

		The current Context3D the default display renderer.

		This property is supported only when using hardware rendering.
	**/
	public var context3D(default, null):Context3D;

	// @:noCompletion @:dox(hide) @:require(flash11) public var displayContextInfo (default, null):String;

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
	public var displayState(get, set):StageDisplayState;

	#if (commonjs || (openfl_html5 && !lime))
	/**
		The parent HTML element where this Stage is embedded.
	**/
	public var element:Element;
	#end

	/**
		The interactive object with keyboard focus; or `null` if focus
		is not set or if the focused object belongs to a security sandbox to which
		the calling object does not have access.

		@throws Error Throws an error if focus cannot be set to the target.
	**/
	public var focus(get, set):InteractiveObject;

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
	public var frameRate(get, set):Float;

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
	public var fullScreenHeight(get, never):UInt;

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
	public var fullScreenSourceRect(get, set):Rectangle;

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
	public var fullScreenWidth(get, never):UInt;

	#if lime
	/**
		The associated Lime Application instance.
	**/
	public var limeApplication(default, null):Application;

	/**
		The associated Lime Window instance for this Stage.
	**/
	public var limeWindow(default, null):Window;
	#end

	// @:noCompletion @:dox(hide) @:require(flash11_2) public var mouseLock:Bool;

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
	public var quality(get, set):StageQuality;

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
	public var scaleMode(get, set):StageScaleMode;

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
	public var showDefaultContextMenu:Bool;

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
	public var softKeyboardRect:Rectangle;

	/**
		A list of Stage3D objects available for displaying 3-dimensional content.

		You can use only a limited number of Stage3D objects at a time. The number of
		available Stage3D objects depends on the platform and on the available hardware.

		A Stage3D object draws in front of a StageVideo object and behind the OpenFL
		display list.
	**/
	public var stage3Ds(default, null):Vector<Stage3D>;

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
	public var stageFocusRect:Bool;

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
	public var stageHeight(default, null):Int;

	#if false
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
	// @:noCompletion @:dox(hide) @:require(flash10_2) public var stageVideos (default, null):Vector<openfl.media.StageVideo>;
	#end

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
	public var stageWidth(default, null):Int;

	#if lime
	@:noCompletion @:dox(hide) @SuppressWarnings("checkstyle:FieldDocComment")
	@:deprecated("Stage.window is deprecated. Use Stage.limeWindow instead.")
	public var window(get, never):Window;

	@:noCompletion private inline function get_window():Window
	{
		return this.limeWindow;
	}
	#end

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
	#if false
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var wmodeGPU (default, null):Bool;
	#end
	@:noCompletion private var _:_Stage;
	@:noCompletion private var __cacheFocus:InteractiveObject;
	@:noCompletion private var __clearBeforeRender:Bool;
	@:noCompletion private var __color:Int;
	@:noCompletion private var __colorSplit:Array<Float>;
	@:noCompletion private var __colorString:String;
	@:noCompletion private var __contentsScaleFactor:Float;
	@:noCompletion private var __currentTabOrderIndex:Int;
	@:noCompletion private var __deltaTime:Int;
	@:noCompletion private var __dirty:Bool;
	@:noCompletion private var __displayMatrix:Matrix;
	@:noCompletion private var __displayRect:Rectangle;
	@:noCompletion private var __displayState:StageDisplayState;
	@:noCompletion private var __dragBounds:Rectangle;
	@:noCompletion private var __dragObject:Sprite;
	@:noCompletion private var __dragOffsetX:Float;
	@:noCompletion private var __dragOffsetY:Float;
	@:noCompletion private var __focus:InteractiveObject;
	@:noCompletion private var __forceRender:Bool;
	@:noCompletion private var __fullscreen:Bool;
	@:noCompletion private var __fullScreenSourceRect:Rectangle;
	@:noCompletion private var __invalidated:Bool;
	@:noCompletion private var __lastClickTime:Int;
	@:noCompletion private var __logicalWidth:Int;
	@:noCompletion private var __logicalHeight:Int;
	@:noCompletion private var __mouseDownLeft:InteractiveObject;
	@:noCompletion private var __mouseDownMiddle:InteractiveObject;
	@:noCompletion private var __mouseDownRight:InteractiveObject;
	@:noCompletion private var __mouseOutStack:Array<DisplayObject>;
	@:noCompletion private var __mouseOverTarget:InteractiveObject;
	@:noCompletion private var __mouseX:Float;
	@:noCompletion private var __mouseY:Float;
	@:noCompletion private var __pendingMouseEvent:Bool;
	@:noCompletion private var __pendingMouseX:Int;
	@:noCompletion private var __pendingMouseY:Int;
	@:noCompletion private var __primaryTouchID:Null<Int>;
	@:noCompletion private var __quality:StageQuality;
	@:noCompletion private var __renderer:DisplayObjectRenderer;
	@:noCompletion private var __rendering:Bool;
	@:noCompletion private var __rollOutStack:Array<DisplayObject>;
	@:noCompletion private var __scaleMode:StageScaleMode;
	@:noCompletion private var __stack:Array<DisplayObject>;
	@:noCompletion private var __touchData:Map<Int, TouchData>;
	@:noCompletion private var __transparent:Bool;
	@:noCompletion private var __wasDirty:Bool;
	@:noCompletion private var __wasFullscreen:Bool;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(Stage.prototype, {
			"color": {
				get: untyped __js__("function () { return this.get_color (); }"),
				set: untyped __js__("function (v) { return this.set_color (v); }")
			},
			"contentsScaleFactor": {
				get: untyped __js__("function () { return this.get_contentsScaleFactor (); }")
			},
			"displayState": {
				get: untyped __js__("function () { return this.get_displayState (); }"),
				set: untyped __js__("function (v) { return this.set_displayState (v); }")
			},
			"focus": {
				get: untyped __js__("function () { return this.get_focus (); }"),
				set: untyped __js__("function (v) { return this.set_focus (v); }")
			},
			"frameRate": {
				get: untyped __js__("function () { return this.get_frameRate (); }"),
				set: untyped __js__("function (v) { return this.set_frameRate (v); }")
			},
			"fullScreenHeight": {
				get: untyped __js__("function () { return this.get_fullScreenHeight (); }")
			},
			"fullScreenWidth": {
				get: untyped __js__("function () { return this.get_fullScreenWidth (); }")
			},
			"quality": {
				get: untyped __js__("function () { return this.get_quality (); }"),
				set: untyped __js__("function (v) { return this.set_quality (v); }")
			},
			"scaleMode": {
				get: untyped __js__("function () { return this.get_scaleMode (); }"),
				set: untyped __js__("function (v) { return this.set_scaleMode (v); }")
			},
		});
	}
	#end

	public function new(#if (commonjs || (openfl_html5 && !lime)) width:Dynamic = 0, height:Dynamic = 0, color:Null<Int> = null,
		documentClass:Class<Dynamic> = null, windowAttributes:Dynamic = null #elseif lime window:Window, color:Null<Int> = null #end)
	{
		#if hxtelemetry
		Telemetry.__initialize();
		#end

		super();

		this.name = null;

		__color = 0xFFFFFFFF;
		__colorSplit = [0xFF, 0xFF, 0xFF];
		__colorString = "#FFFFFF";
		__contentsScaleFactor = 1;
		__currentTabOrderIndex = 0;
		__deltaTime = 0;
		__displayState = NORMAL;
		__mouseX = 0;
		__mouseY = 0;
		__lastClickTime = 0;
		__logicalWidth = 0;
		__logicalHeight = 0;
		__displayMatrix = new Matrix();
		__displayRect = new Rectangle();
		__renderDirty = true;

		stage3Ds = new Vector();
		for (i in 0...#if mobile 2 #else 4 #end)
		{
			stage3Ds.push(new Stage3D(this));
		}

		this.stage = this;

		align = StageAlign.TOP_LEFT;
		allowsFullScreen = true;
		allowsFullScreenInteractive = true;
		__quality = StageQuality.HIGH;
		__scaleMode = StageScaleMode.NO_SCALE;
		showDefaultContextMenu = true;
		softKeyboardRect = new Rectangle();
		stageFocusRect = true;

		__clearBeforeRender = true;
		__forceRender = false;
		__stack = [];
		__rollOutStack = [];
		__mouseOutStack = [];
		__touchData = new Map<Int, TouchData>();

		// #if (commonjs || (openfl_html5 && !lime))
		// _ = new StageBackend(this, width, height, color, documentClass, windowAttributes);
		// #elseif lime
		_ = new _Stage(this, window, color);
		// #else
		// _ = new StageBackend(this);
		// #end
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
	public override function invalidate():Void
	{
		__invalidated = true;

		// TODO: Should this not mark as dirty?
		__renderDirty = true;
	}

	// @:noCompletion @:dox(hide) public function isFocusInaccessible ():Bool;
	public override function localToGlobal(pos:Point):Point
	{
		return pos.clone();
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function __broadcastEvent(event:Event):Void
	{
		if (DisplayObject.__broadcastEvents.exists(event.type))
		{
			var dispatchers = DisplayObject.__broadcastEvents.get(event.type);

			for (dispatcher in dispatchers)
			{
				// TODO: Way to resolve dispatching occurring if object not on stage
				// and there are multiple stage objects running in HTML5?

				if (dispatcher.stage == this || dispatcher.stage == null)
				{
					#if !openfl_disable_handle_error
					try
					{
						dispatcher.__dispatch(event);
					}
					catch (e:Dynamic)
					{
						__handleError(e);
					}
					#else
					dispatcher.__dispatch(event);
					#end
				}
			}
		}
	}

	@SuppressWarnings(["checkstyle:Dynamic", "checkstyle:LeftCurly"])
	@:noCompletion private override function __dispatchEvent(event:Event):Bool
	{
		#if !openfl_disable_handle_error
		try
		{
		#end

			return super.__dispatchEvent(event);

		#if !openfl_disable_handle_error
		}
		catch (e:Dynamic)
		{
			__handleError(e);
			return false;
		}
		#end
	}

	@:noCompletion private function __dispatchPendingMouseEvent():Void
	{
		if (__pendingMouseEvent)
		{
			__onMouse(MouseEvent.MOUSE_MOVE, __pendingMouseX, __pendingMouseY, 0);
			__pendingMouseEvent = false;
		}
	}

	@SuppressWarnings(["checkstyle:Dynamic", "checkstyle:LeftCurly"])
	@:noCompletion private function __dispatchStack(event:Event, stack:Array<DisplayObject>):Void
	{
		#if !openfl_disable_handle_error
		try
		{
		#end

			var target:DisplayObject;
			var length = stack.length;

			if (length == 0)
			{
				event.eventPhase = EventPhase.AT_TARGET;
				target = cast event.target;
				target.__dispatch(event);
			}
			else
			{
				event.eventPhase = EventPhase.CAPTURING_PHASE;
				event.target = stack[stack.length - 1];

				for (i in 0...length - 1)
				{
					stack[i].__dispatch(event);

					if (event.__isCanceled)
					{
						return;
					}
				}

				event.eventPhase = EventPhase.AT_TARGET;
				target = cast event.target;
				target.__dispatch(event);

				if (event.__isCanceled)
				{
					return;
				}

				if (event.bubbles)
				{
					event.eventPhase = EventPhase.BUBBLING_PHASE;
					var i = length - 2;

					while (i >= 0)
					{
						stack[i].__dispatch(event);

						if (event.__isCanceled)
						{
							return;
						}

						i--;
					}
				}
			}

		#if !openfl_disable_handle_error
		}
		catch (e:Dynamic)
		{
			__handleError(e);
		}
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function __dispatchTarget(target:EventDispatcher, event:Event):Bool
	{
		#if !openfl_disable_handle_error
		try
		{
			return target.__dispatchEvent(event);
		}
		catch (e:Dynamic)
		{
			__handleError(e);
			return false;
		}
		#else
		return target.__dispatchEvent(event);
		#end
	}

	@:noCompletion private function __drag(mouse:Point):Void
	{
		var parent = __dragObject.parent;
		if (parent != null)
		{
			parent.__getWorldTransform().__transformInversePoint(mouse);
		}

		var x = mouse.x + __dragOffsetX;
		var y = mouse.y + __dragOffsetY;

		if (__dragBounds != null)
		{
			if (x < __dragBounds.x)
			{
				x = __dragBounds.x;
			}
			else if (x > __dragBounds.right)
			{
				x = __dragBounds.right;
			}

			if (y < __dragBounds.y)
			{
				y = __dragBounds.y;
			}
			else if (y > __dragBounds.bottom)
			{
				y = __dragBounds.bottom;
			}
		}

		__dragObject.x = x;
		__dragObject.y = y;
	}

	@:noCompletion private override function __getInteractive(stack:Array<DisplayObject>):Bool
	{
		if (stack != null)
		{
			stack.push(this);
		}

		return true;
	}

	@:noCompletion private override function __globalToLocal(global:Point, local:Point):Point
	{
		if (global != local)
		{
			local.copyFrom(global);
		}

		return local;
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function __handleError(e:Dynamic):Void
	{
		var event = new UncaughtErrorEvent(UncaughtErrorEvent.UNCAUGHT_ERROR, true, true, e);

		try
		{
			Lib.current.__loaderInfo.uncaughtErrorEvents.dispatchEvent(event);
		}
		catch (e:Dynamic) {}

		if (!event.__preventDefault)
		{
			#if mobile
			Log.println(CallStack.toString(CallStack.exceptionStack()));
			Log.println(Std.string(e));
			#end

			#if (cpp && !cppia)
			untyped __cpp__("throw e");
			#elseif neko
			neko.Lib.rethrow(e);
			#elseif js
			try
			{
				#if (haxe >= "4.1.0")
				var exc = e;
				#else
				var exc = @:privateAccess haxe.CallStack.lastException;
				#end
				if (exc != null && Reflect.hasField(exc, "stack") && exc.stack != null && exc.stack != "")
				{
					untyped __js__("console.log")(exc.stack);
					e.stack = exc.stack;
				}
				else
				{
					var msg = CallStack.toString(CallStack.callStack());
					untyped __js__("console.log")(msg);
				}
			}
			catch (e2:Dynamic) {}
			untyped __js__("throw e");
			#elseif cs
			throw e;
			// cs.Lib.rethrow (e);
			#elseif hl
			hl.Api.rethrow(e);
			#else
			throw e;
			#end
		}
	}

	@:noCompletion private function __onKey(event:KeyboardEvent):Bool
	{
		__dispatchPendingMouseEvent();

		MouseEvent.__altKey = event.altKey;
		#if !openfl_doc_gen
		MouseEvent.__commandKey = event.commandKey;
		#end
		MouseEvent.__ctrlKey = event.ctrlKey;
		MouseEvent.__shiftKey = event.shiftKey;

		var preventDefault = false;
		var stack = new Array<DisplayObject>();

		if (__focus == null)
		{
			__getInteractive(stack);
		}
		else
		{
			__focus.__getInteractive(stack);
		}

		if (stack.length > 0)
		{
			// Flash Player events are not cancelable, should we make only some events (like APP_CONTROL_BACK) cancelable?

			stack.reverse();
			__dispatchStack(event, stack);

			if (event.__preventDefault)
			{
				preventDefault = true;
			}
			else
			{
				if (event.type == KeyboardEvent.KEY_DOWN && event.keyCode == Keyboard.TAB)
				{
					var tabStack = new Array<InteractiveObject>();

					__tabTest(tabStack);

					var nextIndex = -1;
					var nextObject:InteractiveObject = null;
					var nextOffset = event.shiftKey ? -1 : 1;

					if (tabStack.length > 1)
					{
						ArraySort.sort(tabStack, function(a, b)
						{
							return a.tabIndex - b.tabIndex;
						});

						if (tabStack[tabStack.length - 1].tabIndex == -1)
						{
							// all tabIndices are equal to -1
							if (focus != null) nextIndex = 0;
							else
								nextIndex = __currentTabOrderIndex;
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

							if (focus != null)
							{
								var index = tabStack.indexOf(focus);

								if (index < 0) nextIndex = 0;
								else
									nextIndex = index + nextOffset;
							}
							else
							{
								nextIndex = __currentTabOrderIndex;
							}
						}
					}
					else if (tabStack.length == 1)
					{
						nextObject = tabStack[0];

						if (focus == nextObject) nextObject = null;
					}

					if (tabStack.length == 1 || tabStack.length == 0 && focus != null)
					{
						nextIndex = 0;
					}
					else if (tabStack.length > 1)
					{
						if (nextIndex < 0) nextIndex += tabStack.length;

						nextIndex %= tabStack.length;
						nextObject = tabStack[nextIndex];

						if (nextObject == focus)
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

						focus.__getInteractive(stack);
						stack.reverse();

						__dispatchStack(focusEvent, stack);
					}

					if (focusEvent == null || !focusEvent.isDefaultPrevented())
					{
						__currentTabOrderIndex = nextIndex;
						if (nextObject != null) focus = nextObject;

						// TODO: handle border around focus
					}
				}

				// TODO: handle arrow keys changing the focus
			}
		}

		return preventDefault;
	}

	@:noCompletion private function __onMouse(type:String, x:Float, y:Float, button:Int):Void
	{
		if (button > 2) return;

		var targetPoint = Point.__pool.get();
		targetPoint.setTo(x, y);
		__displayMatrix.__transformInversePoint(targetPoint);

		__mouseX = targetPoint.x;
		__mouseY = targetPoint.y;

		var stack = [];
		var target:InteractiveObject = null;

		if (__hitTest(__mouseX, __mouseY, true, stack, true, this))
		{
			target = cast stack[stack.length - 1];
		}
		else
		{
			target = this;
			stack = [this];
		}

		if (target == null) target = this;

		var clickType = null;

		switch (type)
		{
			case MouseEvent.MOUSE_DOWN:
				if (target.__allowMouseFocus())
				{
					if (focus != null)
					{
						var focusEvent = new FocusEvent(FocusEvent.MOUSE_FOCUS_CHANGE, true, true, target, false, 0);

						__dispatchStack(focusEvent, stack);

						if (!focusEvent.isDefaultPrevented())
						{
							focus = target;
						}
					}
					else
					{
						focus = target;
					}
				}
				else
				{
					focus = null;
				}

				__mouseDownLeft = target;
				MouseEvent.__buttonDown = true;

			case MouseEvent.MIDDLE_MOUSE_DOWN:
				__mouseDownMiddle = target;

			case MouseEvent.RIGHT_MOUSE_DOWN:
				__mouseDownRight = target;

			case MouseEvent.MOUSE_UP:
				if (__mouseDownLeft != null)
				{
					MouseEvent.__buttonDown = false;

					if (__mouseDownLeft == target)
					{
						clickType = MouseEvent.CLICK;
					}
					else
					{
						var event:MouseEvent = null;

						#if openfl_pool_events
						event = MouseEvent.__pool.get(MouseEvent.RELEASE_OUTSIDE, __mouseX, __mouseY, new Point(__mouseX, __mouseY), this);
						#else
						event = MouseEvent.__create(MouseEvent.RELEASE_OUTSIDE, 1, __mouseX, __mouseY, new Point(__mouseX, __mouseY), this);
						#end

						__mouseDownLeft.dispatchEvent(event);

						#if openfl_pool_events
						MouseEvent.__pool.release(event);
						#end
					}

					__mouseDownLeft = null;
				}

			case MouseEvent.MIDDLE_MOUSE_UP:
				if (__mouseDownMiddle == target)
				{
					clickType = MouseEvent.MIDDLE_CLICK;
				}

				__mouseDownMiddle = null;

			case MouseEvent.RIGHT_MOUSE_UP:
				if (__mouseDownRight == target)
				{
					clickType = MouseEvent.RIGHT_CLICK;
				}

				__mouseDownRight = null;

			default:
		}

		var localPoint = Point.__pool.get();
		var event:MouseEvent = null;

		#if openfl_pool_events
		event = MouseEvent.__pool.get(type, __mouseX, __mouseY, target.__globalToLocal(targetPoint, localPoint), target);
		#else
		event = MouseEvent.__create(type, button, __mouseX, __mouseY, target.__globalToLocal(targetPoint, localPoint), target);
		#end

		__dispatchStack(event, stack);

		#if openfl_pool_events
		MouseEvent.__pool.release(event);
		#end

		if (clickType != null)
		{
			#if openfl_pool_events
			event = MouseEvent.__pool.get(clickType, __mouseX, __mouseY, target.__globalToLocal(targetPoint, localPoint), target);
			#else
			event = MouseEvent.__create(clickType, button, __mouseX, __mouseY, target.__globalToLocal(targetPoint, localPoint), target);
			#end

			__dispatchStack(event, stack);

			#if openfl_pool_events
			MouseEvent.__pool.release(event);
			#end

			if (type == MouseEvent.MOUSE_UP && cast(target, openfl.display.InteractiveObject).doubleClickEnabled)
			{
				var currentTime = Lib.getTimer();
				if (currentTime - __lastClickTime < 500)
				{
					#if openfl_pool_events
					event = MouseEvent.__pool.get(MouseEvent.DOUBLE_CLICK, __mouseX, __mouseY, target.__globalToLocal(targetPoint, localPoint), target);
					#else
					event = MouseEvent.__create(MouseEvent.DOUBLE_CLICK, button, __mouseX, __mouseY, target.__globalToLocal(targetPoint, localPoint), target);
					#end

					__dispatchStack(event, stack);

					#if openfl_pool_events
					MouseEvent.__pool.release(event);
					#end

					__lastClickTime = 0;
				}
				else
				{
					__lastClickTime = currentTime;
				}
			}
		}

		if (Mouse.__cursor == MouseCursor.AUTO && !Mouse.__hidden)
		{
			var cursor = null;

			if (__mouseDownLeft != null)
			{
				cursor = __mouseDownLeft.__getCursor();
			}
			else
			{
				for (target in stack)
				{
					cursor = target.__getCursor();

					if (cursor != null)
					{
						Mouse.__setStageCursor(this, cursor);
					}
				}
			}

			if (cursor == null)
			{
				Mouse.__setStageCursor(this, ARROW);
			}
		}

		var event;

		if (target != __mouseOverTarget)
		{
			if (__mouseOverTarget != null)
			{
				#if openfl_pool_events
				event = MouseEvent.__pool.get(MouseEvent.MOUSE_OUT, __mouseX, __mouseY, __mouseOverTarget.__globalToLocal(targetPoint, localPoint),
					cast __mouseOverTarget);
				#else
				event = MouseEvent.__create(MouseEvent.MOUSE_OUT, button, __mouseX, __mouseY, __mouseOverTarget.__globalToLocal(targetPoint, localPoint),
					cast __mouseOverTarget);
				#end

				__dispatchStack(event, __mouseOutStack);

				#if openfl_pool_events
				MouseEvent.__pool.release(event);
				#end
			}
		}

		var item, i = 0;
		while (i < __rollOutStack.length)
		{
			item = __rollOutStack[i];
			if (stack.indexOf(item) == -1)
			{
				__rollOutStack.remove(item);

				#if openfl_pool_events
				event = MouseEvent.__pool.get(MouseEvent.ROLL_OUT, __mouseX, __mouseY, __mouseOverTarget.__globalToLocal(targetPoint, localPoint),
					cast __mouseOverTarget);
				#else
				event = MouseEvent.__create(MouseEvent.ROLL_OUT, button, __mouseX, __mouseY, __mouseOverTarget.__globalToLocal(targetPoint, localPoint),
					cast __mouseOverTarget);
				#end
				event.bubbles = false;

				__dispatchTarget(item, event);

				#if openfl_pool_events
				MouseEvent.__pool.release(event);
				#end
			}
			else
			{
				i++;
			}
		}

		for (item in stack)
		{
			if (__rollOutStack.indexOf(item) == -1 && __mouseOverTarget != null)
			{
				if (item.hasEventListener(MouseEvent.ROLL_OVER))
				{
					#if openfl_pool_events
					event = MouseEvent.__pool.get(MouseEvent.ROLL_OVER, __mouseX, __mouseY, __mouseOverTarget.__globalToLocal(targetPoint, localPoint),
						cast item);
					#else
					event = MouseEvent.__create(MouseEvent.ROLL_OVER, button, __mouseX, __mouseY, __mouseOverTarget.__globalToLocal(targetPoint, localPoint),
						cast item);
					#end
					event.bubbles = false;

					__dispatchTarget(item, event);

					#if openfl_pool_events
					MouseEvent.__pool.release(event);
					#end
				}

				if (item.hasEventListener(MouseEvent.ROLL_OUT) || item.hasEventListener(MouseEvent.ROLL_OVER))
				{
					__rollOutStack.push(item);
				}
			}
		}

		if (target != __mouseOverTarget)
		{
			if (target != null)
			{
				#if openfl_pool_events
				event = MouseEvent.__pool.get(MouseEvent.MOUSE_OVER, __mouseX, __mouseY, target.__globalToLocal(targetPoint, localPoint), cast target);
				#else
				event = MouseEvent.__create(MouseEvent.MOUSE_OVER, button, __mouseX, __mouseY, target.__globalToLocal(targetPoint, localPoint), cast target);
				#end

				__dispatchStack(event, stack);

				#if openfl_pool_events
				MouseEvent.__pool.release(event);
				#end
			}

			__mouseOverTarget = target;
			__mouseOutStack = stack;
		}

		if (__dragObject != null)
		{
			__drag(targetPoint);

			var dropTarget = null;

			if (__mouseOverTarget == __dragObject)
			{
				var cacheMouseEnabled = __dragObject.mouseEnabled;
				var cacheMouseChildren = __dragObject.mouseChildren;

				__dragObject.mouseEnabled = false;
				__dragObject.mouseChildren = false;

				var stack = [];

				if (__hitTest(__mouseX, __mouseY, true, stack, true, this))
				{
					dropTarget = stack[stack.length - 1];
				}

				__dragObject.mouseEnabled = cacheMouseEnabled;
				__dragObject.mouseChildren = cacheMouseChildren;
			}
			else if (__mouseOverTarget != this)
			{
				dropTarget = __mouseOverTarget;
			}

			__dragObject.dropTarget = dropTarget;
		}

		Point.__pool.release(targetPoint);
		Point.__pool.release(localPoint);
	}

	@:noCompletion private function __onMouseWheel(deltaX:Float, deltaY:Float):Bool
	{
		// TODO: Support delta modes

		var x = __mouseX;
		var y = __mouseY;

		var stack = [];
		var target:InteractiveObject = null;

		if (__hitTest(__mouseX, __mouseY, true, stack, true, this))
		{
			target = cast stack[stack.length - 1];
		}
		else
		{
			target = this;
			stack = [this];
		}

		if (target == null) target = this;
		var targetPoint = Point.__pool.get();
		targetPoint.setTo(x, y);
		__displayMatrix.__transformInversePoint(targetPoint);
		var delta = Std.int(deltaY);

		var event = MouseEvent.__create(MouseEvent.MOUSE_WHEEL, 0, __mouseX, __mouseY, target.__globalToLocal(targetPoint, targetPoint), target, delta);
		event.cancelable = true;
		__dispatchStack(event, stack);

		Point.__pool.release(targetPoint);

		return event.isDefaultPrevented();
	}

	@:noCompletion private function __onTouch(type:String, id:Int, x:Int, y:Int, pressure:Float, isPrimaryTouchPoint:Bool):Void
	{
		var targetPoint = Point.__pool.get();
		targetPoint.setTo(x, y);
		__displayMatrix.__transformInversePoint(targetPoint);

		var touchX = targetPoint.x;
		var touchY = targetPoint.y;

		var stack = [];
		var target:InteractiveObject = null;

		if (__hitTest(touchX, touchY, false, stack, true, this))
		{
			target = cast stack[stack.length - 1];
		}
		else
		{
			target = this;
			stack = [this];
		}

		if (target == null) target = this;

		var touchData:TouchData = null;

		if (__touchData.exists(id))
		{
			touchData = __touchData.get(id);
		}
		else
		{
			touchData = TouchData.__pool.get();
			touchData.reset();
			__touchData.set(id, touchData);
		}

		var touchType = null;
		var releaseTouchData:Bool = false;

		switch (type)
		{
			case TouchEvent.TOUCH_BEGIN:
				touchData.touchDownTarget = target;

			case TouchEvent.TOUCH_END:
				if (touchData.touchDownTarget == target)
				{
					touchType = TouchEvent.TOUCH_TAP;
				}

				touchData.touchDownTarget = null;
				releaseTouchData = true;

			default:
		}

		var localPoint = Point.__pool.get();
		var touchEvent = TouchEvent.__create(type, null, touchX, touchY, target.__globalToLocal(targetPoint, localPoint), cast target);
		touchEvent.touchPointID = id;
		touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
		touchEvent.pressure = pressure;

		__dispatchStack(touchEvent, stack);

		if (touchType != null)
		{
			touchEvent = TouchEvent.__create(touchType, null, touchX, touchY, target.__globalToLocal(targetPoint, localPoint), cast target);
			touchEvent.touchPointID = id;
			touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.pressure = pressure;

			__dispatchStack(touchEvent, stack);
		}

		var touchOverTarget = touchData.touchOverTarget;

		if (target != touchOverTarget && touchOverTarget != null)
		{
			touchEvent = TouchEvent.__create(TouchEvent.TOUCH_OUT, null, touchX, touchY, touchOverTarget.__globalToLocal(targetPoint, localPoint),
				cast touchOverTarget);
			touchEvent.touchPointID = id;
			touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.pressure = pressure;

			__dispatchTarget(touchOverTarget, touchEvent);
		}

		var touchOutStack = touchData.rollOutStack;
		var item, i = 0;
		while (i < touchOutStack.length)
		{
			item = touchOutStack[i];
			if (stack.indexOf(item) == -1)
			{
				touchOutStack.remove(item);

				touchEvent = TouchEvent.__create(TouchEvent.TOUCH_ROLL_OUT, null, touchX, touchY, touchOverTarget.__globalToLocal(targetPoint, localPoint),
					cast touchOverTarget);
				touchEvent.touchPointID = id;
				touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
				touchEvent.bubbles = false;
				touchEvent.pressure = pressure;

				__dispatchTarget(item, touchEvent);
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
					touchEvent = TouchEvent.__create(TouchEvent.TOUCH_ROLL_OVER, null, touchX, touchY,
						touchOverTarget.__globalToLocal(targetPoint, localPoint), cast item);
					touchEvent.touchPointID = id;
					touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
					touchEvent.bubbles = false;
					touchEvent.pressure = pressure;

					__dispatchTarget(item, touchEvent);
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
				touchEvent = TouchEvent.__create(TouchEvent.TOUCH_OVER, null, touchX, touchY, target.__globalToLocal(targetPoint, localPoint), cast target);
				touchEvent.touchPointID = id;
				touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
				touchEvent.bubbles = true;
				touchEvent.pressure = pressure;

				__dispatchTarget(target, touchEvent);
			}

			touchData.touchOverTarget = target;
		}

		Point.__pool.release(targetPoint);
		Point.__pool.release(localPoint);

		if (releaseTouchData)
		{
			__touchData.remove(id);
			touchData.reset();
			TouchData.__pool.release(touchData);
		}
	}

	#if lime
	@:noCompletion private function __registerLimeModule(application:Application):Void
	{
		_.registerLimeModule(application);
	}
	#end

	@:noCompletion private function __render():Void
	{
		if (__rendering) return;
		__rendering = true;

		#if hxtelemetry
		Telemetry.__advanceFrame();
		#end

		#if gl_stats
		Context3DStats.resetDrawCalls();
		#end

		var event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.ENTER_FRAME);

		__broadcastEvent(event);

		Event.__pool.release(event);
		event = Event.__pool.get(Event.FRAME_CONSTRUCTED);

		__broadcastEvent(event);

		Event.__pool.release(event);
		event = Event.__pool.get(Event.EXIT_FRAME);

		__broadcastEvent(event);

		Event.__pool.release(event);
		#else
		__broadcastEvent(new Event(Event.ENTER_FRAME));
		__broadcastEvent(new Event(Event.FRAME_CONSTRUCTED));
		__broadcastEvent(new Event(Event.EXIT_FRAME));
		#end

		__renderable = true;
		if (__renderer != null)
		{
			__renderer.__enterFrame(this, __deltaTime);
		}
		__deltaTime = 0;

		var shouldRender = #if !openfl_disable_display_render (__renderer != null #if !openfl_always_render && (__renderDirty || __forceRender) #end) #else false #end;
		var shouldUpdate = shouldRender || __transformDirty;

		if (__invalidated && shouldRender)
		{
			__invalidated = false;

			#if openfl_pool_events
			event = Event.__pool.get(Event.RENDER);
			#else
			event = new Event(Event.RENDER);
			#end

			__broadcastEvent(event);

			#if openfl_pool_events
			Event.__pool.release(event);
			#end
		}

		#if hxtelemetry
		var stack = Telemetry.__unwindStack();
		Telemetry.__startTiming(TelemetryCommandName.RENDER);
		#end

		if (DisplayObject.__supportDOM)
		{
			if (shouldUpdate || __wasDirty)
			{
				// If we were dirty last time, we need at least one more
				// update in order to clear "changed" properties
				__update(false, true);
				__wasDirty = shouldUpdate;
			}
		}
		else if (shouldUpdate)
		{
			__update(false, true);
		}

		#if (lime || openfl_html5)
		if (__renderer != null)
		{
			if (context3D != null)
			{
				for (stage3D in stage3Ds)
				{
					context3D.__renderStage3D(stage3D);
				}

				#if !openfl_disable_display_render
				if (context3D.__present) shouldRender = true;
				#end
			}

			if (shouldRender)
			{
				if (context3D == null)
				{
					__renderer.__clear();
				}

				__renderer.__render(this);
			}
			else if (context3D == null)
			{
				_.cancelRender();
			}

			if (context3D != null)
			{
				if (!context3D.__present)
				{
					_.cancelRender();
				}
				else
				{
					if (!__renderer.__cleared)
					{
						__renderer.__clear();
					}

					context3D.__present = false;
					context3D.__cleared = false;
				}

				context3D.__bitmapDataPool.cleanup();
			}

			__renderer.__cleared = false;

			// TODO: Run once for multi-stage application
			BitmapData.__pool.cleanup();
		}
		#end

		#if hxtelemetry
		Telemetry.__endTiming(TelemetryCommandName.RENDER);
		Telemetry.__rewindStack(stack);
		#end

		__rendering = false;
	}

	@:noCompletion private function __resize():Void
	{
		var cacheWidth = stageWidth;
		var cacheHeight = stageHeight;

		var windowWidth = _.getWindowWidth();
		var windowHeight = _.getWindowHeight();

		#if openfl_html5
		__logicalWidth = windowWidth;
		__logicalHeight = windowHeight;
		#end

		__displayMatrix.identity();

		if (fullScreenSourceRect != null && _.getWindowFullscreen())
		{
			stageWidth = Std.int(fullScreenSourceRect.width);
			stageHeight = Std.int(fullScreenSourceRect.height);

			var displayScaleX = windowWidth / stageWidth;
			var displayScaleY = windowHeight / stageHeight;

			__displayMatrix.translate(-fullScreenSourceRect.x, -fullScreenSourceRect.y);
			__displayMatrix.scale(displayScaleX, displayScaleY);

			__displayRect.setTo(fullScreenSourceRect.left, fullScreenSourceRect.right, fullScreenSourceRect.top, fullScreenSourceRect.bottom);
		}
		else
		{
			if (__logicalWidth == 0 && __logicalHeight == 0)
			{
				stageWidth = windowWidth;
				stageHeight = windowHeight;
			}
			else
			{
				stageWidth = __logicalWidth;
				stageHeight = __logicalHeight;

				var scaleX = windowWidth / stageWidth;
				var scaleY = windowHeight / stageHeight;
				var targetScale = Math.min(scaleX, scaleY);

				var offsetX = Math.round((windowWidth - (stageWidth * targetScale)) / 2);
				var offsetY = Math.round((windowHeight - (stageHeight * targetScale)) / 2);

				__displayMatrix.scale(targetScale, targetScale);
				__displayMatrix.translate(offsetX, offsetY);
			}

			__displayRect.setTo(0, 0, stageWidth, stageHeight);
		}

		if (context3D != null)
		{
			context3D.configureBackBuffer(windowWidth, windowHeight, 0, true, true, true);
		}

		for (stage3D in stage3Ds)
		{
			stage3D.__resize(windowWidth, windowHeight);
		}

		if (__renderer != null)
		{
			__renderer.__resize(windowWidth, windowHeight);
		}

		if (stageWidth != cacheWidth || stageHeight != cacheHeight)
		{
			__renderDirty = true;
			__setTransformDirty();

			var event:Event = null;

			#if openfl_pool_events
			event = Event.__pool.get(Event.RESIZE);
			#else
			event = new Event(Event.RESIZE);
			#end

			__dispatchEvent(event);

			#if openfl_pool_events
			Event.__pool.release(event);
			#end
		}
	}

	@:noCompletion private function __setLogicalSize(width:Int, height:Int):Void
	{
		__logicalWidth = width;
		__logicalHeight = height;

		__resize();
	}

	@:noCompletion private function __startDrag(sprite:Sprite, lockCenter:Bool, bounds:Rectangle):Void
	{
		if (bounds == null)
		{
			__dragBounds = null;
		}
		else
		{
			__dragBounds = new Rectangle();

			var right = bounds.right;
			var bottom = bounds.bottom;
			__dragBounds.x = right < bounds.x ? right : bounds.x;
			__dragBounds.y = bottom < bounds.y ? bottom : bounds.y;
			__dragBounds.width = Math.abs(bounds.width);
			__dragBounds.height = Math.abs(bounds.height);
		}

		__dragObject = sprite;

		if (__dragObject != null)
		{
			if (lockCenter)
			{
				__dragOffsetX = 0;
				__dragOffsetY = 0;
			}
			else
			{
				var mouse = Point.__pool.get();
				mouse.setTo(mouseX, mouseY);
				var parent = __dragObject.parent;

				if (parent != null)
				{
					parent.__getWorldTransform().__transformInversePoint(mouse);
				}

				__dragOffsetX = __dragObject.x - mouse.x;
				__dragOffsetY = __dragObject.y - mouse.y;
				Point.__pool.release(mouse);
			}
		}
	}

	@:noCompletion private function __stopDrag(sprite:Sprite):Void
	{
		__dragBounds = null;
		__dragObject = null;
	}

	#if lime
	@:noCompletion private function __unregisterLimeModule(application:Application):Void
	{
		_.unregisterLimeModule(application);
	}
	#end

	// Get & Set Methods
	@:noCompletion private function get_color():Null<Int>
	{
		return __color;
	}

	@:noCompletion private function set_color(value:Null<Int>):Null<Int>
	{
		if (value == null)
		{
			__transparent = true;
			value = 0x000000;
		}
		else
		{
			__transparent = false;
		}

		if (__color != value)
		{
			var r = (value & 0xFF0000) >>> 16;
			var g = (value & 0x00FF00) >>> 8;
			var b = (value & 0x0000FF);

			__colorSplit[0] = r / 0xFF;
			__colorSplit[1] = g / 0xFF;
			__colorSplit[2] = b / 0xFF;
			__colorString = "#" + StringTools.hex(value & 0xFFFFFF, 6);
			__renderDirty = true;
			__color = (0xFF << 24) | (value & 0xFFFFFF);
		}

		return value;
	}

	@:noCompletion private function get_contentsScaleFactor():Float
	{
		return __contentsScaleFactor;
	}

	@:noCompletion private function get_displayState():StageDisplayState
	{
		return __displayState;
	}

	@:noCompletion private function set_displayState(value:StageDisplayState):StageDisplayState
	{
		_.setDisplayState(value);
		return __displayState = value;
	}

	@:noCompletion private function get_focus():InteractiveObject
	{
		return __focus;
	}

	@:noCompletion private function set_focus(value:InteractiveObject):InteractiveObject
	{
		if (value != __focus)
		{
			var oldFocus = __focus;
			__focus = value;
			__cacheFocus = value;

			if (oldFocus != null)
			{
				var event = new FocusEvent(FocusEvent.FOCUS_OUT, true, false, value, false, 0);
				var stack = new Array<DisplayObject>();
				oldFocus.__getInteractive(stack);
				stack.reverse();
				__dispatchStack(event, stack);
			}

			if (value != null)
			{
				var event = new FocusEvent(FocusEvent.FOCUS_IN, true, false, oldFocus, false, 0);
				var stack = new Array<DisplayObject>();
				value.__getInteractive(stack);
				stack.reverse();
				__dispatchStack(event, stack);
			}
		}

		return value;
	}

	@:noCompletion private function get_frameRate():Float
	{
		return _.getFrameRate();
	}

	@:noCompletion private function set_frameRate(value:Float):Float
	{
		_.setFrameRate(value);
		return value;
	}

	@:noCompletion private function get_fullScreenHeight():UInt
	{
		return _.getFullScreenHeight();
	}

	@:noCompletion private function get_fullScreenSourceRect():Rectangle
	{
		return __fullScreenSourceRect == null ? null : __fullScreenSourceRect.clone();
	}

	@:noCompletion private function set_fullScreenSourceRect(value:Rectangle):Rectangle
	{
		if (value == null)
		{
			if (__fullScreenSourceRect != null)
			{
				__fullScreenSourceRect = null;
				__resize();
			}
		}
		else if (!value.equals(__fullScreenSourceRect))
		{
			__fullScreenSourceRect = value.clone();
			__resize();
		}

		return value;
	}

	@:noCompletion private function get_fullScreenWidth():UInt
	{
		return _.getFullScreenWidth();
	}

	@:noCompletion private override function set_height(value:Float):Float
	{
		return this.height;
	}

	@:noCompletion private override function get_mouseX():Float
	{
		return __mouseX;
	}

	@:noCompletion private override function get_mouseY():Float
	{
		return __mouseY;
	}

	@:noCompletion private function get_quality():StageQuality
	{
		return __quality;
	}

	@:noCompletion private function set_quality(value:StageQuality):StageQuality
	{
		__quality = value;

		if (__renderer != null)
		{
			__renderer.__allowSmoothing = (quality != LOW);
		}

		return value;
	}

	@:noCompletion private override function set_rotation(value:Float):Float
	{
		return 0;
	}

	@:noCompletion private function get_scaleMode():StageScaleMode
	{
		return __scaleMode;
	}

	@:noCompletion private function set_scaleMode(value:StageScaleMode):StageScaleMode
	{
		// TODO

		return __scaleMode = value;
	}

	@:noCompletion private override function set_scaleX(value:Float):Float
	{
		return 0;
	}

	@:noCompletion private override function set_scaleY(value:Float):Float
	{
		return 0;
	}

	@:noCompletion private override function get_tabEnabled():Bool
	{
		return false;
	}

	@:noCompletion private override function set_tabEnabled(value:Bool):Bool
	{
		throw new IllegalOperationError("Error: The Stage class does not implement this property or method.");
	}

	@:noCompletion private override function get_tabIndex():Int
	{
		return -1;
	}

	@:noCompletion private override function set_tabIndex(value:Int):Int
	{
		throw new IllegalOperationError("Error: The Stage class does not implement this property or method.");
	}

	@:noCompletion private override function set_transform(value:Transform):Transform
	{
		return this.transform;
	}

	@:noCompletion private override function set_width(value:Float):Float
	{
		return this.width;
	}

	@:noCompletion private override function set_x(value:Float):Float
	{
		return 0;
	}

	@:noCompletion private override function set_y(value:Float):Float
	{
		return 0;
	}
}
#else
typedef Stage = flash.display.Stage;
#end
