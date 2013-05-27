package flash.display;
#if (flash || display)


/**
 * The Stage class represents the main drawing area.
 *
 * <p>For SWF content running in the browser(in Flash<sup>®</sup> Player),
 * the Stage represents the entire area where Flash content is shown. For
 * content running in AIR on desktop operating systems, each NativeWindow
 * object has a corresponding Stage object.</p>
 *
 * <p>The Stage object is not globally accessible. You need to access it
 * through the <code>stage</code> property of a DisplayObject instance.</p>
 *
 * <p>The Stage class has several ancestor classes  -  DisplayObjectContainer,
 * InteractiveObject, DisplayObject, and EventDispatcher  -  from which it
 * inherits properties and methods. Many of these properties and methods are
 * either inapplicable to Stage objects, or require security checks when
 * called on a Stage object. The properties and methods that require security
 * checks are documented as part of the Stage class.</p>
 *
 * <p>In addition, the following inherited properties are inapplicable to
 * Stage objects. If you try to set them, an IllegalOperationError is thrown.
 * These properties may always be read, but since they cannot be set, they
 * will always contain default values.</p>
 *
 * <ul>
 *   <li><code>accessibilityProperties</code></li>
 *   <li><code>alpha</code></li>
 *   <li><code>blendMode</code></li>
 *   <li><code>cacheAsBitmap</code></li>
 *   <li><code>contextMenu</code></li>
 *   <li><code>filters</code></li>
 *   <li><code>focusRect</code></li>
 *   <li><code>loaderInfo</code></li>
 *   <li><code>mask</code></li>
 *   <li><code>mouseEnabled</code></li>
 *   <li><code>name</code></li>
 *   <li><code>opaqueBackground</code></li>
 *   <li><code>rotation</code></li>
 *   <li><code>scale9Grid</code></li>
 *   <li><code>scaleX</code></li>
 *   <li><code>scaleY</code></li>
 *   <li><code>scrollRect</code></li>
 *   <li><code>tabEnabled</code></li>
 *   <li><code>tabIndex</code></li>
 *   <li><code>transform</code></li>
 *   <li><code>visible</code></li>
 *   <li><code>x</code></li>
 *   <li><code>y</code></li>
 * </ul>
 *
 * <p>Some events that you might expect to be a part of the Stage class, such
 * as <code>enterFrame</code>, <code>exitFrame</code>,
 * <code>frameConstructed</code>, and <code>render</code>, cannot be Stage
 * events because a reference to the Stage object cannot be guaranteed to
 * exist in every situation where these events are used. Because these events
 * cannot be dispatched by the Stage object, they are instead dispatched by
 * every DisplayObject instance, which means that you can add an event
 * listener to any DisplayObject instance to listen for these events. These
 * events, which are part of the DisplayObject class, are called broadcast
 * events to differentiate them from events that target a specific
 * DisplayObject instance. Two other broadcast events, <code>activate</code>
 * and <code>deactivate</code>, belong to DisplayObject's superclass,
 * EventDispatcher. The <code>activate</code> and <code>deactivate</code>
 * events behave similarly to the DisplayObject broadcast events, except that
 * these two events are dispatched not only by all DisplayObject instances,
 * but also by all EventDispatcher instances and instances of other
 * EventDispatcher subclasses. For more information on broadcast events, see
 * the DisplayObject class.</p>
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
 *                               <p>Orientation changes can occur when the
 *                               user rotates the device, opens a slide-out
 *                               keyboard, or when the
 *                               <code>setAspectRatio()</code> is called.</p>
 *
 *                               <p><b>Note:</b> If the
 *                               <code>autoOrients</code> property is
 *                               <code>false</code>, then the stage
 *                               orientation does not change when a device is
 *                               rotated. Thus, StageOrientationEvents are
 *                               only dispatched for device rotation when
 *                               <code>autoOrients</code> is
 *                               <code>true</code>.</p>
 * @event orientationChanging    Dispatched by the Stage object when the stage
 *                               orientation begins changing.
 *
 *                               <p><b>Important:</b> orientationChanging
 *                               events are not dispatched on Android
 *                               devices.</p>
 *
 *                               <p><b>Note:</b> If the
 *                               <code>autoOrients</code> property is
 *                               <code>false</code>, then the stage
 *                               orientation does not change when a device is
 *                               rotated. Thus, StageOrientationEvents are
 *                               only dispatched for device rotation when
 *                               <code>autoOrients</code> is
 *                               <code>true</code>.</p>
 * @event resize                 Dispatched when the <code>scaleMode</code>
 *                               property of the Stage object is set to
 *                               <code>StageScaleMode.NO_SCALE</code> and the
 *                               SWF file is resized.
 * @event stageVideoAvailability Dispatched by the Stage object when the state
 *                               of the stageVideos property changes.
 */
