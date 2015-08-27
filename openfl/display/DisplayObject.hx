package openfl.display; #if !flash #if !openfl_legacy


import lime.graphics.cairo.Cairo;
import lime.ui.MouseCursor;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.cairo.CairoShape;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.canvas.CanvasShape;
import openfl._internal.renderer.dom.DOMShape;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Stage;
import openfl.errors.TypeError;
import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.events.EventDispatcher;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.Lib;

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
import js.html.Element;
#end


/**
 * The DisplayObject class is the base class for all objects that can be
 * placed on the display list. The display list manages all objects displayed
 * in openfl. Use the DisplayObjectContainer class to arrange the
 * display objects in the display list. DisplayObjectContainer objects can
 * have child display objects, while other display objects, such as Shape and
 * TextField objects, are "leaf" nodes that have only parents and siblings, no
 * children.
 *
 * <p>The DisplayObject class supports basic functionality like the <i>x</i>
 * and <i>y</i> position of an object, as well as more advanced properties of
 * the object such as its transformation matrix. </p>
 *
 * <p>DisplayObject is an abstract base class; therefore, you cannot call
 * DisplayObject directly. Invoking <code>new DisplayObject()</code> throws an
 * <code>ArgumentError</code> exception. </p>
 *
 * <p>All display objects inherit from the DisplayObject class.</p>
 *
 * <p>The DisplayObject class itself does not include any APIs for rendering
 * content onscreen. For that reason, if you want create a custom subclass of
 * the DisplayObject class, you will want to extend one of its subclasses that
 * do have APIs for rendering content onscreen, such as the Shape, Sprite,
 * Bitmap, SimpleButton, TextField, or MovieClip class.</p>
 *
 * <p>The DisplayObject class contains several broadcast events. Normally, the
 * target of any particular event is a specific DisplayObject instance. For
 * example, the target of an <code>added</code> event is the specific
 * DisplayObject instance that was added to the display list. Having a single
 * target restricts the placement of event listeners to that target and in
 * some cases the target's ancestors on the display list. With broadcast
 * events, however, the target is not a specific DisplayObject instance, but
 * rather all DisplayObject instances, including those that are not on the
 * display list. This means that you can add a listener to any DisplayObject
 * instance to listen for broadcast events. In addition to the broadcast
 * events listed in the DisplayObject class's Events table, the DisplayObject
 * class also inherits two broadcast events from the EventDispatcher class:
 * <code>activate</code> and <code>deactivate</code>.</p>
 *
 * <p>Some properties previously used in the ActionScript 1.0 and 2.0
 * MovieClip, TextField, and Button classes(such as <code>_alpha</code>,
 * <code>_height</code>, <code>_name</code>, <code>_width</code>,
 * <code>_x</code>, <code>_y</code>, and others) have equivalents in the
 * ActionScript 3.0 DisplayObject class that are renamed so that they no
 * longer begin with the underscore(_) character.</p>
 *
 * <p>For more information, see the "Display Programming" chapter of the
 * <i>ActionScript 3.0 Developer's Guide</i>.</p>
 * 
 * @event added            Dispatched when a display object is added to the
 *                         display list. The following methods trigger this
 *                         event:
 *                         <code>DisplayObjectContainer.addChild()</code>,
 *                         <code>DisplayObjectContainer.addChildAt()</code>.
 * @event addedToStage     Dispatched when a display object is added to the on
 *                         stage display list, either directly or through the
 *                         addition of a sub tree in which the display object
 *                         is contained. The following methods trigger this
 *                         event:
 *                         <code>DisplayObjectContainer.addChild()</code>,
 *                         <code>DisplayObjectContainer.addChildAt()</code>.
 * @event enterFrame       [broadcast event] Dispatched when the playhead is
 *                         entering a new frame. If the playhead is not
 *                         moving, or if there is only one frame, this event
 *                         is dispatched continuously in conjunction with the
 *                         frame rate. This event is a broadcast event, which
 *                         means that it is dispatched by all display objects
 *                         with a listener registered for this event.
 * @event exitFrame        [broadcast event] Dispatched when the playhead is
 *                         exiting the current frame. All frame scripts have
 *                         been run. If the playhead is not moving, or if
 *                         there is only one frame, this event is dispatched
 *                         continuously in conjunction with the frame rate.
 *                         This event is a broadcast event, which means that
 *                         it is dispatched by all display objects with a
 *                         listener registered for this event.
 * @event frameConstructed [broadcast event] Dispatched after the constructors
 *                         of frame display objects have run but before frame
 *                         scripts have run. If the playhead is not moving, or
 *                         if there is only one frame, this event is
 *                         dispatched continuously in conjunction with the
 *                         frame rate. This event is a broadcast event, which
 *                         means that it is dispatched by all display objects
 *                         with a listener registered for this event.
 * @event removed          Dispatched when a display object is about to be
 *                         removed from the display list. Two methods of the
 *                         DisplayObjectContainer class generate this event:
 *                         <code>removeChild()</code> and
 *                         <code>removeChildAt()</code>.
 *
 *                         <p>The following methods of a
 *                         DisplayObjectContainer object also generate this
 *                         event if an object must be removed to make room for
 *                         the new object: <code>addChild()</code>,
 *                         <code>addChildAt()</code>, and
 *                         <code>setChildIndex()</code>. </p>
 * @event removedFromStage Dispatched when a display object is about to be
 *                         removed from the display list, either directly or
 *                         through the removal of a sub tree in which the
 *                         display object is contained. Two methods of the
 *                         DisplayObjectContainer class generate this event:
 *                         <code>removeChild()</code> and
 *                         <code>removeChildAt()</code>.
 *
 *                         <p>The following methods of a
 *                         DisplayObjectContainer object also generate this
 *                         event if an object must be removed to make room for
 *                         the new object: <code>addChild()</code>,
 *                         <code>addChildAt()</code>, and
 *                         <code>setChildIndex()</code>. </p>
 * @event render           [broadcast event] Dispatched when the display list
 *                         is about to be updated and rendered. This event
 *                         provides the last opportunity for objects listening
 *                         for this event to make changes before the display
 *                         list is rendered. You must call the
 *                         <code>invalidate()</code> method of the Stage
 *                         object each time you want a <code>render</code>
 *                         event to be dispatched. <code>Render</code> events
 *                         are dispatched to an object only if there is mutual
 *                         trust between it and the object that called
 *                         <code>Stage.invalidate()</code>. This event is a
 *                         broadcast event, which means that it is dispatched
 *                         by all display objects with a listener registered
 *                         for this event.
 *
 *                         <p><b>Note: </b>This event is not dispatched if the
 *                         display is not rendering. This is the case when the
 *                         content is either minimized or obscured. </p>
 */

@:access(openfl.events.Event)
@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Rectangle)


class DisplayObject extends EventDispatcher implements IBitmapDrawable {
	
	
	@:noCompletion private static var __instanceCount = 0;
	@:noCompletion private static var __worldRenderDirty = 0;
	@:noCompletion private static var __worldTransformDirty = 0;
	
	/**
	 * Indicates the alpha transparency value of the object specified. Valid
	 * values are 0(fully transparent) to 1(fully opaque). The default value is
	 * 1. Display objects with <code>alpha</code> set to 0 <i>are</i> active,
	 * even though they are invisible.
	 */
	public var alpha (get, set):Float;
	
