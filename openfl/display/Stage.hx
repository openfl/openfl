package openfl.display; #if !flash #if !lime_legacy


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
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Mouse;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl._internal.renderer.dom.DOMRenderer;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.ui.Keyboard;
import openfl.ui.KeyLocation;

#if js
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


class Stage extends Sprite implements IModule {
	
	
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
	public var displayState (default, set):StageDisplayState;
	
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
	public var frameRate:Float;
	
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
	@:noCompletion private var __dragBounds:Rectangle;
	@:noCompletion private var __dragObject:Sprite;
	@:noCompletion private var __dragOffsetX:Float;
	@:noCompletion private var __dragOffsetY:Float;
	@:noCompletion private var __focus:InteractiveObject;
	@:noCompletion private var __fullscreen:Bool;
	@:noCompletion private var __invalidated:Bool;
	@:noCompletion private var __lastClickTime:Int;
	@:noCompletion private var __mouseOutStack = [];
	@:noCompletion private var __mouseX:Float = 0;
	@:noCompletion private var __mouseY:Float = 0;
	@:noCompletion private var __originalWidth:Int;
	@:noCompletion private var __originalHeight:Int;
	@:noCompletion private var __renderer:AbstractRenderer;
	@:noCompletion private var __rendering:Bool;
	@:noCompletion private var __stack:Array<DisplayObject>;
	@:noCompletion private var __transparent:Bool;
	@:noCompletion private var __wasDirty:Bool;
	@:noCompletion private var __ctrlKey:Bool;
	@:noCompletion private var __altKey:Bool;
	@:noCompletion private var __shiftKey:Bool;
	
	
	#if js
	//@:noCompletion private var __div:DivElement;
	//@:noCompletion private var __element:HtmlElement;
	#if stats
	@:noCompletion private var __stats:Dynamic;
	#end
	#end
	
	
	public function new (width:Int, height:Int, color:Null<Int> = null) {
		
		super ();
		
		if (color == null) {
			
			__transparent = true;
			this.color = 0x000000;
			
		} else {
			
			this.color = color;
			
		}
		
		this.name = null;
		
		__mouseX = 0;
		__mouseY = 0;
		
		stageWidth = width;
		stageHeight = height;
		
		this.stage = this;
		
		align = StageAlign.TOP_LEFT;
		allowsFullScreen = false;
		displayState = StageDisplayState.NORMAL;
		frameRate = 60;
		quality = StageQuality.HIGH;
		scaleMode = StageScaleMode.NO_SCALE;
		stageFocusRect = true;
		
		__clearBeforeRender = true;
		__stack = [];
		
		stage3Ds = new Vector ();
		stage3Ds.push (new Stage3D ());
		
	}
	
	
	public override function globalToLocal (pos:Point):Point {
		
		return pos;
		
	}
	
	
	public function init (context:RenderContext):Void {
		
		
		
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
	
	
	public function onKeyDown (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		var keyCode = __convertKeyCode (keyCode);
		var charCode = keyCode;
		
		switch(keyCode) {
			case Keyboard.CONTROL:
				__ctrlKey = true;
			case Keyboard.ALTERNATE:
				__altKey = true;
			case Keyboard.SHIFT:
				__shiftKey = true;
		}
		
		__onKey (new KeyboardEvent (KeyboardEvent.KEY_DOWN, true, false, charCode, keyCode, null, modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.metaKey));
		
	}
	
	
	public function onKeyUp (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		var keyCode = __convertKeyCode (keyCode);
		var charCode = keyCode;
		
		switch(keyCode) {
			case Keyboard.CONTROL:
				__ctrlKey = false;
			case Keyboard.ALTERNATE:
				__altKey = false;
			case Keyboard.SHIFT:
				__shiftKey = false;
		}
		
		__onKey (new KeyboardEvent (KeyboardEvent.KEY_UP, true, false, charCode, keyCode, null, modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.metaKey));
		
	}
	
	
	public function onMouseDown (x:Float, y:Float, button:Int):Void {
		
		var type = switch (button) {
			
			case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
			case 2: MouseEvent.RIGHT_MOUSE_DOWN;
			default: MouseEvent.MOUSE_DOWN;
			
		}
		
		__onMouse (type, x, y, button);
		
	}
	
	
	public function onMouseMove (x:Float, y:Float, button:Int):Void {
		
		__onMouse (MouseEvent.MOUSE_MOVE, x, y, 0);
		
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
		
		var x = __mouseX;
		var y = __mouseY;
		
		var stack = findMouseEventTargets(x, y);
		var target:InteractiveObject = cast stack[stack.length - 1];
		var targetPoint = new Point (x, y);
		
		var delta = deltaY > 0 ? Math.ceil(deltaY) : deltaY < 0 ? Math.floor(deltaY) : 0;
		
		__fireEvent (MouseEvent.__create (MouseEvent.MOUSE_WHEEL, 0, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target, __ctrlKey, __altKey, __shiftKey, delta), stack);

	}
	
	
	public function onRenderContextLost ():Void {
		
		
		
	}
	
	
	public function onRenderContextRestored (context:RenderContext):Void {
		
		
		
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
	
	
	public function onWindowFocusIn ():Void {
		
		
		
	}
	
	
	public function onWindowFocusOut ():Void {
		
		
		
	}
	
	
	public function onWindowMove (x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onWindowResize (width:Int, height:Int):Void {
		
		stageWidth = width;
		stageHeight = height;
		
		var event = new Event (Event.RESIZE);
		__broadcast (event, false);
		
	}
	
	
	public function render (context:RenderContext):Void {
		
		if (__rendering) return;
		__rendering = true;
		
		__broadcast (new Event (Event.ENTER_FRAME), true);
		
		if (__invalidated) {
			
			__invalidated = false;
			__broadcast (new Event (Event.RENDER), true);
			
		}
		
		__renderable = true;
		__update (false, true);
		
		switch (context) {
			
			case OPENGL (gl):
				
				if (__renderer == null) {
					
					__renderer = new GLRenderer (stageWidth, stageHeight, gl);
					
				}
				
				__renderer.render (this);
			
			case CANVAS (context):
				
				if (__renderer == null) {
					
					__renderer = new CanvasRenderer (stageWidth, stageHeight, context);
					
				}
				
				__renderer.render (this);
			
			case DOM (element):
				
				if (__renderer == null) {
					
					__renderer = new DOMRenderer (stageWidth, stageHeight, element);
					
				}
				
				__renderer.render (this);
			
			default:
			
		}
		
		__rendering = false;
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		
		
	}
	
	
	@:noCompletion private function __convertKeyCode (keyCode:KeyCode):Int {
		
		return switch (keyCode) {
			
			case BACKSPACE: Keyboard.BACKSPACE;
			case TAB: Keyboard.TAB;
			case RETURN: Keyboard.ENTER;
			case ESCAPE: Keyboard.ESCAPE;
			case SPACE: Keyboard.SPACE;
			//case EXCLAMATION: 0x21;
			//case QUOTE: 0x22;
			//case HASH: 0x23;
			//case DOLLAR: 0x24;
			//case PERCENT: 0x25;
			//case AMPERSAND: 0x26;
			case SINGLE_QUOTE: Keyboard.QUOTE;
			//case LEFT_PARENTHESIS: 0x28;
			//case RIGHT_PARENTHESIS: 0x29;
			//case ASTERISK: 0x2A;
			//case PLUS: 0x2B;
			case COMMA: Keyboard.COMMA;
			case MINUS: Keyboard.MINUS;
			case PERIOD: Keyboard.PERIOD;
			case SLASH: Keyboard.SLASH;
			case NUMBER_0: Keyboard.NUMBER_0;
			case NUMBER_1: Keyboard.NUMBER_1;
			case NUMBER_2: Keyboard.NUMBER_2;
			case NUMBER_3: Keyboard.NUMBER_3;
			case NUMBER_4: Keyboard.NUMBER_4;
			case NUMBER_5: Keyboard.NUMBER_5;
			case NUMBER_6: Keyboard.NUMBER_6;
			case NUMBER_7: Keyboard.NUMBER_7;
			case NUMBER_8: Keyboard.NUMBER_8;
			case NUMBER_9: Keyboard.NUMBER_9;
			//case COLON: 0x3A;
			case SEMICOLON: Keyboard.SEMICOLON;
			//case LESS_THAN: 0x3C;
			case EQUALS: Keyboard.EQUAL;
			//case GREATER_THAN: 0x3E;
			//case QUESTION: 0x3F;
			//case AT: 0x40;
			case LEFT_BRACKET: Keyboard.LEFTBRACKET;
			case BACKSLASH: Keyboard.BACKSLASH;
			case RIGHT_BRACKET: Keyboard.RIGHTBRACKET;
			//case CARET: 0x5E;
			//case UNDERSCORE: 0x5F;
			case GRAVE: Keyboard.BACKQUOTE;
			case A: Keyboard.A;
			case B: Keyboard.B;
			case C: Keyboard.C;
			case D: Keyboard.D;
			case E: Keyboard.E;
			case F: Keyboard.F;
			case G: Keyboard.G;
			case H: Keyboard.H;
			case I: Keyboard.I;
			case J: Keyboard.J;
			case K: Keyboard.K;
			case L: Keyboard.L;
			case M: Keyboard.M;
			case N: Keyboard.N;
			case O: Keyboard.O;
			case P: Keyboard.P;
			case Q: Keyboard.Q;
			case R: Keyboard.R;
			case S: Keyboard.S;
			case T: Keyboard.T;
			case U: Keyboard.U;
			case V: Keyboard.V;
			case W: Keyboard.W;
			case X: Keyboard.X;
			case Y: Keyboard.Y;
			case Z: Keyboard.Z;
			case DELETE: Keyboard.DELETE;
			case CAPS_LOCK: Keyboard.CAPS_LOCK;
			case F1: Keyboard.F1;
			case F2: Keyboard.F2;
			case F3: Keyboard.F3;
			case F4: Keyboard.F4;
			case F5: Keyboard.F5;
			case F6: Keyboard.F6;
			case F7: Keyboard.F7;
			case F8: Keyboard.F8;
			case F9: Keyboard.F9;
			case F10: Keyboard.F10;
			case F11: Keyboard.F11;
			case F12: Keyboard.F12;
			//case PRINT_SCREEN: 0x40000046;
			//case SCROLL_LOCK: 0x40000047;
			//case PAUSE: 0x40000048;
			case INSERT: Keyboard.INSERT;
			case HOME: Keyboard.HOME;
			case PAGE_UP: Keyboard.PAGE_UP;
			case END: Keyboard.END;
			case PAGE_DOWN: Keyboard.PAGE_DOWN;
			case RIGHT: Keyboard.RIGHT;
			case LEFT: Keyboard.LEFT;
			case DOWN: Keyboard.DOWN;
			case UP: Keyboard.UP;
			//case NUM_LOCK_CLEAR: 0x40000053;
			case NUMPAD_DIVIDE: Keyboard.NUMPAD_DIVIDE;
			case NUMPAD_MULTIPLY: Keyboard.NUMPAD_MULTIPLY;
			case NUMPAD_MINUS: Keyboard.NUMPAD_SUBTRACT;
			case NUMPAD_PLUS: Keyboard.NUMPAD_ADD;
			case NUMPAD_ENTER: Keyboard.NUMPAD_ENTER;
			case NUMPAD_1: Keyboard.NUMPAD_1;
			case NUMPAD_2: Keyboard.NUMPAD_2;
			case NUMPAD_3: Keyboard.NUMPAD_3;
			case NUMPAD_4: Keyboard.NUMPAD_4;
			case NUMPAD_5: Keyboard.NUMPAD_5;
			case NUMPAD_6: Keyboard.NUMPAD_6;
			case NUMPAD_7: Keyboard.NUMPAD_7;
			case NUMPAD_8: Keyboard.NUMPAD_8;
			case NUMPAD_9: Keyboard.NUMPAD_9;
			case NUMPAD_0: Keyboard.NUMPAD_0;
			case NUMPAD_PERIOD: Keyboard.NUMPAD_DECIMAL;
			//case APPLICATION: 0x40000065;
			//case POWER: 0x40000066;
			//case NUMPAD_EQUALS: 0x40000067;
			case F13: Keyboard.F13;
			case F14: Keyboard.F14;
			case F15: Keyboard.F15;
			//case F16: 0x4000006B;
			//case F17: 0x4000006C;
			//case F18: 0x4000006D;
			//case F19: 0x4000006E;
			//case F20: 0x4000006F;
			//case F21: 0x40000070;
			//case F22: 0x40000071;
			//case F23: 0x40000072;
			//case F24: 0x40000073;
			//case EXECUTE: 0x40000074;
			//case HELP: 0x40000075;
			//case MENU: 0x40000076;
			//case SELECT: 0x40000077;
			//case STOP: 0x40000078;
			//case AGAIN: 0x40000079;
			//case UNDO: 0x4000007A;
			//case CUT: 0x4000007B;
			//case COPY: 0x4000007C;
			//case PASTE: 0x4000007D;
			//case FIND: 0x4000007E;
			//case MUTE: 0x4000007F;
			//case VOLUME_UP: 0x40000080;
			//case VOLUME_DOWN: 0x40000081;
			//case NUMPAD_COMMA: 0x40000085;
			////case NUMPAD_EQUALS_AS400: 0x40000086;
			//case ALT_ERASE: 0x40000099;
			//case SYSTEM_REQUEST: 0x4000009A;
			//case CANCEL: 0x4000009B;
			//case CLEAR: 0x4000009C;
			//case PRIOR: 0x4000009D;
			//case RETURN2: 0x4000009E;
			//case SEPARATOR: 0x4000009F;
			//case OUT: 0x400000A0;
			//case OPER: 0x400000A1;
			//case CLEAR_AGAIN: 0x400000A2;
			//case CRSEL: 0x400000A3;
			//case EXSEL: 0x400000A4;
			//case NUMPAD_00: 0x400000B0;
			//case NUMPAD_000: 0x400000B1;
			//case THOUSAND_SEPARATOR: 0x400000B2;
			//case DECIMAL_SEPARATOR: 0x400000B3;
			//case CURRENCY_UNIT: 0x400000B4;
			//case CURRENCY_SUBUNIT: 0x400000B5;
			//case NUMPAD_LEFT_PARENTHESIS: 0x400000B6;
			//case NUMPAD_RIGHT_PARENTHESIS: 0x400000B7;
			//case NUMPAD_LEFT_BRACE: 0x400000B8;
			//case NUMPAD_RIGHT_BRACE: 0x400000B9;
			//case NUMPAD_TAB: 0x400000BA;
			//case NUMPAD_BACKSPACE: 0x400000BB;
			//case NUMPAD_A: 0x400000BC;
			//case NUMPAD_B: 0x400000BD;
			//case NUMPAD_C: 0x400000BE;
			//case NUMPAD_D: 0x400000BF;
			//case NUMPAD_E: 0x400000C0;
			//case NUMPAD_F: 0x400000C1;
			//case NUMPAD_XOR: 0x400000C2;
			//case NUMPAD_POWER: 0x400000C3;
			//case NUMPAD_PERCENT: 0x400000C4;
			//case NUMPAD_LESS_THAN: 0x400000C5;
			//case NUMPAD_GREATER_THAN: 0x400000C6;
			//case NUMPAD_AMPERSAND: 0x400000C7;
			//case NUMPAD_DOUBLE_AMPERSAND: 0x400000C8;
			//case NUMPAD_VERTICAL_BAR: 0x400000C9;
			//case NUMPAD_DOUBLE_VERTICAL_BAR: 0x400000CA;
			//case NUMPAD_COLON: 0x400000CB;
			//case NUMPAD_HASH: 0x400000CC;
			//case NUMPAD_SPACE: 0x400000CD;
			//case NUMPAD_AT: 0x400000CE;
			//case NUMPAD_EXCLAMATION: 0x400000CF;
			//case NUMPAD_MEM_STORE: 0x400000D0;
			//case NUMPAD_MEM_RECALL: 0x400000D1;
			//case NUMPAD_MEM_CLEAR: 0x400000D2;
			//case NUMPAD_MEM_ADD: 0x400000D3;
			//case NUMPAD_MEM_SUBTRACT: 0x400000D4;
			//case NUMPAD_MEM_MULTIPLY: 0x400000D5;
			//case NUMPAD_MEM_DIVIDE: 0x400000D6;
			//case NUMPAD_PLUS_MINUS: 0x400000D7;
			//case NUMPAD_CLEAR: 0x400000D8;
			//case NUMPAD_CLEAR_ENTRY: 0x400000D9;
			//case NUMPAD_BINARY: 0x400000DA;
			//case NUMPAD_OCTAL: 0x400000DB;
			//case NUMPAD_DECIMAL: 0x400000DC;
			//case NUMPAD_HEXADECIMAL: 0x400000DD;
			case LEFT_CTRL: Keyboard.CONTROL;
			case LEFT_SHIFT: Keyboard.SHIFT;
			case LEFT_ALT: Keyboard.ALTERNATE;
			//case LEFT_META: 0x400000E3;
			case RIGHT_CTRL: Keyboard.CONTROL;
			case RIGHT_SHIFT: Keyboard.SHIFT;
			case RIGHT_ALT: Keyboard.ALTERNATE;
			//case RIGHT_META: 0x400000E7;
			//case MODE: 0x40000101;
			//case AUDIO_NEXT: 0x40000102;
			//case AUDIO_PREVIOUS: 0x40000103;
			//case AUDIO_STOP: 0x40000104;
			//case AUDIO_PLAY: 0x40000105;
			//case AUDIO_MUTE: 0x40000106;
			//case MEDIA_SELECT: 0x40000107;
			//case WWW: 0x40000108;
			//case MAIL: 0x40000109;
			//case CALCULATOR: 0x4000010A;
			//case COMPUTER: 0x4000010B;
			//case APP_CONTROL_SEARCH: 0x4000010C;
			//case APP_CONTROL_HOME: 0x4000010D;
			//case APP_CONTROL_BACK: 0x4000010E;
			//case APP_CONTROL_FORWARD: 0x4000010F;
			//case APP_CONTROL_STOP: 0x40000110;
			//case APP_CONTROL_REFRESH: 0x40000111;
			//case APP_CONTROL_BOOKMARKS: 0x40000112;
			//case BRIGHTNESS_DOWN: 0x40000113;
			//case BRIGHTNESS_UP: 0x40000114;
			//case DISPLAY_SWITCH: 0x40000115;
			//case BACKLIGHT_TOGGLE: 0x40000116;
			//case BACKLIGHT_DOWN: 0x40000117;
			//case BACKLIGHT_UP: 0x40000118;
			//case EJECT: 0x40000119;
			//case SLEEP: 0x4000011A;
			default: cast keyCode;
			
		}
		
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
	
	
	@:noCompletion private override function __getInteractive (stack:Array<DisplayObject>):Void {
		
		stack.push (this);
		
	}
	
	
	@:noCompletion private function __onKey (event:KeyboardEvent):Void {
		
		var stack = new Array <DisplayObject> ();
		
		if (__focus == null) {
			
			__getInteractive (stack);
			
		} else {
			
			__focus.__getInteractive (stack);
			
		}
		
		if (stack.length > 0) {
			
			stack.reverse ();
			__fireEvent (event, stack);
			
		}
		
	}
	
	
	@:noCompletion private function findMouseEventTargets(x, y):Array < DisplayObject > {
		var stack:Array< DisplayObject > = [];
		
		if ( ! __hitTest (x, y, false, stack, true)) {
			
			stack = [ this ];
			
		}
		
		return stack;
	}
	
	
	@:noCompletion private function __onMouse (type:String, x:Float, y:Float, button:Int):Void {
		
		if (button > 2) return;
		
		__mouseX = x;
		__mouseY = y;
		
		var stack = findMouseEventTargets(x, y);
		var target:InteractiveObject = cast stack[stack.length - 1];
		var targetPoint = new Point (x, y);
		
		__fireEvent (MouseEvent.__create (type, button, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target, __ctrlKey, __altKey, __shiftKey), stack);
		
		var clickType = switch (type) {
			
			case MouseEvent.MOUSE_UP: MouseEvent.CLICK;
			case MouseEvent.MIDDLE_MOUSE_UP: MouseEvent.MIDDLE_CLICK;
			case MouseEvent.RIGHT_MOUSE_UP: MouseEvent.RIGHT_CLICK;
			default: null;
			
		}
		
		if (clickType != null) {
			
			__fireEvent (MouseEvent.__create (clickType, button, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target, __ctrlKey, __altKey, __shiftKey), stack);
			
			if (type == MouseEvent.MOUSE_UP && cast (target, openfl.display.InteractiveObject).doubleClickEnabled) {
				
				var currentTime = Lib.getTimer ();
				if (currentTime - __lastClickTime < 500) {
					
					__fireEvent (MouseEvent.__create (MouseEvent.DOUBLE_CLICK, button, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target, __ctrlKey, __altKey, __shiftKey), stack);
					__lastClickTime = 0;
					
				} else {
					
					__lastClickTime = currentTime;
					
				}
				
			}
			
		}
		
		if (Std.is (target, Sprite)) {
			
			var targetSprite:Sprite = cast target;
			
			if (targetSprite.buttonMode && targetSprite.useHandCursor) {
				
				Mouse.cursor = POINTER;
				
			} else {
				
				Mouse.cursor = ARROW;
				
			}
			
		} else if (Std.is (target, SimpleButton)) {
			
			var targetButton:SimpleButton = cast target;
			
			if (targetButton.useHandCursor) {
				
				Mouse.cursor = POINTER;
				
			} else {
				
				Mouse.cursor = ARROW;
				
			}
			
		} else if (Std.is (target, TextField)) {
			
			var targetTextField:TextField = cast target;
			
			if (targetTextField.type == INPUT) {
				
				Mouse.cursor = TEXT;
				
			} else {
				
				Mouse.cursor = ARROW;
				
			}
			
		} else {
			
			Mouse.cursor = ARROW;
			
		}
		
		for (target in __mouseOutStack) {
			
			if (stack.indexOf (target) == -1) {
				
				__mouseOutStack.remove (target);
				
				var localPoint = target.globalToLocal (targetPoint);
				target.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_OUT, false, false, localPoint.x, localPoint.y, cast target, __ctrlKey, __altKey, __shiftKey));
				
			}
			
		}
		
		for (target in stack) {
			
			if (__mouseOutStack.indexOf (target) == -1) {
				
				if (target.hasEventListener (MouseEvent.MOUSE_OVER)) {
					
					var localPoint = target.globalToLocal (targetPoint);
					target.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_OVER, false, false, localPoint.x, localPoint.y, cast target, __ctrlKey, __altKey, __shiftKey));
					
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
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, localPoint, cast target);
			touchEvent.touchPointID = id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, 0, localPoint, cast target, __ctrlKey, __altKey, __shiftKey);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			__fireEvent (touchEvent, __stack);
			__fireEvent (mouseEvent, __stack);
			
		} else {
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, point, this);
			touchEvent.touchPointID = id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, 0, point, this, __ctrlKey, __altKey, __shiftKey);
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
	
	
	@:noCompletion public override function __update (transformOnly:Bool, updateChildren:Bool):Void {
		
		if (transformOnly) {
			
			if (DisplayObject.__worldTransformDirty > 0) {
				
				super.__update (true, updateChildren);
				
				if (updateChildren) {
					
					DisplayObject.__worldTransformDirty = 0;
					__dirty = true;
					
				}
				
			}
			
		} else {
			
			if (DisplayObject.__worldTransformDirty > 0 || __dirty || DisplayObject.__worldRenderDirty > 0) {
				
				super.__update (false, updateChildren);
				
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
				
				super.__update (false, updateChildren);
				
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
	
	
	
	
	#if js
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
	
	
	@:noCompletion private function set_displayState (value:StageDisplayState):StageDisplayState {
		
		/*switch(value) {
			case NORMAL:
				var fs_exit_function = untyped __js__("function() {
			    if (document.exitFullscreen) {
			      document.exitFullscreen();
			    } else if (document.msExitFullscreen) {
			      document.msExitFullscreen();
			    } else if (document.mozCancelFullScreen) {
			      document.mozCancelFullScreen();
			    } else if (document.webkitExitFullscreen) {
			      document.webkitExitFullscreen();
			    }
				}");
				fs_exit_function();
			case FULL_SCREEN | FULL_SCREEN_INTERACTIVE:
				var fsfunction = untyped __js__("function(elem) {
					if (elem.requestFullscreen) elem.requestFullscreen();
					else if (elem.msRequestFullscreen) elem.msRequestFullscreen();
					else if (elem.mozRequestFullScreen) elem.mozRequestFullScreen();
					else if (elem.webkitRequestFullscreen) elem.webkitRequestFullscreen();
				}");
				fsfunction(__element);
			default:
		}*/
		displayState = value;
		return value;
		
	}
	
	
}


#else
typedef Stage = openfl._v2.display.Stage;
#end
#else
typedef Stage = flash.display.Stage;
#end