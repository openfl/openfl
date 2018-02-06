import BlendMode from "./BlendMode";
import DisplayObjectContainer from "./DisplayObjectContainer";
import IBitmapDrawable from "./IBitmapDrawable";
import LoaderInfo from "./LoaderInfo";
import Stage from "./Stage";
import EventDispatcher from "./../events/EventDispatcher";
import BitmapFilter from "./../filters/BitmapFilter";
import Point from "./../geom/Point";
import Rectangle from "./../geom/Rectangle";
import Transform from "./../geom/Transform";
import Vector3D from "./../geom/Vector3D";


declare namespace openfl.display {
	
	
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
	 * @:event added            Dispatched when a display object is added to the
	 *                         display list. The following methods trigger this
	 *                         event:
	 *                         `DisplayObjectContainer.addChild()`,
	 *                         `DisplayObjectContainer.addChildAt()`.
	 * @:event addedToStage     Dispatched when a display object is added to the on
	 *                         stage display list, either directly or through the
	 *                         addition of a sub tree in which the display object
	 *                         is contained. The following methods trigger this
	 *                         event:
	 *                         `DisplayObjectContainer.addChild()`,
	 *                         `DisplayObjectContainer.addChildAt()`.
	 * @:event enterFrame       [broadcast event] Dispatched when the playhead is
	 *                         entering a new frame. If the playhead is not
	 *                         moving, or if there is only one frame, this event
	 *                         is dispatched continuously in conjunction with the
	 *                         frame rate. This event is a broadcast event, which
	 *                         means that it is dispatched by all display objects
	 *                         with a listener registered for this event.
	 * @:event exitFrame        [broadcast event] Dispatched when the playhead is
	 *                         exiting the current frame. All frame scripts have
	 *                         been run. If the playhead is not moving, or if
	 *                         there is only one frame, this event is dispatched
	 *                         continuously in conjunction with the frame rate.
	 *                         This event is a broadcast event, which means that
	 *                         it is dispatched by all display objects with a
	 *                         listener registered for this event.
	 * @:event frameConstructed [broadcast event] Dispatched after the constructors
	 *                         of frame display objects have run but before frame
	 *                         scripts have run. If the playhead is not moving, or
	 *                         if there is only one frame, this event is
	 *                         dispatched continuously in conjunction with the
	 *                         frame rate. This event is a broadcast event, which
	 *                         means that it is dispatched by all display objects
	 *                         with a listener registered for this event.
	 * @:event removed          Dispatched when a display object is about to be
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
	 * @:event removedFromStage Dispatched when a display object is about to be
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
	 * @:event render           [broadcast event] Dispatched when the display list
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
	export class DisplayObject extends EventDispatcher implements IBitmapDrawable /*#if openfl_dynamic implements Dynamic<DisplayObject> #end*/ {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) accessibilityProperties:flash.accessibility.AccessibilityProperties;
		// #end
		
		/**
		 * Indicates the alpha transparency value of the object specified. Valid
		 * values are 0(fully transparent) to 1(fully opaque). The default value is
		 * 1. Display objects with `alpha` set to 0 _are_ active,
		 * even though they are invisible.
		 */
		alpha:number;
		
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
		blendMode:BlendMode;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) blendShader (null, default):Shader;
		// #end
		
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
		cacheAsBitmap:boolean;
		
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
		filters:Array<BitmapFilter>;
		
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
		height:number;
		
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
		readonly loaderInfo:LoaderInfo;
		
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
		mask:DisplayObject;
		
		/**
		 * Indicates the x coordinate of the mouse or user input device position, in
		 * pixels.
		 *
		 * **Note**: For a DisplayObject that has been rotated, the returned x
		 * coordinate will reflect the non-rotated object.
		 */
		readonly mouseX:number;
		
		/**
		 * Indicates the y coordinate of the mouse or user input device position, in
		 * pixels.
		 *
		 * **Note**: For a DisplayObject that has been rotated, the returned y
		 * coordinate will reflect the non-rotated object.
		 */
		readonly mouseY:number;
		
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
		name:string;
		
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
		opaqueBackground:number | null;
		
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
		readonly parent:DisplayObjectContainer;
		
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
		readonly root:DisplayObject;
		
		/**
		 * Indicates the rotation of the DisplayObject instance, in degrees, from its
		 * original orientation. Values from 0 to 180 represent clockwise rotation;
		 * values from 0 to -180 represent counterclockwise rotation. Values outside
		 * this range are added to or subtracted from 360 to obtain a value within
		 * the range. For example, the statement `my_video.rotation = 450`
		 * is the same as ` my_video.rotation = 90`.
		 */
		rotation:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) rotationX:Float;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) rotationY:Float;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) rotationZ:Float;
		// #end
		
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
		scale9Grid:Rectangle;
		
		/**
		 * Indicates the horizontal scale(percentage) of the object as applied from
		 * the registration point. The default registration point is(0,0). 1.0
		 * equals 100% scale.
		 *
		 * Scaling the local coordinate system changes the `x` and
		 * `y` property values, which are defined in whole pixels. 
		 */
		scaleX:number;
		
		/**
		 * Indicates the vertical scale(percentage) of an object as applied from the
		 * registration point of the object. The default registration point is(0,0).
		 * 1.0 is 100% scale.
		 *
		 * Scaling the local coordinate system changes the `x` and
		 * `y` property values, which are defined in whole pixels. 
		 */
		scaleY:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) scaleZ:Float;
		// #end
		
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
		scrollRect:Rectangle;
		
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
		readonly stage:Stage;
		
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
		transform:Transform;
		
		/**
		 * Whether or not the display object is visible. Display objects that are not
		 * visible are disabled. For example, if `visible=false` for an
		 * InteractiveObject instance, it cannot be clicked.
		 */
		visible:boolean;
		
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
		width:number;
		
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
		x:number;
		
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
		y:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) var z:Float;
		// #end
		
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
		getBounds (targetCoordinateSpace:DisplayObject):Rectangle;
		
		
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
		getRect (targetCoordinateSpace:DisplayObject):Rectangle;
		
		
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
		globalToLocal (pos:Point):Point;
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public function globalToLocal3D (point:Point):Vector3D;
		// #end
		
		
		/**
		 * Evaluates the bounding box of the display object to see if it overlaps or
		 * intersects with the bounding box of the `obj` display object.
		 * 
		 * @param obj The display object to test against.
		 * @return `true` if the bounding boxes of the display objects
		 *         intersect; `false` if not.
		 */
		hitTestObject (obj:DisplayObject):boolean;
		
		
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
		hitTestPoint (x:number, y:number, shapeFlag?:boolean):boolean;
		
		
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
		localToGlobal (point:Point):Point;
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public function local3DToGlobal (point3d:Vector3D):Point;
		// #end
		
		
	}
	
	
}


export default openfl.display.DisplayObject;