	/**
	 * A value from the BlendMode class that specifies which blend mode to use. A
	 * bitmap can be drawn internally in two ways. If you have a blend mode
	 * enabled or an external clipping mask, the bitmap is drawn by adding a
	 * bitmap-filled square shape to the vector render. If you attempt to set
	 * this property to an invalid value, Flash runtimes set the value to
	 * <code>BlendMode.NORMAL</code>.
	 *
	 * <p>The <code>blendMode</code> property affects each pixel of the display
	 * object. Each pixel is composed of three constituent colors(red, green,
	 * and blue), and each constituent color has a value between 0x00 and 0xFF.
	 * Flash Player or Adobe AIR compares each constituent color of one pixel in
	 * the movie clip with the corresponding color of the pixel in the
	 * background. For example, if <code>blendMode</code> is set to
	 * <code>BlendMode.LIGHTEN</code>, Flash Player or Adobe AIR compares the red
	 * value of the display object with the red value of the background, and uses
	 * the lighter of the two as the value for the red component of the displayed
	 * color.</p>
	 *
	 * <p>The following table describes the <code>blendMode</code> settings. The
	 * BlendMode class defines string values you can use. The illustrations in
	 * the table show <code>blendMode</code> values applied to a circular display
	 * object(2) superimposed on another display object(1).</p>
	 */
	public var blendMode(default, set):BlendMode;
	
	/**
	 * If set to <code>true</code>, NME will use the software renderer to cache
	 * an internal bitmap representation of the display object. For native targets,
	 * this is often much slower than the default hardware renderer. When you
	 * are using the Flash target, this caching may increase performance for display 
	 * objects that contain complex vector content.
	 *
	 * <p>All vector data for a display object that has a cached bitmap is drawn
	 * to the bitmap instead of the main display. If
	 * <code>cacheAsBitmapMatrix</code> is null or unsupported, the bitmap is
	 * then copied to the main display as unstretched, unrotated pixels snapped
	 * to the nearest pixel boundaries. Pixels are mapped 1 to 1 with the parent
	 * object. If the bounds of the bitmap change, the bitmap is recreated
	 * instead of being stretched.</p>
	 *
	 * <p>If <code>cacheAsBitmapMatrix</code> is non-null and supported, the
	 * object is drawn to the off-screen bitmap using that matrix and the
	 * stretched and/or rotated results of that rendering are used to draw the
	 * object to the main display.</p>
	 *
	 * <p>No internal bitmap is created unless the <code>cacheAsBitmap</code>
	 * property is set to <code>true</code>.</p>
	 *
	 * <p>After you set the <code>cacheAsBitmap</code> property to
	 * <code>true</code>, the rendering does not change, however the display
	 * object performs pixel snapping automatically. The animation speed can be
	 * significantly faster depending on the complexity of the vector content.
	 * </p>
	 *
	 * <p>The <code>cacheAsBitmap</code> property is automatically set to
	 * <code>true</code> whenever you apply a filter to a display object(when
	 * its <code>filter</code> array is not empty), and if a display object has a
	 * filter applied to it, <code>cacheAsBitmap</code> is reported as
	 * <code>true</code> for that display object, even if you set the property to
	 * <code>false</code>. If you clear all filters for a display object, the
	 * <code>cacheAsBitmap</code> setting changes to what it was last set to.</p>
	 *
	 * <p>A display object does not use a bitmap even if the
	 * <code>cacheAsBitmap</code> property is set to <code>true</code> and
	 * instead renders from vector data in the following cases:</p>
	 *
	 * <ul>
	 *   <li>The bitmap is too large. In AIR 1.5 and Flash Player 10, the maximum
	 * size for a bitmap image is 8,191 pixels in width or height, and the total
	 * number of pixels cannot exceed 16,777,215 pixels.(So, if a bitmap image
	 * is 8,191 pixels wide, it can only be 2,048 pixels high.) In Flash Player 9
	 * and earlier, the limitation is is 2880 pixels in height and 2,880 pixels
	 * in width.</li>
	 *   <li>The bitmap fails to allocate(out of memory error). </li>
	 * </ul>
	 *
	 * <p>The <code>cacheAsBitmap</code> property is best used with movie clips
	 * that have mostly static content and that do not scale and rotate
	 * frequently. With such movie clips, <code>cacheAsBitmap</code> can lead to
	 * performance increases when the movie clip is translated(when its <i>x</i>
	 * and <i>y</i> position is changed).</p>
	 */
	public var cacheAsBitmap:Bool;
	
	/**
	 * An indexed array that contains each filter object currently associated
	 * with the display object. The openfl.filters package contains several
	 * classes that define specific filters you can use.
	 *
	 * <p>Filters can be applied in Flash Professional at design time, or at run
	 * time by using ActionScript code. To apply a filter by using ActionScript,
	 * you must make a temporary copy of the entire <code>filters</code> array,
	 * modify the temporary array, then assign the value of the temporary array
	 * back to the <code>filters</code> array. You cannot directly add a new
	 * filter object to the <code>filters</code> array.</p>
	 *
	 * <p>To add a filter by using ActionScript, perform the following steps
	 * (assume that the target display object is named
	 * <code>myDisplayObject</code>):</p>
	 *
	 * <ol>
	 *   <li>Create a new filter object by using the constructor method of your
	 * chosen filter class.</li>
	 *   <li>Assign the value of the <code>myDisplayObject.filters</code> array
	 * to a temporary array, such as one named <code>myFilters</code>.</li>
	 *   <li>Add the new filter object to the <code>myFilters</code> temporary
	 * array.</li>
	 *   <li>Assign the value of the temporary array to the
	 * <code>myDisplayObject.filters</code> array.</li>
	 * </ol>
	 *
	 * <p>If the <code>filters</code> array is undefined, you do not need to use
	 * a temporary array. Instead, you can directly assign an array literal that
	 * contains one or more filter objects that you create. The first example in
	 * the Examples section adds a drop shadow filter by using code that handles
	 * both defined and undefined <code>filters</code> arrays.</p>
	 *
	 * <p>To modify an existing filter object, you must use the technique of
	 * modifying a copy of the <code>filters</code> array:</p>
	 *
	 * <ol>
	 *   <li>Assign the value of the <code>filters</code> array to a temporary
	 * array, such as one named <code>myFilters</code>.</li>
	 *   <li>Modify the property by using the temporary array,
	 * <code>myFilters</code>. For example, to set the quality property of the
	 * first filter in the array, you could use the following code:
	 * <code>myFilters[0].quality = 1;</code></li>
	 *   <li>Assign the value of the temporary array to the <code>filters</code>
	 * array.</li>
	 * </ol>
	 *
	 * <p>At load time, if a display object has an associated filter, it is
	 * marked to cache itself as a transparent bitmap. From this point forward,
	 * as long as the display object has a valid filter list, the player caches
	 * the display object as a bitmap. This source bitmap is used as a source
	 * image for the filter effects. Each display object usually has two bitmaps:
	 * one with the original unfiltered source display object and another for the
	 * final image after filtering. The final image is used when rendering. As
	 * long as the display object does not change, the final image does not need
	 * updating.</p>
	 *
	 * <p>The openfl.filters package includes classes for filters. For example, to
	 * create a DropShadow filter, you would write:</p>
	 * 
	 * @throws ArgumentError When <code>filters</code> includes a ShaderFilter
	 *                       and the shader output type is not compatible with
	 *                       this operation(the shader must specify a
	 *                       <code>pixel4</code> output).
	 * @throws ArgumentError When <code>filters</code> includes a ShaderFilter
	 *                       and the shader doesn't specify any image input or
	 *                       the first input is not an <code>image4</code> input.
	 * @throws ArgumentError When <code>filters</code> includes a ShaderFilter
	 *                       and the shader specifies an image input that isn't
	 *                       provided.
	 * @throws ArgumentError When <code>filters</code> includes a ShaderFilter, a
	 *                       ByteArray or Vector.<Number> instance as a shader
	 *                       input, and the <code>width</code> and
	 *                       <code>height</code> properties aren't specified for
	 *                       the ShaderInput object, or the specified values
	 *                       don't match the amount of data in the input data.
	 *                       See the <code>ShaderInput.input</code> property for
	 *                       more information.
	 */
	public var filters (get, set):Array<BitmapFilter>;
	
