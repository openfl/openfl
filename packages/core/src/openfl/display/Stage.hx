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
		Developer's Guide(_ : _Stage).
	**/
	public var align(get, set):StageAlign;

	/**
		Specifies whether this stage allows the use of the full screen mode
	**/
	public var allowsFullScreen(get, never):Bool;

	/**
		Specifies whether this stage allows the use of the full screen with text input mode
	**/
	public var allowsFullScreenInteractive(get, never):Bool;

	#if lime
	@:noCompletion @:dox(hide) @SuppressWarnings("checkstyle:FieldDocComment")
	@:deprecated("Stage.application is deprecated. Use Stage.limeApplication instead.")
	public var application(get, never):Application;

	@:noCompletion private inline function get_application():Application
	{
		return (_ : _Stage).limeApplication;
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
	public var context3D(get, never):Context3D;

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
							  the _ActionScript 3.0 Developer's Guide(_ : _Stage).
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
	public var element(get, set):Element;
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
							  the _ActionScript 3.0 Developer's Guide(_ : _Stage).
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
	public var limeApplication(get, never):Application;

	/**
		The associated Lime Window instance for this Stage.
	**/
	public var limeWindow(get, never):Window;
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
							  the _ActionScript 3.0 Developer's Guide(_ : _Stage).
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
							  the _ActionScript 3.0 Developer's Guide(_ : _Stage).
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
							  the _ActionScript 3.0 Developer's Guide(_ : _Stage).
	**/
	public var showDefaultContextMenu(get, set):Bool;

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
	public var softKeyboardRect(get, set):Rectangle;

	/**
		A list of Stage3D objects available for displaying 3-dimensional content.

		You can use only a limited number of Stage3D objects at a time. The number of
		available Stage3D objects depends on the platform and on the available hardware.

		A Stage3D object draws in front of a StageVideo object and behind the OpenFL
		display list.
	**/
	public var stage3Ds(get, never):Vector<Stage3D>;

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
							  the _ActionScript 3.0 Developer's Guide(_ : _Stage).
	**/
	public var stageFocusRect(get, set):Bool;

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
							  the _ActionScript 3.0 Developer's Guide(_ : _Stage).
	**/
	public var stageHeight(get, never):Int;

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
							  the _ActionScript 3.0 Developer's Guide(_ : _Stage).
	**/
	public var stageWidth(get, never):Int;

	#if lime
	@:noCompletion @:dox(hide) @SuppressWarnings("checkstyle:FieldDocComment")
	@:deprecated("Stage.window is deprecated. Use Stage.limeWindow instead.")
	public var window(get, never):Window;

	@:noCompletion private inline function get_window():Window
	{
		return (_ : _Stage).limeWindow;
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
	public function new(#if (commonjs || (openfl_html5 && !lime)) width:Dynamic = 0, height:Dynamic = 0, color:Null<Int> = null,
		documentClass:Class<Dynamic> = null, windowAttributes:Dynamic = null #elseif lime window:Window, color:Null<Int> = null #end)
	{
		if (_ == null)
		{
			#if (commonjs || (openfl_html5 && !lime))
			_ = new _Stage(width, height, color, documentClass, windowAttributes);
			#else
			_ = new _Stage(window, color);
			#end
		}

		super();
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
		(_ : _Stage).invalidate();
	}

	#if lime
	@:noCompletion private function __registerLimeModule(application:Application):Void
	{
		(_ : _Stage).registerLimeModule(application);
	}

	@:noCompletion private function __unregisterLimeModule(application:Application):Void
	{
		(_ : _Stage).unregisterLimeModule(application);
	}
	#end

	// @:noCompletion @:dox(hide) public function isFocusInaccessible ():Bool;
	// Get & Set Methods

	@:noCompletion private function get_align():StageAlign
	{
		return (_ : _Stage).align;
	}

	@:noCompletion private function set_align(value:StageAlign):StageAlign
	{
		return (_ : _Stage).align = value;
	}

	@:noCompletion private function get_allowsFullScreen():Bool
	{
		return (_ : _Stage).allowsFullScreen;
	}

	@:noCompletion private function get_allowsFullScreenInteractive():Bool
	{
		return (_ : _Stage).allowsFullScreenInteractive;
	}

	@:noCompletion private function get_color():Null<Int>
	{
		return (_ : _Stage).color;
	}

	@:noCompletion private function set_color(value:Null<Int>):Null<Int>
	{
		return (_ : _Stage).color = value;
	}

	@:noCompletion private function get_contentsScaleFactor():Float
	{
		return (_ : _Stage).contentsScaleFactor;
	}

	@:noCompletion private function get_context3D():Context3D
	{
		return (_ : _Stage).context3D;
	}

	@:noCompletion private function get_displayState():StageDisplayState
	{
		return (_ : _Stage).displayState;
	}

	@:noCompletion private function set_displayState(value:StageDisplayState):StageDisplayState
	{
		return (_ : _Stage).displayState = value;
	}

	#if (commonjs || (openfl_html5 && !lime))
	@:noCompletion private function get_element():Element
	{
		return (_ : _Stage).element;
	}
	#end

	@:noCompletion private function get_focus():InteractiveObject
	{
		return (_ : _Stage).focus;
	}

	@:noCompletion private function set_focus(value:InteractiveObject):InteractiveObject
	{
		return (_ : _Stage).focus = value;
	}

	@:noCompletion private function get_frameRate():Float
	{
		return (_ : _Stage).frameRate;
	}

	@:noCompletion private function set_frameRate(value:Float):Float
	{
		return (_ : _Stage).frameRate = value;
	}

	@:noCompletion private function get_fullScreenHeight():UInt
	{
		return (_ : _Stage).fullScreenHeight;
	}

	@:noCompletion private function get_fullScreenSourceRect():Rectangle
	{
		return (_ : _Stage).fullScreenSourceRect;
	}

	@:noCompletion private function set_fullScreenSourceRect(value:Rectangle):Rectangle
	{
		return (_ : _Stage).fullScreenSourceRect = value;
	}

	@:noCompletion private function get_fullScreenWidth():UInt
	{
		return (_ : _Stage).fullScreenWidth;
	}

	#if lime
	@:noCompletion private function get_limeApplication():Application
	{
		return (_ : _Stage).limeApplication;
	}

	@:noCompletion private function get_limeWindow():Window
	{
		return (_ : _Stage).limeWindow;
	}
	#end

	@:noCompletion private function get_quality():StageQuality
	{
		return (_ : _Stage).quality;
	}

	@:noCompletion private function set_quality(value:StageQuality):StageQuality
	{
		return (_ : _Stage).quality = value;
	}

	@:noCompletion private function get_scaleMode():StageScaleMode
	{
		return (_ : _Stage).scaleMode;
	}

	@:noCompletion private function set_scaleMode(value:StageScaleMode):StageScaleMode
	{
		return (_ : _Stage).scaleMode = value;
	}

	@:noCompletion private function get_showDefaultContextMenu():Bool
	{
		return (_ : _Stage).showDefaultContextMenu;
	}

	@:noCompletion private function set_showDefaultContextMenu(value:Bool):Bool
	{
		return (_ : _Stage).showDefaultContextMenu = value;
	}

	@:noCompletion private function get_softKeyboardRect():Rectangle
	{
		return (_ : _Stage).softKeyboardRect;
	}

	@:noCompletion private function set_softKeyboardRect(value:Rectangle):Rectangle
	{
		return (_ : _Stage).softKeyboardRect = value;
	}

	@:noCompletion private function get_stage3Ds():Vector<Stage3D>
	{
		return (_ : _Stage).stage3Ds;
	}

	@:noCompletion private function get_stageFocusRect():Bool
	{
		return (_ : _Stage).stageFocusRect;
	}

	@:noCompletion private function set_stageFocusRect(value:Bool):Bool
	{
		return (_ : _Stage).stageFocusRect = value;
	}

	@:noCompletion private function get_stageHeight():Int
	{
		return (_ : _Stage).stageHeight;
	}

	@:noCompletion private function get_stageWidth():Int
	{
		return (_ : _Stage).stageWidth;
	}
}
#else
typedef Stage = flash.display.Stage;
#end
