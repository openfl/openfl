package openfl.display; #if !flash #if !openfl_legacy


import haxe.EnumFlags;
import lime.app.IModule;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.CanvasRenderContext;
import lime.graphics.DOMRenderContext;
import lime.graphics.GLRenderContext;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import lime.utils.GLUtils;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Mouse;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.cairo.CairoRenderer;
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl._internal.renderer.dom.DOMRenderer;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl.display.DisplayObjectContainer;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.events.TouchEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.ui.GameInput;
import openfl.ui.Keyboard;
import openfl.ui.KeyLocation;

#if hxtelemetry
import openfl.profiler.Telemetry;
#end

#if (js && html5)
import js.html.CanvasElement;
import js.html.DivElement;
import js.html.Element;
import js.Browser;
#end


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

@:access(openfl.events.Event)
@:access(openfl.ui.GameInput)
@:access(openfl.ui.Keyboard)


class Stage extends DisplayObjectContainer implements IModule {
	
	
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
	public var align:StageAlign;
	
	/**
	 * Specifies whether this stage allows the use of the full screen mode
	 */
	public var allowsFullScreen:Bool;
	
	/**
	 * The window background color.
	 */
	public var color (get, set):Int;
	
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
	public var displayState (get, set):StageDisplayState;
	
	/**
	 * The interactive object with keyboard focus; or <code>null</code> if focus
	 * is not set or if the focused object belongs to a security sandbox to which
	 * the calling object does not have access.
	 * 
	 * @throws Error Throws an error if focus cannot be set to the target.
	 */
	public var focus (get, set):InteractiveObject;
	
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
	public var frameRate (get, set):Float;
	
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
	public var quality:StageQuality;
	
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
	public var scaleMode:StageScaleMode;
	public var stage3Ds (default, null):Vector<Stage3D>;
	
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
	public var stageFocusRect:Bool;
	
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
	public var stageHeight (default, null):Int;
	
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
	public var stageWidth (default, null):Int;
	
	@:noCompletion private var __clearBeforeRender:Bool;
	@:noCompletion private var __color:Int;
	@:noCompletion private var __colorSplit:Array<Float>;
	@:noCompletion private var __colorString:String;
	@:noCompletion private var __dirty:Bool;
	@:noCompletion private var __displayState:StageDisplayState;
	@:noCompletion private var __dragBounds:Rectangle;
	@:noCompletion private var __dragObject:Sprite;
	@:noCompletion private var __dragOffsetX:Float;
	@:noCompletion private var __dragOffsetY:Float;
	@:noCompletion private var __focus:InteractiveObject;
	@:noCompletion private var __fullscreen:Bool;
	@:noCompletion private var __invalidated:Bool;
	@:noCompletion private var __lastClickTime:Int;
	@:noCompletion private var __mouseOutStack:Array<DisplayObject>;
	@:noCompletion private var __mouseX:Float;
	@:noCompletion private var __mouseY:Float;
	@:noCompletion private var __originalWidth:Int;
	@:noCompletion private var __originalHeight:Int;
	@:noCompletion private var __renderer:AbstractRenderer;
	@:noCompletion private var __rendering:Bool;
	@:noCompletion private var __stack:Array<DisplayObject>;
	@:noCompletion private var __transparent:Bool;
	@:noCompletion private var __wasDirty:Bool;
	