	/**
	 * Indicates the height of the display object, in pixels. The height is
	 * calculated based on the bounds of the content of the display object. When
	 * you set the <code>height</code> property, the <code>scaleY</code> property
	 * is adjusted accordingly, as shown in the following code:
	 *
	 * <p>Except for TextField and Video objects, a display object with no
	 * content(such as an empty sprite) has a height of 0, even if you try to
	 * set <code>height</code> to a different value.</p>
	 */
	public var height (get, set):Float;
	
	/**
	 * Returns a LoaderInfo object containing information about loading the file
	 * to which this display object belongs. The <code>loaderInfo</code> property
	 * is defined only for the root display object of a SWF file or for a loaded
	 * Bitmap(not for a Bitmap that is drawn with ActionScript). To find the
	 * <code>loaderInfo</code> object associated with the SWF file that contains
	 * a display object named <code>myDisplayObject</code>, use
	 * <code>myDisplayObject.root.loaderInfo</code>.
	 *
	 * <p>A large SWF file can monitor its download by calling
	 * <code>this.root.loaderInfo.addEventListener(Event.COMPLETE,
	 * func)</code>.</p>
	 */
	public var loaderInfo:LoaderInfo;
	
	/**
	 * The calling display object is masked by the specified <code>mask</code>
	 * object. To ensure that masking works when the Stage is scaled, the
	 * <code>mask</code> display object must be in an active part of the display
	 * list. The <code>mask</code> object itself is not drawn. Set
	 * <code>mask</code> to <code>null</code> to remove the mask.
	 *
	 * <p>To be able to scale a mask object, it must be on the display list. To
	 * be able to drag a mask Sprite object(by calling its
	 * <code>startDrag()</code> method), it must be on the display list. To call
	 * the <code>startDrag()</code> method for a mask sprite based on a
	 * <code>mouseDown</code> event being dispatched by the sprite, set the
	 * sprite's <code>buttonMode</code> property to <code>true</code>.</p>
	 *
	 * <p>When display objects are cached by setting the
	 * <code>cacheAsBitmap</code> property to <code>true</code> an the
	 * <code>cacheAsBitmapMatrix</code> property to a Matrix object, both the
	 * mask and the display object being masked must be part of the same cached
	 * bitmap. Thus, if the display object is cached, then the mask must be a
	 * child of the display object. If an ancestor of the display object on the
	 * display list is cached, then the mask must be a child of that ancestor or
	 * one of its descendents. If more than one ancestor of the masked object is
	 * cached, then the mask must be a descendent of the cached container closest
	 * to the masked object in the display list.</p>
	 *
	 * <p><b>Note:</b> A single <code>mask</code> object cannot be used to mask
	 * more than one calling display object. When the <code>mask</code> is
	 * assigned to a second display object, it is removed as the mask of the
	 * first object, and that object's <code>mask</code> property becomes
	 * <code>null</code>.</p>
	 */
	public var mask (get, set):DisplayObject;
	
	/**
	 * Indicates the x coordinate of the mouse or user input device position, in
	 * pixels.
	 *
	 * <p><b>Note</b>: For a DisplayObject that has been rotated, the returned x
	 * coordinate will reflect the non-rotated object.</p>
	 */
	public var mouseX (get, null):Float;
	
	/**
	 * Indicates the y coordinate of the mouse or user input device position, in
	 * pixels.
	 *
	 * <p><b>Note</b>: For a DisplayObject that has been rotated, the returned y
	 * coordinate will reflect the non-rotated object.</p>
	 */
	public var mouseY (get, null):Float;
	
	/**
	 * Indicates the instance name of the DisplayObject. The object can be
	 * identified in the child list of its parent display object container by
	 * calling the <code>getChildByName()</code> method of the display object
	 * container.
	 * 
	 * @throws IllegalOperationError If you are attempting to set this property
	 *                               on an object that was placed on the timeline
	 *                               in the Flash authoring tool.
	 */
	public var name (get, set):String;
	
	/**
	 * Specifies whether the display object is opaque with a certain background
	 * color. A transparent bitmap contains alpha channel data and is drawn
	 * transparently. An opaque bitmap has no alpha channel(and renders faster
	 * than a transparent bitmap). If the bitmap is opaque, you specify its own
	 * background color to use.
	 *
	 * <p>If set to a number value, the surface is opaque(not transparent) with
	 * the RGB background color that the number specifies. If set to
	 * <code>null</code>(the default value), the display object has a
	 * transparent background.</p>
	 *
	 * <p>The <code>opaqueBackground</code> property is intended mainly for use
	 * with the <code>cacheAsBitmap</code> property, for rendering optimization.
	 * For display objects in which the <code>cacheAsBitmap</code> property is
	 * set to true, setting <code>opaqueBackground</code> can improve rendering
	 * performance.</p>
	 *
	 * <p>The opaque background region is <i>not</i> matched when calling the
	 * <code>hitTestPoint()</code> method with the <code>shapeFlag</code>
	 * parameter set to <code>true</code>.</p>
	 *
	 * <p>The opaque background region does not respond to mouse events.</p>
	 */
	public var opaqueBackground:Null <Int>;
	
	/**
	 * Indicates the DisplayObjectContainer object that contains this display
	 * object. Use the <code>parent</code> property to specify a relative path to
	 * display objects that are above the current display object in the display
	 * list hierarchy.
	 *
	 * <p>You can use <code>parent</code> to move up multiple levels in the
	 * display list as in the following:</p>
	 * 
	 * @throws SecurityError The parent display object belongs to a security
	 *                       sandbox to which you do not have access. You can
	 *                       avoid this situation by having the parent movie call
	 *                       the <code>Security.allowDomain()</code> method.
	 */
	public var parent (default, null):DisplayObjectContainer;
	
