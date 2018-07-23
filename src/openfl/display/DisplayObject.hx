package openfl.display; #if !flash


import lime.graphics.cairo.Cairo;
import lime.ui.MouseCursor;
import lime.utils.ObjectPool;
import openfl._internal.renderer.cairo.CairoBitmap;
import openfl._internal.renderer.cairo.CairoDisplayObject;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasBitmap;
import openfl._internal.renderer.canvas.CanvasDisplayObject;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.dom.DOMBitmap;
import openfl._internal.renderer.dom.DOMDisplayObject;
import openfl._internal.renderer.opengl.GLBitmap;
import openfl._internal.renderer.opengl.GLDisplayObject;
import openfl._internal.renderer.opengl.GLGraphics;
import openfl._internal.renderer.opengl.GLShape;
import openfl._internal.Lib;
import openfl.display.Stage;
import openfl.errors.TypeError;
import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;
import openfl.events.RenderEvent;
import openfl.events.TouchEvent;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.Vector;

#if (lime >= "7.0.0")
import lime._internal.graphics.ImageCanvasUtil; // TODO
#else
import lime.graphics.utils.ImageCanvasUtil;
#end

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
 * The DisplayObject class supports basic functionality like the _x_
 * and _y_ position of an object, as well as more advanced properties of
 * the object such as its transformation matrix. 
 *
 * DisplayObject is an abstract base class; therefore, you cannot call
 * DisplayObject directly. Invoking `new DisplayObject()` throws an
 * `ArgumentError` exception. 
 *
 * All display objects inherit from the DisplayObject class.
 *
 * The DisplayObject class itself does not include any APIs for rendering
 * content onscreen. For that reason, if you want create a custom subclass of
 * the DisplayObject class, you will want to extend one of its subclasses that
 * do have APIs for rendering content onscreen, such as the Shape, Sprite,
 * Bitmap, SimpleButton, TextField, or MovieClip class.
 *
 * The DisplayObject class contains several broadcast events. Normally, the
 * target of any particular event is a specific DisplayObject instance. For
 * example, the target of an `added` event is the specific
 * DisplayObject instance that was added to the display list. Having a single
 * target restricts the placement of event listeners to that target and in
 * some cases the target's ancestors on the display list. With broadcast
 * events, however, the target is not a specific DisplayObject instance, but
 * rather all DisplayObject instances, including those that are not on the
 * display list. This means that you can add a listener to any DisplayObject
 * instance to listen for broadcast events. In addition to the broadcast
 * events listed in the DisplayObject class's Events table, the DisplayObject
 * class also inherits two broadcast events from the EventDispatcher class:
 * `activate` and `deactivate`.
 *
 * Some properties previously used in the ActionScript 1.0 and 2.0
 * MovieClip, TextField, and Button classes(such as `_alpha`,
 * `_height`, `_name`, `_width`,
 * `_x`, `_y`, and others) have equivalents in the
 * ActionScript 3.0 DisplayObject class that are renamed so that they no
 * longer begin with the underscore(_) character.
 *
 * For more information, see the "Display Programming" chapter of the
 * _ActionScript 3.0 Developer's Guide_.
 * 
 * @event added            Dispatched when a display object is added to the
 *                         display list. The following methods trigger this
 *                         event:
 *                         `DisplayObjectContainer.addChild()`,
 *                         `DisplayObjectContainer.addChildAt()`.
 * @event addedToStage     Dispatched when a display object is added to the on
 *                         stage display list, either directly or through the
 *                         addition of a sub tree in which the display object
 *                         is contained. The following methods trigger this
 *                         event:
 *                         `DisplayObjectContainer.addChild()`,
 *                         `DisplayObjectContainer.addChildAt()`.
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
 *                         `removeChild()` and
 *                         `removeChildAt()`.
 *
 *                         The following methods of a
 *                         DisplayObjectContainer object also generate this
 *                         event if an object must be removed to make room for
 *                         the new object: `addChild()`,
 *                         `addChildAt()`, and
 *                         `setChildIndex()`. 
 * @event removedFromStage Dispatched when a display object is about to be
 *                         removed from the display list, either directly or
 *                         through the removal of a sub tree in which the
 *                         display object is contained. Two methods of the
 *                         DisplayObjectContainer class generate this event:
 *                         `removeChild()` and
 *                         `removeChildAt()`.
 *
 *                         The following methods of a
 *                         DisplayObjectContainer object also generate this
 *                         event if an object must be removed to make room for
 *                         the new object: `addChild()`,
 *                         `addChildAt()`, and
 *                         `setChildIndex()`. 
 * @event render           [broadcast event] Dispatched when the display list
 *                         is about to be updated and rendered. This event
 *                         provides the last opportunity for objects listening
 *                         for this event to make changes before the display
 *                         list is rendered. You must call the
 *                         `invalidate()` method of the Stage
 *                         object each time you want a `render`
 *                         event to be dispatched. `Render` events
 *                         are dispatched to an object only if there is mutual
 *                         trust between it and the object that called
 *                         `Stage.invalidate()`. This event is a
 *                         broadcast event, which means that it is dispatched
 *                         by all display objects with a listener registered
 *                         for this event.
 *
 *                         **Note: **This event is not dispatched if the
 *                         display is not rendering. This is the case when the
 *                         content is either minimized or obscured. 
 */

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(lime.graphics.Image)
@:access(lime.graphics.ImageBuffer)
@:access(openfl._internal.renderer.opengl.GLGraphics)
@:access(openfl.events.Event)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObjectContainer)
@:access(openfl.display.Graphics)
@:access(openfl.display.Shader)
@:access(openfl.display.Stage)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class DisplayObject extends EventDispatcher implements IBitmapDrawable #if (openfl_dynamic && haxe_ver < "4.0.0") implements Dynamic<DisplayObject> #end {
	
	
	@:noCompletion private static var __broadcastEvents = new Map<String, Array<DisplayObject>> ();
	@:noCompletion private static var __initStage:Stage;
	@:noCompletion private static var __instanceCount = 0;
	@:noCompletion private static #if !js inline #end var __supportDOM:Bool #if !js = false #end;
	@:noCompletion private static var __tempColorTransform = new ColorTransform ();
	@:noCompletion private static var __tempStack = new ObjectPool<Vector<DisplayObject>> (function () { return new Vector<DisplayObject> (); }, function (stack) { stack.length = 0; });
	
	
	// @:noCompletion @:dox(hide) public var accessibilityProperties:flash.accessibility.AccessibilityProperties;
	
	/**
	 * Indicates the alpha transparency value of the object specified. Valid
	 * values are 0(fully transparent) to 1(fully opaque). The default value is
	 * 1. Display objects with `alpha` set to 0 _are_ active,
	 * even though they are invisible.
	 */
	@:keep public var alpha (get, set):Float;
	
	/**
	 * A value from the BlendMode class that specifies which blend mode to use. A
	 * bitmap can be drawn internally in two ways. If you have a blend mode
	 * enabled or an external clipping mask, the bitmap is drawn by adding a
	 * bitmap-filled square shape to the vector render. If you attempt to set
	 * this property to an invalid value, Flash runtimes set the value to
	 * `BlendMode.NORMAL`.
	 *
	 * The `blendMode` property affects each pixel of the display
	 * object. Each pixel is composed of three constituent colors(red, green,
	 * and blue), and each constituent color has a value between 0x00 and 0xFF.
	 * Flash Player or Adobe AIR compares each constituent color of one pixel in
	 * the movie clip with the corresponding color of the pixel in the
	 * background. For example, if `blendMode` is set to
	 * `BlendMode.LIGHTEN`, Flash Player or Adobe AIR compares the red
	 * value of the display object with the red value of the background, and uses
	 * the lighter of the two as the value for the red component of the displayed
	 * color.
	 *
	 * The following table describes the `blendMode` settings. The
	 * BlendMode class defines string values you can use. The illustrations in
	 * the table show `blendMode` values applied to a circular display
	 * object(2) superimposed on another display object(1).
	 */
	public var blendMode (get, set):BlendMode;
	
	// @:noCompletion @:dox(hide) @:require(flash10) public var blendShader (null, default):Shader;
	
	/**
	 * All vector data for a display object that has a cached bitmap is drawn
	 * to the bitmap instead of the main display. If
	 * `cacheAsBitmapMatrix` is null or unsupported, the bitmap is
	 * then copied to the main display as unstretched, unrotated pixels snapped
	 * to the nearest pixel boundaries. Pixels are mapped 1 to 1 with the parent
	 * object. If the bounds of the bitmap change, the bitmap is recreated
	 * instead of being stretched.
	 *
	 * If `cacheAsBitmapMatrix` is non-null and supported, the
	 * object is drawn to the off-screen bitmap using that matrix and the
	 * stretched and/or rotated results of that rendering are used to draw the
	 * object to the main display.
	 *
	 * No internal bitmap is created unless the `cacheAsBitmap`
	 * property is set to `true`.
	 *
	 * After you set the `cacheAsBitmap` property to
	 * `true`, the rendering does not change, however the display
	 * object performs pixel snapping automatically. The animation speed can be
	 * significantly faster depending on the complexity of the vector content.
	 * 
	 *
	 * The `cacheAsBitmap` property is automatically set to
	 * `true` whenever you apply a filter to a display object(when
	 * its `filter` array is not empty), and if a display object has a
	 * filter applied to it, `cacheAsBitmap` is reported as
	 * `true` for that display object, even if you set the property to
	 * `false`. If you clear all filters for a display object, the
	 * `cacheAsBitmap` setting changes to what it was last set to.
	 *
	 * A display object does not use a bitmap even if the
	 * `cacheAsBitmap` property is set to `true` and
	 * instead renders from vector data in the following cases:
	 *
	 * 
	 *  * The bitmap is too large. In AIR 1.5 and Flash Player 10, the maximum
	 * size for a bitmap image is 8,191 pixels in width or height, and the total
	 * number of pixels cannot exceed 16,777,215 pixels.(So, if a bitmap image
	 * is 8,191 pixels wide, it can only be 2,048 pixels high.) In Flash Player 9
	 * and earlier, the limitation is is 2880 pixels in height and 2,880 pixels
	 * in width.
	 *  * The bitmap fails to allocate(out of memory error). 
	 * 
	 *
	 * The `cacheAsBitmap` property is best used with movie clips
	 * that have mostly static content and that do not scale and rotate
	 * frequently. With such movie clips, `cacheAsBitmap` can lead to
	 * performance increases when the movie clip is translated(when its _x_
	 * and _y_ position is changed).
	 */
	public var cacheAsBitmap (get, set):Bool;
	
	public var cacheAsBitmapMatrix (get, set):Matrix;
	
	/**
	 * An indexed array that contains each filter object currently associated
	 * with the display object. The openfl.filters package contains several
	 * classes that define specific filters you can use.
	 *
	 * Filters can be applied in Flash Professional at design time, or at run
	 * time by using ActionScript code. To apply a filter by using ActionScript,
	 * you must make a temporary copy of the entire `filters` array,
	 * modify the temporary array, then assign the value of the temporary array
	 * back to the `filters` array. You cannot directly add a new
	 * filter object to the `filters` array.
	 *
	 * To add a filter by using ActionScript, perform the following steps
	 * (assume that the target display object is named
	 * `myDisplayObject`):
	 *
	 *  1. Create a new filter object by using the constructor method of your
	 * chosen filter class.
	 *  2. Assign the value of the `myDisplayObject.filters` array
	 * to a temporary array, such as one named `myFilters`.
	 *  3. Add the new filter object to the `myFilters` temporary
	 * array.
	 *  4. Assign the value of the temporary array to the
	 * `myDisplayObject.filters` array.
	 *
	 * If the `filters` array is undefined, you do not need to use
	 * a temporary array. Instead, you can directly assign an array literal that
	 * contains one or more filter objects that you create. The first example in
	 * the Examples section adds a drop shadow filter by using code that handles
	 * both defined and undefined `filters` arrays.
	 *
	 * To modify an existing filter object, you must use the technique of
	 * modifying a copy of the `filters` array:
	 *
	 *  1. Assign the value of the `filters` array to a temporary
	 * array, such as one named `myFilters`.
	 *  2. Modify the property by using the temporary array,
	 * `myFilters`. For example, to set the quality property of the
	 * first filter in the array, you could use the following code:
	 * `myFilters[0].quality = 1;`
	 *  3. Assign the value of the temporary array to the `filters`
	 * array.
	 *
	 * At load time, if a display object has an associated filter, it is
	 * marked to cache itself as a transparent bitmap. From this point forward,
	 * as long as the display object has a valid filter list, the player caches
	 * the display object as a bitmap. This source bitmap is used as a source
	 * image for the filter effects. Each display object usually has two bitmaps:
	 * one with the original unfiltered source display object and another for the
	 * final image after filtering. The final image is used when rendering. As
	 * long as the display object does not change, the final image does not need
	 * updating.
	 *
	 * The openfl.filters package includes classes for filters. For example, to
	 * create a DropShadow filter, you would write:
	 * 
	 * @throws ArgumentError When `filters` includes a ShaderFilter
	 *                       and the shader output type is not compatible with
	 *                       this operation(the shader must specify a
	 *                       `pixel4` output).
	 * @throws ArgumentError When `filters` includes a ShaderFilter
	 *                       and the shader doesn't specify any image input or
	 *                       the first input is not an `image4` input.
	 * @throws ArgumentError When `filters` includes a ShaderFilter
	 *                       and the shader specifies an image input that isn't
	 *                       provided.
	 * @throws ArgumentError When `filters` includes a ShaderFilter, a
	 *                       ByteArray or Vector.<Number> instance as a shader
	 *                       input, and the `width` and
	 *                       `height` properties aren't specified for
	 *                       the ShaderInput object, or the specified values
	 *                       don't match the amount of data in the input data.
	 *                       See the `ShaderInput.input` property for
	 *                       more information.
	 */
	public var filters (get, set):Array<BitmapFilter>;
	
	/**
	 * Indicates the height of the display object, in pixels. The height is
	 * calculated based on the bounds of the content of the display object. When
	 * you set the `height` property, the `scaleY` property
	 * is adjusted accordingly, as shown in the following code:
	 *
	 * Except for TextField and Video objects, a display object with no
	 * content(such as an empty sprite) has a height of 0, even if you try to
	 * set `height` to a different value.
	 */
	@:keep public var height (get, set):Float;
	
	/**
	 * Returns a LoaderInfo object containing information about loading the file
	 * to which this display object belongs. The `loaderInfo` property
	 * is defined only for the root display object of a SWF file or for a loaded
	 * Bitmap(not for a Bitmap that is drawn with ActionScript). To find the
	 * `loaderInfo` object associated with the SWF file that contains
	 * a display object named `myDisplayObject`, use
	 * `myDisplayObject.root.loaderInfo`.
	 *
	 * A large SWF file can monitor its download by calling
	 * `this.root.loaderInfo.addEventListener(Event.COMPLETE,
	 * func)`.
	 */
	public var loaderInfo (get, never):LoaderInfo;
	
	/**
	 * The calling display object is masked by the specified `mask`
	 * object. To ensure that masking works when the Stage is scaled, the
	 * `mask` display object must be in an active part of the display
	 * list. The `mask` object itself is not drawn. Set
	 * `mask` to `null` to remove the mask.
	 *
	 * To be able to scale a mask object, it must be on the display list. To
	 * be able to drag a mask Sprite object(by calling its
	 * `startDrag()` method), it must be on the display list. To call
	 * the `startDrag()` method for a mask sprite based on a
	 * `mouseDown` event being dispatched by the sprite, set the
	 * sprite's `buttonMode` property to `true`.
	 *
	 * When display objects are cached by setting the
	 * `cacheAsBitmap` property to `true` an the
	 * `cacheAsBitmapMatrix` property to a Matrix object, both the
	 * mask and the display object being masked must be part of the same cached
	 * bitmap. Thus, if the display object is cached, then the mask must be a
	 * child of the display object. If an ancestor of the display object on the
	 * display list is cached, then the mask must be a child of that ancestor or
	 * one of its descendents. If more than one ancestor of the masked object is
	 * cached, then the mask must be a descendent of the cached container closest
	 * to the masked object in the display list.
	 *
	 * **Note:** A single `mask` object cannot be used to mask
	 * more than one calling display object. When the `mask` is
	 * assigned to a second display object, it is removed as the mask of the
	 * first object, and that object's `mask` property becomes
	 * `null`.
	 */
	public var mask (get, set):DisplayObject;
	
	/**
	 * Indicates the x coordinate of the mouse or user input device position, in
	 * pixels.
	 *
	 * **Note**: For a DisplayObject that has been rotated, the returned x
	 * coordinate will reflect the non-rotated object.
	 */
	public var mouseX (get, never):Float;
	
	/**
	 * Indicates the y coordinate of the mouse or user input device position, in
	 * pixels.
	 *
	 * **Note**: For a DisplayObject that has been rotated, the returned y
	 * coordinate will reflect the non-rotated object.
	 */
	public var mouseY (get, never):Float;
	
	/**
	 * Indicates the instance name of the DisplayObject. The object can be
	 * identified in the child list of its parent display object container by
	 * calling the `getChildByName()` method of the display object
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
	 * If set to a number value, the surface is opaque(not transparent) with
	 * the RGB background color that the number specifies. If set to
	 * `null`(the default value), the display object has a
	 * transparent background.
	 *
	 * The `opaqueBackground` property is intended mainly for use
	 * with the `cacheAsBitmap` property, for rendering optimization.
	 * For display objects in which the `cacheAsBitmap` property is
	 * set to true, setting `opaqueBackground` can improve rendering
	 * performance.
	 *
	 * The opaque background region is _not_ matched when calling the
	 * `hitTestPoint()` method with the `shapeFlag`
	 * parameter set to `true`.
	 *
	 * The opaque background region does not respond to mouse events.
	 */
	public var opaqueBackground:Null<Int>;
	
	/**
	 * Indicates the DisplayObjectContainer object that contains this display
	 * object. Use the `parent` property to specify a relative path to
	 * display objects that are above the current display object in the display
	 * list hierarchy.
	 *
	 * You can use `parent` to move up multiple levels in the
	 * display list as in the following:
	 * 
	 * @throws SecurityError The parent display object belongs to a security
	 *                       sandbox to which you do not have access. You can
	 *                       avoid this situation by having the parent movie call
	 *                       the `Security.allowDomain()` method.
	 */
	public var parent (default, null):DisplayObjectContainer;
	
	/**
	 * For a display object in a loaded SWF file, the `root` property
	 * is the top-most display object in the portion of the display list's tree
	 * structure represented by that SWF file. For a Bitmap object representing a
	 * loaded image file, the `root` property is the Bitmap object
	 * itself. For the instance of the main class of the first SWF file loaded,
	 * the `root` property is the display object itself. The
	 * `root` property of the Stage object is the Stage object itself.
	 * The `root` property is set to `null` for any display
	 * object that has not been added to the display list, unless it has been
	 * added to a display object container that is off the display list but that
	 * is a child of the top-most display object in a loaded SWF file.
	 *
	 * For example, if you create a new Sprite object by calling the
	 * `Sprite()` constructor method, its `root` property
	 * is `null` until you add it to the display list(or to a display
	 * object container that is off the display list but that is a child of the
	 * top-most display object in a SWF file).
	 *
	 * For a loaded SWF file, even though the Loader object used to load the
	 * file may not be on the display list, the top-most display object in the
	 * SWF file has its `root` property set to itself. The Loader
	 * object does not have its `root` property set until it is added
	 * as a child of a display object for which the `root` property is
	 * set.
	 */
	public var root (get, never):DisplayObject;
	
	/**
	 * Indicates the rotation of the DisplayObject instance, in degrees, from its
	 * original orientation. Values from 0 to 180 represent clockwise rotation;
	 * values from 0 to -180 represent counterclockwise rotation. Values outside
	 * this range are added to or subtracted from 360 to obtain a value within
	 * the range. For example, the statement `my_video.rotation = 450`
	 * is the same as ` my_video.rotation = 90`.
	 */
	@:keep public var rotation (get, set):Float;
	
	// @:noCompletion @:dox(hide) @:require(flash10) public var rotationX:Float;
	// @:noCompletion @:dox(hide) @:require(flash10) public var rotationY:Float;
	// @:noCompletion @:dox(hide) @:require(flash10) public var rotationZ:Float;
	
	/**
	 * The current scaling grid that is in effect. If set to `null`,
	 * the entire display object is scaled normally when any scale transformation
	 * is applied.
	 *
	 * When you define the `scale9Grid` property, the display
	 * object is divided into a grid with nine regions based on the
	 * `scale9Grid` rectangle, which defines the center region of the
	 * grid. The eight other regions of the grid are the following areas: 
	 *
	 * 
	 *  * The upper-left corner outside of the rectangle
	 *  * The area above the rectangle 
	 *  * The upper-right corner outside of the rectangle
	 *  * The area to the left of the rectangle
	 *  * The area to the right of the rectangle
	 *  * The lower-left corner outside of the rectangle
	 *  * The area below the rectangle
	 *  * The lower-right corner outside of the rectangle
	 * 
	 *
	 * You can think of the eight regions outside of the center(defined by
	 * the rectangle) as being like a picture frame that has special rules
	 * applied to it when scaled.
	 *
	 * When the `scale9Grid` property is set and a display object
	 * is scaled, all text and gradients are scaled normally; however, for other
	 * types of objects the following rules apply:
	 *
	 * 
	 *  * Content in the center region is scaled normally. 
	 *  * Content in the corners is not scaled. 
	 *  * Content in the top and bottom regions is scaled horizontally only.
	 * Content in the left and right regions is scaled vertically only.
	 *  * All fills(including bitmaps, video, and gradients) are stretched to
	 * fit their shapes.
	 * 
	 *
	 * If a display object is rotated, all subsequent scaling is normal(and
	 * the `scale9Grid` property is ignored).
	 *
	 * For example, consider the following display object and a rectangle that
	 * is applied as the display object's `scale9Grid`:
	 *
	 * A common use for setting `scale9Grid` is to set up a display
	 * object to be used as a component, in which edge regions retain the same
	 * width when the component is scaled.
	 * 
	 * @throws ArgumentError If you pass an invalid argument to the method.
	 */
	public var scale9Grid:Rectangle;
	
	/**
	 * Indicates the horizontal scale(percentage) of the object as applied from
	 * the registration point. The default registration point is(0,0). 1.0
	 * equals 100% scale.
	 *
	 * Scaling the local coordinate system changes the `x` and
	 * `y` property values, which are defined in whole pixels. 
	 */
	@:keep public var scaleX (get, set):Float;
	
	/**
	 * Indicates the vertical scale(percentage) of an object as applied from the
	 * registration point of the object. The default registration point is(0,0).
	 * 1.0 is 100% scale.
	 *
	 * Scaling the local coordinate system changes the `x` and
	 * `y` property values, which are defined in whole pixels. 
	 */
	@:keep public var scaleY (get, set):Float;
	
	// @:noCompletion @:dox(hide) @:require(flash10) public var scaleZ:Float;
	
	/**
	 * The scroll rectangle bounds of the display object. The display object is
	 * cropped to the size defined by the rectangle, and it scrolls within the
	 * rectangle when you change the `x` and `y` properties
	 * of the `scrollRect` object.
	 *
	 * The properties of the `scrollRect` Rectangle object use the
	 * display object's coordinate space and are scaled just like the overall
	 * display object. The corner bounds of the cropped window on the scrolling
	 * display object are the origin of the display object(0,0) and the point
	 * defined by the width and height of the rectangle. They are not centered
	 * around the origin, but use the origin to define the upper-left corner of
	 * the area. A scrolled display object always scrolls in whole pixel
	 * increments. 
	 *
	 * You can scroll an object left and right by setting the `x`
	 * property of the `scrollRect` Rectangle object. You can scroll
	 * an object up and down by setting the `y` property of the
	 * `scrollRect` Rectangle object. If the display object is rotated
	 * 90° and you scroll it left and right, the display object actually scrolls
	 * up and down.
	 */
	public var scrollRect (get, set):Rectangle;
	
	@:beta public var shader (get, set):Shader;
	
	/**
	 * The Stage of the display object. A Flash runtime application has only one
	 * Stage object. For example, you can create and load multiple display
	 * objects into the display list, and the `stage` property of each
	 * display object refers to the same Stage object(even if the display object
	 * belongs to a loaded SWF file).
	 *
	 * If a display object is not added to the display list, its
	 * `stage` property is set to `null`.
	 */
	public var stage (default, null):Stage;
	
	/**
	 * An object with properties pertaining to a display object's matrix, color
	 * transform, and pixel bounds. The specific properties  -  matrix,
	 * colorTransform, and three read-only properties
	 * (`concatenatedMatrix`, `concatenatedColorTransform`,
	 * and `pixelBounds`)  -  are described in the entry for the
	 * Transform class.
	 *
	 * Each of the transform object's properties is itself an object. This
	 * concept is important because the only way to set new values for the matrix
	 * or colorTransform objects is to create a new object and copy that object
	 * into the transform.matrix or transform.colorTransform property.
	 *
	 * For example, to increase the `tx` value of a display
	 * object's matrix, you must make a copy of the entire matrix object, then
	 * copy the new object into the matrix property of the transform object:
	 * ` var myMatrix:Matrix =
	 * myDisplayObject.transform.matrix; myMatrix.tx += 10;
	 * myDisplayObject.transform.matrix = myMatrix; `
	 *
	 * You cannot directly set the `tx` property. The following
	 * code has no effect on `myDisplayObject`: 
	 * ` myDisplayObject.transform.matrix.tx +=
	 * 10; `
	 *
	 * You can also copy an entire transform object and assign it to another
	 * display object's transform property. For example, the following code
	 * copies the entire transform object from `myOldDisplayObj` to
	 * `myNewDisplayObj`:
	 * `myNewDisplayObj.transform = myOldDisplayObj.transform;`
	 *
	 * The resulting display object, `myNewDisplayObj`, now has the
	 * same values for its matrix, color transform, and pixel bounds as the old
	 * display object, `myOldDisplayObj`.
	 *
	 * Note that AIR for TV devices use hardware acceleration, if it is
	 * available, for color transforms.
	 */
	@:keep public var transform (get, set):Transform;
	
	/**
	 * Whether or not the display object is visible. Display objects that are not
	 * visible are disabled. For example, if `visible=false` for an
	 * InteractiveObject instance, it cannot be clicked.
	 */
	public var visible (get, set):Bool;
	
	/**
	 * Indicates the width of the display object, in pixels. The width is
	 * calculated based on the bounds of the content of the display object. When
	 * you set the `width` property, the `scaleX` property
	 * is adjusted accordingly, as shown in the following code:
	 *
	 * Except for TextField and Video objects, a display object with no
	 * content(such as an empty sprite) has a width of 0, even if you try to set
	 * `width` to a different value.
	 */
	@:keep public var width (get, set):Float;
	
	/**
	 * Indicates the _x_ coordinate of the DisplayObject instance relative
	 * to the local coordinates of the parent DisplayObjectContainer. If the
	 * object is inside a DisplayObjectContainer that has transformations, it is
	 * in the local coordinate system of the enclosing DisplayObjectContainer.
	 * Thus, for a DisplayObjectContainer rotated 90° counterclockwise, the
	 * DisplayObjectContainer's children inherit a coordinate system that is
	 * rotated 90° counterclockwise. The object's coordinates refer to the
	 * registration point position.
	 */
	@:keep public var x (get, set):Float;
	
	/**
	 * Indicates the _y_ coordinate of the DisplayObject instance relative
	 * to the local coordinates of the parent DisplayObjectContainer. If the
	 * object is inside a DisplayObjectContainer that has transformations, it is
	 * in the local coordinate system of the enclosing DisplayObjectContainer.
	 * Thus, for a DisplayObjectContainer rotated 90° counterclockwise, the
	 * DisplayObjectContainer's children inherit a coordinate system that is
	 * rotated 90° counterclockwise. The object's coordinates refer to the
	 * registration point position.
	 */
	@:keep public var y (get, set):Float;
	
	// @:noCompletion @:dox(hide) @:require(flash10) var z:Float;
	
	
	@:noCompletion private var __alpha:Float;
	@:noCompletion private var __blendMode:BlendMode;
	@:noCompletion private var __cacheAsBitmap:Bool;
	@:noCompletion private var __cacheAsBitmapMatrix:Matrix;
	@:noCompletion private var __cacheBitmap:Bitmap;
	@:noCompletion private var __cacheBitmapBackground:Null<Int>;
	@:noCompletion private var __cacheBitmapColorTransform:ColorTransform;
	@:noCompletion private var __cacheBitmapData:BitmapData;
	@:noCompletion private var __cacheBitmapData2:BitmapData;
	@:noCompletion private var __cacheBitmapData3:BitmapData;
	@:noCompletion private var __cacheBitmapMatrix:Matrix;
	@:noCompletion private var __cacheBitmapRenderer:DisplayObjectRenderer;
	@:noCompletion private var __cairo:Cairo;
	@:noCompletion private var __children:Array<DisplayObject>;
	@:noCompletion private var __customRenderClear:Bool;
	@:noCompletion private var __customRenderEvent:RenderEvent;
	@:noCompletion private var __filters:Array<BitmapFilter>;
	@:noCompletion private var __graphics:Graphics;
	@:noCompletion private var __interactive:Bool;
	@:noCompletion private var __isCacheBitmapRender:Bool;
	@:noCompletion private var __isMask:Bool;
	@:noCompletion private var __loaderInfo:LoaderInfo;
	@:noCompletion private var __mask:DisplayObject;
	@:noCompletion private var __maskTarget:DisplayObject;
	@:noCompletion private var __name:String;
	@:noCompletion private var __objectTransform:Transform;
	@:noCompletion private var __renderable:Bool;
	@:noCompletion private var __renderDirty:Bool;
	@:noCompletion private var __renderParent:DisplayObject;
	@:noCompletion private var __renderTransform:Matrix;
	@:noCompletion private var __renderTransformCache:Matrix;
	@:noCompletion private var __renderTransformChanged:Bool;
	@:noCompletion private var __rotation:Float;
	@:noCompletion private var __rotationCosine:Float;
	@:noCompletion private var __rotationSine:Float;
	@:noCompletion private var __scaleX:Float;
	@:noCompletion private var __scaleY:Float;
	@:noCompletion private var __scrollRect:Rectangle;
	@:noCompletion private var __shader:Shader;
	@:noCompletion private var __tempPoint:Point;
	@:noCompletion private var __transform:Matrix;
	@:noCompletion private var __transformDirty:Bool;
	@:noCompletion private var __visible:Bool;
	@:noCompletion private var __worldAlpha:Float;
	@:noCompletion private var __worldAlphaChanged:Bool;
	@:noCompletion private var __worldBlendMode:BlendMode;
	@:noCompletion private var __worldClip:Rectangle;
	@:noCompletion private var __worldClipChanged:Bool;
	@:noCompletion private var __worldColorTransform:ColorTransform;
	@:noCompletion private var __worldShader:Shader;
	@:noCompletion private var __worldTransform:Matrix;
	@:noCompletion private var __worldVisible:Bool;
	@:noCompletion private var __worldVisibleChanged:Bool;
	@:noCompletion private var __worldTransformInvalid:Bool;
	@:noCompletion private var __worldZ:Int;
	
	#if (js && html5)
	@:noCompletion private var __canvas:CanvasElement;
	@:noCompletion private var __context:CanvasRenderingContext2D;
	@:noCompletion private var __style:CSSStyleDeclaration;
	#end
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperties (DisplayObject.prototype, {
			"alpha": { get: untyped __js__ ("function () { return this.get_alpha (); }"), set: untyped __js__ ("function (v) { return this.set_alpha (v); }") },
			"blendMode": { get: untyped __js__ ("function () { return this.get_blendMode (); }"), set: untyped __js__ ("function (v) { return this.set_blendMode (v); }") },
			"cacheAsBitmap": { get: untyped __js__ ("function () { return this.get_cacheAsBitmap (); }"), set: untyped __js__ ("function (v) { return this.set_cacheAsBitmap (v); }") },
			"cacheAsBitmapMatrix": { get: untyped __js__ ("function () { return this.get_cacheAsBitmapMatrix (); }"), set: untyped __js__ ("function (v) { return this.set_cacheAsBitmapMatrix (v); }") },
			"filters": { get: untyped __js__ ("function () { return this.get_filters (); }"), set: untyped __js__ ("function (v) { return this.set_filters (v); }") },
			"height": { get: untyped __js__ ("function () { return this.get_height (); }"), set: untyped __js__ ("function (v) { return this.set_height (v); }") },
			"loaderInfo": { get: untyped __js__ ("function () { return this.get_loaderInfo (); }") },
			"mask": { get: untyped __js__ ("function () { return this.get_mask (); }"), set: untyped __js__ ("function (v) { return this.set_mask (v); }") },
			"mouseX": { get: untyped __js__ ("function () { return this.get_mouseX (); }") },
			"mouseY": { get: untyped __js__ ("function () { return this.get_mouseY (); }") },
			"name": { get: untyped __js__ ("function () { return this.get_name (); }"), set: untyped __js__ ("function (v) { return this.set_name (v); }") },
			"root": { get: untyped __js__ ("function () { return this.get_root (); }") },
			"rotation": { get: untyped __js__ ("function () { return this.get_rotation (); }"), set: untyped __js__ ("function (v) { return this.set_rotation (v); }") },
			"scaleX": { get: untyped __js__ ("function () { return this.get_scaleX (); }"), set: untyped __js__ ("function (v) { return this.set_scaleX (v); }") },
			"scaleY": { get: untyped __js__ ("function () { return this.get_scaleY (); }"), set: untyped __js__ ("function (v) { return this.set_scaleY (v); }") },
			"scrollRect": { get: untyped __js__ ("function () { return this.get_scrollRect (); }"), set: untyped __js__ ("function (v) { return this.set_scrollRect (v); }") },
			"shader": { get: untyped __js__ ("function () { return this.get_shader (); }"), set: untyped __js__ ("function (v) { return this.set_shader (v); }") },
			"transform": { get: untyped __js__ ("function () { return this.get_transform (); }"), set: untyped __js__ ("function (v) { return this.set_transform (v); }") },
			"visible": { get: untyped __js__ ("function () { return this.get_visible (); }"), set: untyped __js__ ("function (v) { return this.set_visible (v); }") },
			"width": { get: untyped __js__ ("function () { return this.get_width (); }"), set: untyped __js__ ("function (v) { return this.set_width (v); }") },
			"x": { get: untyped __js__ ("function () { return this.get_x (); }"), set: untyped __js__ ("function (v) { return this.set_x (v); }") },
			"y": { get: untyped __js__ ("function () { return this.get_y (); }"), set: untyped __js__ ("function (v) { return this.set_y (v); }") },
		});
		
	}
	#end
	
	
	@:noCompletion private function new () {
		
		super ();
		
		__alpha = 1;
		__blendMode = NORMAL;
		__cacheAsBitmap = false;
		__transform = new Matrix ();
		__visible = true;
		
		__rotation = 0;
		__rotationSine = 0;
		__rotationCosine = 1;
		__scaleX = 1;
		__scaleY = 1;
		
		__worldAlpha = 1;
		__worldBlendMode = NORMAL;
		__worldTransform = new Matrix ();
		__worldColorTransform = new ColorTransform ();
		__renderTransform = new Matrix ();
		__worldVisible = true;
		
		name = "instance" + (++__instanceCount);
		
		if (__initStage != null) {
			
			this.stage = __initStage;
			__initStage = null;
			this.stage.addChild (this);
			
		}
		
	}
	
	
	public override function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		switch (type) {
			
			case Event.ACTIVATE, Event.DEACTIVATE, Event.ENTER_FRAME, Event.EXIT_FRAME, Event.FRAME_CONSTRUCTED, Event.RENDER:
				
				if (!__broadcastEvents.exists (type)) {
					
					__broadcastEvents.set (type, []);
					
				}
				
				var dispatchers = __broadcastEvents.get (type);
				
				if (dispatchers.indexOf (this) == -1) {
					
					dispatchers.push (this);
					
				}
			
			case RenderEvent.CLEAR_DOM, RenderEvent.RENDER_CAIRO, RenderEvent.RENDER_CANVAS, RenderEvent.RENDER_DOM, RenderEvent.RENDER_OPENGL:
				
				if (__customRenderEvent == null) {
					
					__customRenderEvent = new RenderEvent (null);
					__customRenderEvent.objectColorTransform = new ColorTransform ();
					__customRenderEvent.objectMatrix = new Matrix ();
					__customRenderClear = true;
					
				}
			
			default:
			
		}
		
		super.addEventListener (type, listener, useCapture, priority, useWeakReference);
		
	}
	
	
	public override function dispatchEvent (event:Event):Bool {
		
		if (Std.is (event, MouseEvent)) {
			
			var mouseEvent:MouseEvent = cast event;
			mouseEvent.stageX = __getRenderTransform ().__transformX (mouseEvent.localX, mouseEvent.localY);
			mouseEvent.stageY = __getRenderTransform ().__transformY (mouseEvent.localX, mouseEvent.localY);
			
		} else if (Std.is (event, TouchEvent)) {
			
			var touchEvent:TouchEvent = cast event;
			touchEvent.stageX = __getRenderTransform ().__transformX (touchEvent.localX, touchEvent.localY);
			touchEvent.stageY = __getRenderTransform ().__transformY (touchEvent.localX, touchEvent.localY);
			
		}
		
		return __dispatchWithCapture (event);
		
	}
	
	
	/**
	 * Returns a rectangle that defines the area of the display object relative
	 * to the coordinate system of the `targetCoordinateSpace` object.
	 * Consider the following code, which shows how the rectangle returned can
	 * vary depending on the `targetCoordinateSpace` parameter that
	 * you pass to the method:
	 *
	 * **Note:** Use the `localToGlobal()` and
	 * `globalToLocal()` methods to convert the display object's local
	 * coordinates to display coordinates, or display coordinates to local
	 * coordinates, respectively.
	 *
	 * The `getBounds()` method is similar to the
	 * `getRect()` method; however, the Rectangle returned by the
	 * `getBounds()` method includes any strokes on shapes, whereas
	 * the Rectangle returned by the `getRect()` method does not. For
	 * an example, see the description of the `getRect()` method.
	 * 
	 * @param targetCoordinateSpace The display object that defines the
	 *                              coordinate system to use.
	 * @return The rectangle that defines the area of the display object relative
	 *         to the `targetCoordinateSpace` object's coordinate
	 *         system.
	 */
	public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle {
		
		var matrix = Matrix.__pool.get ();
		
		if (targetCoordinateSpace != null && targetCoordinateSpace != this) {
			
			matrix.copyFrom (__getWorldTransform ());
			
			var targetMatrix = Matrix.__pool.get ();
			
			targetMatrix.copyFrom (targetCoordinateSpace.__getWorldTransform ());
			targetMatrix.invert ();
			
			matrix.concat (targetMatrix);

			Matrix.__pool.release (targetMatrix);
			
		} else {
			
			matrix.identity ();
			
		}
		
		var bounds = new Rectangle ();
		__getBounds (bounds, matrix);
		
		Matrix.__pool.release (matrix);
		
		return bounds;
		
	}
	
	
	/**
	 * Returns a rectangle that defines the boundary of the display object, based
	 * on the coordinate system defined by the `targetCoordinateSpace`
	 * parameter, excluding any strokes on shapes. The values that the
	 * `getRect()` method returns are the same or smaller than those
	 * returned by the `getBounds()` method.
	 *
	 * **Note:** Use `localToGlobal()` and
	 * `globalToLocal()` methods to convert the display object's local
	 * coordinates to Stage coordinates, or Stage coordinates to local
	 * coordinates, respectively.
	 * 
	 * @param targetCoordinateSpace The display object that defines the
	 *                              coordinate system to use.
	 * @return The rectangle that defines the area of the display object relative
	 *         to the `targetCoordinateSpace` object's coordinate
	 *         system.
	 */
	public function getRect (targetCoordinateSpace:DisplayObject):Rectangle {
		
		// should not account for stroke widths, but is that possible?
		return getBounds (targetCoordinateSpace);
		
	}
	
	
	/**
	 * Converts the `point` object from the Stage(global) coordinates
	 * to the display object's(local) coordinates.
	 *
	 * To use this method, first create an instance of the Point class. The
	 * _x_ and _y_ values that you assign represent global coordinates
	 * because they relate to the origin(0,0) of the main display area. Then
	 * pass the Point instance as the parameter to the
	 * `globalToLocal()` method. The method returns a new Point object
	 * with _x_ and _y_ values that relate to the origin of the display
	 * object instead of the origin of the Stage.
	 * 
	 * @param point An object created with the Point class. The Point object
	 *              specifies the _x_ and _y_ coordinates as
	 *              properties.
	 * @return A Point object with coordinates relative to the display object.
	 */
	public function globalToLocal (pos:Point):Point {
		
		return __globalToLocal (pos, new Point ());
		
	}
	
	
	// @:noCompletion @:dox(hide) @:require(flash10) public function globalToLocal3D (point:Point):Vector3D;
	
	
	/**
	 * Evaluates the bounding box of the display object to see if it overlaps or
	 * intersects with the bounding box of the `obj` display object.
	 * 
	 * @param obj The display object to test against.
	 * @return `true` if the bounding boxes of the display objects
	 *         intersect; `false` if not.
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
	 * point specified by the `x` and `y` parameters. The
	 * `x` and `y` parameters specify a point in the
	 * coordinate space of the Stage, not the display object container that
	 * contains the display object(unless that display object container is the
	 * Stage).
	 * 
	 * @param x         The _x_ coordinate to test against this object.
	 * @param y         The _y_ coordinate to test against this object.
	 * @param shapeFlag Whether to check against the actual pixels of the object
	 *                 (`true`) or the bounding box
	 *                 (`false`).
	 * @return `true` if the display object overlaps or intersects
	 *         with the specified point; `false` otherwise.
	 */
	public function hitTestPoint (x:Float, y:Float, shapeFlag:Bool = false):Bool {
		
		if (stage != null) {
			
			return __hitTest (x, y, shapeFlag, null, true, this);
			
		} else {
			
			return false;
			
		}
		
	}
	
	
	/**
	 * Calling the `invalidate()` method signals to have the current object 
	 * redrawn the next time the object is eligible to be rendered.
	**/
	public function invalidate ():Void {
		
		__setRenderDirty ();
		
	}
	
	
	/**
	 * Converts the `point` object from the display object's(local)
	 * coordinates to the Stage(global) coordinates.
	 *
	 * This method allows you to convert any given _x_ and _y_
	 * coordinates from values that are relative to the origin(0,0) of a
	 * specific display object(local coordinates) to values that are relative to
	 * the origin of the Stage(global coordinates).
	 *
	 * To use this method, first create an instance of the Point class. The
	 * _x_ and _y_ values that you assign represent local coordinates
	 * because they relate to the origin of the display object.
	 *
	 * You then pass the Point instance that you created as the parameter to
	 * the `localToGlobal()` method. The method returns a new Point
	 * object with _x_ and _y_ values that relate to the origin of the
	 * Stage instead of the origin of the display object.
	 * 
	 * @param point The name or identifier of a point created with the Point
	 *              class, specifying the _x_ and _y_ coordinates as
	 *              properties.
	 * @return A Point object with coordinates relative to the Stage.
	 */
	public function localToGlobal (point:Point):Point {
		
		return __getRenderTransform ().transformPoint (point);
		
	}
	
	
	// @:noCompletion @:dox(hide) @:require(flash10) public function local3DToGlobal (point3d:Vector3D):Point;
	
	
	public override function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		
		super.removeEventListener (type, listener, useCapture);
		
		switch (type) {
			
			case Event.ACTIVATE, Event.DEACTIVATE, Event.ENTER_FRAME, Event.EXIT_FRAME, Event.FRAME_CONSTRUCTED, Event.RENDER:
				
				if (!hasEventListener (type)) {
					
					if (__broadcastEvents.exists (type)) {
						
						__broadcastEvents.get (type).remove (this);
						
					}
					
				}
			
			case RenderEvent.CLEAR_DOM, RenderEvent.RENDER_CAIRO, RenderEvent.RENDER_CANVAS, RenderEvent.RENDER_DOM, RenderEvent.RENDER_OPENGL:
				
				if (!hasEventListener (RenderEvent.CLEAR_DOM) && !hasEventListener (RenderEvent.RENDER_CAIRO) && !hasEventListener (RenderEvent.RENDER_CANVAS) && !hasEventListener (RenderEvent.RENDER_DOM) && !hasEventListener (RenderEvent.RENDER_OPENGL)) {
					
					__customRenderEvent = null;
					
				}
			
			default:
			
		}
		
	}
	
	
	@:noCompletion private static inline function __calculateAbsoluteTransform (local:Matrix, parentTransform:Matrix, target:Matrix):Void {
		
		target.a = local.a * parentTransform.a + local.b * parentTransform.c;
		target.b = local.a * parentTransform.b + local.b * parentTransform.d;
		target.c = local.c * parentTransform.a + local.d * parentTransform.c;
		target.d = local.c * parentTransform.b + local.d * parentTransform.d;
		target.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
		target.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
		
	}
	
	
	@:noCompletion private function __cleanup ():Void {
		
		__cairo = null;
		
		#if (js && html5)
		__canvas = null;
		__context = null;
		#end
		
		if (__graphics != null) {
			
			__graphics.__cleanup ();
			
		}
		
		if (__cacheBitmap != null) {
			
			__cacheBitmap.__cleanup();
			__cacheBitmap = null;
			
		}
		
		if (__cacheBitmapData != null) {
			
			__cacheBitmapData.dispose();
			__cacheBitmapData = null;
			
		}
		
	}
	
	
	@:noCompletion private function __dispatch (event:Event):Bool {
		
		if (__eventMap != null && hasEventListener (event.type)) {
			
			var result = super.__dispatchEvent (event);
			
			if (event.__isCanceled) {
				
				return true;
				
			}
			
			return result;
			
		}
		
		return true;
		
	}
	
	
	@:noCompletion private function __dispatchChildren (event:Event):Void {
		
		
		
	}
	
	
	@:noCompletion private override function __dispatchEvent (event:Event):Bool {
		
		var parent = event.bubbles ? this.parent : null;
		var result = super.__dispatchEvent (event);
		
		if (event.__isCanceled) {
			
			return true;
			
		}
		
		if (parent != null && parent != this) {
			
			event.eventPhase = EventPhase.BUBBLING_PHASE;
			
			if (event.target == null) {
				
				event.target = this;
				
			}
			
			parent.__dispatchEvent (event);
			
		}
		
		return result;
		
	}
	
	
	@:noCompletion private function __dispatchWithCapture (event:Event):Bool {
		
		if (event.target == null) {
			
			event.target = this;
			
		}
		
		if (parent != null) {
			
			event.eventPhase = CAPTURING_PHASE;
			
			if (parent == stage) {
				
				parent.__dispatch (event);
				
			} else {
				
				var stack = __tempStack.get ();
				var parent = parent;
				var i = 0;
				
				while (parent != null) {
					
					stack[i] = parent;
					parent = parent.parent;
					i++;
					
				}
				
				for (j in 0...i) {
					
					stack[i - j - 1].__dispatch (event);
					
				}
				
				__tempStack.release (stack);
				
			}
			
		}
		
		event.eventPhase = AT_TARGET;
		
		return __dispatchEvent (event);
		
	}
	
	
	@:noCompletion private function __enterFrame (deltaTime:Int):Void {
		
		
		
	}
	
	
	@:noCompletion private function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__graphics != null) {
			
			__graphics.__getBounds (rect, matrix);
			
		}
		
	}
	
	
	@:noCompletion private function __getCursor ():MouseCursor {
		
		return null;
		
	}
	
	
	@:noCompletion private function __getFilterBounds (rect:Rectangle, matrix:Matrix):Void {
		
		// TODO: Should this be __getRenderBounds, to account for scrollRect?
		
		__getBounds (rect, matrix);
		
		if (__filters != null) {
			
			var extension = Rectangle.__pool.get ();
			
			for (filter in __filters) {
				extension.__expand (-filter.__leftExtension, -filter.__topExtension, filter.__leftExtension + filter.__rightExtension, filter.__topExtension + filter.__bottomExtension);
			}
			
			rect.width += extension.width;
			rect.height += extension.height;
			rect.x += extension.x;
			rect.y += extension.y;
			
			Rectangle.__pool.release (extension);
			
		}
		
	}
	
	
	@:noCompletion private function __getInteractive (stack:Array<DisplayObject>):Bool {
		
		return false;
		
	}
	
	
	@:noCompletion private function __getLocalBounds (rect:Rectangle):Void {
		
		//var cacheX = __transform.tx;
		//var cacheY = __transform.ty;
		//__transform.tx = __transform.ty = 0;
		
		__getBounds (rect, __transform);
		
		//__transform.tx = cacheX;
		//__transform.ty = cacheY;
		
		rect.x -= __transform.tx;
		rect.y -= __transform.ty;
		
	}
	
	
	@:noCompletion private function __getRenderBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__scrollRect == null) {
			
			__getBounds (rect, matrix);
			
		} else {
			
			var r = Rectangle.__pool.get ();
			r.copyFrom (__scrollRect);
			r.__transform (r, matrix);
			rect.__expand (matrix.tx, matrix.ty, r.width, r.height);
			Rectangle.__pool.release (r);
			
		}
		
	}
	
	
	@:noCompletion private function __getRenderTransform ():Matrix {
		
		__getWorldTransform ();
		return __renderTransform;
		
	}
	
	
	@:noCompletion private function __getWorldTransform ():Matrix {
		
		var transformDirty = __transformDirty || __worldTransformInvalid;
		
		if (transformDirty) {
			
			var list = [];
			var current = this;
			
			if (parent == null) {
				
				__update (true, false);
				
			} else {
				
				while (current != stage) {
					
					list.push (current);
					current = current.parent;
					
					if (current == null) break;
				}
				
			}
			
			var i = list.length;
			while (--i >= 0) {
				
				current = list[i];
				current.__update (true, false);
				
			}
			
		}
		
		return __worldTransform;
		
	}
	
	
	@:noCompletion private function __globalToLocal (global:Point, local:Point):Point {
		
		__getRenderTransform ();
		
		if (global == local) {
			
			__renderTransform.__transformInversePoint (global);
			
		} else {
			
			local.x = __renderTransform.__transformInverseX (global.x, global.y);
			local.y = __renderTransform.__transformInverseY (global.x, global.y);
			
		}
		
		return local;
		
	}
	
	
	@:noCompletion private function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (__graphics != null) {
			
			if (!hitObject.__visible || __isMask) return false;
			if (mask != null && !mask.__hitTestMask (x, y)) return false;
			
			if (__graphics.__hitTest (x, y, shapeFlag, __getRenderTransform ())) {
				
				if (stack != null && !interactiveOnly) {
					
					stack.push (hitObject);
					
				}
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private function __hitTestMask (x:Float, y:Float):Bool {
		
		if (__graphics != null) {
			
			if (__graphics.__hitTest (x, y, true, __getRenderTransform ())) {
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private function __readGraphicsData (graphicsData:Vector<IGraphicsData>, recurse:Bool):Void {
		
		if (__graphics != null) {
			
			__graphics.__readGraphicsData (graphicsData);
			
		}
		
	}
	
	
	@:noCompletion private function __renderCairo (renderer:CairoRenderer):Void {
		
		#if lime_cairo
		__updateCacheBitmap (renderer, /*!__worldColorTransform.__isDefault ()*/ false);
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			CairoBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			CairoDisplayObject.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		#end
		
	}
	
	
	@:noCompletion private function __renderCairoMask (renderer:CairoRenderer):Void {
		
		#if lime_cairo
		if (__graphics != null) {
			
			CairoGraphics.renderMask (__graphics, renderer);
			
		}
		#end
		
	}
	
	
	@:noCompletion private function __renderCanvas (renderer:CanvasRenderer):Void {
		
		if (mask == null || (mask.width > 0 && mask.height > 0)) {
			
			__updateCacheBitmap (renderer, /*!__worldColorTransform.__isDefault ()*/ false);
			
			if (__cacheBitmap != null && !__isCacheBitmapRender) {
				
				CanvasBitmap.render (__cacheBitmap, renderer);
				
			} else {
				
				CanvasDisplayObject.render (this, renderer);
				
			}
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	@:noCompletion private function __renderCanvasMask (renderer:CanvasRenderer):Void {
		
		if (__graphics != null) {
			
			CanvasGraphics.renderMask (__graphics, renderer);
			
		}
		
	}
	
	
	@:noCompletion private function __renderDOM (renderer:DOMRenderer):Void {
		
		__updateCacheBitmap (renderer, /*!__worldColorTransform.__isDefault ()*/ false);
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			__renderDOMClear (renderer);
			__cacheBitmap.stage = stage;
			
			DOMBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			DOMDisplayObject.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	@:noCompletion private function __renderDOMClear (renderer:DOMRenderer):Void {
		
		DOMDisplayObject.clear (this, renderer);
		
	}
	
	
	@:noCompletion private function __renderEvent (renderer:DisplayObjectRenderer):Void {
		
		if (__customRenderEvent != null && __renderable) {
			
			__customRenderEvent.allowSmoothing = renderer.__allowSmoothing;
			__customRenderEvent.objectMatrix.copyFrom (__renderTransform);
			__customRenderEvent.objectColorTransform.__copyFrom (__worldColorTransform);
			__customRenderEvent.renderer = renderer;
			
			switch (renderer.__type) {
				
				case OPENGL:
					
					var renderer:OpenGLRenderer = cast renderer;
					renderer.setShader (__worldShader);
					__customRenderEvent.type = RenderEvent.RENDER_OPENGL;
				
				case CAIRO:
					
					__customRenderEvent.type = RenderEvent.RENDER_CAIRO;
				
				case DOM:
					
					if (stage != null && __worldVisible) {
						
						__customRenderEvent.type = RenderEvent.RENDER_DOM;
						
					} else {
						
						__customRenderEvent.type = RenderEvent.CLEAR_DOM;
						
					}
				
				case CANVAS:
					
					__customRenderEvent.type = RenderEvent.RENDER_CANVAS;
				
				default:
					
					return;
				
			}
			
			renderer.__setBlendMode (__worldBlendMode);
			renderer.__pushMaskObject (this);
			
			dispatchEvent (__customRenderEvent);
			
			renderer.__popMaskObject (this);
			
			if (renderer.__type == OPENGL) {
				
				var renderer:OpenGLRenderer = cast renderer;
				renderer.setViewport ();
				
			}
			
		}
		
	}
	
	
	@:noCompletion private function __renderGL (renderer:OpenGLRenderer):Void {
		
		__updateCacheBitmap (renderer, false);
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			GLBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			GLDisplayObject.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	@:noCompletion private function __renderGLMask (renderer:OpenGLRenderer):Void {
		
		if (__graphics != null) {
			
			//GLGraphics.renderMask (__graphics, renderer);
			GLShape.renderMask (this, renderer);
			
		}
		
	}
	
	
	@:noCompletion private function __setParentRenderDirty ():Void {
		
		var renderParent = __renderParent != null ? __renderParent : parent;
		if (renderParent != null && !renderParent.__renderDirty) {
			
			renderParent.__renderDirty = true;
			renderParent.__setParentRenderDirty ();
			
		}
		
	}
	
	
	@:noCompletion private inline function __setRenderDirty ():Void {
		
		if (!__renderDirty) {
			
			__renderDirty = true;
			__setParentRenderDirty ();
			
		}
		
	}
	
	
	@:noCompletion private function __setStageReference (stage:Stage):Void {
		
		this.stage = stage;
		
	}
	
	
	@:noCompletion private function __setTransformDirty ():Void {
		
		if (!__transformDirty) {
			
			__transformDirty = true;
			
			__setWorldTransformInvalid ();
			__setParentRenderDirty ();
			
		}
		
	}
	
	
	@:noCompletion private function __setWorldTransformInvalid ():Void {
		
		__worldTransformInvalid = true;
		
	}
	
	
	@:noCompletion private function __shouldCacheHardware (value:Null<Bool>):Null<Bool> {
		
		if (value == true || __filters != null) return true;
		
		if (value == false || (__graphics != null && !GLGraphics.isCompatible (__graphics))) {
			
			return false;
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function __stopAllMovieClips ():Void {
		
		
		
	}
	
	
	@:noCompletion private function __update (transformOnly:Bool, updateChildren:Bool):Void {
		
		var renderParent = __renderParent != null ? __renderParent : parent;
		if (__isMask && renderParent == null) renderParent = __maskTarget;
		__renderable = (__visible && __scaleX != 0 && __scaleY != 0 && !__isMask && (renderParent == null || !renderParent.__isMask));
		__updateTransforms ();
		
		//if (updateChildren && __transformDirty) {
			
			__transformDirty = false;
			
		//}
		
		__worldTransformInvalid = false;

		if (!transformOnly) {
			
			if (__supportDOM) {
				
				__renderTransformChanged = !__renderTransform.equals (__renderTransformCache);
				
				if (__renderTransformCache == null) {
					
					__renderTransformCache = __renderTransform.clone ();
					
				} else {
					
					__renderTransformCache.copyFrom (__renderTransform);
					
				}
				
			}
			
			if (renderParent != null) {
				
				if (__supportDOM) {
					
					var worldVisible = (renderParent.__worldVisible && __visible);
					__worldVisibleChanged = (__worldVisible != worldVisible);
					__worldVisible = worldVisible;
					
					var worldAlpha = alpha * renderParent.__worldAlpha;
					__worldAlphaChanged = (__worldAlpha != worldAlpha);
					__worldAlpha = worldAlpha;
					
				} else {
					
					__worldAlpha = alpha * renderParent.__worldAlpha;
					
				}
				
				if (__objectTransform != null) {
					
					__worldColorTransform.__copyFrom (__objectTransform.colorTransform);
					__worldColorTransform.__combine (renderParent.__worldColorTransform);
					
				} else {
					
					__worldColorTransform.__copyFrom (renderParent.__worldColorTransform);
					
				}
				
				if (__blendMode == null || __blendMode == NORMAL) {
					
					// TODO: Handle multiple blend modes better
					__worldBlendMode = renderParent.__blendMode;
					
				} else {
					
					__worldBlendMode = __blendMode;
					
				}
				
				if (__shader == null) {
					
					__worldShader = renderParent.__shader;
					
				} else {
					
					__worldShader = __shader;
					
				}
				
			} else {
				
				__worldAlpha = alpha;
				
				if (__supportDOM) {
					
					__worldVisibleChanged = (__worldVisible != __visible);
					__worldVisible = __visible;
					
					__worldAlphaChanged = (__worldAlpha != alpha);
					
				}
				
				if (__objectTransform != null) {
					
					__worldColorTransform.__copyFrom (__objectTransform.colorTransform);
					
				} else {
					
					__worldColorTransform.__identity ();
					
				}
				
			}
			
			//if (updateChildren && __renderDirty) {
				
				//__renderDirty = false;
				
			//}
			
		}
		
		if (updateChildren && mask != null) {
			
			mask.__update (transformOnly, true);
			
		}
		
	}
	
	
	@:noCompletion private function __updateCacheBitmap (renderer:DisplayObjectRenderer, force:Bool):Bool {
		
		if (__isCacheBitmapRender) return false;
		
		var colorTransform = __tempColorTransform;
		colorTransform.__copyFrom (__worldColorTransform);
		if (renderer.__worldColorTransform != null) colorTransform.__combine (renderer.__worldColorTransform);
		
		if (cacheAsBitmap || (renderer.__type != OPENGL && !colorTransform.__isDefault ())) {
			
			var rect = null;
			
			var needRender = (__cacheBitmap == null || (__renderDirty && (force || (__children != null && __children.length > 0) || (__graphics != null && __graphics.__dirty))) || opaqueBackground != __cacheBitmapBackground || (renderer.__type != OPENGL && !__cacheBitmapColorTransform.__equals (colorTransform)));
			var updateTransform = (needRender || (renderer.__type == OPENGL && !__cacheBitmap.__worldTransform.equals (__worldTransform)));
			var hasFilters = __filters != null;
			
			if (hasFilters && !needRender) {
				
				for (filter in __filters) {
					
					if (filter.__renderDirty) {
						
						needRender = true;
						break;
						
					}
					
				}
			
			}
			
			if (__cacheBitmapMatrix == null) {
				
				__cacheBitmapMatrix = new Matrix ();
				
			}
			
			var bitmapMatrix = (__cacheAsBitmapMatrix != null ? __cacheAsBitmapMatrix : __renderTransform);
			
			if (!needRender && (bitmapMatrix.a != __cacheBitmapMatrix.a || bitmapMatrix.b != __cacheBitmapMatrix.b || bitmapMatrix.c != __cacheBitmapMatrix.c || bitmapMatrix.d != __cacheBitmapMatrix.d)) {
				
				needRender = true;
				
			}
			
			if (!needRender && renderer.__type != OPENGL && __cacheBitmapData != null && __cacheBitmapData.image != null && __cacheBitmapData.image.version < __cacheBitmapData.__textureVersion) {
				
				needRender = true;
				
			}
			
			__cacheBitmapMatrix.copyFrom (bitmapMatrix);
			__cacheBitmapMatrix.tx = 0;
			__cacheBitmapMatrix.ty = 0;
			
			// TODO: Handle dimensions better if object has a scrollRect?
			
			var bitmapWidth = 0, bitmapHeight = 0;
			var filterWidth = 0, filterHeight = 0;
			var offsetX = 0., offsetY = 0.;
			
			if (updateTransform || needRender) {
				
				rect = Rectangle.__pool.get ();
				
				__getFilterBounds (rect, __cacheBitmapMatrix);
				
				filterWidth = Math.ceil (rect.width);
				filterHeight = Math.ceil (rect.height);
				
				offsetX = rect.x > 0 ? Math.ceil (rect.x) : Math.floor (rect.x);
				offsetY = rect.y > 0 ? Math.ceil (rect.y) : Math.floor (rect.y);
				
				if (__cacheBitmapData != null) {
					
					if (filterWidth > __cacheBitmapData.width || filterHeight > __cacheBitmapData.height) {
						
						bitmapWidth = Math.ceil (Math.max (filterWidth * 1.25, __cacheBitmapData.width));
						bitmapHeight = Math.ceil (Math.max (filterHeight * 1.25, __cacheBitmapData.height));
						needRender = true;
						
					} else {
						
						bitmapWidth = __cacheBitmapData.width;
						bitmapHeight = __cacheBitmapData.height;
						
					}
					
				} else {
					
					bitmapWidth = filterWidth;
					bitmapHeight = filterHeight;
					
				}
				
			}
			
			if (needRender) {
				
				updateTransform = true;
				__cacheBitmapBackground = opaqueBackground;
				
				if (filterWidth >= 0.5 && filterHeight >= 0.5) {
					
					var needsFill = (opaqueBackground != null && (bitmapWidth != filterWidth || bitmapHeight != filterHeight));
					var fillColor = opaqueBackground != null ? (0xFF << 24) | opaqueBackground : 0;
					var bitmapColor = needsFill ? 0 : fillColor;
					var allowFramebuffer = (renderer.__type == OPENGL);
					
					if (__cacheBitmapData == null || bitmapWidth > __cacheBitmapData.width || bitmapHeight > __cacheBitmapData.height) {
						
						__cacheBitmapData = new BitmapData (bitmapWidth, bitmapHeight, true, bitmapColor);
						
						if (__cacheBitmap == null) __cacheBitmap = new Bitmap ();
						__cacheBitmap.__bitmapData = __cacheBitmapData;
						__cacheBitmapRenderer = null;
						
					} else {
						
						__cacheBitmapData.__fillRect (__cacheBitmapData.rect, bitmapColor, allowFramebuffer);
						
					}
					
					if (needsFill) {
						
						rect.setTo (0, 0, filterWidth, filterHeight);
						__cacheBitmapData.__fillRect (rect, fillColor, allowFramebuffer);
						
					}
					
				} else {
					
					__cacheBitmap = null;
					__cacheBitmapData = null;
					__cacheBitmapData2 = null;
					__cacheBitmapData3 = null;
					__cacheBitmapRenderer = null;
					return true;
					
				}
				
			} else {
				
				// Should we retain these longer?
				
				__cacheBitmapData = __cacheBitmap.bitmapData;
				__cacheBitmapData2 = null;
				__cacheBitmapData3 = null;
				
			}
			
			if (updateTransform || needRender) {
				
				__cacheBitmap.__worldTransform.copyFrom (__worldTransform);
				
				if (bitmapMatrix == __renderTransform) {
					
					__cacheBitmap.__renderTransform.identity ();
					__cacheBitmap.__renderTransform.tx = __renderTransform.tx + offsetX;
					__cacheBitmap.__renderTransform.ty = __renderTransform.ty + offsetY;
					
				} else {
					
					__cacheBitmap.__renderTransform.copyFrom (__cacheBitmapMatrix);
					__cacheBitmap.__renderTransform.invert ();
					__cacheBitmap.__renderTransform.concat (__renderTransform);
					__cacheBitmap.__renderTransform.tx += offsetX;
					__cacheBitmap.__renderTransform.ty += offsetY;
					
				}
				
			}
			
			__cacheBitmap.smoothing = renderer.__allowSmoothing;
			__cacheBitmap.__renderable = __renderable;
			__cacheBitmap.__worldAlpha = __worldAlpha;
			__cacheBitmap.__worldBlendMode = __worldBlendMode;
			__cacheBitmap.__worldShader = __worldShader;
			__cacheBitmap.__scrollRect = __scrollRect;
			//__cacheBitmap.filters = filters;
			__cacheBitmap.mask = __mask;
			
			if (needRender) {
				
				var renderType = renderer.__type;
				
				if (renderType == OPENGL) {
					
					if (#if !openfl_disable_gl_cacheasbitmap __shouldCacheHardware (null) == false #else true #end) {
						
						#if (js && html5)
						renderType = CANVAS;
						#else
						renderType = CAIRO;
						#end
						
					}
					
				}
				
				if (__cacheBitmapRenderer == null || renderType != __cacheBitmapRenderer.__type) {
					
					if (renderType == OPENGL) {
						
						__cacheBitmapRenderer = new OpenGLRenderer (renderer.__context, __cacheBitmapData);
						
					} else {
						
						if (__cacheBitmapData.image == null) {
							
							var color = opaqueBackground != null ? (0xFF << 24) | opaqueBackground : 0;
							__cacheBitmapData = new BitmapData (bitmapWidth, bitmapHeight, true, color);
							__cacheBitmap.__bitmapData = __cacheBitmapData;
							
						}
						
						#if (js && html5)
						ImageCanvasUtil.convertToCanvas (__cacheBitmapData.image);
						__cacheBitmapRenderer = new CanvasRenderer (__cacheBitmapData.image.buffer.__srcContext);
						#else
						__cacheBitmapRenderer = new CairoRenderer (new Cairo (__cacheBitmapData.getSurface ()));
						#end
						
					}
					
					__cacheBitmapRenderer.__worldTransform = new Matrix ();
					__cacheBitmapRenderer.__worldColorTransform = new ColorTransform ();
					
				}
				
				if (__cacheBitmapColorTransform == null) __cacheBitmapColorTransform = new ColorTransform ();
				
				__cacheBitmapRenderer.__stage = stage;
				
				__cacheBitmapRenderer.__allowSmoothing = renderer.__allowSmoothing;
				__cacheBitmapRenderer.__setBlendMode (NORMAL);
				__cacheBitmapRenderer.__worldAlpha = 1 / __worldAlpha;
				
				__cacheBitmapRenderer.__worldTransform.copyFrom (__renderTransform);
				__cacheBitmapRenderer.__worldTransform.invert ();
				__cacheBitmapRenderer.__worldTransform.concat (__cacheBitmapMatrix);
				__cacheBitmapRenderer.__worldTransform.tx -= offsetX;
				__cacheBitmapRenderer.__worldTransform.ty -= offsetY;
				
				__cacheBitmapRenderer.__worldColorTransform.__copyFrom (colorTransform);
				__cacheBitmapRenderer.__worldColorTransform.__invert ();
				
				__isCacheBitmapRender = true;
				
				if (__cacheBitmapRenderer.__type == OPENGL) {
					
					var parentRenderer:OpenGLRenderer = cast renderer;
					var childRenderer:OpenGLRenderer = cast __cacheBitmapRenderer;
					
					var cacheBlendMode = parentRenderer.__blendMode;
					parentRenderer.__suspendClipAndMask ();
					childRenderer.__copyShader (parentRenderer);
					
					__cacheBitmapData.__setUVRect (childRenderer.__context, 0, 0, filterWidth, filterHeight);
					childRenderer.__setRenderTarget (__cacheBitmapData);
					if (__cacheBitmapData.image != null) __cacheBitmapData.__textureVersion = __cacheBitmapData.image.version + 1;
					
					__cacheBitmapData.__drawGL (this, childRenderer);
					
					if (hasFilters) {
						
						var needSecondBitmapData = true;
						var needCopyOfOriginal = false;
						
						for (filter in __filters) {
							// if (filter.__needSecondBitmapData) {
							// 	needSecondBitmapData = true;
							// }
							if (filter.__preserveObject) {
								needCopyOfOriginal = true;
							}
						}
						
						var bitmap = __cacheBitmapData;
						var bitmap2 = null;
						var bitmap3 = null;
						
						// if (needSecondBitmapData) {
							if (__cacheBitmapData2 == null || bitmapWidth > __cacheBitmapData2.width || bitmapHeight > __cacheBitmapData2.height) {
								__cacheBitmapData2 = new BitmapData (bitmapWidth, bitmapHeight, true, 0);
							} else {
								//__cacheBitmapData2.fillRect (__cacheBitmapData2.rect, 0);
								if (__cacheBitmapData2.image != null) {
									__cacheBitmapData2.__textureVersion = __cacheBitmapData2.image.version + 1;
								}
							}
							__cacheBitmapData2.__setUVRect (childRenderer.__context, 0, 0, filterWidth, filterHeight);
							bitmap2 = __cacheBitmapData2;
						// } else {
						// 	bitmap2 = bitmapData;
						// }
						
						if (needCopyOfOriginal) {
							if (__cacheBitmapData3 == null || bitmapWidth > __cacheBitmapData3.width || bitmapHeight > __cacheBitmapData3.height) {
								__cacheBitmapData3 = new BitmapData (bitmapWidth, bitmapHeight, true, 0);
							} else {
								//__cacheBitmapData3.fillRect (__cacheBitmapData3.rect, 0);
								if (__cacheBitmapData3.image != null) {
									__cacheBitmapData3.__textureVersion = __cacheBitmapData3.image.version + 1;
								}
							}
							__cacheBitmapData3.__setUVRect (childRenderer.__context, 0, 0, filterWidth, filterHeight);
							bitmap3 = __cacheBitmapData3;
						}
						
						childRenderer.__setBlendMode (NORMAL);
						childRenderer.__worldAlpha = 1;
						childRenderer.__worldTransform.identity ();
						childRenderer.__worldColorTransform.__identity ();
						
						// var sourceRect = bitmap.rect;
						// if (__tempPoint == null) __tempPoint = new Point ();
						// var destPoint = __tempPoint;
						var shader, cacheBitmap;
						
						for (filter in __filters) {
							
							if (filter.__preserveObject) {
								
								childRenderer.__setRenderTarget (bitmap3);
								childRenderer.__renderFilterPass (bitmap, childRenderer.__defaultDisplayShader);
								
							}
							
							for (i in 0...filter.__numShaderPasses) {
								
								shader = filter.__initShader (childRenderer, i);
								childRenderer.__setBlendMode (filter.__shaderBlendMode);
								childRenderer.__setRenderTarget (bitmap2);
								childRenderer.__renderFilterPass (bitmap, shader);
								
								cacheBitmap = bitmap;
								bitmap = bitmap2;
								bitmap2 = cacheBitmap;
								
							}
							
							if (filter.__preserveObject) {
								
								childRenderer.__setBlendMode (NORMAL);
								childRenderer.__setRenderTarget (bitmap);
								childRenderer.__renderFilterPass (bitmap3, childRenderer.__defaultDisplayShader, false);
								
							}
							
							filter.__renderDirty = false;
							
						}
						
						__cacheBitmap.__bitmapData = bitmap;
						
					}
					
					parentRenderer.__blendMode = NORMAL;
					parentRenderer.__setBlendMode (cacheBlendMode);
					parentRenderer.__copyShader (childRenderer);
					parentRenderer.__resumeClipAndMask (childRenderer);
					parentRenderer.setViewport ();
					
					__cacheBitmapColorTransform.__copyFrom (colorTransform);
					
				} else {
					
					#if (js && html5)
					__cacheBitmapData.__drawCanvas (this, cast __cacheBitmapRenderer);
					#else
					__cacheBitmapData.__drawCairo (this, cast __cacheBitmapRenderer);
					#end
					
					if (hasFilters) {
						
						var needSecondBitmapData = false;
						var needCopyOfOriginal = false;
						
						for (filter in __filters) {
							if (filter.__needSecondBitmapData) {
								needSecondBitmapData = true;
							}
							if (filter.__preserveObject) {
								needCopyOfOriginal = true;
							}
						}
						
						var bitmap = __cacheBitmapData;
						var bitmap2 = null;
						var bitmap3 = null;
						
						if (needSecondBitmapData) {
							if (__cacheBitmapData2 == null || __cacheBitmapData2.image == null || bitmapWidth > __cacheBitmapData2.width || bitmapHeight > __cacheBitmapData2.height) {
								__cacheBitmapData2 = new BitmapData (bitmapWidth, bitmapHeight, true, 0);
							} else {
								__cacheBitmapData2.fillRect (__cacheBitmapData2.rect, 0);
							}
							bitmap2 = __cacheBitmapData2;
						} else {
							bitmap2 = bitmap;
						}
						
						if (needCopyOfOriginal) {
							if (__cacheBitmapData3 == null || __cacheBitmapData3.image == null || bitmapWidth > __cacheBitmapData3.width || bitmapHeight > __cacheBitmapData3.height) {
								__cacheBitmapData3 = new BitmapData (bitmapWidth, bitmapHeight, true, 0);
							} else {
								__cacheBitmapData3.fillRect (__cacheBitmapData3.rect, 0);
							}
							bitmap3 = __cacheBitmapData3;
						}
						
						var sourceRect = Rectangle.__pool.get ();
						sourceRect.setTo (0, 0, filterWidth, filterHeight);
						
						if (__tempPoint == null) __tempPoint = new Point ();
						var destPoint = __tempPoint;
						var cacheBitmap, lastBitmap;
						
						for (filter in __filters) {
							
							if (filter.__preserveObject) {
								bitmap3.copyPixels (bitmap, bitmap.rect, destPoint);
							}
							
							lastBitmap = filter.__applyFilter (bitmap2, bitmap, sourceRect, destPoint);
							
							if (filter.__preserveObject) {
								lastBitmap.draw (bitmap3, null, __objectTransform != null ? __objectTransform.colorTransform : null);
							}
							filter.__renderDirty = false;
							
							if (needSecondBitmapData && lastBitmap == bitmap2) {
								
								cacheBitmap = bitmap;
								bitmap = bitmap2;
								bitmap2 = cacheBitmap;
								
							}
							
						}
						
						if (__cacheBitmapData != bitmap) {
							
							// TODO: Fix issue with swapping __cacheBitmap.__bitmapData
							__cacheBitmapData.copyPixels (bitmap, bitmap.rect, destPoint);
							
							// cacheBitmap = __cacheBitmapData;
							// __cacheBitmapData = bitmap;
							// __cacheBitmapData2 = cacheBitmap;
							// __cacheBitmap.__bitmapData = __cacheBitmapData;
							
						}
						
						Rectangle.__pool.release (sourceRect);
						__cacheBitmap.__imageVersion = __cacheBitmapData.__textureVersion;
						
					}
					
					__cacheBitmapColorTransform.__copyFrom (colorTransform);
					
					if (!__cacheBitmapColorTransform.__isDefault ()) {
						
						__cacheBitmapData.colorTransform (__cacheBitmapData.rect, __cacheBitmapColorTransform);
						
					}
					
				}
				
				__isCacheBitmapRender = false;
				
			}
			
			if (updateTransform || needRender) {
				
				Rectangle.__pool.release (rect);
				
			}
			
			return updateTransform;
			
		} else if (__cacheBitmap != null) {
			
			if (renderer.__type == DOM) {
				
				__cacheBitmap.__renderDOMClear (cast renderer);
				
			}
			
			__cacheBitmap = null;
			__cacheBitmapData = null;
			__cacheBitmapData2 = null;
			__cacheBitmapData3 = null;
			__cacheBitmapColorTransform = null;
			__cacheBitmapRenderer = null;
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private function __updateTransforms (overrideTransform:Matrix = null):Void {
		
		var overrided = overrideTransform != null;
		var local = overrided ? overrideTransform : __transform;
		
		if (__worldTransform == null) {
			
			__worldTransform = new Matrix ();
			
		}
		
		if (__renderTransform == null) {
			
			__renderTransform = new Matrix ();
			
		}
		
		var renderParent = __renderParent != null ? __renderParent : parent;
		
		if (!overrided && parent != null) {
			
			__calculateAbsoluteTransform (local, parent.__worldTransform, __worldTransform);
			
		} else {
			
			__worldTransform.copyFrom (local);
			
		}
		
		if (!overrided && renderParent != null) {
			
			__calculateAbsoluteTransform (local, renderParent.__renderTransform, __renderTransform);
			
		} else {
			
			__renderTransform.copyFrom (local);
			
		}
		
		if (__scrollRect != null) {
			
			__renderTransform.__translateTransformed (-__scrollRect.x, -__scrollRect.y);
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:keep @:noCompletion private function get_alpha ():Float {
		
		return __alpha;
		
	}
	
	
	@:keep @:noCompletion private function set_alpha (value:Float):Float {
		
		if (value > 1.0) value = 1.0;
		if (value != __alpha) __setRenderDirty ();
		return __alpha = value;
		
	}
	
	
	@:noCompletion private function get_blendMode ():BlendMode {
		
		return __blendMode;
		
	}
	
	
	@:noCompletion private function set_blendMode (value:BlendMode):BlendMode {
		
		if (value == null) value = NORMAL;
		if (value != __blendMode) __setRenderDirty ();
		return __blendMode = value;
		
	}
	
	
	@:noCompletion private function get_cacheAsBitmap ():Bool {
		
		return (__filters == null ? __cacheAsBitmap : true);
		
	}
	
	
	@:noCompletion private function set_cacheAsBitmap (value:Bool):Bool {
		
		__setRenderDirty ();
		return __cacheAsBitmap = value;
		
	}
	
	
	@:noCompletion private function get_cacheAsBitmapMatrix ():Matrix {
		
		return __cacheAsBitmapMatrix;
		
	}
	
	
	@:noCompletion private function set_cacheAsBitmapMatrix (value:Matrix):Matrix {
		
		__setRenderDirty ();
		return __cacheAsBitmapMatrix = (value != null ? value.clone () : value);
		
	}
	
	
	@:noCompletion private function get_filters ():Array<BitmapFilter> {
		
		if (__filters == null) {
			
			return new Array ();
			
		} else {
			
			return __filters.copy ();
			
		}
		
	}
	
	
	@:noCompletion private function set_filters (value:Array<BitmapFilter>):Array<BitmapFilter> {
		
		if (value != null && value.length > 0) {
			
			__filters = value;
			//__updateFilters = true;
			
		} else {
			
			__filters = null;
			//__updateFilters = false;
			
		}
		
		__setRenderDirty ();
		
		return value;
		
	}
	
	
	@:keep @:noCompletion private function get_height ():Float {
		
		var rect = Rectangle.__pool.get ();
		__getLocalBounds (rect);
		var height = rect.height;
		Rectangle.__pool.release (rect);
		return height;
		
	}
	
	
	@:keep @:noCompletion private function set_height (value:Float):Float {
		
		var rect = Rectangle.__pool.get ();
		var matrix = Matrix.__pool.get ();
		matrix.identity ();
		
		__getBounds (rect, matrix);
		
		if (value != rect.height) {
			
			scaleY = value / rect.height;
			
		} else {
			
			scaleY = 1;
			
		}
		
		Rectangle.__pool.release (rect);
		Matrix.__pool.release (matrix);
		
		return value;
		
	}
	
	
	@:noCompletion private function get_loaderInfo ():LoaderInfo {
		
		if (stage != null) {
			
			return Lib.current.__loaderInfo;
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function get_mask ():DisplayObject {
		
		return __mask;
		
	}
	
	
	@:noCompletion private function set_mask (value:DisplayObject):DisplayObject {
		
		if (value == __mask) {
			
			return value;
			
		}
		
		if (value != __mask) {
			
			__setTransformDirty ();
			__setRenderDirty ();
			
		}
		
		if (__mask != null) {
			
			__mask.__isMask = false;
			__mask.__maskTarget = null;
			__mask.__setTransformDirty ();
			__mask.__setRenderDirty ();
			
		}
		
		if (value != null) {
			
			value.__isMask = true;
			value.__maskTarget = this;
			value.__setWorldTransformInvalid ();
			
		}
		
		if (__cacheBitmap != null && __cacheBitmap.mask != value) {
			
			__cacheBitmap.mask = value;
			
		}
		
		return __mask = value;
		
	}
	
	
	@:noCompletion private function get_mouseX ():Float {
		
		var mouseX = (stage != null ? stage.__mouseX : Lib.current.stage.__mouseX);
		var mouseY = (stage != null ? stage.__mouseY : Lib.current.stage.__mouseY);
		
		return __getRenderTransform ().__transformInverseX (mouseX, mouseY);
		
	}
	
	
	@:noCompletion private function get_mouseY ():Float {
		
		var mouseX = (stage != null ? stage.__mouseX : Lib.current.stage.__mouseX);
		var mouseY = (stage != null ? stage.__mouseY : Lib.current.stage.__mouseY);
		
		return __getRenderTransform ().__transformInverseY (mouseX, mouseY);
		
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
	
	
	@:keep @:noCompletion private function get_rotation ():Float {
		
		return __rotation;
		
	}
	
	
	@:keep @:noCompletion private function set_rotation (value:Float):Float {
		
		if (value != __rotation) {
			
			__rotation = value;
			var radians = __rotation * (Math.PI / 180);
			__rotationSine = Math.sin (radians);
			__rotationCosine = Math.cos (radians);
			
			__transform.a = __rotationCosine * __scaleX;
			__transform.b = __rotationSine * __scaleX;
			__transform.c = -__rotationSine * __scaleY;
			__transform.d = __rotationCosine * __scaleY;
			
			__setTransformDirty ();
			
		}
		
		return value;
		
	}
	
	
	@:keep private function get_scaleX ():Float {
		
		return __scaleX;
		
	}
	
	
	@:keep private function set_scaleX (value:Float):Float {
		
		if (value != __scaleX) {
			
			__scaleX = value;
			
			if (__transform.b == 0) {
				
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
			
		}
		
		return value;
		
	}
	
	
	@:keep private function get_scaleY ():Float {
		
		return __scaleY;
		
	}
	
	
	@:keep private function set_scaleY (value:Float):Float {
		
		if (value != __scaleY) {
			
			__scaleY = value;
			
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
			
		}
		
		return value;
		
	}
	
	
	@:noCompletion private function get_scrollRect ():Rectangle {
		
		if (__scrollRect == null) {
			
			return null;
			
		}
		
		return __scrollRect.clone();
		
	}
	
	
	@:noCompletion private function set_scrollRect (value:Rectangle):Rectangle {
		
		if (value != __scrollRect) {
			
			__setTransformDirty ();
			
			if (__supportDOM) {
				
				__setRenderDirty ();
				
			}
			
		}
		
		return __scrollRect = value;
		
	}
	
	
	@:noCompletion private function get_shader ():Shader {
		
		return __shader;
		
	}
	
	
	@:noCompletion private function set_shader (value:Shader):Shader {
		
		__shader = value;
		__setRenderDirty ();
		return value;
		
	}
	
	
	@:keep @:noCompletion private function get_transform ():Transform {
		
		if (__objectTransform == null) {
			
			__objectTransform = new Transform (this);
			
		}
		
		return __objectTransform;
		
	}
	
	
	@:keep @:noCompletion private function set_transform (value:Transform):Transform {
		
		if (value == null) {
			
			throw new TypeError ("Parameter transform must be non-null.");
			
		}
		
		if (__objectTransform == null) {
			
			__objectTransform = new Transform (this);
			
		}
		
		__setTransformDirty ();
		__objectTransform.matrix = value.matrix;
		
		if (!__objectTransform.colorTransform.__equals (value.colorTransform)) {
			
			__objectTransform.colorTransform.__copyFrom (value.colorTransform);
			__setRenderDirty ();
			
		}
		
		return __objectTransform;
		
	}
	
	
	@:noCompletion private function get_visible ():Bool {
		
		return __visible;
		
	}
	
	
	@:noCompletion private function set_visible (value:Bool):Bool {
		
		if (value != __visible) __setRenderDirty ();
		return __visible = value;
		
	}
	
	
	@:keep @:noCompletion private function get_width ():Float {
		
		var rect = Rectangle.__pool.get ();
		__getLocalBounds (rect);
		var width = rect.width;
		Rectangle.__pool.release (rect);
		return width;
		
	}
	
	
	@:keep @:noCompletion private function set_width (value:Float):Float {
		
		var rect = Rectangle.__pool.get ();
		var matrix = Matrix.__pool.get ();
		matrix.identity ();
		
		__getBounds (rect, matrix);
		
		if (value != rect.width) {
			
			scaleX = value / rect.width;
			
		} else {
			
			scaleX = 1;
			
		}
		
		Rectangle.__pool.release (rect);
		Matrix.__pool.release (matrix);
		
		return value;
		
	}
	
	
	@:keep @:noCompletion private function get_x ():Float {
		
		return __transform.tx;
		
	}
	
	
	@:keep @:noCompletion private function set_x (value:Float):Float {
		
		if (value != __transform.tx) __setTransformDirty ();
		return __transform.tx = value;
		
	}
	
	
	@:keep @:noCompletion private function get_y ():Float {
		
		return __transform.ty;
		
	}
	
	
	@:keep @:noCompletion private function set_y (value:Float):Float {
		
		if (value != __transform.ty) __setTransformDirty ();
		return __transform.ty = value;
		
	}
	
	
}


#else
typedef DisplayObject = flash.display.DisplayObject;
#end