	#if (js && html5)
	//@:noCompletion private var __div:DivElement;
	//@:noCompletion private var __element:HtmlElement;
	#if stats
	@:noCompletion private var __stats:Dynamic;
	#end
	#end
	
	
	public function new (width:Int, height:Int, color:Null<Int> = null) {
		
		#if hxtelemetry
		Telemetry.__initialize ();
		#end
		
		super ();
		
		if (color == null) {
			
			__transparent = true;
			this.color = 0x000000;
			
		} else {
			
			this.color = color;
			
		}
		
		this.name = null;
		
		__displayState = NORMAL;
		__mouseX = 0;
		__mouseY = 0;
		__lastClickTime = 0;

		stageWidth = width;
		stageHeight = height;
		
		this.stage = this;
		
		align = StageAlign.TOP_LEFT;
		allowsFullScreen = false;
		quality = StageQuality.HIGH;
		scaleMode = StageScaleMode.NO_SCALE;
		stageFocusRect = true;
		
		__clearBeforeRender = true;
		__stack = [];
		__mouseOutStack = [];
		
		stage3Ds = new Vector ();
		stage3Ds.push (new Stage3D ());
		
	}
	
	
	public override function globalToLocal (pos:Point):Point {
		
		return pos;
		
	}
	
	
	public function init (context:RenderContext):Void {
		
		switch (context) {
			
			case OPENGL (gl):
				
				#if !disable_cffi
				__renderer = new GLRenderer (stageWidth, stageHeight, gl);
				#end
			
			case CANVAS (context):
				
				__renderer = new CanvasRenderer (stageWidth, stageHeight, context);
			
			case DOM (element):
				
				__renderer = new DOMRenderer (stageWidth, stageHeight, element);
			
			case CAIRO (cairo):
				
				__renderer = new CairoRenderer (stageWidth, stageHeight, cairo);
			
			default:
			
		}
		
	}
	
	
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
	public function invalidate ():Void {
		
		__invalidated = true;
		
	}
	
	
	public override function localToGlobal (pos:Point):Point {
		
		return pos;
		
	}
	
	
	public function onGamepadAxisMove (gamepad:Gamepad, axis:GamepadAxis, value:Float):Void {
		
		GameInput.__onGamepadAxisMove (gamepad, axis, value);
		
	}
	
	
	public function onGamepadButtonDown (gamepad:Gamepad, button:GamepadButton):Void {
		
		GameInput.__onGamepadButtonDown (gamepad, button);
		
	}
	
	
	public function onGamepadButtonUp (gamepad:Gamepad, button:GamepadButton):Void {
		
		GameInput.__onGamepadButtonUp (gamepad, button);
		
	}
	
	
	public function onGamepadConnect (gamepad:Gamepad):Void {
		
		GameInput.__onGamepadConnect (gamepad);
		
	}
	
	
	public function onGamepadDisconnect (gamepad:Gamepad):Void {
		
		GameInput.__onGamepadDisconnect (gamepad);
		
	}
	
	
	public function onKeyDown (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		__onKey (KeyboardEvent.KEY_DOWN, keyCode, modifier);
		
	}
	
	
	public function onKeyUp (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		__onKey (KeyboardEvent.KEY_UP, keyCode, modifier);
		
	}
	
	
	public function onMouseDown (x:Float, y:Float, button:Int):Void {
		
		var type = switch (button) {
			
			case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
			case 2: MouseEvent.RIGHT_MOUSE_DOWN;
			default: MouseEvent.MOUSE_DOWN;
			
		}
		
		__onMouse (type, x, y, button);
		
	}
	
	
	public function onMouseMove (x:Float, y:Float):Void {
		
		__onMouse (MouseEvent.MOUSE_MOVE, x, y, 0);
		
	}
	
	
	public function onMouseMoveRelative (x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onMouseUp (x:Float, y:Float, button:Int):Void {
		
		var type = switch (button) {
			
			case 1: MouseEvent.MIDDLE_MOUSE_UP;
			case 2: MouseEvent.RIGHT_MOUSE_UP;
			default: MouseEvent.MOUSE_UP;
			
		}
		
		__onMouse (type, x, y, button);
		
	}
	
	
	public function onMouseWheel (deltaX:Float, deltaY:Float):Void {
		
		__onMouseWheel (deltaX, deltaY);
		
	}
	
	
	public function onRenderContextLost ():Void {
		
		
		
	}
	
	
	public function onRenderContextRestored (context:RenderContext):Void {
		
		
		
	}
	
	
	public function onTextEdit (text:String, start:Int, length:Int):Void {
		
		
		
	}
	
	
	public function onTextInput (text:String):Void {
		
		var stack = new Array <DisplayObject> ();
		
		if (__focus == null) {
			
			__getInteractive (stack);
			
		} else {
			
			__focus.__getInteractive (stack);
			
		}
		
		var event = new TextEvent (TextEvent.TEXT_INPUT, true, false, text);
		if (stack.length > 0) {
			
			stack.reverse ();
			__fireEvent (event, stack);
		} else {
			
			__broadcast (event, true);
		}
		
	}
	
	
	public function onTouchMove (x:Float, y:Float, id:Int):Void {
		
		__onTouch (TouchEvent.TOUCH_MOVE, x, y, id);
		
	}
	
	
	public function onTouchEnd (x:Float, y:Float, id:Int):Void {
		
		__onTouch (TouchEvent.TOUCH_END, x, y, id);
		
	}
	
	
	public function onTouchStart (x:Float, y:Float, id:Int):Void {
		
		__onTouch (TouchEvent.TOUCH_BEGIN, x, y, id);
		
	}
	
	
	public function onWindowActivate ():Void {
		
		var event = new Event (Event.ACTIVATE);
		__broadcast (event, true);
		
	}
	
	
	public function onWindowClose ():Void {
		
		
		
	}
	
	
	public function onWindowDeactivate ():Void {
		
		var event = new Event (Event.DEACTIVATE);
		__broadcast (event, true);
		
	}
	
	
	public function onWindowEnter ():Void {
		
		
		
	}
	
	
	public function onWindowFocusIn ():Void {
		
		var event = new FocusEvent (FocusEvent.FOCUS_IN, true, false, null, false, 0);
		__broadcast (event, true);
		
	}
	
	
	public function onWindowFocusOut ():Void {
		
		var event = new FocusEvent (FocusEvent.FOCUS_OUT, true, false, null, false, 0);
		__broadcast (event, true);
		
	}
	
	
	public function onWindowFullscreen ():Void {
		
		
		
	}
	
	
	public function onWindowLeave ():Void {
		
		dispatchEvent (new Event (Event.MOUSE_LEAVE));
		
	}
	
	
	public function onWindowMinimize ():Void {
		
		
		
	}
	
	
	public function onWindowMove (x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onWindowResize (width:Int, height:Int):Void {
		
		stageWidth = width;
		stageHeight = height;
		
		if (__renderer != null) {
			
			__renderer.resize (width, height);
			
		}
		
		var event = new Event (Event.RESIZE);
		__broadcast (event, false);
		
	}
	
	
	public function onWindowRestore ():Void {
		
		
		
	}
	
	
	public function render (context:RenderContext):Void {
		
		if (__rendering) return;
		__rendering = true;
		
		#if hxtelemetry
		Telemetry.__advanceFrame ();
		#end
		
		__broadcast (new Event (Event.ENTER_FRAME), true);
		
		if (__invalidated) {
			
			__invalidated = false;
			__broadcast (new Event (Event.RENDER), true);
			
		}
		
		#if hxtelemetry
		var stack = Telemetry.__unwindStack ();
		Telemetry.__startTiming (TelemetryCommandName.RENDER);
		#end
		
		__renderable = true;
		__update (false, true);
		
		if (__renderer != null) {
			
			switch (context) {
				
				case CAIRO (cairo):
					
					cast (__renderer, CairoRenderer).cairo = cairo;
					@:privateAccess (__renderer.renderSession).cairo = cairo;
				
				default:
					
			}
			
			__renderer.render (this);
			
		}
		
		#if hxtelemetry
		Telemetry.__endTiming (TelemetryCommandName.RENDER);
		Telemetry.__rewindStack (stack);
		#end
		
		__rendering = false;
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		
		
	}
	
	
	@:noCompletion private function __drag (mouse:Point):Void {
		
		var parent = __dragObject.parent;
		if (parent != null) {
			
			mouse = parent.globalToLocal (mouse);
			
		}
		
		var x = mouse.x + __dragOffsetX;
		var y = mouse.y + __dragOffsetY;
		
		if (__dragBounds != null) {
			
			if (x < __dragBounds.x) {
				
				x = __dragBounds.x;
				
			} else if (x > __dragBounds.right) {
				
				x = __dragBounds.right;
				
			}
			
			if (y < __dragBounds.y) {
				
				y = __dragBounds.y;
				
			} else if (y > __dragBounds.bottom) {
				
				y = __dragBounds.bottom;
				
			}
			
		}
		
		__dragObject.x = x;
		__dragObject.y = y;
		
	}
	
	
	@:noCompletion private function __fireEvent (event:Event, stack:Array<DisplayObject>):Void {
		
		var length = stack.length;
		
		if (length == 0) {
			
			event.eventPhase = EventPhase.AT_TARGET;
			event.target.__broadcast (event, false);
			
		} else {
			
			event.eventPhase = EventPhase.CAPTURING_PHASE;
			event.target = stack[stack.length - 1];
			
			for (i in 0...length - 1) {
				
				stack[i].__broadcast (event, false);
				
				if (event.__isCancelled) {
					
					return;
					
				}
				
			}
			
			event.eventPhase = EventPhase.AT_TARGET;
			event.target.__broadcast (event, false);
			
			if (event.__isCancelled) {
				
				return;
				
			}
			
			if (event.bubbles) {
				
				event.eventPhase = EventPhase.BUBBLING_PHASE;
				var i = length - 2;
				
				while (i >= 0) {
					
					stack[i].__broadcast (event, false);
					
					if (event.__isCancelled) {
						
						return;
						
					}
					
					i--;
					
				}
				
			}
			
		}
		
	}
	
	
	@:noCompletion private override function __getInteractive (stack:Array<DisplayObject>):Bool {
		
		if (stack != null) {
			
			stack.push (this);
			
		}
		
		return true;
		
	}
	
	
	@:noCompletion private function __onKey (type:String, keyCode:KeyCode, modifier:KeyModifier):Void {
		
		MouseEvent.__altKey = modifier.altKey;
		MouseEvent.__commandKey = modifier.metaKey;
		MouseEvent.__ctrlKey = modifier.ctrlKey;
		MouseEvent.__shiftKey = modifier.shiftKey;
		
		var stack = new Array <DisplayObject> ();
		
		if (__focus == null) {
			
			__getInteractive (stack);
			
		} else {
			
			__focus.__getInteractive (stack);
			
		}
		
		if (stack.length > 0) {

			var keyLocation = Keyboard.__getKeyLocation (keyCode);
			var keyCode = Keyboard.__convertKeyCode (keyCode);
			var charCode = Keyboard.__getCharCode (keyCode, modifier.shiftKey);
			
			var event = new KeyboardEvent (type, true, false, charCode, keyCode, keyLocation, modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.metaKey);
			
			stack.reverse ();
			__fireEvent (event, stack);
			
			#if (windows || linux)
			
			if (keyCode == KeyCode.RETURN && modifier.altKey && type == KeyboardEvent.KEY_DOWN && !modifier.ctrlKey && !modifier.shiftKey && !modifier.metaKey && !event.isDefaultPrevented ()) {
				
				switch (displayState) {
					
					case NORMAL: displayState = FULL_SCREEN;
					default: displayState = NORMAL;
					
				}
				
			}
			
			#elseif mac
			
			if (keyCode == KeyCode.F && modifier.ctrlKey && modifier.metaKey && type == KeyboardEvent.KEY_DOWN && !modifier.altKey && !modifier.shiftKey && !event.isDefaultPrevented ()) {
				
				switch (displayState) {
					
					case NORMAL: displayState = FULL_SCREEN;
					default: displayState = NORMAL;
					
				}
				
			}
			
			#end
			
		}
		
	}
	
	
	@:noCompletion private function __onMouse (type:String, x:Float, y:Float, button:Int):Void {
		
		if (button > 2) return;
		
		__mouseX = x;
		__mouseY = y;
		
		var stack = [];
		var target:InteractiveObject = null;
		var targetPoint = new Point (x, y);
		
		if (__hitTest (x, y, false, stack, true)) {
			
			target = cast stack[stack.length - 1];
			
		} else {
			
			target = this;
			stack = [ this ];
			
		}
		
		if (type == MouseEvent.MOUSE_DOWN) {
			
			focus = target;
			
		}
		
		__fireEvent (MouseEvent.__create (type, button, __mouseX, __mouseY, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target), stack);
		
		var clickType = switch (type) {
			
			case MouseEvent.MOUSE_UP: MouseEvent.CLICK;
			case MouseEvent.MIDDLE_MOUSE_UP: MouseEvent.MIDDLE_CLICK;
			case MouseEvent.RIGHT_MOUSE_UP: MouseEvent.RIGHT_CLICK;
			default: null;
			
		}
		
		if (clickType != null) {
			
			__fireEvent (MouseEvent.__create (clickType, button, __mouseX, __mouseY, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target), stack);
			
			if (type == MouseEvent.MOUSE_UP && cast (target, openfl.display.InteractiveObject).doubleClickEnabled) {
				
				var currentTime = Lib.getTimer ();
				if (currentTime - __lastClickTime < 500) {
					
					__fireEvent (MouseEvent.__create (MouseEvent.DOUBLE_CLICK, button, __mouseX, __mouseY, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target), stack);
					__lastClickTime = 0;
					
				} else {
					
					__lastClickTime = currentTime;
					
				}
				
			}
			
		}
		
		var cursor = null;
		
		for (target in stack) {
			
			cursor = target.__getCursor ();
			
			if (cursor != null) {
				
				Mouse.cursor = cursor;
				break;
				
			}
			
		}
		
		if (cursor == null) {
			
			Mouse.cursor = ARROW;
			
		}
		
		for (target in __mouseOutStack) {
			
			if (stack.indexOf (target) == -1) {
				
				__mouseOutStack.remove (target);
				
				var localPoint = target.globalToLocal (targetPoint);
				target.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_OUT, false, false, localPoint.x, localPoint.y, cast target));
				
			}
			
		}
		
		for (target in stack) {
			
			if (__mouseOutStack.indexOf (target) == -1) {
				
				if (target.hasEventListener (MouseEvent.MOUSE_OVER)) {
					
					var localPoint = target.globalToLocal (targetPoint);
					target.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_OVER, false, false, localPoint.x, localPoint.y, cast target));
					
				}
				
				if (target.hasEventListener (MouseEvent.MOUSE_OUT)) {
					
					__mouseOutStack.push (target);
					
				}
				
			}
			
		}
		
		if (__dragObject != null) {
			
			__drag (targetPoint);
			
		}
		
	}
	
	
	@:noCompletion private function __onMouseWheel (deltaX:Float, deltaY:Float):Void {
		
		var x = __mouseX;
		var y = __mouseY;
		
		var stack = [];
		
		if (!__hitTest (x, y, false, stack, true)) {
			
			stack = [ this ];
			
		}
		
		var target:InteractiveObject = cast stack[stack.length - 1];
		var targetPoint = new Point (x, y);
		var delta = Std.int (deltaY);
		
		__fireEvent (MouseEvent.__create (MouseEvent.MOUSE_WHEEL, 0, __mouseX, __mouseY, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target, delta), stack);
		
	}
	
	
	@:noCompletion private function __onTouch (type:String, x:Float, y:Float, id:Int):Void {
		
		/*event.preventDefault ();
		
		var rect;
		
		if (__canvas != null) {
			
			rect = __canvas.getBoundingClientRect ();
			
		} else {
			
			rect = __div.getBoundingClientRect ();
			
		}
		
		var touch = event.changedTouches[0];
		var point = new Point ((touch.pageX - rect.left) * (stageWidth / rect.width), (touch.pageY - rect.top) * (stageHeight / rect.height));
		*/
		var point = new Point (x, y);
		
		__mouseX = point.x;
		__mouseY = point.y;
		
		var __stack = [];
		
		var mouseType = switch (type) {
			
			case TouchEvent.TOUCH_BEGIN: MouseEvent.MOUSE_DOWN;
			case TouchEvent.TOUCH_MOVE: MouseEvent.MOUSE_MOVE;
			case TouchEvent.TOUCH_END: MouseEvent.MOUSE_UP;
			default: null;
			
		}
		
		if (__hitTest (x, y, false, __stack, true)) {
			
			var target = __stack[__stack.length - 1];
			var localPoint = target.globalToLocal (point);
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, __mouseX, __mouseY, localPoint, cast target);
			touchEvent.touchPointID = id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, 0, __mouseX, __mouseY, localPoint, cast target);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			__fireEvent (touchEvent, __stack);
			__fireEvent (mouseEvent, __stack);
			
		} else {
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, __mouseX, __mouseY, point, this);
			touchEvent.touchPointID = id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, 0, __mouseX, __mouseY, point, this);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			__fireEvent (touchEvent, [ stage ]);
			__fireEvent (mouseEvent, [ stage ]);
			
		}
		
		if (type == TouchEvent.TOUCH_MOVE && __dragObject != null) {
			
			__drag (point);
			
		}
		
	}
	
	
	@:noCompletion private function __resize ():Void {
		
		/*
		if (__element != null && (__div == null || (__div != null && __fullscreen))) {
			
			if (__fullscreen) {
				
				stageWidth = __element.clientWidth;
				stageHeight = __element.clientHeight;
				
				if (__canvas != null) {
					
					if (__element != cast __canvas) {
						
						__canvas.width = stageWidth;
						__canvas.height = stageHeight;
						
					}
					
				} else {
					
					__div.style.width = stageWidth + "px";
					__div.style.height = stageHeight + "px";
					
				}
				
			} else {
				
				var scaleX = __element.clientWidth / __originalWidth;
				var scaleY = __element.clientHeight / __originalHeight;
				
				var currentRatio = scaleX / scaleY;
				var targetRatio = Math.min (scaleX, scaleY);
				
				if (__canvas != null) {
					
					if (__element != cast __canvas) {
						
						__canvas.style.width = __originalWidth * targetRatio + "px";
						__canvas.style.height = __originalHeight * targetRatio + "px";
						__canvas.style.marginLeft = ((__element.clientWidth - (__originalWidth * targetRatio)) / 2) + "px";
						__canvas.style.marginTop = ((__element.clientHeight - (__originalHeight * targetRatio)) / 2) + "px";
						
					}
					
				} else {
					
					__div.style.width = __originalWidth * targetRatio + "px";
					__div.style.height = __originalHeight * targetRatio + "px";
					__div.style.marginLeft = ((__element.clientWidth - (__originalWidth * targetRatio)) / 2) + "px";
					__div.style.marginTop = ((__element.clientHeight - (__originalHeight * targetRatio)) / 2) + "px";
					
				}
				
			}
			
		}*/
		
	}
	
	
	@:noCompletion private function __startDrag (sprite:Sprite, lockCenter:Bool, bounds:Rectangle):Void {
		
		__dragBounds = (bounds == null) ? null : bounds.clone ();
		__dragObject = sprite;
		
		if (__dragObject != null) {
			
			if (lockCenter) {
				
				__dragOffsetX = -__dragObject.width / 2;
				__dragOffsetY = -__dragObject.height / 2;
				
			} else {
				
				var mouse = new Point (mouseX, mouseY);
				var parent = __dragObject.parent;
				
				if (parent != null) {
					
					mouse = parent.globalToLocal (mouse);
					
				}
				
				__dragOffsetX = __dragObject.x - mouse.x;
				__dragOffsetY = __dragObject.y - mouse.y;
				
			}
			
		}
		
	}
	
	
	@:noCompletion private function __stopDrag (sprite:Sprite):Void {
		
		__dragBounds = null;
		__dragObject = null;
		
	}
	
	
	@:noCompletion public override function __update (transformOnly:Bool, updateChildren:Bool, ?maskGrahpics:Graphics = null):Void {
		
		if (transformOnly) {
			
			if (DisplayObject.__worldTransformDirty > 0) {
				
				super.__update (true, updateChildren, maskGrahpics);
				
				if (updateChildren) {
					
					DisplayObject.__worldTransformDirty = 0;
					__dirty = true;
					
				}
				
			}
			
		} else {
			
			if (DisplayObject.__worldTransformDirty > 0 || __dirty || DisplayObject.__worldRenderDirty > 0) {
				
				super.__update (false, updateChildren, maskGrahpics);
				
				if (updateChildren) {
					
					#if dom
					__wasDirty = true;
					#end
					
					DisplayObject.__worldTransformDirty = 0;
					DisplayObject.__worldRenderDirty = 0;
					__dirty = false;
					
				}
				
			} #if dom else if (__wasDirty) {
				
				// If we were dirty last time, we need at least one more
				// update in order to clear "changed" properties
				
				super.__update (false, updateChildren, maskGrahpics);
				
				if (updateChildren) {
					
					__wasDirty = false;
					
				}
				
			} #end
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private override function get_mouseX ():Float {
		
		return __mouseX;
		
	}
	
	
	@:noCompletion private override function get_mouseY ():Float {
		
		return __mouseY;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	#if (js && html5)
	@:noCompletion private function canvas_onContextLost (event:js.html.webgl.ContextEvent):Void {
		
		//__glContextLost = true;
		
	}
	
	
	@:noCompletion private function canvas_onContextRestored (event:js.html.webgl.ContextEvent):Void {
		
		//__glContextLost = false;
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_color ():Int {
		
		return __color;
		
	}
	
	
	@:noCompletion private function set_color (value:Int):Int {
		
		var r = (value & 0xFF0000) >>> 16;
		var g = (value & 0x00FF00) >>> 8;
		var b = (value & 0x0000FF);
		
		__colorSplit = [ r / 0xFF, g / 0xFF, b / 0xFF ];
		__colorString = "#" + StringTools.hex (value, 6);
		
		return __color = value;
		
	}
	
	
	@:noCompletion private inline function get_displayState ():StageDisplayState {
		
		return __displayState;
		
	}
	
	
	@:noCompletion private function set_displayState (value:StageDisplayState):StageDisplayState {
		
		switch (value) {
			
			case NORMAL:
				
				//Lib.application.window.minimized = false;
				Lib.application.window.fullscreen = false;
			
			default:
				
				//Lib.application.window.minimized = false;
				Lib.application.window.fullscreen = true;
			
		}
		
		return __displayState = value;
		
	}
	
	
	@:noCompletion private function get_focus ():InteractiveObject {
		
		return __focus;
		
	}
	
	
	@:noCompletion private function set_focus (value:InteractiveObject):InteractiveObject {
		
		if (value != __focus) {
			
			if (__focus != null) {
				
				var event = new FocusEvent (FocusEvent.FOCUS_OUT, true, false, value, false, 0);
				__stack = [];
				__focus.__getInteractive (__stack);
				__stack.reverse ();
				__fireEvent (event, __stack);
				
			}
			
			if (value != null) {
				
				var event = new FocusEvent (FocusEvent.FOCUS_IN, true, false, __focus, false, 0);
				__stack = [];
				value.__getInteractive (__stack);
				__stack.reverse ();
				__fireEvent (event, __stack);
				
			}
			
			__focus = value;
			
		}
		
		return __focus;
		
	}
	
	
	@:noCompletion private function get_frameRate ():Float {
		
		return Lib.application.frameRate;
		
	}
	
	
	@:noCompletion private function set_frameRate (value:Float):Float {
		
		return Lib.application.frameRate = value;
		
	}

}


#else
typedef Stage = openfl._legacy.display.Stage;
#end
#else
typedef Stage = flash.display.Stage;
#end