	/**
	 * For a display object in a loaded SWF file, the <code>root</code> property
	 * is the top-most display object in the portion of the display list's tree
	 * structure represented by that SWF file. For a Bitmap object representing a
	 * loaded image file, the <code>root</code> property is the Bitmap object
	 * itself. For the instance of the main class of the first SWF file loaded,
	 * the <code>root</code> property is the display object itself. The
	 * <code>root</code> property of the Stage object is the Stage object itself.
	 * The <code>root</code> property is set to <code>null</code> for any display
	 * object that has not been added to the display list, unless it has been
	 * added to a display object container that is off the display list but that
	 * is a child of the top-most display object in a loaded SWF file.
	 *
	 * <p>For example, if you create a new Sprite object by calling the
	 * <code>Sprite()</code> constructor method, its <code>root</code> property
	 * is <code>null</code> until you add it to the display list(or to a display
	 * object container that is off the display list but that is a child of the
	 * top-most display object in a SWF file).</p>
	 *
	 * <p>For a loaded SWF file, even though the Loader object used to load the
	 * file may not be on the display list, the top-most display object in the
	 * SWF file has its <code>root</code> property set to itself. The Loader
	 * object does not have its <code>root</code> property set until it is added
	 * as a child of a display object for which the <code>root</code> property is
	 * set.</p>
	 */
	public var root (get, null):DisplayObject;
	
	/**
	 * Indicates the rotation of the DisplayObject instance, in degrees, from its
	 * original orientation. Values from 0 to 180 represent clockwise rotation;
	 * values from 0 to -180 represent counterclockwise rotation. Values outside
	 * this range are added to or subtracted from 360 to obtain a value within
	 * the range. For example, the statement <code>my_video.rotation = 450</code>
	 * is the same as <code> my_video.rotation = 90</code>.
	 */
	public var rotation (get, set):Float;
	
	/**
	 * The current scaling grid that is in effect. If set to <code>null</code>,
	 * the entire display object is scaled normally when any scale transformation
	 * is applied.
	 *
	 * <p>When you define the <code>scale9Grid</code> property, the display
	 * object is divided into a grid with nine regions based on the
	 * <code>scale9Grid</code> rectangle, which defines the center region of the
	 * grid. The eight other regions of the grid are the following areas: </p>
	 *
	 * <ul>
	 *   <li>The upper-left corner outside of the rectangle</li>
	 *   <li>The area above the rectangle </li>
	 *   <li>The upper-right corner outside of the rectangle</li>
	 *   <li>The area to the left of the rectangle</li>
	 *   <li>The area to the right of the rectangle</li>
	 *   <li>The lower-left corner outside of the rectangle</li>
	 *   <li>The area below the rectangle</li>
	 *   <li>The lower-right corner outside of the rectangle</li>
	 * </ul>
	 *
	 * <p>You can think of the eight regions outside of the center(defined by
	 * the rectangle) as being like a picture frame that has special rules
	 * applied to it when scaled.</p>
	 *
	 * <p>When the <code>scale9Grid</code> property is set and a display object
	 * is scaled, all text and gradients are scaled normally; however, for other
	 * types of objects the following rules apply:</p>
	 *
	 * <ul>
	 *   <li>Content in the center region is scaled normally. </li>
	 *   <li>Content in the corners is not scaled. </li>
	 *   <li>Content in the top and bottom regions is scaled horizontally only.
	 * Content in the left and right regions is scaled vertically only.</li>
	 *   <li>All fills(including bitmaps, video, and gradients) are stretched to
	 * fit their shapes.</li>
	 * </ul>
	 *
	 * <p>If a display object is rotated, all subsequent scaling is normal(and
	 * the <code>scale9Grid</code> property is ignored).</p>
	 *
	 * <p>For example, consider the following display object and a rectangle that
	 * is applied as the display object's <code>scale9Grid</code>:</p>
	 *
	 * <p>A common use for setting <code>scale9Grid</code> is to set up a display
	 * object to be used as a component, in which edge regions retain the same
	 * width when the component is scaled.</p>
	 * 
	 * @throws ArgumentError If you pass an invalid argument to the method.
	 */
	public var scale9Grid:Rectangle;
	
	/**
	 * Indicates the horizontal scale(percentage) of the object as applied from
	 * the registration point. The default registration point is(0,0). 1.0
	 * equals 100% scale.
	 *
	 * <p>Scaling the local coordinate system changes the <code>x</code> and
	 * <code>y</code> property values, which are defined in whole pixels. </p>
	 */
	public var scaleX (get, set):Float;
	
	/**
	 * Indicates the vertical scale(percentage) of an object as applied from the
	 * registration point of the object. The default registration point is(0,0).
	 * 1.0 is 100% scale.
	 *
	 * <p>Scaling the local coordinate system changes the <code>x</code> and
	 * <code>y</code> property values, which are defined in whole pixels. </p>
	 */
	public var scaleY (get, set):Float;
	
	/**
	 * The scroll rectangle bounds of the display object. The display object is
	 * cropped to the size defined by the rectangle, and it scrolls within the
	 * rectangle when you change the <code>x</code> and <code>y</code> properties
	 * of the <code>scrollRect</code> object.
	 *
	 * <p>The properties of the <code>scrollRect</code> Rectangle object use the
	 * display object's coordinate space and are scaled just like the overall
	 * display object. The corner bounds of the cropped window on the scrolling
	 * display object are the origin of the display object(0,0) and the point
	 * defined by the width and height of the rectangle. They are not centered
	 * around the origin, but use the origin to define the upper-left corner of
	 * the area. A scrolled display object always scrolls in whole pixel
	 * increments. </p>
	 *
	 * <p>You can scroll an object left and right by setting the <code>x</code>
	 * property of the <code>scrollRect</code> Rectangle object. You can scroll
	 * an object up and down by setting the <code>y</code> property of the
	 * <code>scrollRect</code> Rectangle object. If the display object is rotated
	 * 90° and you scroll it left and right, the display object actually scrolls
	 * up and down.</p>
	 */
	public var scrollRect (get, set):Rectangle;
	
	/**
	 * The Stage of the display object. A Flash runtime application has only one
	 * Stage object. For example, you can create and load multiple display
	 * objects into the display list, and the <code>stage</code> property of each
	 * display object refers to the same Stage object(even if the display object
	 * belongs to a loaded SWF file).
	 *
	 * <p>If a display object is not added to the display list, its
	 * <code>stage</code> property is set to <code>null</code>.</p>
	 */
	public var stage (default, null):Stage;
	
	/**
	 * An object with properties pertaining to a display object's matrix, color
	 * transform, and pixel bounds. The specific properties  -  matrix,
	 * colorTransform, and three read-only properties
	 * (<code>concatenatedMatrix</code>, <code>concatenatedColorTransform</code>,
	 * and <code>pixelBounds</code>)  -  are described in the entry for the
	 * Transform class.
	 *
	 * <p>Each of the transform object's properties is itself an object. This
	 * concept is important because the only way to set new values for the matrix
	 * or colorTransform objects is to create a new object and copy that object
	 * into the transform.matrix or transform.colorTransform property.</p>
	 *
	 * <p>For example, to increase the <code>tx</code> value of a display
	 * object's matrix, you must make a copy of the entire matrix object, then
	 * copy the new object into the matrix property of the transform object:</p>
	 * <pre xml:space="preserve"><code> var myMatrix:Matrix =
	 * myDisplayObject.transform.matrix; myMatrix.tx += 10;
	 * myDisplayObject.transform.matrix = myMatrix; </code></pre>
	 *
	 * <p>You cannot directly set the <code>tx</code> property. The following
	 * code has no effect on <code>myDisplayObject</code>: </p>
	 * <pre xml:space="preserve"><code> myDisplayObject.transform.matrix.tx +=
	 * 10; </code></pre>
	 *
	 * <p>You can also copy an entire transform object and assign it to another
	 * display object's transform property. For example, the following code
	 * copies the entire transform object from <code>myOldDisplayObj</code> to
	 * <code>myNewDisplayObj</code>:</p>
	 * <code>myNewDisplayObj.transform = myOldDisplayObj.transform;</code>
	 *
	 * <p>The resulting display object, <code>myNewDisplayObj</code>, now has the
	 * same values for its matrix, color transform, and pixel bounds as the old
	 * display object, <code>myOldDisplayObj</code>.</p>
	 *
	 * <p>Note that AIR for TV devices use hardware acceleration, if it is
	 * available, for color transforms.</p>
	 */
	public var transform (get, set):Transform;
	
