package flash.display {
	
	
	// import lime.app.Application in LimeApplication;
	// import lime.app.IModule;
	// import lime.app.Preloader;
	// import lime.graphics.RenderContext;
	// import lime.graphics.Renderer;
	// import lime.ui.Gamepad;
	// import lime.ui.GamepadAxis;
	// import lime.ui.GamepadButton;
	// import lime.ui.Joystick;
	// import lime.ui.JoystickHatPosition;
	// import lime.ui.KeyCode;
	// import lime.ui.KeyModifier;
	// import lime.ui.Touch;
	// import lime.ui.Window;
	import flash.geom.Rectangle;
	// import flash.Vector;
	
	
	/**
	 * @externs
	 * The Stage class represents the main drawing area.
	 *
	 * For SWF content running in the browser(in Flash<sup>®</sup> Player),
	 * the Stage represents the entire area where Flash content is shown. For
	 * content running in AIR on desktop operating systems, each NativeWindow
	 * object has a corresponding Stage object.
	 *
	 * The Stage object is not globally accessible. You need to access it
	 * through the `stage` property of a DisplayObject instance.
	 *
	 * The Stage class has several ancestor classes  -  DisplayObjectContainer,
	 * InteractiveObject, DisplayObject, and EventDispatcher  -  from which it
	 * inherits properties and methods. Many of these properties and methods are
	 * either inapplicable to Stage objects, or require security checks when
	 * called on a Stage object. The properties and methods that require security
	 * checks are documented as part of the Stage class.
	 *
	 * In addition, the following inherited properties are inapplicable to
	 * Stage objects. If you try to set them, an IllegalOperationError is thrown.
	 * These properties may always be read, but since they cannot be set, they
	 * will always contain default values.
	 *
	 * 
	 *  * `accessibilityProperties`
	 *  * `alpha`
	 *  * `blendMode`
	 *  * `cacheAsBitmap`
	 *  * `contextMenu`
	 *  * `filters`
	 *  * `focusRect`
	 *  * `loaderInfo`
	 *  * `mask`
	 *  * `mouseEnabled`
	 *  * `name`
	 *  * `opaqueBackground`
	 *  * `rotation`
	 *  * `scale9Grid`
	 *  * `scaleX`
	 *  * `scaleY`
	 *  * `scrollRect`
	 *  * `tabEnabled`
	 *  * `tabIndex`
	 *  * `transform`
	 *  * `visible`
	 *  * `x`
	 *  * `y`
	 * 
	 *
	 * Some events that you might expect to be a part of the Stage class, such
	 * as `enterFrame`, `exitFrame`,
	 * `frameConstructed`, and `render`, cannot be Stage
	 * events because a reference to the Stage object cannot be guaranteed to
	 * exist in every situation where these events are used. Because these events
	 * cannot be dispatched by the Stage object, they are instead dispatched by
	 * every DisplayObject instance, which means that you can add an event
	 * listener to any DisplayObject instance to listen for these events. These
	 * events, which are part of the DisplayObject class, are called broadcast
	 * events to differentiate them from events that target a specific
	 * DisplayObject instance. Two other broadcast events, `activate`
	 * and `deactivate`, belong to DisplayObject's superclass,
	 * EventDispatcher. The `activate` and `deactivate`
	 * events behave similarly to the DisplayObject broadcast events, except that
	 * these two events are dispatched not only by all DisplayObject instances,
	 * but also by all EventDispatcher instances and instances of other
	 * EventDispatcher subclasses. For more information on broadcast events, see
	 * the DisplayObject class.
	 * 
	 * @event fullScreen             Dispatched when the Stage object enters, or
	 *                               leaves, full-screen mode. A change in
	 *                               full-screen mode can be initiated through
	 *                               ActionScript, or the user invoking a keyboard
	 *                               shortcut, or if the current focus leaves the
	 *                               full-screen window.
	 * @event mouseLeave             Dispatched by the Stage object when the
	 *                               pointer moves out of the stage area. If the
	 *                               mouse button is pressed, the event is not
	 *                               dispatched.
	 * @event orientationChange      Dispatched by the Stage object when the stage
	 *                               orientation changes.
	 *
	 *                               Orientation changes can occur when the
	 *                               user rotates the device, opens a slide-out
	 *                               keyboard, or when the
	 *                               `setAspectRatio()` is called.
	 *
	 *                               **Note:** If the
	 *                               `autoOrients` property is
	 *                               `false`, then the stage
	 *                               orientation does not change when a device is
	 *                               rotated. Thus, StageOrientationEvents are
	 *                               only dispatched for device rotation when
	 *                               `autoOrients` is
	 *                               `true`.
	 * @event orientationChanging    Dispatched by the Stage object when the stage
	 *                               orientation begins changing.
	 *
	 *                               **Important:** orientationChanging
	 *                               events are not dispatched on Android
	 *                               devices.
	 *
	 *                               **Note:** If the
	 *                               `autoOrients` property is
	 *                               `false`, then the stage
	 *                               orientation does not change when a device is
	 *                               rotated. Thus, StageOrientationEvents are
	 *                               only dispatched for device rotation when
	 *                               `autoOrients` is
	 *                               `true`.
	 * @event resize                 Dispatched when the `scaleMode`
	 *                               property of the Stage object is set to
	 *                               `StageScaleMode.NO_SCALE` and the
	 *                               SWF file is resized.
	 * @event stageVideoAvailability Dispatched by the Stage object when the state
	 *                               of the stageVideos property changes.
	 */
	public class Stage extends DisplayObjectContainer /*implements IModule*/ {
		
		
		/**
		 * A value from the StageAlign class that specifies the alignment of the
		 * stage in Flash Player or the browser. The following are valid values:
		 *
		 * The `align` property is only available to an object that is
		 * in the same security sandbox as the Stage owner(the main SWF file). To
		 * avoid this, the Stage owner can grant permission to the domain of the
		 * calling object by calling the `Security.allowDomain()` method
		 * or the `Security.alowInsecureDomain()` method. For more
		 * information, see the "Security" chapter in the _ActionScript 3.0
		 * Developer's Guide_.
		 */
		public var align:String;
		
		/**
		 * Specifies whether this stage allows the use of the full screen mode
		 */
		public function get allowsFullScreen ():Boolean { return false; };
		
		/**
		 * Specifies whether this stage allows the use of the full screen with text input mode
		 */
		public function get allowsFullScreenInteractive ():Boolean { return false; }
		
		//public var application (default, null):Application;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash15) public var browserZoomFactor (default, null):Float;
		// #end
		
		/**
		 * The window background color.
		 */
		public function get color ():uint { return 0; }
		public function set color (value:uint):void {}
		
		protected function get_color ():uint { return 0; }
		protected function set_color (value:uint):uint { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var colorCorrection:flash.display.ColorCorrection;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var colorCorrectionSupport (default, null):flash.display.ColorCorrectionSupport;
		// #end
		
		public function get contentsScaleFactor ():Number { return 0; }
		
		protected function get_contentsScaleFactor ():Number { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public var displayContextInfo (default, null):String;
		// #end
		
		/**
		 * A value from the StageDisplayState class that specifies which display
		 * state to use. The following are valid values:
		 * 
		 *  * `StageDisplayState.FULL_SCREEN` Sets AIR application or
		 * Flash runtime to expand the stage over the user's entire screen, with
		 * keyboard input disabled.
		 *  * `StageDisplayState.FULL_SCREEN_INTERACTIVE` Sets the AIR
		 * application to expand the stage over the user's entire screen, with
		 * keyboard input allowed.(Not available for content running in Flash
		 * Player.)
		 *  * `StageDisplayState.NORMAL` Sets the Flash runtime back to
		 * the standard stage display mode.
		 * 
		 *
		 * The scaling behavior of the movie in full-screen mode is determined by
		 * the `scaleMode` setting(set using the
		 * `Stage.scaleMode` property or the SWF file's `embed`
		 * tag settings in the HTML file). If the `scaleMode` property is
		 * set to `noScale` while the application transitions to
		 * full-screen mode, the Stage `width` and `height`
		 * properties are updated, and the Stage dispatches a `resize`
		 * event. If any other scale mode is set, the stage and its contents are
		 * scaled to fill the new screen dimensions. The Stage object retains its
		 * original `width` and `height` values and does not
		 * dispatch a `resize` event.
		 *
		 * The following restrictions apply to SWF files that play within an HTML
		 * page(not those using the stand-alone Flash Player or not running in the
		 * AIR runtime):
		 *
		 * 
		 *  * To enable full-screen mode, add the `allowFullScreen`
		 * parameter to the `object` and `embed` tags in the
		 * HTML page that includes the SWF file, with `allowFullScreen`
		 * set to `"true"`, as shown in the following example: 
		 *  * Full-screen mode is initiated in response to a mouse click or key
		 * press by the user; the movie cannot change `Stage.displayState`
		 * without user input. Flash runtimes restrict keyboard input in full-screen
		 * mode. Acceptable keys include keyboard shortcuts that terminate
		 * full-screen mode and non-printing keys such as arrows, space, Shift, and
		 * Tab keys. Keyboard shortcuts that terminate full-screen mode are: Escape
		 * (Windows, Linux, and Mac), Control+W(Windows), Command+W(Mac), and
		 * Alt+F4.
		 *
		 * A Flash runtime dialog box appears over the movie when users enter
		 * full-screen mode to inform the users they are in full-screen mode and that
		 * they can press the Escape key to end full-screen mode.
		 * 
		 *  * Starting with Flash Player 9.0.115.0, full-screen works the same in
		 * windowless mode as it does in window mode. If you set the Window Mode
		 * (`wmode` in the HTML) to Opaque Windowless
		 * (`opaque`) or Transparent Windowless
		 * (`transparent`), full-screen can be initiated, but the
		 * full-screen window will always be opaque.
		 * 
		 *
		 * These restrictions are _not_ present for SWF content running in
		 * the stand-alone Flash Player or in AIR. AIR supports an interactive
		 * full-screen mode which allows keyboard input.
		 *
		 * For AIR content running in full-screen mode, the system screen saver
		 * and power saving options are disabled while video content is playing and
		 * until either the video stops or full-screen mode is exited.
		 *
		 * On Linux, setting `displayState` to
		 * `StageDisplayState.FULL_SCREEN` or
		 * `StageDisplayState.FULL_SCREEN_INTERACTIVE` is an asynchronous
		 * operation.
		 * 
		 * @throws SecurityError Calling the `displayState` property of a
		 *                       Stage object throws an exception for any caller that
		 *                       is not in the same security sandbox as the Stage
		 *                       owner(the main SWF file). To avoid this, the Stage
		 *                       owner can grant permission to the domain of the
		 *                       caller by calling the
		 *                       `Security.allowDomain()` method or the
		 *                       `Security.allowInsecureDomain()` method.
		 *                       For more information, see the "Security" chapter in
		 *                       the _ActionScript 3.0 Developer's Guide_.
		 *                       Trying to set the `displayState` property
		 *                       while the settings dialog is displayed, without a
		 *                       user response, or if the `param` or
		 *                       `embed` HTML tag's
		 *                       `allowFullScreen` attribute is not set to
		 *                       `true` throws a security error.
		 */
		public var displayState:String;
		
		protected function get_displayState ():String { return null; }
		protected function set_displayState (value:String):String { return null; }
		
		public function get element ():* { return null; }
		// public var element (default, never):js.html.Element;
		
		/**
		 * The interactive object with keyboard focus; or `null` if focus
		 * is not set or if the focused object belongs to a security sandbox to which
		 * the calling object does not have access.
		 * 
		 * @throws Error Throws an error if focus cannot be set to the target.
		 */
		public var focus:InteractiveObject;
		
		protected function get_focus ():InteractiveObject { return null; }
		protected function set_focus (value:InteractiveObject):InteractiveObject { return null; }
		
		/**
		 * Gets and sets the frame rate of the stage. The frame rate is defined as
		 * frames per second. By default the rate is set to the frame rate of the
		 * first SWF file loaded. Valid range for the frame rate is from 0.01 to 1000
		 * frames per second.
		 *
		 * **Note:** An application might not be able to follow high frame rate
		 * settings, either because the target platform is not fast enough or the
		 * player is synchronized to the vertical blank timing of the display device
		 * (usually 60 Hz on LCD devices). In some cases, a target platform might
		 * also choose to lower the maximum frame rate if it anticipates high CPU
		 * usage.
		 *
		 * For content running in Adobe AIR, setting the `frameRate`
		 * property of one Stage object changes the frame rate for all Stage objects
		 * (used by different NativeWindow objects). 
		 * 
		 * @throws SecurityError Calling the `frameRate` property of a
		 *                       Stage object throws an exception for any caller that
		 *                       is not in the same security sandbox as the Stage
		 *                       owner(the main SWF file). To avoid this, the Stage
		 *                       owner can grant permission to the domain of the
		 *                       caller by calling the
		 *                       `Security.allowDomain()` method or the
		 *                       `Security.allowInsecureDomain()` method.
		 *                       For more information, see the "Security" chapter in
		 *                       the _ActionScript 3.0 Developer's Guide_.
		 */
		public function get frameRate ():Number { return 0; }
		public function set frameRate (value:Number):void {}
		
		protected function get_frameRate ():Number { return 0; }
		protected function set_frameRate (value:Number):Number { return 0; }
		
		public function get fullScreenHeight ():uint { return 0; }
		
		protected function get_fullScreenHeight ():uint { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) public var fullScreenSourceRect:Rectangle;
		// #end
		
		public function get fullScreenWidth ():uint { return 0; }
		
		protected function get_fullScreenWidth ():uint { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11_2) public var mouseLock:Bool;
		// #end
		
		/**
		 * A value from the StageQuality class that specifies which rendering quality
		 * is used. The following are valid values:
		 * 
		 *  * `StageQuality.LOW` - Low rendering quality. Graphics are
		 * not anti-aliased, and bitmaps are not smoothed, but runtimes still use
		 * mip-mapping.
		 *  * `StageQuality.MEDIUM` - Medium rendering quality.
		 * Graphics are anti-aliased using a 2 x 2 pixel grid, bitmap smoothing is
		 * dependent on the `Bitmap.smoothing` setting. Runtimes use
		 * mip-mapping. This setting is suitable for movies that do not contain
		 * text.
		 *  * `StageQuality.HIGH` - High rendering quality. Graphics
		 * are anti-aliased using a 4 x 4 pixel grid, and bitmap smoothing is
		 * dependent on the `Bitmap.smoothing` setting. Runtimes use
		 * mip-mapping. This is the default rendering quality setting that Flash
		 * Player uses.
		 *  * `StageQuality.BEST` - Very high rendering quality.
		 * Graphics are anti-aliased using a 4 x 4 pixel grid. If
		 * `Bitmap.smoothing` is `true` the runtime uses a high
		 * quality downscale algorithm that produces fewer artifacts(however, using
		 * `StageQuality.BEST` with `Bitmap.smoothing` set to
		 * `true` slows performance significantly and is not a recommended
		 * setting).
		 * 
		 *
		 * Higher quality settings produce better rendering of scaled bitmaps.
		 * However, higher quality settings are computationally more expensive. In
		 * particular, when rendering scaled video, using higher quality settings can
		 * reduce the frame rate. 
		 *
		 * In the desktop profile of Adobe AIR, `quality` can be set to
		 * `StageQuality.BEST` or `StageQuality.HIGH`(and the
		 * default value is `StageQuality.HIGH`). Attempting to set it to
		 * another value has no effect(and the property remains unchanged). In the
		 * moble profile of AIR, all four quality settings are available. The default
		 * value on mobile devices is `StageQuality.MEDIUM`.
		 *
		 * For content running in Adobe AIR, setting the `quality`
		 * property of one Stage object changes the rendering quality for all Stage
		 * objects(used by different NativeWindow objects). 
		 * **_Note:_** The operating system draws the device fonts, which are
		 * therefore unaffected by the `quality` property.
		 * 
		 * @throws SecurityError Calling the `quality` property of a Stage
		 *                       object throws an exception for any caller that is
		 *                       not in the same security sandbox as the Stage owner
		 *                      (the main SWF file). To avoid this, the Stage owner
		 *                       can grant permission to the domain of the caller by
		 *                       calling the `Security.allowDomain()`
		 *                       method or the
		 *                       `Security.allowInsecureDomain()` method.
		 *                       For more information, see the "Security" chapter in
		 *                       the _ActionScript 3.0 Developer's Guide_.
		 */
		public var quality:String;
		
		protected function get_quality ():String { return null; }
		protected function set_quality (value:String):String { return null; }
		
		/**
		 * A value from the StageScaleMode class that specifies which scale mode to
		 * use. The following are valid values:
		 * 
		 *  * `StageScaleMode.EXACT_FIT` - The entire application is
		 * visible in the specified area without trying to preserve the original
		 * aspect ratio. Distortion can occur, and the application may appear
		 * stretched or compressed. 
		 *  * `StageScaleMode.SHOW_ALL` - The entire application is
		 * visible in the specified area without distortion while maintaining the
		 * original aspect ratio of the application. Borders can appear on two sides
		 * of the application. 
		 *  * `StageScaleMode.NO_BORDER` - The entire application fills
		 * the specified area, without distortion but possibly with some cropping,
		 * while maintaining the original aspect ratio of the application. 
		 *  * `StageScaleMode.NO_SCALE` - The entire application is
		 * fixed, so that it remains unchanged even as the size of the player window
		 * changes. Cropping might occur if the player window is smaller than the
		 * content. 
		 * 
		 * 
		 * @throws SecurityError Calling the `scaleMode` property of a
		 *                       Stage object throws an exception for any caller that
		 *                       is not in the same security sandbox as the Stage
		 *                       owner(the main SWF file). To avoid this, the Stage
		 *                       owner can grant permission to the domain of the
		 *                       caller by calling the
		 *                       `Security.allowDomain()` method or the
		 *                       `Security.allowInsecureDomain()` method.
		 *                       For more information, see the "Security" chapter in
		 *                       the _ActionScript 3.0 Developer's Guide_.
		 */
		public var scaleMode:String;
		
		protected function get_scaleMode ():String { return null; }
		protected function set_scaleMode (value:String):String { return null; }
		
		public var showDefaultContextMenu:Boolean;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public var softKeyboardRect (default, null):Rectangle;
		// #end
		
		public function get stage3Ds ():Vector.<Stage3D> { return null; }
		
		/**
		 * Specifies whether or not objects display a glowing border when they have
		 * focus.
		 * 
		 * @throws SecurityError Calling the `stageFocusRect` property of
		 *                       a Stage object throws an exception for any caller
		 *                       that is not in the same security sandbox as the
		 *                       Stage owner(the main SWF file). To avoid this, the
		 *                       Stage owner can grant permission to the domain of
		 *                       the caller by calling the
		 *                       `Security.allowDomain()` method or the
		 *                       `Security.allowInsecureDomain()` method.
		 *                       For more information, see the "Security" chapter in
		 *                       the _ActionScript 3.0 Developer's Guide_.
		 */
		public var stageFocusRect:Boolean;
		
		/**
		 * The current height, in pixels, of the Stage.
		 *
		 * If the value of the `Stage.scaleMode` property is set to
		 * `StageScaleMode.NO_SCALE` when the user resizes the window, the
		 * Stage content maintains its size while the `stageHeight`
		 * property changes to reflect the new height size of the screen area
		 * occupied by the SWF file.(In the other scale modes, the
		 * `stageHeight` property always reflects the original height of
		 * the SWF file.) You can add an event listener for the `resize`
		 * event and then use the `stageHeight` property of the Stage
		 * class to determine the actual pixel dimension of the resized Flash runtime
		 * window. The event listener allows you to control how the screen content
		 * adjusts when the user resizes the window.
		 *
		 * Air for TV devices have slightly different behavior than desktop
		 * devices when you set the `stageHeight` property. If the
		 * `Stage.scaleMode` property is set to
		 * `StageScaleMode.NO_SCALE` and you set the
		 * `stageHeight` property, the stage height does not change until
		 * the next frame of the SWF.
		 *
		 * **Note:** In an HTML page hosting the SWF file, both the
		 * `object` and `embed` tags' `height`
		 * attributes must be set to a percentage(such as `100%`), not
		 * pixels. If the settings are generated by JavaScript code, the
		 * `height` parameter of the `AC_FL_RunContent() `
		 * method must be set to a percentage, too. This percentage is applied to the
		 * `stageHeight` value.
		 * 
		 * @throws SecurityError Calling the `stageHeight` property of a
		 *                       Stage object throws an exception for any caller that
		 *                       is not in the same security sandbox as the Stage
		 *                       owner(the main SWF file). To avoid this, the Stage
		 *                       owner can grant permission to the domain of the
		 *                       caller by calling the
		 *                       `Security.allowDomain()` method or the
		 *                       `Security.allowInsecureDomain()` method.
		 *                       For more information, see the "Security" chapter in
		 *                       the _ActionScript 3.0 Developer's Guide_.
		 */
		public function get stageHeight ():int { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_2) public var stageVideos (default, null):flash.Vector<flash.media.StageVideo>;
		// #end
		
		/**
		 * Specifies the current width, in pixels, of the Stage.
		 *
		 * If the value of the `Stage.scaleMode` property is set to
		 * `StageScaleMode.NO_SCALE` when the user resizes the window, the
		 * Stage content maintains its defined size while the `stageWidth`
		 * property changes to reflect the new width size of the screen area occupied
		 * by the SWF file.(In the other scale modes, the `stageWidth`
		 * property always reflects the original width of the SWF file.) You can add
		 * an event listener for the `resize` event and then use the
		 * `stageWidth` property of the Stage class to determine the
		 * actual pixel dimension of the resized Flash runtime window. The event
		 * listener allows you to control how the screen content adjusts when the
		 * user resizes the window.
		 *
		 * Air for TV devices have slightly different behavior than desktop
		 * devices when you set the `stageWidth` property. If the
		 * `Stage.scaleMode` property is set to
		 * `StageScaleMode.NO_SCALE` and you set the
		 * `stageWidth` property, the stage width does not change until
		 * the next frame of the SWF.
		 *
		 * **Note:** In an HTML page hosting the SWF file, both the
		 * `object` and `embed` tags' `width`
		 * attributes must be set to a percentage(such as `100%`), not
		 * pixels. If the settings are generated by JavaScript code, the
		 * `width` parameter of the `AC_FL_RunContent() `
		 * method must be set to a percentage, too. This percentage is applied to the
		 * `stageWidth` value.
		 * 
		 * @throws SecurityError Calling the `stageWidth` property of a
		 *                       Stage object throws an exception for any caller that
		 *                       is not in the same security sandbox as the Stage
		 *                       owner(the main SWF file). To avoid this, the Stage
		 *                       owner can grant permission to the domain of the
		 *                       caller by calling the
		 *                       `Security.allowDomain()` method or the
		 *                       `Security.allowInsecureDomain()` method.
		 *                       For more information, see the "Security" chapter in
		 *                       the _ActionScript 3.0 Developer's Guide_.
		 */
		public function get stageWidth ():int { return 0; }
		
		//public var window (default, null):Window;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var wmodeGPU (default, null):Bool;
		// #end
		
		
		// #if !flash
		//public function new (window:Window, color:Null<Int> = null);
		public function Stage (width:int = 0, height:int = 0, color:Object = null, documentClass:Class = null, windowConfig:Object = null) {}
		// #end
		
		
		/**
		 * Calling the `invalidate()` method signals Flash runtimes to
		 * alert display objects on the next opportunity it has to render the display
		 * list(for example, when the playhead advances to a new frame). After you
		 * call the `invalidate()` method, when the display list is next
		 * rendered, the Flash runtime sends a `render` event to each
		 * display object that has registered to listen for the `render`
		 * event. You must call the `invalidate()` method each time you
		 * want the Flash runtime to send `render` events.
		 *
		 * The `render` event gives you an opportunity to make changes
		 * to the display list immediately before it is actually rendered. This lets
		 * you defer updates to the display list until the latest opportunity. This
		 * can increase performance by eliminating unnecessary screen updates.
		 *
		 * The `render` event is dispatched only to display objects
		 * that are in the same security domain as the code that calls the
		 * `stage.invalidate()` method, or to display objects from a
		 * security domain that has been granted permission via the
		 * `Security.allowDomain()` method.
		 * 
		 */
		// public override function invalidate ():void {}
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function isFocusInaccessible ():Bool;
		// #end
		
		
		// @:noCompletion @:dox(hide) public function addRenderer (renderer:Renderer):Void;
		// @:noCompletion @:dox(hide) public function addWindow (window:Window):Void;
		// @:noCompletion @:dox(hide) public function registerModule (application:LimeApplication):Void;
		// @:noCompletion @:dox(hide) public function removeRenderer (renderer:Renderer):Void;
		// @:noCompletion @:dox(hide) public function removeWindow (window:Window):Void;
		// @:noCompletion @:dox(hide) public function setPreloader (preloader:Preloader):Void;
		// @:noCompletion @:dox(hide) public function unregisterModule (application:LimeApplication):Void;
		// @:noCompletion @:dox(hide) public function onGamepadAxisMove (gamepad:Gamepad, axis:GamepadAxis, value:Float):Void;
		// @:noCompletion @:dox(hide) public function onGamepadButtonDown (gamepad:Gamepad, button:GamepadButton):Void;
		// @:noCompletion @:dox(hide) public function onGamepadButtonUp (gamepad:Gamepad, button:GamepadButton):Void;
		// @:noCompletion @:dox(hide) public function onGamepadConnect (gamepad:Gamepad):Void;
		// @:noCompletion @:dox(hide) public function onGamepadDisconnect (gamepad:Gamepad):Void;
		// @:noCompletion @:dox(hide) public function onJoystickAxisMove (joystick:Joystick, axis:Int, value:Float):Void;
		// @:noCompletion @:dox(hide) public function onJoystickButtonDown (joystick:Joystick, button:Int):Void;
		// @:noCompletion @:dox(hide) public function onJoystickButtonUp (joystick:Joystick, button:Int):Void;
		// @:noCompletion @:dox(hide) public function onJoystickConnect (joystick:Joystick):Void;
		// @:noCompletion @:dox(hide) public function onJoystickDisconnect (joystick:Joystick):Void;
		// @:noCompletion @:dox(hide) public function onJoystickHatMove (joystick:Joystick, hat:Int, position:JoystickHatPosition):Void;
		// @:noCompletion @:dox(hide) public function onJoystickTrackballMove (joystick:Joystick, trackball:Int, value:Float):Void;
		// @:noCompletion @:dox(hide) public function onKeyDown (window:Window, keyCode:KeyCode, modifier:KeyModifier):Void;
		// @:noCompletion @:dox(hide) public function onKeyUp (window:Window, keyCode:KeyCode, modifier:KeyModifier):Void;
		// @:noCompletion @:dox(hide) public function onModuleExit (code:Int):Void;
		// @:noCompletion @:dox(hide) public function onMouseDown (window:Window, x:Float, y:Float, button:Int):Void;
		// @:noCompletion @:dox(hide) public function onMouseMove (window:Window, x:Float, y:Float):Void;
		// @:noCompletion @:dox(hide) public function onMouseMoveRelative (window:Window, x:Float, y:Float):Void;
		// @:noCompletion @:dox(hide) public function onMouseUp (window:Window, x:Float, y:Float, button:Int):Void;
		// @:noCompletion @:dox(hide) public function onMouseWheel (window:Window, deltaX:Float, deltaY:Float):Void;
		// @:noCompletion @:dox(hide) public function onPreloadComplete ():Void;
		// @:noCompletion @:dox(hide) public function onPreloadProgress (loaded:Int, total:Int):Void;
		// @:noCompletion @:dox(hide) public function onRenderContextLost (renderer:Renderer):Void;
		// @:noCompletion @:dox(hide) public function onRenderContextRestored (renderer:Renderer, context:RenderContext):Void;
		// @:noCompletion @:dox(hide) public function onTextEdit (window:Window, text:String, start:Int, length:Int):Void;
		// @:noCompletion @:dox(hide) public function onTextInput (window:Window, text:String):Void;
		// @:noCompletion @:dox(hide) public function onTouchMove (touch:Touch):Void;
		// @:noCompletion @:dox(hide) public function onTouchEnd (touch:Touch):Void;
		// @:noCompletion @:dox(hide) public function onTouchStart (touch:Touch):Void;
		// @:noCompletion @:dox(hide) public function onWindowActivate (window:Window):Void;
		// @:noCompletion @:dox(hide) public function onWindowClose (window:Window):Void;
		// @:noCompletion @:dox(hide) public function onWindowCreate (window:Window):Void;
		// @:noCompletion @:dox(hide) public function onWindowDeactivate (window:Window):Void;
		// @:noCompletion @:dox(hide) public function onWindowDropFile (window:Window, file:String):Void;
		// @:noCompletion @:dox(hide) public function onWindowEnter (window:Window):Void;
		// @:noCompletion @:dox(hide) public function onWindowFocusIn (window:Window):Void;
		// @:noCompletion @:dox(hide) public function onWindowFocusOut (window:Window):Void;
		// @:noCompletion @:dox(hide) public function onWindowFullscreen (window:Window):Void;
		// @:noCompletion @:dox(hide) public function onWindowLeave (window:Window):Void;
		// @:noCompletion @:dox(hide) public function onWindowMinimize (window:Window):Void;
		// @:noCompletion @:dox(hide) public function onWindowMove (window:Window, x:Float, y:Float):Void;
		// @:noCompletion @:dox(hide) public function onWindowResize (window:Window, width:Int, height:Int):Void;
		// @:noCompletion @:dox(hide) public function onWindowRestore (window:Window):Void;
		// @:noCompletion @:dox(hide) public function render (renderer:Renderer):Void;
		// @:noCompletion @:dox(hide) public function update (deltaTime:Int):Void;
		
		
	}
	
	
}