extern class Stage extends DisplayObjectContainer {

	/**
	 * A value from the StageAlign class that specifies the alignment of the
	 * stage in Flash Player or the browser. The following are valid values:
	 *
	 * <p>The <code>align</code> property is only available to an object that is
	 * in the same security sandbox as the Stage owner(the main SWF file). To
	 * avoid this, the Stage owner can grant permission to the domain of the
	 * calling object by calling the <code>Security.allowDomain()</code> method
	 * or the <code>Security.alowInsecureDomain()</code> method. For more
	 * information, see the "Security" chapter in the <i>ActionScript 3.0
	 * Developer's Guide</i>.</p>
	 */
	var align : StageAlign;

	/**
	 * Specifies whether this stage allows the use of the full screen mode
	 */
	@:require(flash11) var allowsFullScreen(default,null) : Bool;

	/**
	 */
	@:require(flash10_2) var color : Int;

	/**
	 * Controls Flash runtime color correction for displays. Color correction
	 * works only if the main monitor is assigned a valid ICC color profile,
	 * which specifies the device's particular color attributes. By default, the
	 * Flash runtime tries to match the color correction of its host(usually a
	 * browser).
	 *
	 * <p>Use the <code>Stage.colorCorrectionSupport</code> property to determine
	 * if color correction is available on the current system and the default
	 * state. . If color correction is available, all colors on the stage are
	 * assumed to be in the sRGB color space, which is the most standard color
	 * space. Source profiles of input devices are not considered during color
	 * correction. No input color correction is applied; only the stage output is
	 * mapped to the main monitor's ICC color profile.</p>
	 *
	 * <p>In general, the benefits of activating color management include
	 * predictable and consistent color, better conversion, accurate proofing and
	 * more efficient cross-media output. Be aware, though, that color management
	 * does not provide perfect conversions due to devices having a different
	 * gamut from each other or original images. Nor does color management
	 * eliminate the need for custom or edited profiles. Color profiles are
	 * dependent on browsers, operating systems(OS), OS extensions, output
	 * devices, and application support.</p>
	 *
	 * <p>Applying color correction degrades the Flash runtime performance. A
	 * Flash runtime's color correction is document style color correction
	 * because all SWF movies are considered documents with implicit sRGB
	 * profiles. Use the <code>Stage.colorCorrectionSupport</code> property to
	 * tell the Flash runtime to correct colors when displaying the SWF file
	 * (document) to the display color space. Flash runtimes only compensates for
	 * differences between monitors, not for differences between input devices
	 * (camera/scanner/etc.). </p>
	 *
	 * <p>The three possible values are strings with corresponding constants in
	 * the flash.display.ColorCorrection class:</p>
	 *
	 * <ul>
	 *   <li><code>"default"</code>: Use the same color correction as the host
	 * system.</li>
	 *   <li><code>"on"</code>: Always perform color correction.</li>
	 *   <li><code>"off"</code>: Never perform color correction.</li>
	 * </ul>
	 */
	#if !display
	@:require(flash10) var colorCorrection : ColorCorrection;
	@:require(flash11_4) var contentsScaleFactor(default, null) : Float;
	#end

	/**
	 * Specifies whether the Flash runtime is running on an operating system that
	 * supports color correction and whether the color profile of the main
	 * (primary) monitor can be read and understood by the Flash runtime. This
	 * property also returns the default state of color correction on the host
	 * system(usually the browser). Currently the return values can be:
	 *
	 * <p>The three possible values are strings with corresponding constants in
	 * the flash.display.ColorCorrectionSupport class:</p>
	 *
	 * <ul>
	 *   <li><code>"unsupported"</code>: Color correction is not available.</li>
	 *   <li><code>"defaultOn"</code>: Always performs color correction.</li>
	 *   <li><code>"defaultOff"</code>: Never performs color correction.</li>
	 * </ul>
	 */
	#if !display
	@:require(flash10) var colorCorrectionSupport(default,null) : ColorCorrectionSupport;
	@:require(flash11) var displayContextInfo(default, null) : String;
	#end

	/**
	 * A value from the StageDisplayState class that specifies which display
	 * state to use. The following are valid values:
	 * <ul>
	 *   <li><code>StageDisplayState.FULL_SCREEN</code> Sets AIR application or
	 * Flash runtime to expand the stage over the user's entire screen, with
	 * keyboard input disabled.</li>
	 *   <li><code>StageDisplayState.FULL_SCREEN_INTERACTIVE</code> Sets the AIR
	 * application to expand the stage over the user's entire screen, with
	 * keyboard input allowed.(Not available for content running in Flash
	 * Player.)</li>
	 *   <li><code>StageDisplayState.NORMAL</code> Sets the Flash runtime back to
	 * the standard stage display mode.</li>
	 * </ul>
	 *
	 * <p>The scaling behavior of the movie in full-screen mode is determined by
	 * the <code>scaleMode</code> setting(set using the
	 * <code>Stage.scaleMode</code> property or the SWF file's <code>embed</code>
	 * tag settings in the HTML file). If the <code>scaleMode</code> property is
	 * set to <code>noScale</code> while the application transitions to
	 * full-screen mode, the Stage <code>width</code> and <code>height</code>
	 * properties are updated, and the Stage dispatches a <code>resize</code>
	 * event. If any other scale mode is set, the stage and its contents are
	 * scaled to fill the new screen dimensions. The Stage object retains its
	 * original <code>width</code> and <code>height</code> values and does not
	 * dispatch a <code>resize</code> event.</p>
	 *
	 * <p>The following restrictions apply to SWF files that play within an HTML
	 * page(not those using the stand-alone Flash Player or not running in the
	 * AIR runtime):</p>
	 *
	 * <ul>
	 *   <li>To enable full-screen mode, add the <code>allowFullScreen</code>
	 * parameter to the <code>object</code> and <code>embed</code> tags in the
	 * HTML page that includes the SWF file, with <code>allowFullScreen</code>
	 * set to <code>"true"</code>, as shown in the following example: </li>
	 *   <li>Full-screen mode is initiated in response to a mouse click or key
	 * press by the user; the movie cannot change <code>Stage.displayState</code>
	 * without user input. Flash runtimes restrict keyboard input in full-screen
	 * mode. Acceptable keys include keyboard shortcuts that terminate
	 * full-screen mode and non-printing keys such as arrows, space, Shift, and
	 * Tab keys. Keyboard shortcuts that terminate full-screen mode are: Escape
	 * (Windows, Linux, and Mac), Control+W(Windows), Command+W(Mac), and
	 * Alt+F4.
	 *
	 * <p>A Flash runtime dialog box appears over the movie when users enter
	 * full-screen mode to inform the users they are in full-screen mode and that
	 * they can press the Escape key to end full-screen mode.</p>
	 * </li>
	 *   <li>Starting with Flash Player 9.0.115.0, full-screen works the same in
	 * windowless mode as it does in window mode. If you set the Window Mode
	 * (<code>wmode</code> in the HTML) to Opaque Windowless
	 * (<code>opaque</code>) or Transparent Windowless
	 * (<code>transparent</code>), full-screen can be initiated, but the
	 * full-screen window will always be opaque.</li>
	 * </ul>
	 *
	 * <p>These restrictions are <i>not</i> present for SWF content running in
	 * the stand-alone Flash Player or in AIR. AIR supports an interactive
	 * full-screen mode which allows keyboard input.</p>
	 *
	 * <p>For AIR content running in full-screen mode, the system screen saver
	 * and power saving options are disabled while video content is playing and
	 * until either the video stops or full-screen mode is exited.</p>
	 *
	 * <p>On Linux, setting <code>displayState</code> to
	 * <code>StageDisplayState.FULL_SCREEN</code> or
	 * <code>StageDisplayState.FULL_SCREEN_INTERACTIVE</code> is an asynchronous
	 * operation.</p>
	 * 
	 * @throws SecurityError Calling the <code>displayState</code> property of a
	 *                       Stage object throws an exception for any caller that
	 *                       is not in the same security sandbox as the Stage
	 *                       owner(the main SWF file). To avoid this, the Stage
	 *                       owner can grant permission to the domain of the
	 *                       caller by calling the
	 *                       <code>Security.allowDomain()</code> method or the
	 *                       <code>Security.allowInsecureDomain()</code> method.
	 *                       For more information, see the "Security" chapter in
	 *                       the <i>ActionScript 3.0 Developer's Guide</i>.
	 *                       Trying to set the <code>displayState</code> property
	 *                       while the settings dialog is displayed, without a
	 *                       user response, or if the <code>param</code> or
	 *                       <code>embed</code> HTML tag's
	 *                       <code>allowFullScreen</code> attribute is not set to
	 *                       <code>true</code> throws a security error.
	 */
	var displayState : StageDisplayState;

	/**
	 * The interactive object with keyboard focus; or <code>null</code> if focus
	 * is not set or if the focused object belongs to a security sandbox to which
	 * the calling object does not have access.
	 * 
	 * @throws Error Throws an error if focus cannot be set to the target.
	 */
	var focus : InteractiveObject;

	/**
	 * Gets and sets the frame rate of the stage. The frame rate is defined as
	 * frames per second. By default the rate is set to the frame rate of the
	 * first SWF file loaded. Valid range for the frame rate is from 0.01 to 1000
	 * frames per second.
	 *
	 * <p><b>Note:</b> An application might not be able to follow high frame rate
	 * settings, either because the target platform is not fast enough or the
	 * player is synchronized to the vertical blank timing of the display device
	 * (usually 60 Hz on LCD devices). In some cases, a target platform might
	 * also choose to lower the maximum frame rate if it anticipates high CPU
	 * usage.</p>
	 *
	 * <p>For content running in Adobe AIR, setting the <code>frameRate</code>
	 * property of one Stage object changes the frame rate for all Stage objects
	 * (used by different NativeWindow objects). </p>
	 * 
	 * @throws SecurityError Calling the <code>frameRate</code> property of a
	 *                       Stage object throws an exception for any caller that
	 *                       is not in the same security sandbox as the Stage
	 *                       owner(the main SWF file). To avoid this, the Stage
	 *                       owner can grant permission to the domain of the
	 *                       caller by calling the
	 *                       <code>Security.allowDomain()</code> method or the
	 *                       <code>Security.allowInsecureDomain()</code> method.
	 *                       For more information, see the "Security" chapter in
	 *                       the <i>ActionScript 3.0 Developer's Guide</i>.
	 */
	var frameRate : Float;

	/**
	 * Returns the height of the monitor that will be used when going to full
	 * screen size, if that state is entered immediately. If the user has
	 * multiple monitors, the monitor that's used is the monitor that most of the
	 * stage is on at the time.
	 *
	 * <p><b>Note</b>: If the user has the opportunity to move the browser from
	 * one monitor to another between retrieving the value and going to full
	 * screen size, the value could be incorrect. If you retrieve the value in an
	 * event handler that sets <code>Stage.displayState</code> to
	 * <code>StageDisplayState.FULL_SCREEN</code>, the value will be correct.</p>
	 *
	 * <p>This is the pixel height of the monitor and is the same as the stage
	 * height would be if <code>Stage.align</code> is set to
	 * <code>StageAlign.TOP_LEFT</code> and <code>Stage.scaleMode</code> is set
	 * to <code>StageScaleMode.NO_SCALE</code>.</p>
	 */
	var fullScreenHeight(default,null) : Int;

	/**
	 * Sets the Flash runtime to scale a specific region of the stage to
	 * full-screen mode. If available, the Flash runtime scales in hardware,
	 * which uses the graphics and video card on a user's computer, and generally
	 * displays content more quickly than software scaling.
	 *
	 * <p>When this property is set to a valid rectangle and the
	 * <code>displayState</code> property is set to full-screen mode, the Flash
	 * runtime scales the specified area. The actual Stage size in pixels within
	 * ActionScript does not change. The Flash runtime enforces a minimum limit
	 * for the size of the rectangle to accommodate the standard "Press Esc to
	 * exit full-screen mode" message. This limit is usually around 260 by 30
	 * pixels but can vary on platform and Flash runtime version.</p>
	 *
	 * <p>This property can only be set when the Flash runtime is not in
	 * full-screen mode. To use this property correctly, set this property first,
	 * then set the <code>displayState</code> property to full-screen mode, as
	 * shown in the code examples.</p>
	 *
	 * <p>To enable scaling, set the <code>fullScreenSourceRect</code> property
	 * to a rectangle object:</p>
	 *
	 * <p>The end user also can select within Flash Player Display Settings to
	 * turn off hardware scaling, which is enabled by default. For more
	 * information, see <a href="http://www.adobe.com/go/display_settings"
	 * scope="external">www.adobe.com/go/display_settings</a>.</p>
	 */
	var fullScreenSourceRect : flash.geom.Rectangle;

	/**
	 * Returns the width of the monitor that will be used when going to full
	 * screen size, if that state is entered immediately. If the user has
	 * multiple monitors, the monitor that's used is the monitor that most of the
	 * stage is on at the time.
	 *
	 * <p><b>Note</b>: If the user has the opportunity to move the browser from
	 * one monitor to another between retrieving the value and going to full
	 * screen size, the value could be incorrect. If you retrieve the value in an
	 * event handler that sets <code>Stage.displayState</code> to
	 * <code>StageDisplayState.FULL_SCREEN</code>, the value will be correct.</p>
	 *
	 * <p>This is the pixel width of the monitor and is the same as the stage
	 * width would be if <code>Stage.align</code> is set to
	 * <code>StageAlign.TOP_LEFT</code> and <code>Stage.scaleMode</code> is set
	 * to <code>StageScaleMode.NO_SCALE</code>.</p>
	 */
	var fullScreenWidth(default,null) : Int;

	/**
	 * A value from the StageQuality class that specifies which rendering quality
	 * is used. The following are valid values:
	 * <ul>
	 *   <li><code>StageQuality.LOW</code> - Low rendering quality. Graphics are
	 * not anti-aliased, and bitmaps are not smoothed, but runtimes still use
	 * mip-mapping.</li>
	 *   <li><code>StageQuality.MEDIUM</code> - Medium rendering quality.
	 * Graphics are anti-aliased using a 2 x 2 pixel grid, bitmap smoothing is
	 * dependent on the <code>Bitmap.smoothing</code> setting. Runtimes use
	 * mip-mapping. This setting is suitable for movies that do not contain
	 * text.</li>
	 *   <li><code>StageQuality.HIGH</code> - High rendering quality. Graphics
	 * are anti-aliased using a 4 x 4 pixel grid, and bitmap smoothing is
	 * dependent on the <code>Bitmap.smoothing</code> setting. Runtimes use
	 * mip-mapping. This is the default rendering quality setting that Flash
	 * Player uses.</li>
	 *   <li><code>StageQuality.BEST</code> - Very high rendering quality.
	 * Graphics are anti-aliased using a 4 x 4 pixel grid. If
	 * <code>Bitmap.smoothing</code> is <code>true</code> the runtime uses a high
	 * quality downscale algorithm that produces fewer artifacts(however, using
	 * <code>StageQuality.BEST</code> with <code>Bitmap.smoothing</code> set to
	 * <code>true</code> slows performance significantly and is not a recommended
	 * setting).</li>
	 * </ul>
	 *
	 * <p>Higher quality settings produce better rendering of scaled bitmaps.
	 * However, higher quality settings are computationally more expensive. In
	 * particular, when rendering scaled video, using higher quality settings can
	 * reduce the frame rate. </p>
	 *
	 * <p>In the desktop profile of Adobe AIR, <code>quality</code> can be set to
	 * <code>StageQuality.BEST</code> or <code>StageQuality.HIGH</code>(and the
	 * default value is <code>StageQuality.HIGH</code>). Attempting to set it to
	 * another value has no effect(and the property remains unchanged). In the
	 * moble profile of AIR, all four quality settings are available. The default
	 * value on mobile devices is <code>StageQuality.MEDIUM</code>.</p>
	 *
	 * <p>For content running in Adobe AIR, setting the <code>quality</code>
	 * property of one Stage object changes the rendering quality for all Stage
	 * objects(used by different NativeWindow objects). </p>
	 * <b><i>Note:</i></b> The operating system draws the device fonts, which are
	 * therefore unaffected by the <code>quality</code> property.
	 * 
	 * @throws SecurityError Calling the <code>quality</code> property of a Stage
	 *                       object throws an exception for any caller that is
	 *                       not in the same security sandbox as the Stage owner
	 *                      (the main SWF file). To avoid this, the Stage owner
	 *                       can grant permission to the domain of the caller by
	 *                       calling the <code>Security.allowDomain()</code>
	 *                       method or the
	 *                       <code>Security.allowInsecureDomain()</code> method.
	 *                       For more information, see the "Security" chapter in
	 *                       the <i>ActionScript 3.0 Developer's Guide</i>.
	 */
	var quality : StageQuality;

	/**
	 * A value from the StageScaleMode class that specifies which scale mode to
	 * use. The following are valid values:
	 * <ul>
	 *   <li><code>StageScaleMode.EXACT_FIT</code> - The entire application is
	 * visible in the specified area without trying to preserve the original
	 * aspect ratio. Distortion can occur, and the application may appear
	 * stretched or compressed. </li>
	 *   <li><code>StageScaleMode.SHOW_ALL</code> - The entire application is
	 * visible in the specified area without distortion while maintaining the
	 * original aspect ratio of the application. Borders can appear on two sides
	 * of the application. </li>
	 *   <li><code>StageScaleMode.NO_BORDER</code> - The entire application fills
	 * the specified area, without distortion but possibly with some cropping,
	 * while maintaining the original aspect ratio of the application. </li>
	 *   <li><code>StageScaleMode.NO_SCALE</code> - The entire application is
	 * fixed, so that it remains unchanged even as the size of the player window
	 * changes. Cropping might occur if the player window is smaller than the
	 * content. </li>
	 * </ul>
	 * 
	 * @throws SecurityError Calling the <code>scaleMode</code> property of a
	 *                       Stage object throws an exception for any caller that
	 *                       is not in the same security sandbox as the Stage
	 *                       owner(the main SWF file). To avoid this, the Stage
	 *                       owner can grant permission to the domain of the
	 *                       caller by calling the
	 *                       <code>Security.allowDomain()</code> method or the
	 *                       <code>Security.allowInsecureDomain()</code> method.
	 *                       For more information, see the "Security" chapter in
	 *                       the <i>ActionScript 3.0 Developer's Guide</i>.
	 */
	var scaleMode : StageScaleMode;

	/**
	 * Specifies whether to show or hide the default items in the Flash runtime
	 * context menu.
	 *
	 * <p>If the <code>showDefaultContextMenu</code> property is set to
	 * <code>true</code>(the default), all context menu items appear. If the
	 * <code>showDefaultContextMenu</code> property is set to <code>false</code>,
	 * only the Settings and About... menu items appear.</p>
	 * 
	 * @throws SecurityError Calling the <code>showDefaultContextMenu</code>
	 *                       property of a Stage object throws an exception for
	 *                       any caller that is not in the same security sandbox
	 *                       as the Stage owner(the main SWF file). To avoid
	 *                       this, the Stage owner can grant permission to the
	 *                       domain of the caller by calling the
	 *                       <code>Security.allowDomain()</code> method or the
	 *                       <code>Security.allowInsecureDomain()</code> method.
	 *                       For more information, see the "Security" chapter in
	 *                       the <i>ActionScript 3.0 Developer's Guide</i>.
	 */
	var showDefaultContextMenu : Bool;

	/**
	 * The area of the stage that is currently covered by the software keyboard.
	 *
	 * <p>The area has a size of zero(0,0,0,0) when the soft keyboard is not
	 * visible.</p>
	 *
	 * <p>When the keyboard opens, the <code>softKeyboardRect</code> is set at
	 * the time the softKeyboardActivate event is dispatched. If the keyboard
	 * changes size while open, the runtime updates the
	 * <code>softKeyboardRect</code> property and dispatches an additional
	 * softKeyboardActivate event.</p>
	 *
	 * <p><b>Note:</b> On Android, the area covered by the keyboard is estimated
	 * when the operating system does not provide the information necessary to
	 * determine the exact area. This problem occurs in fullscreen mode and also
	 * when the keyboard opens in response to an InteractiveObject receiving
	 * focus or invoking the <code>requestSoftKeyboard()</code> method.</p>
	 */
	@:require(flash11) var softKeyboardRect(default, null) : flash.geom.Rectangle;
	#if !display
	@:require(flash11) var stage3Ds(default,null) : flash.Vector<Stage3D>;
	#end

	/**
	 * Specifies whether or not objects display a glowing border when they have
	 * focus.
	 * 
	 * @throws SecurityError Calling the <code>stageFocusRect</code> property of
	 *                       a Stage object throws an exception for any caller
	 *                       that is not in the same security sandbox as the
	 *                       Stage owner(the main SWF file). To avoid this, the
	 *                       Stage owner can grant permission to the domain of
	 *                       the caller by calling the
	 *                       <code>Security.allowDomain()</code> method or the
	 *                       <code>Security.allowInsecureDomain()</code> method.
	 *                       For more information, see the "Security" chapter in
	 *                       the <i>ActionScript 3.0 Developer's Guide</i>.
	 */
	var stageFocusRect : Bool;

	/**
	 * The current height, in pixels, of the Stage.
	 *
	 * <p>If the value of the <code>Stage.scaleMode</code> property is set to
	 * <code>StageScaleMode.NO_SCALE</code> when the user resizes the window, the
	 * Stage content maintains its size while the <code>stageHeight</code>
	 * property changes to reflect the new height size of the screen area
	 * occupied by the SWF file.(In the other scale modes, the
	 * <code>stageHeight</code> property always reflects the original height of
	 * the SWF file.) You can add an event listener for the <code>resize</code>
	 * event and then use the <code>stageHeight</code> property of the Stage
	 * class to determine the actual pixel dimension of the resized Flash runtime
	 * window. The event listener allows you to control how the screen content
	 * adjusts when the user resizes the window.</p>
	 *
	 * <p>Air for TV devices have slightly different behavior than desktop
	 * devices when you set the <code>stageHeight</code> property. If the
	 * <code>Stage.scaleMode</code> property is set to
	 * <code>StageScaleMode.NO_SCALE</code> and you set the
	 * <code>stageHeight</code> property, the stage height does not change until
	 * the next frame of the SWF.</p>
	 *
	 * <p><b>Note:</b> In an HTML page hosting the SWF file, both the
	 * <code>object</code> and <code>embed</code> tags' <code>height</code>
	 * attributes must be set to a percentage(such as <code>100%</code>), not
	 * pixels. If the settings are generated by JavaScript code, the
	 * <code>height</code> parameter of the <code>AC_FL_RunContent() </code>
	 * method must be set to a percentage, too. This percentage is applied to the
	 * <code>stageHeight</code> value.</p>
	 * 
	 * @throws SecurityError Calling the <code>stageHeight</code> property of a
	 *                       Stage object throws an exception for any caller that
	 *                       is not in the same security sandbox as the Stage
	 *                       owner(the main SWF file). To avoid this, the Stage
	 *                       owner can grant permission to the domain of the
	 *                       caller by calling the
	 *                       <code>Security.allowDomain()</code> method or the
	 *                       <code>Security.allowInsecureDomain()</code> method.
	 *                       For more information, see the "Security" chapter in
	 *                       the <i>ActionScript 3.0 Developer's Guide</i>.
	 */
	var stageHeight : Int;

	/**
	 * A list of StageVideo objects available for playing external videos.
	 *
	 * <p>You can use only a limited number of StageVideo objects at a time. When
	 * a SWF begins to run, the number of available StageVideo objects depends on
	 * the platform and on available hardware. </p>
	 *
	 * <p>To use a StageVideo object, assign a member of the
	 * <code>stageVideos</code> Vector object to a StageVideo variable. </p>
	 *
	 * <p>All StageVideo objects are displayed on the stage behind any display
	 * objects. The StageVideo objects are displayed on the stage in the order
	 * they appear in the <code>stageVideos</code> Vector object. For example, if
	 * the <code>stageVideos</code> Vector object contains three entries:</p>
	 *
	 * <ol>
	 *   <li>The StageVideo object in the 0 index of the <code>stageVideos</code>
	 * Vector object is displayed behind all StageVideo objects.</li>
	 *   <li>The StageVideo object at index 1 is displayed in front of the
	 * StageVideo object at index 0.</li>
	 *   <li>The StageVideo object at index 2 is displayed in front of the
	 * StageVideo object at index 1.</li>
	 * </ol>
	 *
	 * <p>Use the <code>StageVideo.depth</code> property to change this
	 * ordering.</p>
	 *
	 * <p><b>Note:</b> AIR for TV devices support only one StageVideo object.</p>
	 */
	#if !display
	@:require(flash10_2) var stageVideos(default, null) : flash.Vector<flash.media.StageVideo>;
	#end

	/**
	 * Specifies the current width, in pixels, of the Stage.
	 *
	 * <p>If the value of the <code>Stage.scaleMode</code> property is set to
	 * <code>StageScaleMode.NO_SCALE</code> when the user resizes the window, the
	 * Stage content maintains its defined size while the <code>stageWidth</code>
	 * property changes to reflect the new width size of the screen area occupied
	 * by the SWF file.(In the other scale modes, the <code>stageWidth</code>
	 * property always reflects the original width of the SWF file.) You can add
	 * an event listener for the <code>resize</code> event and then use the
	 * <code>stageWidth</code> property of the Stage class to determine the
	 * actual pixel dimension of the resized Flash runtime window. The event
	 * listener allows you to control how the screen content adjusts when the
	 * user resizes the window.</p>
	 *
	 * <p>Air for TV devices have slightly different behavior than desktop
	 * devices when you set the <code>stageWidth</code> property. If the
	 * <code>Stage.scaleMode</code> property is set to
	 * <code>StageScaleMode.NO_SCALE</code> and you set the
	 * <code>stageWidth</code> property, the stage width does not change until
	 * the next frame of the SWF.</p>
	 *
	 * <p><b>Note:</b> In an HTML page hosting the SWF file, both the
	 * <code>object</code> and <code>embed</code> tags' <code>width</code>
	 * attributes must be set to a percentage(such as <code>100%</code>), not
	 * pixels. If the settings are generated by JavaScript code, the
	 * <code>width</code> parameter of the <code>AC_FL_RunContent() </code>
	 * method must be set to a percentage, too. This percentage is applied to the
	 * <code>stageWidth</code> value.</p>
	 * 
	 * @throws SecurityError Calling the <code>stageWidth</code> property of a
	 *                       Stage object throws an exception for any caller that
	 *                       is not in the same security sandbox as the Stage
	 *                       owner(the main SWF file). To avoid this, the Stage
	 *                       owner can grant permission to the domain of the
	 *                       caller by calling the
	 *                       <code>Security.allowDomain()</code> method or the
	 *                       <code>Security.allowInsecureDomain()</code> method.
	 *                       For more information, see the "Security" chapter in
	 *                       the <i>ActionScript 3.0 Developer's Guide</i>.
	 */
	var stageWidth : Int;

	/**
	 * Indicates whether GPU compositing is available and in use. The
	 * <code>wmodeGPU</code> value is <code>true</code> <i>only</i> when all
	 * three of the following conditions exist:
	 *
	 * <p>
	 * <ul>
	 *   <li>GPU compositing has been requested.</li>
	 *   <li>GPU compositing is available.</li>
	 *   <li>GPU compositing is in use.</li>
	 * </ul>
	 * </p>
	 *
	 * <p>Specifically, the <code>wmodeGPU</code> property indicates one of the
	 * following:</p>
	 *
	 * <p>
	 * <ol>
	 *   <li>GPU compositing has not been requested or is unavailable. In this
	 * case, the <code>wmodeGPU</code> property value is <code>false</code>.</li>
	 *   <li>GPU compositing has been requested(if applicable and available),
	 * but the environment is operating in "fallback mode"(not optimal
	 * rendering) due to limitations of the content. In this case, the
	 * <code>wmodeGPU</code> property value is <code>true</code>.</li>
	 *   <li>GPU compositing has been requested(if applicable and available),
	 * and the environment is operating in the best mode. In this case, the
	 * <code>wmodeGPU</code> property value is also <code>true</code>.</li>
	 * </ol>
	 * </p>
	 *
	 * <p>In other words, the <code>wmodeGPU</code> property identifies the
	 * capability and state of the rendering environment. For runtimes that do
	 * not support GPU compositing, such as AIR 1.5.2, the value is always
	 * <code>false</code>, because(as stated above) the value is
	 * <code>true</code> only when GPU compositing has been requested, is
	 * available, and is in use.</p>
	 *
	 * <p>The <code>wmodeGPU</code> property is useful to determine, at runtime,
	 * whether or not GPU compositing is in use. The value of
	 * <code>wmodeGPU</code> indicates if your content is going to be scaled by
	 * hardware, or not, so you can present graphics at the correct size. You can
	 * also determine if you're rendering in a fast path or not, so that you can
	 * adjust your content complexity accordingly.</p>
	 *
	 * <p>For Flash Player in a browser, GPU compositing can be requested by the
	 * value of <code>gpu</code> for the <code>wmode</code> HTML parameter in the
	 * page hosting the SWF file. For other configurations, GPU compositing can
	 * be requested in the header of a SWF file(set using SWF authoring
	 * tools).</p>
	 *
	 * <p>However, the <code>wmodeGPU</code> property does not identify the
	 * current rendering performance. Even if GPU compositing is "in use" the
	 * rendering process might not be operating in the best mode. To adjust your
	 * content for optimal rendering, use a Flash runtime debugger version, and
	 * set the <code>DisplayGPUBlendsetting</code> in your mm.cfg file.</p>
	 *
	 * <p><b>Note:</b> This property is always <code>false</code> when referenced
	 * from ActionScript that runs before the runtime performs its first
	 * rendering pass. For example, if you examine <code>wmodeGPU</code> from a
	 * script in Frame 1 of Adobe Flash Professional, and your SWF file is the
	 * first SWF file loaded in a new instance of the runtime, then the
	 * <code>wmodeGPU</code> value is <code>false</code>. To get an accurate
	 * value, wait until at least one rendering pass has occurred. If you write
	 * an event listener for the <code>exitFrame</code> event of any
	 * <code>DisplayObject</code>, the <code>wmodeGPU</code> value at is the
	 * correct value.</p>
	 */
	@:require(flash10_1) var wmodeGPU(default,null) : Bool;

	/**
	 * Calling the <code>invalidate()</code> method signals Flash runtimes to
	 * alert display objects on the next opportunity it has to render the display
	 * list(for example, when the playhead advances to a new frame). After you
	 * call the <code>invalidate()</code> method, when the display list is next
	 * rendered, the Flash runtime sends a <code>render</code> event to each
	 * display object that has registered to listen for the <code>render</code>
	 * event. You must call the <code>invalidate()</code> method each time you
	 * want the Flash runtime to send <code>render</code> events.
	 *
	 * <p>The <code>render</code> event gives you an opportunity to make changes
	 * to the display list immediately before it is actually rendered. This lets
	 * you defer updates to the display list until the latest opportunity. This
	 * can increase performance by eliminating unnecessary screen updates.</p>
	 *
	 * <p>The <code>render</code> event is dispatched only to display objects
	 * that are in the same security domain as the code that calls the
	 * <code>stage.invalidate()</code> method, or to display objects from a
	 * security domain that has been granted permission via the
	 * <code>Security.allowDomain()</code> method.</p>
	 * 
	 */
	function invalidate() : Void;

	/**
	 * Determines whether the <code>Stage.focus</code> property returns
	 * <code>null</code> for security reasons. In other words,
	 * <code>isFocusInaccessible</code> returns <code>true</code> if the object
	 * that has focus belongs to a security sandbox to which the SWF file does
	 * not have access.
	 * 
	 * @return <code>true</code> if the object that has focus belongs to a
	 *         security sandbox to which the SWF file does not have access.
	 */
	function isFocusInaccessible() : Bool;
}


#end