	/**
	 * Whether or not the display object is visible. Display objects that are not
	 * visible are disabled. For example, if <code>visible=false</code> for an
	 * InteractiveObject instance, it cannot be clicked.
	 */
	public var visible (get, set):Bool;
	
	/**
	 * Indicates the width of the display object, in pixels. The width is
	 * calculated based on the bounds of the content of the display object. When
	 * you set the <code>width</code> property, the <code>scaleX</code> property
	 * is adjusted accordingly, as shown in the following code:
	 *
	 * <p>Except for TextField and Video objects, a display object with no
	 * content(such as an empty sprite) has a width of 0, even if you try to set
	 * <code>width</code> to a different value.</p>
	 */
	public var width (get, set):Float;
	
	/**
	 * Indicates the <i>x</i> coordinate of the DisplayObject instance relative
	 * to the local coordinates of the parent DisplayObjectContainer. If the
	 * object is inside a DisplayObjectContainer that has transformations, it is
	 * in the local coordinate system of the enclosing DisplayObjectContainer.
	 * Thus, for a DisplayObjectContainer rotated 90° counterclockwise, the
	 * DisplayObjectContainer's children inherit a coordinate system that is
	 * rotated 90° counterclockwise. The object's coordinates refer to the
	 * registration point position.
	 */
	public var x (get, set):Float;
	
	/**
	 * Indicates the <i>y</i> coordinate of the DisplayObject instance relative
	 * to the local coordinates of the parent DisplayObjectContainer. If the
	 * object is inside a DisplayObjectContainer that has transformations, it is
	 * in the local coordinate system of the enclosing DisplayObjectContainer.
	 * Thus, for a DisplayObjectContainer rotated 90° counterclockwise, the
	 * DisplayObjectContainer's children inherit a coordinate system that is
	 * rotated 90° counterclockwise. The object's coordinates refer to the
	 * registration point position.
	 */
	public var y (get, set):Float;
	
	@:dox(hide) @:noCompletion @:dox(hide) public var __worldTransform:Matrix;
	@:dox(hide) @:noCompletion @:dox(hide) public var __worldColorTransform:ColorTransform;
	
	@:noCompletion private var __alpha:Float;
	@:noCompletion private var __blendMode:BlendMode;
	@:noCompletion private var __filters:Array<BitmapFilter>;
	@:noCompletion private var __graphics:Graphics;
	@:noCompletion private var __interactive:Bool;
	@:noCompletion private var __isMask:Bool;
	@:noCompletion private var __mask:DisplayObject;
	@:noCompletion private var __maskGraphics:Graphics;
	@:noCompletion private var __maskCached:Bool = false;
	@:noCompletion private var __name:String;
	@:noCompletion private var __objectTransform:Transform;
	@:noCompletion private var __renderable:Bool;
	@:noCompletion private var __renderDirty:Bool;
	@:noCompletion private var __rotation:Float;
	@:noCompletion private var __rotationCosine:Float;
	@:noCompletion private var __rotationSine:Float;
	@:noCompletion private var __scrollRect:Rectangle;
	@:noCompletion private var __transform:Matrix;
	@:noCompletion private var __transformDirty:Bool;
	@:noCompletion private var __visible:Bool;
	@:noCompletion private var __worldAlpha:Float;
	@:noCompletion private var __worldAlphaChanged:Bool;
	@:noCompletion private var __worldClip:Rectangle;
	@:noCompletion private var __worldClipChanged:Bool;
	@:noCompletion private var __worldTransformCache:Matrix;
	@:noCompletion private var __worldTransformChanged:Bool;
	@:noCompletion private var __worldVisible:Bool;
	@:noCompletion private var __worldVisibleChanged:Bool;
	@:noCompletion private var __worldZ:Int;
	@:noCompletion private var __cacheAsBitmap:Bool = false;
	
	#if (js && html5)
	@:noCompletion private var __canvas:CanvasElement;
	@:noCompletion private var __context:CanvasRenderingContext2D;
	@:noCompletion private var __style:CSSStyleDeclaration;
	#end
	
	@:noCompletion private var __cairo:Cairo;
	
	
	private function new () {
		
		super ();
		
		__alpha = 1;
		__transform = new Matrix ();
		__visible = true;
		
		__rotation = 0;
		__rotationSine = 0;
		__rotationCosine = 1;
		
		__worldAlpha = 1;
		__worldTransform = new Matrix ();
		__worldColorTransform = new ColorTransform ();
		
		#if dom
		__worldVisible = true;
		#end
		
		name = "instance" + (++__instanceCount);
		
	}
	
	
	/**
	 * Returns a rectangle that defines the area of the display object relative
	 * to the coordinate system of the <code>targetCoordinateSpace</code> object.
	 * Consider the following code, which shows how the rectangle returned can
	 * vary depending on the <code>targetCoordinateSpace</code> parameter that
	 * you pass to the method:
	 *
	 * <p><b>Note:</b> Use the <code>localToGlobal()</code> and
	 * <code>globalToLocal()</code> methods to convert the display object's local
	 * coordinates to display coordinates, or display coordinates to local
	 * coordinates, respectively.</p>
	 *
	 * <p>The <code>getBounds()</code> method is similar to the
	 * <code>getRect()</code> method; however, the Rectangle returned by the
	 * <code>getBounds()</code> method includes any strokes on shapes, whereas
	 * the Rectangle returned by the <code>getRect()</code> method does not. For
	 * an example, see the description of the <code>getRect()</code> method.</p>
	 * 
	 * @param targetCoordinateSpace The display object that defines the
	 *                              coordinate system to use.
	 * @return The rectangle that defines the area of the display object relative
	 *         to the <code>targetCoordinateSpace</code> object's coordinate
	 *         system.
	 */
	public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle {
		
		var matrix = __getTransform ();
		
		if (targetCoordinateSpace != null) {
			
			matrix = matrix.clone ();
			matrix.concat (targetCoordinateSpace.__worldTransform.clone ().invert ());
			
		}
		
		var bounds = new Rectangle ();
		__getBounds (bounds, matrix);
		
		return bounds;
		
	}
	
	
	/**
	 * Returns a rectangle that defines the boundary of the display object, based
	 * on the coordinate system defined by the <code>targetCoordinateSpace</code>
	 * parameter, excluding any strokes on shapes. The values that the
	 * <code>getRect()</code> method returns are the same or smaller than those
	 * returned by the <code>getBounds()</code> method.
	 *
	 * <p><b>Note:</b> Use <code>localToGlobal()</code> and
	 * <code>globalToLocal()</code> methods to convert the display object's local
	 * coordinates to Stage coordinates, or Stage coordinates to local
	 * coordinates, respectively.</p>
	 * 
	 * @param targetCoordinateSpace The display object that defines the
	 *                              coordinate system to use.
	 * @return The rectangle that defines the area of the display object relative
	 *         to the <code>targetCoordinateSpace</code> object's coordinate
	 *         system.
	 */
	public function getRect (targetCoordinateSpace:DisplayObject):Rectangle {
		
		// should not account for stroke widths, but is that possible?
		return getBounds (targetCoordinateSpace);
		
	}
	
	
	/**
	 * Converts the <code>point</code> object from the Stage(global) coordinates
	 * to the display object's(local) coordinates.
	 *
	 * <p>To use this method, first create an instance of the Point class. The
	 * <i>x</i> and <i>y</i> values that you assign represent global coordinates
	 * because they relate to the origin(0,0) of the main display area. Then
	 * pass the Point instance as the parameter to the
	 * <code>globalToLocal()</code> method. The method returns a new Point object
	 * with <i>x</i> and <i>y</i> values that relate to the origin of the display
	 * object instead of the origin of the Stage.</p>
	 * 
	 * @param point An object created with the Point class. The Point object
	 *              specifies the <i>x</i> and <i>y</i> coordinates as
	 *              properties.
	 * @return A Point object with coordinates relative to the display object.
	 */
	public function globalToLocal (pos:Point):Point {
		
		pos = pos.clone ();
		__getTransform ().__transformInversePoint (pos);
		return pos;
		
	}
	
	
	/**
	 * Evaluates the bounding box of the display object to see if it overlaps or
	 * intersects with the bounding box of the <code>obj</code> display object.
	 * 
	 * @param obj The display object to test against.
	 * @return <code>true</code> if the bounding boxes of the display objects
	 *         intersect; <code>false</code> if not.
	 */
	public function hitTestObject (obj:DisplayObject):Bool {
		
		if (obj != null && obj.parent != null && parent != null) {
			
			var currentBounds = getBounds (this);
			var targetBounds = obj.getBounds (this);
			
			return currentBounds.intersects (targetBounds);
			
		}
		
		return false;
		
	}
	
	
	/**
	 * Evaluates the display object to see if it overlaps or intersects with the
	 * point specified by the <code>x</code> and <code>y</code> parameters. The
	 * <code>x</code> and <code>y</code> parameters specify a point in the
	 * coordinate space of the Stage, not the display object container that
	 * contains the display object(unless that display object container is the
	 * Stage).
	 * 
	 * @param x         The <i>x</i> coordinate to test against this object.
	 * @param y         The <i>y</i> coordinate to test against this object.
	 * @param shapeFlag Whether to check against the actual pixels of the object
	 *                 (<code>true</code>) or the bounding box
	 *                 (<code>false</code>).
	 * @return <code>true</code> if the display object overlaps or intersects
	 *         with the specified point; <code>false</code> otherwise.
	 */
	public function hitTestPoint (x:Float, y:Float, shapeFlag:Bool = false):Bool {
		
		if (parent != null) {
			
			var bounds = new Rectangle ();
			__getBounds (bounds, __getTransform ());
			
			return bounds.containsPoint (new Point (x, y));
			
		}
		
		return false;
		
	}
	
	
	/**
	 * Converts the <code>point</code> object from the display object's(local)
	 * coordinates to the Stage(global) coordinates.
	 *
	 * <p>This method allows you to convert any given <i>x</i> and <i>y</i>
	 * coordinates from values that are relative to the origin(0,0) of a
	 * specific display object(local coordinates) to values that are relative to
	 * the origin of the Stage(global coordinates).</p>
	 *
	 * <p>To use this method, first create an instance of the Point class. The
	 * <i>x</i> and <i>y</i> values that you assign represent local coordinates
	 * because they relate to the origin of the display object.</p>
	 *
	 * <p>You then pass the Point instance that you created as the parameter to
	 * the <code>localToGlobal()</code> method. The method returns a new Point
	 * object with <i>x</i> and <i>y</i> values that relate to the origin of the
	 * Stage instead of the origin of the display object.</p>
	 * 
	 * @param point The name or identifier of a point created with the Point
	 *              class, specifying the <i>x</i> and <i>y</i> coordinates as
	 *              properties.
	 * @return A Point object with coordinates relative to the Stage.
	 */
	public function localToGlobal (point:Point):Point {
		
		return __getTransform ().transformPoint (point);
		
	}
	
	
	@:noCompletion private function __broadcast (event:Event, notifyChilden:Bool):Bool {
		
		if (__eventMap != null && hasEventListener (event.type)) {
			
			var result = super.__dispatchEvent (event);
			
			if (event.__isCancelled) {
				
				return true;
				
			}
			
			return result;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private override function __dispatchEvent (event:Event):Bool {
		
		var result = super.__dispatchEvent (event);
		
		if (event.__isCancelled) {
			
			return true;
			
		}
		
		if (event.bubbles && parent != null && parent != this) {
			
			event.eventPhase = EventPhase.BUBBLING_PHASE;
			
			if (event.target == null) {
				
				event.target = this;
				
			}
			
			parent.__dispatchEvent (event);
			
		}
		
		return result;
		
	}
	
	
	@:noCompletion private function __enterFrame ():Void {
		
		
		
	}
	
	
	@:noCompletion private function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__graphics != null) {
			
			__graphics.__getBounds (rect, matrix);
			
		}
		
	}
	
	
	@:noCompletion private function __getCursor ():MouseCursor {
		
		return null;
		
	}
	
	
	@:noCompletion private function __getInteractive (stack:Array<DisplayObject>):Bool {
		
		return false;
		
	}
	
	
	@:noCompletion private inline function __getLocalBounds (rect:Rectangle):Void {
		
		__getTransform ();
		__getBounds (rect, new Matrix ());
		
	}
	
	
	@:noCompletion private function __getTransform ():Matrix {
		
		if (__transformDirty || __worldTransformDirty > 0) {
			
			var list = [];
			var current = this;
			var transformDirty = __transformDirty;
			
			if (parent == null) {
				
				if (transformDirty) __update (true, false);
				
			} else {
				
				while (current.parent != null) {
					
					list.push (current);
					current = current.parent;
					
					if (current.__transformDirty) {
						
						transformDirty = true;
						
					}
					
				}
				
			}
			
			if (transformDirty) {
				
				var i = list.length;
				while (--i >= 0) {
					
					list[i].__update (true, false);
					
				}
				
			}
			
		}
		
		return __worldTransform;
		
	}
	
	
	@:noCompletion private function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (__graphics != null) {
			
			if (!visible || __isMask) return false;
			if (mask != null && !mask.__hitTestMask (x, y)) return false;
			
			if (__graphics.__hitTest (x, y, shapeFlag, __getTransform ())) {
				
				if (stack != null && !interactiveOnly) {
					
					stack.push (this);
					
				}
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private function __hitTestMask (x:Float, y:Float):Bool {
		
		if (__graphics != null) {
			
			if (__graphics.__hitTest (x, y, true, __getTransform ())) {
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion @:dox(hide) public function __renderCairo (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CairoShape.render (this, renderSession);
			
		}
		
	}
	
	
	@:noCompletion @:dox(hide) public function __renderCairoMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CairoGraphics.renderMask (__graphics, renderSession);
			
		}
		
	}
	
	
	@:noCompletion @:dox(hide) public function __renderCanvas (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CanvasShape.render (this, renderSession);
			
		}
		
	}
	
	
	@:noCompletion @:dox(hide) public function __renderCanvasMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CanvasGraphics.renderMask (__graphics, renderSession);
			
		}
		
	}
	
	
	@:noCompletion @:dox(hide) public function __renderDOM (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			DOMShape.render (this, renderSession);
			
		}
		
	}
	
	
	@:noCompletion @:dox(hide) public function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (__graphics != null) {
			
			if (#if !disable_cairo_graphics __graphics.__hardware #else true #end) {
				
				GraphicsRenderer.render (this, renderSession);
				
			} else {
				
				#if (js && html5)
				CanvasGraphics.render (__graphics, renderSession);
				#elseif lime_cairo
				CairoGraphics.render (__graphics, renderSession);
				#end
				
				GLRenderer.renderBitmap (this, renderSession);
				
			}
			
		}
		
	}
	
	
	@:noCompletion private function __setStageReference (stage:Stage):Void {
		
		if (this.stage != stage) {
			
			if (this.stage != null) {
				
				dispatchEvent (new Event (Event.REMOVED_FROM_STAGE, false, false));
				
			}
			
			this.stage = stage;
			
			if (stage != null) {
				
				dispatchEvent (new Event (Event.ADDED_TO_STAGE, false, false));
				
			}
			
		}
		
	}
	
	
	@:noCompletion private inline function __setRenderDirty ():Void {
		
		if (!__renderDirty) {
			
			__renderDirty = true;
			__worldRenderDirty++;
			
		}
		
	}
	
	
	@:noCompletion private inline function __setTransformDirty ():Void {
		
		if (!__transformDirty) {
			
			__transformDirty = true;
			__worldTransformDirty++;
			
		}
		
	}
	
	
	@:noCompletion @:dox(hide) public function __update (transformOnly:Bool, updateChildren:Bool, ?maskGraphics:Graphics = null):Void {
		
		__renderable = (visible && scaleX != 0 && scaleY != 0 && !__isMask);
		
		if (__worldTransform == null) {
			
			__worldTransform = new Matrix ();
			
		}
		
		if (parent != null) {
			
			var parentTransform = parent.__worldTransform;
			
			__worldTransform.a = __transform.a * parentTransform.a + __transform.b * parentTransform.c;
			__worldTransform.b = __transform.a * parentTransform.b + __transform.b * parentTransform.d;
			__worldTransform.c = __transform.c * parentTransform.a + __transform.d * parentTransform.c;
			__worldTransform.d = __transform.c * parentTransform.b + __transform.d * parentTransform.d;
			__worldTransform.tx = __transform.tx * parentTransform.a + __transform.ty * parentTransform.c + parentTransform.tx;
			__worldTransform.ty = __transform.tx * parentTransform.b + __transform.ty * parentTransform.d + parentTransform.ty;
			
			if (__isMask) __maskCached = false;
			
		} else {
			
			__worldTransform.copyFrom (__transform);
			
		}
		
		if (scrollRect != null) {
			
			scrollRect.__transform (scrollRect, __worldTransform);
			
		}
		
		if (updateChildren && __transformDirty) {
			
			__transformDirty = false;
			__worldTransformDirty--;
			
		}
		
		if (!transformOnly && __mask != null && !__mask.__maskCached) {
			
			if (__maskGraphics == null) {
				
				__maskGraphics = new Graphics ();
				
			}
			
			__maskGraphics.clear ();
			
			__mask.__update (true, true, __maskGraphics);
			__mask.__maskCached = true;
			
		}
		
		if (maskGraphics != null) {
			
			__updateMask (maskGraphics);
			
		}
		
		if (!transformOnly) {
			
			#if dom
			__worldTransformChanged = !__worldTransform.equals (__worldTransformCache);
			
			if (__worldTransformCache == null) {
				
				__worldTransformCache = __worldTransform.clone ();
				
			} else {
				
				__worldTransformCache.copyFrom (__worldTransform);
				
			}
			
			var worldClip:Rectangle = null;
			#end
			
			if (!__worldColorTransform.__equals (transform.colorTransform)) {
				
				__worldColorTransform = transform.colorTransform.__clone ();
				
			}
			
			if (parent != null) {
				
				#if !dom
				
				__worldAlpha = alpha * parent.__worldAlpha;
				__worldColorTransform.__combine (parent.__worldColorTransform);
				
				if ((blendMode == null || blendMode == NORMAL)) {
					
					__blendMode = parent.__blendMode;
					
				}
				
				#else
				
				var worldVisible = (parent.__worldVisible && visible);
				__worldVisibleChanged = (__worldVisible != worldVisible);
				__worldVisible = worldVisible;
				
				var worldAlpha = alpha * parent.__worldAlpha;
				__worldAlphaChanged = (__worldAlpha != worldAlpha);
				__worldAlpha = worldAlpha;
				
				if (parent.__worldClip != null) {
					
					worldClip = parent.__worldClip.clone ();
					
				}
				
				if (scrollRect != null) {
					
					var bounds = scrollRect.clone ();
					bounds.__transform (bounds, __worldTransform);
					
					if (worldClip != null) {
						
						bounds.__contract (worldClip.x - scrollRect.x, worldClip.y - scrollRect.y, worldClip.width, worldClip.height);
						
					}
					
					worldClip = bounds;
					
				}
				
				#end
				
			} else {
				
				__worldAlpha = alpha;
				
				#if dom
				
				__worldVisibleChanged = (__worldVisible != visible);
				__worldVisible = visible;
				
				__worldAlphaChanged = (__worldAlpha != alpha);
				
				if (scrollRect != null) {
					
					worldClip = scrollRect.clone ();
					worldClip.__transform (worldClip, __worldTransform);
					
				}
				
				#end
				
			}
			
			#if dom
			__worldClipChanged = ((worldClip == null && __worldClip != null) || (worldClip != null && !worldClip.equals (__worldClip)));
			__worldClip = worldClip;
			#end
			
			if (updateChildren && __renderDirty) {
				
				__renderDirty = false;
				
			}
			
		}
		
	}
	
	
	@:noCompletion @:dox(hide) public function __updateChildren (transformOnly:Bool):Void {
		
		__renderable = (visible && scaleX != 0 && scaleY != 0 && !__isMask);
		if (!__renderable && !__isMask) return;
		__worldAlpha = alpha;
		
		if (__transformDirty) {
			
			__transformDirty = false;
			__worldTransformDirty--;
			
		}
		
	}
	
	
	@:noCompletion @:dox(hide) public function __updateMask (maskGraphics:Graphics):Void {
		
		if (__graphics != null) {
			
			maskGraphics.__commands.push (OverrideMatrix (this.__worldTransform));
			maskGraphics.__commands = maskGraphics.__commands.concat (__graphics.__commands);
			maskGraphics.__dirty = true;
			maskGraphics.__visible = true;
			
			if (maskGraphics.__bounds == null) {
				
				maskGraphics.__bounds = new Rectangle();
				
			}
			
			__graphics.__getBounds (maskGraphics.__bounds, @:privateAccess Matrix.__identity);
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_alpha ():Float {
		
		return __alpha;
		
	}
	
	
	@:noCompletion private function set_alpha (value:Float):Float {
		
		if (value > 1.0) value = 1.0;
		if (value != __alpha) __setRenderDirty ();
		return __alpha = value;
		
	}
	
	
	@:noCompletion private function set_blendMode (value:BlendMode):BlendMode {
		
		__blendMode = value;
		return blendMode = value;
		
	}
	
	
	@:noCompletion private function get_filters ():Array<BitmapFilter> {
		
		if (__filters == null) {
			
			return new Array ();
			
		} else {
			
			return __filters.copy ();
			
		}
		
	}
	
	
	@:noCompletion private function set_filters (value:Array<BitmapFilter>):Array<BitmapFilter> {
		
		// set
		
		return value;
		
	}
	
	
	@:noCompletion private function get_height ():Float {
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		return bounds.height * scaleY;
		
	}
	
	
	@:noCompletion private function set_height (value:Float):Float {
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		if (value != bounds.height) {
			
			scaleY = value / bounds.height;
			
		} else {
			
			scaleY = 1;
			
		}
		
		return value;
		
	}
	
	
	@:noCompletion private function get_mask ():DisplayObject {
		
		return __mask;
		
	}
	
	
	@:noCompletion private function set_mask (value:DisplayObject):DisplayObject {
		
		if (value != __mask) {
			__setTransformDirty ();
			__setRenderDirty ();
		}
		if (__mask != null) {
			__mask.__isMask = false;
			__mask.__maskCached = false;
			__mask.__setTransformDirty();
			__mask.__setRenderDirty();
			__maskGraphics = null;
		}
		if (value != null) value.__isMask = true;
		return __mask = value;
		
	}
	
	
	@:noCompletion private function get_mouseX ():Float {
		
		if (stage != null) {
			
			return __getTransform ().__transformInverseX (stage.__mouseX, stage.__mouseY);
			
			
		}
		
		return 0;
		
	}
	
	
	@:noCompletion private function get_mouseY ():Float {
		
		if (stage != null) {
			
			return __getTransform ().__transformInverseY (stage.__mouseX, stage.__mouseY);
			
		}
		
		return 0;
		
	}
	
	
	@:noCompletion private function get_name ():String {
		
		return __name;
		
	}
	
	
	@:noCompletion private function set_name (value:String):String {
		
		return __name = value;
		
	}
	
	
	@:noCompletion private function get_root ():DisplayObject {
		
		if (stage != null) {
			
			return Lib.current;
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function get_rotation ():Float {
		
		return __rotation;
		
	}
	
	
	@:noCompletion private function set_rotation (value:Float):Float {
		
		if (value != __rotation) {
			
			__rotation = value;
			var radians = __rotation * (Math.PI / 180);
			__rotationSine = Math.sin (radians);
			__rotationCosine = Math.cos (radians);
			
			var __scaleX = this.scaleX;
			var __scaleY = this.scaleY;
			
			__transform.a = __rotationCosine * __scaleX;
			__transform.b = __rotationSine * __scaleX;
			__transform.c = -__rotationSine * __scaleY;
			__transform.d = __rotationCosine * __scaleY;
			
			__setTransformDirty ();
			
		}
		
		return value;
		
	}
	
	
	@:noCompletion private function get_scaleX ():Float {
		
		if (__transform.b == 0) {
			
			return __transform.a;
			
		} else {
			
			return Math.sqrt (__transform.a * __transform.a + __transform.b * __transform.b);
			
		}
		
	}
	
	
	@:noCompletion private function set_scaleX (value:Float):Float {
		
		if (__transform.c == 0) {
			
			if (value != __transform.a) __setTransformDirty ();
			__transform.a = value;
			
		} else {
			
			var a = __rotationCosine * value;
			var b = __rotationSine * value;
			
			if (__transform.a != a || __transform.b != b) {
				
				__setTransformDirty ();
				
			}
			
			__transform.a = a;
			__transform.b = b;
			
		}
		
		return value;
		
	}
	
	
	@:noCompletion private function get_scaleY ():Float {
		
		if (__transform.c == 0) {
			
			return __transform.d;
			
		} else {
			
			return Math.sqrt (__transform.c * __transform.c + __transform.d * __transform.d);
			
		}
		
	}
	
	
	@:noCompletion private function set_scaleY (value:Float):Float {
		
		if (__transform.c == 0) {
			
			if (value != __transform.d) __setTransformDirty ();
			__transform.d = value;
			
		} else {
			
			var c = -__rotationSine * value;
			var d = __rotationCosine * value;
			
			if (__transform.d != d || __transform.c != c) {
				
				__setTransformDirty ();
				
			}
			
			__transform.c = c;
			__transform.d = d;
			
		}
		
		return value;
		
	}
	
	
	@:noCompletion private function get_scrollRect ():Rectangle {
		
		if ( __scrollRect == null ) return null;
		
		return __scrollRect.clone();
		
	}
	
	
	@:noCompletion private function set_scrollRect (value:Rectangle):Rectangle {
		
		if (value != __scrollRect) {
			
			__setTransformDirty ();
			#if dom __setRenderDirty (); #end
			
		}
		
		return __scrollRect = value;
		
	}
	
	
	@:noCompletion private function get_transform ():Transform {
		
		if (__objectTransform == null) {
			
			__objectTransform = new Transform (this);
			
		}
		
		return __objectTransform;
		
	}
	
	
	@:noCompletion private function set_transform (value:Transform):Transform {
		
		if (value == null) {
			
			throw new TypeError ("Parameter transform must be non-null.");
			
		}
		
		if (__objectTransform == null) {
			
			__objectTransform = new Transform (this);
			
		}
		
		__setTransformDirty ();
		__objectTransform.matrix = value.matrix;
		__objectTransform.colorTransform = value.colorTransform.__clone();
		
		return __objectTransform;
		
	}
	
	
	@:noCompletion private function get_visible ():Bool {
		
		return __visible;
		
	}
	
	
	@:noCompletion private function set_visible (value:Bool):Bool {
		
		if (value != __visible) __setRenderDirty ();
		return __visible = value;
		
	}
	
	
	@:noCompletion private function get_width ():Float {
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		return bounds.width * scaleX;
		
	}
	
	
	@:noCompletion private function set_width (value:Float):Float {
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		if (value != bounds.width) {
			
			scaleX = value / bounds.width;
			
		} else {
			
			scaleX = 1;
			
		}
		
		return value;
		
	}
	
	
	@:noCompletion private function get_x ():Float {
		
		return __transform.tx;
		
	}
	
	
	@:noCompletion private function set_x (value:Float):Float {
		
		if (value != __transform.tx) __setTransformDirty ();
		return __transform.tx = value;
		
	}
	
	
	@:noCompletion private function get_y ():Float {
		
		return __transform.ty;
		
	}
	
	
	@:noCompletion private function set_y (value:Float):Float {
		
		if (value != __transform.ty) __setTransformDirty ();
		return __transform.ty = value;
		
	}
	
	
}


#else
typedef DisplayObject = openfl._legacy.display.DisplayObject;
#end
#else
typedef DisplayObject = flash.display.DisplayObject;
#end
