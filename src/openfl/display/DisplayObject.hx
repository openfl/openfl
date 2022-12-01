package openfl.display;

#if !flash
import openfl.display._internal.IBitmapDrawableType;
import openfl.utils.ObjectPool;
import openfl.utils._internal.Lib;
import openfl.errors.TypeError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.EventPhase;
import openfl.events.EventType;
import openfl.events.MouseEvent;
import openfl.events.RenderEvent;
import openfl.events.TouchEvent;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.ui.MouseCursor;
import openfl.Vector;
#if lime
import lime.graphics.cairo.Cairo;
#end
#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
#end

/**
	The DisplayObject class is the base class for all objects that can be
	placed on the display list. The display list manages all objects displayed
	in openfl. Use the DisplayObjectContainer class to arrange the
	display objects in the display list. DisplayObjectContainer objects can
	have child display objects, while other display objects, such as Shape and
	TextField objects, are "leaf" nodes that have only parents and siblings, no
	children.

	The DisplayObject class supports basic functionality like the _x_
	and _y_ position of an object, as well as more advanced properties of
	the object such as its transformation matrix.

	DisplayObject is an abstract base class; therefore, you cannot call
	DisplayObject directly. Invoking `new DisplayObject()` throws an
	`ArgumentError` exception.

	All display objects inherit from the DisplayObject class.

	The DisplayObject class itself does not include any APIs for rendering
	content onscreen. For that reason, if you want create a custom subclass of
	the DisplayObject class, you will want to extend one of its subclasses that
	do have APIs for rendering content onscreen, such as the Shape, Sprite,
	Bitmap, SimpleButton, TextField, or MovieClip class.

	The DisplayObject class contains several broadcast events. Normally, the
	target of any particular event is a specific DisplayObject instance. For
	example, the target of an `added` event is the specific
	DisplayObject instance that was added to the display list. Having a single
	target restricts the placement of event listeners to that target and in
	some cases the target's ancestors on the display list. With broadcast
	events, however, the target is not a specific DisplayObject instance, but
	rather all DisplayObject instances, including those that are not on the
	display list. This means that you can add a listener to any DisplayObject
	instance to listen for broadcast events. In addition to the broadcast
	events listed in the DisplayObject class's Events table, the DisplayObject
	class also inherits two broadcast events from the EventDispatcher class:
	`activate` and `deactivate`.

	Some properties previously used in the ActionScript 1.0 and 2.0
	MovieClip, TextField, and Button classes(such as `_alpha`,
	`_height`, `_name`, `_width`,
	`_x`, `_y`, and others) have equivalents in the
	ActionScript 3.0 DisplayObject class that are renamed so that they no
	longer begin with the underscore(_) character.

	For more information, see the "Display Programming" chapter of the
	_ActionScript 3.0 Developer's Guide_.

	@event added            Dispatched when a display object is added to the
							display list. The following methods trigger this
							event:
							`DisplayObjectContainer.addChild()`,
							`DisplayObjectContainer.addChildAt()`.
	@event addedToStage     Dispatched when a display object is added to the on
							stage display list, either directly or through the
							addition of a sub tree in which the display object
							is contained. The following methods trigger this
							event:
							`DisplayObjectContainer.addChild()`,
							`DisplayObjectContainer.addChildAt()`.
	@event enterFrame       [broadcast event] Dispatched when the playhead is
							entering a new frame. If the playhead is not
							moving, or if there is only one frame, this event
							is dispatched continuously in conjunction with the
							frame rate. This event is a broadcast event, which
							means that it is dispatched by all display objects
							with a listener registered for this event.
	@event exitFrame        [broadcast event] Dispatched when the playhead is
							exiting the current frame. All frame scripts have
							been run. If the playhead is not moving, or if
							there is only one frame, this event is dispatched
							continuously in conjunction with the frame rate.
							This event is a broadcast event, which means that
							it is dispatched by all display objects with a
							listener registered for this event.
	@event frameConstructed [broadcast event] Dispatched after the constructors
							of frame display objects have run but before frame
							scripts have run. If the playhead is not moving, or
							if there is only one frame, this event is
							dispatched continuously in conjunction with the
							frame rate. This event is a broadcast event, which
							means that it is dispatched by all display objects
							with a listener registered for this event.
	@event removed          Dispatched when a display object is about to be
							removed from the display list. Two methods of the
							DisplayObjectContainer class generate this event:
							`removeChild()` and
							`removeChildAt()`.

							The following methods of a
							DisplayObjectContainer object also generate this
							event if an object must be removed to make room for
							the new object: `addChild()`,
							`addChildAt()`, and
							`setChildIndex()`.
	@event removedFromStage Dispatched when a display object is about to be
							removed from the display list, either directly or
							through the removal of a sub tree in which the
							display object is contained. Two methods of the
							DisplayObjectContainer class generate this event:
							`removeChild()` and
							`removeChildAt()`.

							The following methods of a
							DisplayObjectContainer object also generate this
							event if an object must be removed to make room for
							the new object: `addChild()`,
							`addChildAt()`, and
							`setChildIndex()`.
	@event render           [broadcast event] Dispatched when the display list
							is about to be updated and rendered. This event
							provides the last opportunity for objects listening
							for this event to make changes before the display
							list is rendered. You must call the
							`invalidate()` method of the Stage
							object each time you want a `render`
							event to be dispatched. `Render` events
							are dispatched to an object only if there is mutual
							trust between it and the object that called
							`Stage.invalidate()`. This event is a
							broadcast event, which means that it is dispatched
							by all display objects with a listener registered
							for this event.

							**Note: **This event is not dispatched if the
							display is not rendering. This is the case when the
							content is either minimized or obscured.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.graphics.Image)
@:access(lime.graphics.ImageBuffer)
@:access(openfl.display3D._internal.Context3DState)
@:access(openfl.display._internal.Context3DGraphics)
@:access(openfl.events.Event)
@:access(openfl.display3D.Context3D)
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
@:access(openfl.geom.Transform)
class DisplayObject extends EventDispatcher implements IBitmapDrawable #if (openfl_dynamic && haxe_ver < "4.0.0") implements Dynamic<DisplayObject> #end
{
	@:noCompletion private static var __broadcastEvents:Map<String, Array<DisplayObject>> = new Map();
	@:noCompletion private static var __initStage:Stage;
	@:noCompletion private static var __instanceCount:Int = 0;

	@:noCompletion
	private static #if !js inline #end var __supportDOM:Bool #if !js = false #end;

	@:noCompletion private static var __tempStack:ObjectPool<Vector<DisplayObject>> = new ObjectPool<Vector<DisplayObject>>(function() return
		new Vector<DisplayObject>(), function(stack) stack.length = 0);

	#if false
	/**
		The current accessibility options for this display object. If you modify the `accessibilityProperties`
		property or any of the fields within `accessibilityProperties`, you must call the
		`Accessibility.updateProperties()` method to make your changes take effect.

		**Note:** For an object created in the Flash authoring environment, the value of `accessibilityProperties`
		is prepopulated with any information you entered in the Accessibility panel for that object.
	**/
	// @:noCompletion @:dox(hide) public var accessibilityProperties:openfl.accessibility.AccessibilityProperties;
	#end

	/**
		Indicates the alpha transparency value of the object specified. Valid
		values are 0 (fully transparent) to 1 (fully opaque). The default value is 1.
		Display objects with `alpha` set to 0 _are_ active, even though they are invisible.
	**/
	@:keep public var alpha(get, set):Float;

	/**
		A value from the BlendMode class that specifies which blend mode to use. A
		bitmap can be drawn internally in two ways. If you have a blend mode
		enabled or an external clipping mask, the bitmap is drawn by adding a
		bitmap-filled square shape to the vector render. If you attempt to set
		this property to an invalid value, Flash runtimes set the value to
		`BlendMode.NORMAL`.

		The `blendMode` property affects each pixel of the display
		object. Each pixel is composed of three constituent colors(red, green,
		and blue), and each constituent color has a value between 0x00 and 0xFF.
		Flash Player or Adobe AIR compares each constituent color of one pixel in
		the movie clip with the corresponding color of the pixel in the
		background. For example, if `blendMode` is set to
		`BlendMode.LIGHTEN`, Flash Player or Adobe AIR compares the red
		value of the display object with the red value of the background, and uses
		the lighter of the two as the value for the red component of the displayed
		color.

		The following table describes the `blendMode` settings. The
		BlendMode class defines string values you can use. The illustrations in
		the table show `blendMode` values applied to a circular display
		object(2) superimposed on another display object(1).

		![Square Number 1](/images/blendMode-0a.jpg)  ![Circle Number 2](/images/blendMode-0b.jpg)

		| BlendMode Constant | Illustration | Description |
		| --- | --- | --- |
		| `BlendMode.NORMAL` | ![blend mode NORMAL](/images/blendMode-1.jpg) | The display object appears in front of the background. Pixel values of the display object override those of the background. Where the display object is transparent, the background is visible. |
		| `BlendMode.LAYER` | ![blend mode LAYER](/images/blendMode-2.jpg) | Forces the creation of a transparency group for the display object. This means that the display object is pre-composed in a temporary buffer before it is processed further. This is done automatically if the display object is pre-cached using bitmap caching or if the display object is a display object container with at least one child object with a `blendMode` setting other than `BlendMode.NORMAL`. Not supported under GPU rendering. |
		| `BlendMode.MULTIPLY` | ![blend mode MULTIPLY](/images/blendMode-3.jpg) | Multiplies the values of the display object constituent colors by the colors of the background color, and then normalizes by dividing by 0xFF, resulting in darker colors. This setting is commonly used for shadows and depth effects.<br>For example, if a constituent color (such as red) of one pixel in the display object and the corresponding color of the pixel in the background both have the value 0x88, the multiplied result is 0x4840. Dividing by 0xFF yields a value of 0x48 for that constituent color, which is a darker shade than the color of the display object or the color of the background. |
		| `BlendMode.SCREEN` | ![blend mode SCREEN](/images/blendMode-4.jpg) | Multiplies the complement (inverse) of the display object color by the complement of the background color, resulting in a bleaching effect. This setting is commonly used for highlights or to remove black areas of the display object. |
		| `BlendMode.LIGHTEN` | ![blend mode LIGHTEN](/images/blendMode-5.jpg) | Selects the lighter of the constituent colors of the display object and the color of the background (the colors with the larger values). This setting is commonly used for superimposing type.<br>For example, if the display object has a pixel with an RGB value of 0xFFCC33, and the background pixel has an RGB value of 0xDDF800, the resulting RGB value for the displayed pixel is 0xFFF833 (because 0xFF > 0xDD, 0xCC < 0xF8, and 0x33 > 0x00 = 33). Not supported under GPU rendering. |
		| `BlendMode.DARKEN` | ![blend mode DARKEN](/images/blendMode-6.jpg) | Selects the darker of the constituent colors of the display object and the colors of the background (the colors with the smaller values). This setting is commonly used for superimposing type.<br>For example, if the display object has a pixel with an RGB value of 0xFFCC33, and the background pixel has an RGB value of 0xDDF800, the resulting RGB value for the displayed pixel is 0xDDCC00 (because 0xFF > 0xDD, 0xCC < 0xF8, and 0x33 > 0x00 = 33). Not supported under GPU rendering. |
		| `BlendMode.DIFFERENCE` | ![blend mode DIFFERENCE](/images/blendMode-7.jpg) | Compares the constituent colors of the display object with the colors of its background, and subtracts the darker of the values of the two constituent colors from the lighter value. This setting is commonly used for more vibrant colors.<br>For example, if the display object has a pixel with an RGB value of 0xFFCC33, and the background pixel has an RGB value of 0xDDF800, the resulting RGB value for the displayed pixel is 0x222C33 (because 0xFF - 0xDD = 0x22, 0xF8 - 0xCC = 0x2C, and 0x33 - 0x00 = 0x33). |
		| `BlendMode.ADD` | ![blend mode ADD](/images/blendMode-8.jpg) | Adds the values of the constituent colors of the display object to the colors of its background, applying a ceiling of 0xFF. This setting is commonly used for animating a lightening dissolve between two objects.<br>For example, if the display object has a pixel with an RGB value of 0xAAA633, and the background pixel has an RGB value of 0xDD2200, the resulting RGB value for the displayed pixel is 0xFFC833 (because 0xAA + 0xDD > 0xFF, 0xA6 + 0x22 = 0xC8, and 0x33 + 0x00 = 0x33). |
		| `BlendMode.SUBTRACT` | ![blend mode SUBTRACT](/images/blendMode-9.jpg) | Subtracts the values of the constituent colors in the display object from the values of the background color, applying a floor of 0. This setting is commonly used for animating a darkening dissolve between two objects.<br>For example, if the display object has a pixel with an RGB value of 0xAA2233, and the background pixel has an RGB value of 0xDDA600, the resulting RGB value for the displayed pixel is 0x338400 (because 0xDD - 0xAA = 0x33, 0xA6 - 0x22 = 0x84, and 0x00 - 0x33 < 0x00). |
		| `BlendMode.INVERT` | ![blend mode INVERT](/images/blendMode-10.jpg) | Inverts the background. |
		| `BlendMode.ALPHA` | ![blend mode ALPHA](/images/blendMode-11.jpg) | Applies the alpha value of each pixel of the display object to the background. This requires the `blendMode` setting of the parent display object to be set to `BlendMode.LAYER`. For example, in the illustration, the parent display object, which is a white background, has `blendMode = BlendMode.LAYER`. Not supported under GPU rendering. |
		| `BlendMode.ERASE` | ![blend mode ERASE](/images/blendMode-12.jpg) | Erases the background based on the alpha value of the display object. This requires the `blendMode` of the parent display object to be set to `BlendMode.LAYER`. For example, in the illustration, the parent display object, which is a white background, has `blendMode = BlendMode.LAYER`. Not supported under GPU rendering. |
		| `BlendMode.OVERLAY` | ![blend mode OVERLAY](/images/blendMode-13.jpg) | Adjusts the color of each pixel based on the darkness of the background. If the background is lighter than 50% gray, the display object and background colors are screened, which results in a lighter color. If the background is darker than 50% gray, the colors are multiplied, which results in a darker color. This setting is commonly used for shading effects. Not supported under GPU rendering. |
		| `BlendMode.HARDLIGHT` | ![blend mode HARDLIGHT](/images/blendMode-14.jpg) | Adjusts the color of each pixel based on the darkness of the display object. If the display object is lighter than 50% gray, the display object and background colors are screened, which results in a lighter color. If the display object is darker than 50% gray, the colors are multiplied, which results in a darker color. This setting is commonly used for shading effects. Not supported under GPU rendering. |
		| `BlendMode.SHADER` | N/A | Adjusts the color using a custom shader routine. The shader that is used is specified as the Shader instance assigned to the blendShader property. Setting the blendShader property of a display object to a Shader instance automatically sets the display object's `blendMode` property to `BlendMode.SHADER`. If the `blendMode` property is set to `BlendMode.SHADER` without first setting the `blendShader` property, the `blendMode` property is set to `BlendMode.NORMAL`. Not supported under GPU rendering. |
	**/
	public var blendMode(get, set):BlendMode;

	#if false
	/**
		Sets a shader that is used for blending the foreground and background. When the `blendMode` property is set
		to `BlendMode.SHADER`, the specified Shader is used to create the blend mode output for the display object.

		Setting the `blendShader` property of a display object to a Shader instance automatically sets the display
		object's `blendMode` property to `BlendMode.SHADER`. If the `blendShader` property is set (which sets the
		`blendMode` property to `BlendMode.SHADER`), then the value of the `blendMode` property is changed, the
		blend mode can be reset to use the blend shader simply by setting the `blendMode` property to
		`BlendMode.SHADER`. The `blendShader` property does not need to be set again except to change the shader
		that's used for the blend mode.

		The Shader assigned to the `blendShader` property must specify at least two `image4` inputs. The inputs do
		not need to be specified in code using the associated ShaderInput objects' input properties. The background
		display object is automatically used as the first input (the input with index 0). The foreground display
		object is used as the second input (the input with index 1). A shader used as a blend shader can specify more
		than two inputs. In that case, any additional input must be specified by setting its ShaderInput instance's
		`input` property.

		When you assign a Shader instance to this property the shader is copied internally. The blend operation uses
		that internal copy, not a reference to the original shader. Any changes made to the shader, such as changing
		a parameter value, input, or bytecode, are not applied to the copied shader that's used for the blend mode.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var blendShader(null, default):Shader;
	#end

	/**
		All vector data for a display object that has a cached bitmap is drawn
		to the bitmap instead of the main display. If
		`cacheAsBitmapMatrix` is null or unsupported, the bitmap is
		then copied to the main display as unstretched, unrotated pixels snapped
		to the nearest pixel boundaries. Pixels are mapped 1 to 1 with the parent
		object. If the bounds of the bitmap change, the bitmap is recreated
		instead of being stretched.

		If `cacheAsBitmapMatrix` is non-null and supported, the
		object is drawn to the off-screen bitmap using that matrix and the
		stretched and/or rotated results of that rendering are used to draw the
		object to the main display.

		No internal bitmap is created unless the `cacheAsBitmap`
		property is set to `true`.

		After you set the `cacheAsBitmap` property to
		`true`, the rendering does not change, however the display
		object performs pixel snapping automatically. The animation speed can be
		significantly faster depending on the complexity of the vector content.

		The `cacheAsBitmap` property is automatically set to
		`true` whenever you apply a filter to a display object(when
		its `filter` array is not empty), and if a display object has a
		filter applied to it, `cacheAsBitmap` is reported as
		`true` for that display object, even if you set the property to
		`false`. If you clear all filters for a display object, the
		`cacheAsBitmap` setting changes to what it was last set to.

		A display object does not use a bitmap even if the
		`cacheAsBitmap` property is set to `true` and
		instead renders from vector data in the following cases:

		* The bitmap is too large. In AIR 1.5 and Flash Player 10, the maximum
		size for a bitmap image is 8,191 pixels in width or height, and the total
		number of pixels cannot exceed 16,777,215 pixels.(So, if a bitmap image
		is 8,191 pixels wide, it can only be 2,048 pixels high.) In Flash Player 9
		and earlier, the limitation is is 2880 pixels in height and 2,880 pixels
		in width.
		*  The bitmap fails to allocate(out of memory error).

		The `cacheAsBitmap` property is best used with movie clips
		that have mostly static content and that do not scale and rotate
		frequently. With such movie clips, `cacheAsBitmap` can lead to
		performance increases when the movie clip is translated(when its _x_
		and _y_ position is changed).
	**/
	public var cacheAsBitmap(get, set):Bool;

	/**
		If non-null, this Matrix object defines how a display object is rendered when `cacheAsBitmap` is set to
		`true`. The application uses this matrix as a transformation matrix that is applied when rendering the
		bitmap version of the display object.

		_AIR profile support:_ This feature is supported on mobile devices, but it is not supported on desktop
		operating systems. It also has limited support on AIR for TV devices. Specifically, on AIR for TV devices,
		supported transformations include scaling and translation, but not rotation and skewing. See AIR Profile
		Support for more information regarding API support across multiple profiles.

		With `cacheAsBitmapMatrix` set, the application retains a cached bitmap image across various 2D
		transformations, including translation, rotation, and scaling. If the application uses hardware acceleration,
		the object will be stored in video memory as a texture. This allows the GPU to apply the supported
		transformations to the object. The GPU can perform these transformations faster than the CPU.

		To use the hardware acceleration, set Rendering to GPU in the General tab of the iPhone Settings dialog box
		in Flash Professional CS5. Or set the `renderMode` property to gpu in the application descriptor file. Note
		that AIR for TV devices automatically use hardware acceleration if it is available.

		For example, the following code sends an untransformed bitmap representation of the display object to the GPU:

		```haxe
		var matrix:Matrix = new Matrix(); // creates an identity matrix
		mySprite.cacheAsBitmapMatrix = matrix;
		mySprite.cacheAsBitmap = true;
		```

		Usually, the identity matrix (`new Matrix()`) suffices. However, you can use another matrix, such as a
		scaled-down matrix, to upload a different bitmap to the GPU. For example, the following example applies a
		`cacheAsBitmapMatrix` matrix that is scaled by 0.5 on the x and y axes. The bitmap object that the GPU uses
		is smaller, however the GPU adjusts its size to match the `transform.matrix` property of the display object:

		```haxe
		var matrix:Matrix = new Matrix(); // creates an identity matrix
		matrix.scale(0.5, 0.5); // scales the matrix
		mySprite.cacheAsBitmapMatrix = matrix;
		mySprite.cacheAsBitmap = true;
		```

		Generally, you should choose to use a matrix that transforms the display object to the size that it will
		appear in the application. For example, if your application displays the bitmap version of the sprite scaled
		down by a half, use a matrix that scales down by a half. If you application will display the sprite larger
		than its current dimensions, use a matrix that scales up by that factor.

		**Note:** The `cacheAsBitmapMatrix` property is suitable for 2D transformations. If you need to apply
		transformations in 3D, you may do so by setting a 3D property of the object and manipulating its
		`transform.matrix3D` property. If the application is packaged using GPU mode, this allows the 3D transforms
		to be applied to the object by the GPU. The `cacheAsBitmapMatrix` is ignored for 3D objects.
	**/
	public var cacheAsBitmapMatrix(get, set):Matrix;

	/**
		An indexed array that contains each filter object currently associated
		with the display object. The openfl.filters package contains several
		classes that define specific filters you can use.

		Filters can be applied in Flash Professional at design time, or at run
		time by using ActionScript code. To apply a filter by using ActionScript,
		you must make a temporary copy of the entire `filters` array,
		modify the temporary array, then assign the value of the temporary array
		back to the `filters` array. You cannot directly add a new
		filter object to the `filters` array.

		To add a filter by using ActionScript, perform the following steps
		(assume that the target display object is named
		`myDisplayObject`):

		 1. Create a new filter object by using the constructor method of your
		chosen filter class.
		 2. Assign the value of the `myDisplayObject.filters` array
		to a temporary array, such as one named `myFilters`.
		 3. Add the new filter object to the `myFilters` temporary
		array.
		 4. Assign the value of the temporary array to the
		`myDisplayObject.filters` array.

		If the `filters` array is undefined, you do not need to use
		a temporary array. Instead, you can directly assign an array literal that
		contains one or more filter objects that you create. The first example in
		the Examples section adds a drop shadow filter by using code that handles
		both defined and undefined `filters` arrays.

		To modify an existing filter object, you must use the technique of
		modifying a copy of the `filters` array:

		 1. Assign the value of the `filters` array to a temporary
		array, such as one named `myFilters`.
		 2. Modify the property by using the temporary array,
		`myFilters`. For example, to set the quality property of the
		first filter in the array, you could use the following code:
		`myFilters[0].quality = 1;`
		 3. Assign the value of the temporary array to the `filters`
		array.

		At load time, if a display object has an associated filter, it is
		marked to cache itself as a transparent bitmap. From this point forward,
		as long as the display object has a valid filter list, the player caches
		the display object as a bitmap. This source bitmap is used as a source
		image for the filter effects. Each display object usually has two bitmaps:
		one with the original unfiltered source display object and another for the
		final image after filtering. The final image is used when rendering. As
		long as the display object does not change, the final image does not need
		updating.

		The openfl.filters package includes classes for filters. For example, to
		create a DropShadow filter, you would write:

		@throws ArgumentError When `filters` includes a ShaderFilter
							  and the shader output type is not compatible with
							  this operation(the shader must specify a
							  `pixel4` output).
		@throws ArgumentError When `filters` includes a ShaderFilter
							  and the shader doesn't specify any image input or
							  the first input is not an `image4` input.
		@throws ArgumentError When `filters` includes a ShaderFilter
							  and the shader specifies an image input that isn't
							  provided.
		@throws ArgumentError When `filters` includes a ShaderFilter, a
							  ByteArray or Vector.<Number> instance as a shader
							  input, and the `width` and
							  `height` properties aren't specified for
							  the ShaderInput object, or the specified values
							  don't match the amount of data in the input data.
							  See the `ShaderInput.input` property for
							  more information.
	**/
	public var filters(get, set):Array<BitmapFilter>;

	/**
		Indicates the height of the display object, in pixels. The height is
		calculated based on the bounds of the content of the display object. When
		you set the `height` property, the `scaleY` property
		is adjusted accordingly, as shown in the following code:

		Except for TextField and Video objects, a display object with no
		content(such as an empty sprite) has a height of 0, even if you try to
		set `height` to a different value.
	**/
	@:keep public var height(get, set):Float;

	/**
		Returns a LoaderInfo object containing information about loading the file
		to which this display object belongs. The `loaderInfo` property
		is defined only for the root display object of a SWF file or for a loaded
		Bitmap(not for a Bitmap that is drawn with ActionScript). To find the
		`loaderInfo` object associated with the SWF file that contains
		a display object named `myDisplayObject`, use
		`myDisplayObject.root.loaderInfo`.

		A large SWF file can monitor its download by calling
		`this.root.loaderInfo.addEventListener(Event.COMPLETE,
		func)`.
	**/
	public var loaderInfo(get, never):LoaderInfo;

	/**
		The calling display object is masked by the specified `mask`
		object. To ensure that masking works when the Stage is scaled, the
		`mask` display object must be in an active part of the display
		list. The `mask` object itself is not drawn. Set
		`mask` to `null` to remove the mask.

		To be able to scale a mask object, it must be on the display list. To
		be able to drag a mask Sprite object(by calling its
		`startDrag()` method), it must be on the display list. To call
		the `startDrag()` method for a mask sprite based on a
		`mouseDown` event being dispatched by the sprite, set the
		sprite's `buttonMode` property to `true`.

		When display objects are cached by setting the
		`cacheAsBitmap` property to `true` an the
		`cacheAsBitmapMatrix` property to a Matrix object, both the
		mask and the display object being masked must be part of the same cached
		bitmap. Thus, if the display object is cached, then the mask must be a
		child of the display object. If an ancestor of the display object on the
		display list is cached, then the mask must be a child of that ancestor or
		one of its descendents. If more than one ancestor of the masked object is
		cached, then the mask must be a descendent of the cached container closest
		to the masked object in the display list.

		**Note:** A single `mask` object cannot be used to mask
		more than one calling display object. When the `mask` is
		assigned to a second display object, it is removed as the mask of the
		first object, and that object's `mask` property becomes
		`null`.
	**/
	public var mask(get, set):DisplayObject;

	/**
		Indicates the x coordinate of the mouse or user input device position, in
		pixels.

		**Note**: For a DisplayObject that has been rotated, the returned x
		coordinate will reflect the non-rotated object.
	**/
	public var mouseX(get, never):Float;

	/**
		Indicates the y coordinate of the mouse or user input device position, in
		pixels.

		**Note**: For a DisplayObject that has been rotated, the returned y
		coordinate will reflect the non-rotated object.
	**/
	public var mouseY(get, never):Float;

	/**
		Indicates the instance name of the DisplayObject. The object can be
		identified in the child list of its parent display object container by
		calling the `getChildByName()` method of the display object
		container.

		@throws IllegalOperationError If you are attempting to set this property
									  on an object that was placed on the timeline
									  in the Flash authoring tool.
	**/
	public var name(get, set):String;

	/**
		Specifies whether the display object is opaque with a certain background
		color. A transparent bitmap contains alpha channel data and is drawn
		transparently. An opaque bitmap has no alpha channel(and renders faster
		than a transparent bitmap). If the bitmap is opaque, you specify its own
		background color to use.

		If set to a number value, the surface is opaque(not transparent) with
		the RGB background color that the number specifies. If set to
		`null`(the default value), the display object has a
		transparent background.

		The `opaqueBackground` property is intended mainly for use
		with the `cacheAsBitmap` property, for rendering optimization.
		For display objects in which the `cacheAsBitmap` property is
		set to true, setting `opaqueBackground` can improve rendering
		performance.

		The opaque background region is _not_ matched when calling the
		`hitTestPoint()` method with the `shapeFlag`
		parameter set to `true`.

		The opaque background region does not respond to mouse events.
	**/
	public var opaqueBackground:Null<Int>;

	/**
		Indicates the DisplayObjectContainer object that contains this display
		object. Use the `parent` property to specify a relative path to
		display objects that are above the current display object in the display
		list hierarchy.

		You can use `parent` to move up multiple levels in the
		display list as in the following:

		```haxe
		this.parent.parent.alpha = 20;
		```

		@throws SecurityError The parent display object belongs to a security
							  sandbox to which you do not have access. You can
							  avoid this situation by having the parent movie call
							  the `Security.allowDomain()` method.
	**/
	public var parent(default, null):DisplayObjectContainer;

	/**
		For a display object in a loaded SWF file, the `root` property
		is the top-most display object in the portion of the display list's tree
		structure represented by that SWF file. For a Bitmap object representing a
		loaded image file, the `root` property is the Bitmap object
		itself. For the instance of the main class of the first SWF file loaded,
		the `root` property is the display object itself. The
		`root` property of the Stage object is the Stage object itself.
		The `root` property is set to `null` for any display
		object that has not been added to the display list, unless it has been
		added to a display object container that is off the display list but that
		is a child of the top-most display object in a loaded SWF file.

		For example, if you create a new Sprite object by calling the
		`Sprite()` constructor method, its `root` property
		is `null` until you add it to the display list(or to a display
		object container that is off the display list but that is a child of the
		top-most display object in a SWF file).

		For a loaded SWF file, even though the Loader object used to load the
		file may not be on the display list, the top-most display object in the
		SWF file has its `root` property set to itself. The Loader
		object does not have its `root` property set until it is added
		as a child of a display object for which the `root` property is
		set.
	**/
	public var root(get, never):DisplayObject;

	/**
		Indicates the rotation of the DisplayObject instance, in degrees, from its
		original orientation. Values from 0 to 180 represent clockwise rotation;
		values from 0 to -180 represent counterclockwise rotation. Values outside
		this range are added to or subtracted from 360 to obtain a value within
		the range. For example, the statement `my_video.rotation = 450`
		is the same as ` my_video.rotation = 90`.
	**/
	@:keep public var rotation(get, set):Float;

	#if false
	/**
		Indicates the x-axis rotation of the DisplayObject instance, in degrees, from its original orientation
		relative to the 3D parent container. Values from 0 to 180 represent clockwise rotation; values from 0 to
		-180 represent counterclockwise rotation. Values outside this range are added to or subtracted from 360 to
		obtain a value within the range.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var rotationX:Float;
	#end

	#if false
	/**
		Indicates the y-axis rotation of the DisplayObject instance, in degrees, from its original orientation
		relative to the 3D parent container. Values from 0 to 180 represent clockwise rotation; values from 0 to
		-180 represent counterclockwise rotation. Values outside this range are added to or subtracted from 360 to
		obtain a value within the range.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var rotationY:Float;
	#end

	#if false
	/**
		Indicates the z-axis rotation of the DisplayObject instance, in degrees, from its original orientation
		relative to the 3D parent container. Values from 0 to 180 represent clockwise rotation; values from 0 to
		-180 represent counterclockwise rotation. Values outside this range are added to or subtracted from 360 to
		obtain a value within the range.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var rotationZ:Float;
	#end

	/**
		The current scaling grid that is in effect. If set to `null`,
		the entire display object is scaled normally when any scale transformation
		is applied.

		When you define the `scale9Grid` property, the display
		object is divided into a grid with nine regions based on the
		`scale9Grid` rectangle, which defines the center region of the
		grid. The eight other regions of the grid are the following areas:

		* The upper-left corner outside of the rectangle
		* The area above the rectangle
		* The upper-right corner outside of the rectangle
		* The area to the left of the rectangle
		* The area to the right of the rectangle
		* The lower-left corner outside of the rectangle
		* The area below the rectangle
		* The lower-right corner outside of the rectangle

		You can think of the eight regions outside of the center (defined by
		the rectangle) as being like a picture frame that has special rules
		applied to it when scaled.

		**Note:** Content that is not rendered through the `graphics` interface
		of a display object will not be affected by the `scale9Grid` property.

		When the `scale9Grid` property is set and a display object
		is scaled, all text and gradients are scaled normally; however, for other
		types of objects the following rules apply:

		* Content in the center region is scaled normally.
		* Content in the corners is not scaled.
		* Content in the top and bottom regions is scaled horizontally only.
		* Content in the left and right regions is scaled vertically only.
		* All fills (including bitmaps, video, and gradients) are stretched to
		fit their shapes.

		If a display object is rotated, all subsequent scaling is normal(and
		the `scale9Grid` property is ignored).

		For example, consider the following display object and a rectangle that
		is applied as the display object's `scale9Grid`:

		| | |
		| --- | --- |
		| ![display object image](/images/scale9Grid-a.jpg)<br>The display object. | ![display object scale 9 region](/images/scale9Grid-b.jpg)<br>The red rectangle shows the scale9Grid. |

		When the display object is scaled or stretched, the objects within the rectangle scale normally, but the
		objects outside of the rectangle scale according to the `scale9Grid` rules:

		| | |
		| --- | --- |
		| Scaled to 75%: | ![display object at 75%](/images/scale9Grid-c.jpg) |
		| Scaled to 50%: | ![display object at 50%](/images/scale9Grid-d.jpg) |
		| Scaled to 25%: | ![display object at 25%](/images/scale9Grid-e.jpg) |
		| Stretched horizontally 150%: | ![display stretched 150%](/images/scale9Grid-f.jpg) |

		A common use for setting `scale9Grid` is to set up a display
		object to be used as a component, in which edge regions retain the same
		width when the component is scaled.

		@throws ArgumentError If you pass an invalid argument to the method.
	**/
	public var scale9Grid(get, set):Rectangle;

	/**
		Indicates the horizontal scale (percentage) of the object as applied from
		the registration point. The default registration point is (0,0). 1.0
		equals 100% scale.

		Scaling the local coordinate system changes the `x` and
		`y` property values, which are defined in whole pixels.
	**/
	@:keep public var scaleX(get, set):Float;

	/**
		Indicates the vertical scale (percentage) of an object as applied from the
		registration point of the object. The default registration point is (0,0).
		1.0 is 100% scale.

		Scaling the local coordinate system changes the `x` and
		`y` property values, which are defined in whole pixels.
	**/
	@:keep public var scaleY(get, set):Float;

	#if false
	/**
		Indicates the depth scale (percentage) of an object as applied from the registration point of the object.
		The default registration point is (0,0). 1.0 is 100% scale.

		Scaling the local coordinate system changes the `x`, `y` and `z` property values, which are defined in whole
		pixels.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var scaleZ:Float;
	#end

	/**
		The scroll rectangle bounds of the display object. The display object is
		cropped to the size defined by the rectangle, and it scrolls within the
		rectangle when you change the `x` and `y` properties
		of the `scrollRect` object.

		The properties of the `scrollRect` Rectangle object use the
		display object's coordinate space and are scaled just like the overall
		display object. The corner bounds of the cropped window on the scrolling
		display object are the origin of the display object(0,0) and the point
		defined by the width and height of the rectangle. They are not centered
		around the origin, but use the origin to define the upper-left corner of
		the area. A scrolled display object always scrolls in whole pixel
		increments.

		You can scroll an object left and right by setting the `x`
		property of the `scrollRect` Rectangle object. You can scroll
		an object up and down by setting the `y` property of the
		`scrollRect` Rectangle object. If the display object is rotated
		90� and you scroll it left and right, the display object actually scrolls
		up and down.
	**/
	public var scrollRect(get, set):Rectangle;

	/**
		**BETA**

		Applies a custom Shader object to use when rendering this display object (or its children) when using
		hardware rendering. This occurs as a single-pass render on this object only, if visible. In order to
		apply a post-process effect to multiple display objects at once, enable `cacheAsBitmap` or use the
		`filters` property with a ShaderFilter
	**/
	@:beta public var shader(get, set):Shader;

	/**
		The Stage of the display object. A Flash runtime application has only one
		Stage object. For example, you can create and load multiple display
		objects into the display list, and the `stage` property of each
		display object refers to the same Stage object(even if the display object
		belongs to a loaded SWF file).

		If a display object is not added to the display list, its
		`stage` property is set to `null`.
	**/
	public var stage(default, null):Stage;

	/**
		An object with properties pertaining to a display object's matrix, color
		transform, and pixel bounds. The specific properties  -  matrix,
		colorTransform, and three read-only properties
		(`concatenatedMatrix`, `concatenatedColorTransform`,
		and `pixelBounds`)  -  are described in the entry for the
		Transform class.

		Each of the transform object's properties is itself an object. This
		concept is important because the only way to set new values for the matrix
		or colorTransform objects is to create a new object and copy that object
		into the transform.matrix or transform.colorTransform property.

		For example, to increase the `tx` value of a display
		object's matrix, you must make a copy of the entire matrix object, then
		copy the new object into the matrix property of the transform object:
		` var myMatrix:Matrix =
		myDisplayObject.transform.matrix; myMatrix.tx += 10;
		myDisplayObject.transform.matrix = myMatrix; `

		You cannot directly set the `tx` property. The following
		code has no effect on `myDisplayObject`:
		` myDisplayObject.transform.matrix.tx +=
		10; `

		You can also copy an entire transform object and assign it to another
		display object's transform property. For example, the following code
		copies the entire transform object from `myOldDisplayObj` to
		`myNewDisplayObj`:
		`myNewDisplayObj.transform = myOldDisplayObj.transform;`

		The resulting display object, `myNewDisplayObj`, now has the
		same values for its matrix, color transform, and pixel bounds as the old
		display object, `myOldDisplayObj`.

		Note that AIR for TV devices use hardware acceleration, if it is
		available, for color transforms.
	**/
	@:keep public var transform(get, set):Transform;

	/**
		Whether or not the display object is visible. Display objects that are not
		visible are disabled. For example, if `visible=false` for an
		InteractiveObject instance, it cannot be clicked.
	**/
	public var visible(get, set):Bool;

	/**
		Indicates the width of the display object, in pixels. The width is
		calculated based on the bounds of the content of the display object. When
		you set the `width` property, the `scaleX` property
		is adjusted accordingly, as shown in the following code:

		Except for TextField and Video objects, a display object with no
		content(such as an empty sprite) has a width of 0, even if you try to set
		`width` to a different value.
	**/
	@:keep public var width(get, set):Float;

	/**
		Indicates the _x_ coordinate of the DisplayObject instance relative
		to the local coordinates of the parent DisplayObjectContainer. If the
		object is inside a DisplayObjectContainer that has transformations, it is
		in the local coordinate system of the enclosing DisplayObjectContainer.
		Thus, for a DisplayObjectContainer rotated 90� counterclockwise, the
		DisplayObjectContainer's children inherit a coordinate system that is
		rotated 90� counterclockwise. The object's coordinates refer to the
		registration point position.
	**/
	@:keep public var x(get, set):Float;

	/**
		Indicates the _y_ coordinate of the DisplayObject instance relative
		to the local coordinates of the parent DisplayObjectContainer. If the
		object is inside a DisplayObjectContainer that has transformations, it is
		in the local coordinate system of the enclosing DisplayObjectContainer.
		Thus, for a DisplayObjectContainer rotated 90� counterclockwise, the
		DisplayObjectContainer's children inherit a coordinate system that is
		rotated 90� counterclockwise. The object's coordinates refer to the
		registration point position.
	**/
	@:keep public var y(get, set):Float;

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
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __cairo:#if lime Cairo #else Dynamic #end;
	@:noCompletion private var __children:Array<DisplayObject>;
	@:noCompletion private var __customRenderClear:Bool;
	@:noCompletion private var __customRenderEvent:RenderEvent;
	@:noCompletion private var __drawableType:IBitmapDrawableType;
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
	@:noCompletion private var __scale9Grid:Rectangle;
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
	@:noCompletion private var __worldScale9Grid:Rectangle;
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
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(DisplayObject.prototype, {
			"alpha": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_alpha (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_alpha (v); }")
			},
			"blendMode": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_blendMode (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_blendMode (v); }")
			},
			"cacheAsBitmap": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_cacheAsBitmap (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_cacheAsBitmap (v); }")
			},
			"cacheAsBitmapMatrix": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_cacheAsBitmapMatrix (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_cacheAsBitmapMatrix (v); }")
			},
			"filters": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_filters (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_filters (v); }")
			},
			"height": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_height (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_height (v); }")
			},
			"loaderInfo": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_loaderInfo (); }")
			},
			"mask": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_mask (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_mask (v); }")
			},
			"mouseX": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_mouseX (); }")
			},
			"mouseY": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_mouseY (); }")
			},
			"name": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_name (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_name (v); }")
			},
			"root": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_root (); }")
			},
			"rotation": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_rotation (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_rotation (v); }")
			},
			"scaleX": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_scaleX (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_scaleX (v); }")
			},
			"scaleY": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_scaleY (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_scaleY (v); }")
			},
			"scrollRect": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_scrollRect (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_scrollRect (v); }")
			},
			"shader": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_shader (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_shader (v); }")
			},
			"transform": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_transform (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_transform (v); }")
			},
			"visible": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_visible (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_visible (v); }")
			},
			"width": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_width (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_width (v); }")
			},
			"x": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_x (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_x (v); }")
			},
			"y": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_y (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_y (v); }")
			},
		});
	}
	#end

	@:noCompletion private function new()
	{
		super();

		__drawableType = DISPLAY_OBJECT;

		__alpha = 1;
		__blendMode = NORMAL;
		__cacheAsBitmap = false;
		__transform = new Matrix();
		__visible = true;

		__rotation = 0;
		__rotationSine = 0;
		__rotationCosine = 1;
		__scaleX = 1;
		__scaleY = 1;

		__worldAlpha = 1;
		__worldBlendMode = NORMAL;
		__worldTransform = new Matrix();
		__worldColorTransform = new ColorTransform();
		__renderTransform = new Matrix();
		__worldVisible = true;

		name = "instance" + (++__instanceCount);

		if (__initStage != null)
		{
			this.stage = __initStage;
			__initStage = null;
			this.stage.addChild(this);
		}
	}

	@SuppressWarnings("checkstyle:Dynamic")
	public override function addEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false, priority:Int = 0,
			useWeakReference:Bool = false):Void
	{
		switch (type)
		{
			case Event.ACTIVATE, Event.DEACTIVATE, Event.ENTER_FRAME, Event.EXIT_FRAME, Event.FRAME_CONSTRUCTED, Event.RENDER:
				if (!__broadcastEvents.exists(type))
				{
					__broadcastEvents.set(type, []);
				}

				var dispatchers = __broadcastEvents.get(type);

				if (dispatchers.indexOf(this) == -1)
				{
					dispatchers.push(this);
				}

			case RenderEvent.CLEAR_DOM, RenderEvent.RENDER_CAIRO, RenderEvent.RENDER_CANVAS, RenderEvent.RENDER_DOM, RenderEvent.RENDER_OPENGL:
				if (__customRenderEvent == null)
				{
					__customRenderEvent = new RenderEvent(null);
					__customRenderEvent.objectColorTransform = new ColorTransform();
					__customRenderEvent.objectMatrix = new Matrix();
					__customRenderClear = true;
				}

			default:
		}

		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	public override function dispatchEvent(event:Event):Bool
	{
		if ((event is MouseEvent))
		{
			var mouseEvent:MouseEvent = cast event;
			mouseEvent.stageX = __getRenderTransform().__transformX(mouseEvent.localX, mouseEvent.localY);
			mouseEvent.stageY = __getRenderTransform().__transformY(mouseEvent.localX, mouseEvent.localY);
		}
		else if ((event is TouchEvent))
		{
			var touchEvent:TouchEvent = cast event;
			touchEvent.stageX = __getRenderTransform().__transformX(touchEvent.localX, touchEvent.localY);
			touchEvent.stageY = __getRenderTransform().__transformY(touchEvent.localX, touchEvent.localY);
		}

		event.target = this;

		return __dispatchWithCapture(event);
	}

	/**
		Returns a rectangle that defines the area of the display object relative
		to the coordinate system of the `targetCoordinateSpace` object.
		Consider the following code, which shows how the rectangle returned can
		vary depending on the `targetCoordinateSpace` parameter that
		you pass to the method:

		**Note:** Use the `localToGlobal()` and
		`globalToLocal()` methods to convert the display object's local
		coordinates to display coordinates, or display coordinates to local
		coordinates, respectively.

		The `getBounds()` method is similar to the
		`getRect()` method; however, the Rectangle returned by the
		`getBounds()` method includes any strokes on shapes, whereas
		the Rectangle returned by the `getRect()` method does not. For
		an example, see the description of the `getRect()` method.

		@param targetCoordinateSpace The display object that defines the
									 coordinate system to use.
		@return The rectangle that defines the area of the display object relative
				to the `targetCoordinateSpace` object's coordinate
				system.
	**/
	public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
	{
		var matrix = Matrix.__pool.get();

		if (targetCoordinateSpace != null && targetCoordinateSpace != this)
		{
			matrix.copyFrom(__getWorldTransform());

			var targetMatrix = Matrix.__pool.get();

			targetMatrix.copyFrom(targetCoordinateSpace.__getWorldTransform());
			targetMatrix.invert();

			matrix.concat(targetMatrix);

			Matrix.__pool.release(targetMatrix);
		}
		else
		{
			matrix.identity();
		}

		var bounds = new Rectangle();
		__getBounds(bounds, matrix);

		Matrix.__pool.release(matrix);

		return bounds;
	}

	/**
		Returns a rectangle that defines the boundary of the display object, based
		on the coordinate system defined by the `targetCoordinateSpace`
		parameter, excluding any strokes on shapes. The values that the
		`getRect()` method returns are the same or smaller than those
		returned by the `getBounds()` method.

		**Note:** Use `localToGlobal()` and
		`globalToLocal()` methods to convert the display object's local
		coordinates to Stage coordinates, or Stage coordinates to local
		coordinates, respectively.

		@param targetCoordinateSpace The display object that defines the
									 coordinate system to use.
		@return The rectangle that defines the area of the display object relative
				to the `targetCoordinateSpace` object's coordinate
				system.
	**/
	public function getRect(targetCoordinateSpace:DisplayObject):Rectangle
	{
		// should not account for stroke widths, but is that possible?
		return getBounds(targetCoordinateSpace);
	}

	/**
		Converts the `point` object from the Stage(global) coordinates
		to the display object's(local) coordinates.

		To use this method, first create an instance of the Point class. The
		_x_ and _y_ values that you assign represent global coordinates
		because they relate to the origin(0,0) of the main display area. Then
		pass the Point instance as the parameter to the
		`globalToLocal()` method. The method returns a new Point object
		with _x_ and _y_ values that relate to the origin of the display
		object instead of the origin of the Stage.

		@param point An object created with the Point class. The Point object
					 specifies the _x_ and _y_ coordinates as
					 properties.
		@return A Point object with coordinates relative to the display object.
	**/
	public function globalToLocal(pos:Point):Point
	{
		return __globalToLocal(pos, new Point());
	}

	// @:noCompletion @:dox(hide) @:require(flash10) public function globalToLocal3D (point:Point):Vector3D;

	/**
		Evaluates the bounding box of the display object to see if it overlaps or
		intersects with the bounding box of the `obj` display object.

		@param obj The display object to test against.
		@return `true` if the bounding boxes of the display objects
				intersect; `false` if not.
	**/
	public function hitTestObject(obj:DisplayObject):Bool
	{
		if (obj != null && obj.parent != null && parent != null)
		{
			var currentBounds = getBounds(this);
			var targetBounds = obj.getBounds(this);

			return currentBounds.intersects(targetBounds);
		}

		return false;
	}

	/**
		Evaluates the display object to see if it overlaps or intersects with the
		point specified by the `x` and `y` parameters. The
		`x` and `y` parameters specify a point in the
		coordinate space of the Stage, not the display object container that
		contains the display object(unless that display object container is the
		Stage).

		@param x         The _x_ coordinate to test against this object.
		@param y         The _y_ coordinate to test against this object.
		@param shapeFlag Whether to check against the actual pixels of the object
						(`true`) or the bounding box
						(`false`).
		@return `true` if the display object overlaps or intersects
				with the specified point; `false` otherwise.
	**/
	public function hitTestPoint(x:Float, y:Float, shapeFlag:Bool = false):Bool
	{
		if (stage != null)
		{
			return __hitTest(x, y, shapeFlag, null, false, this);
		}
		else
		{
			return false;
		}
	}

	/**
		Calling the `invalidate()` method signals to have the current object
		redrawn the next time the object is eligible to be rendered.
	**/
	public function invalidate():Void
	{
		__setRenderDirty();
	}

	/**
		Converts the `point` object from the display object's(local)
		coordinates to the Stage(global) coordinates.

		This method allows you to convert any given _x_ and _y_
		coordinates from values that are relative to the origin(0,0) of a
		specific display object(local coordinates) to values that are relative to
		the origin of the Stage(global coordinates).

		To use this method, first create an instance of the Point class. The
		_x_ and _y_ values that you assign represent local coordinates
		because they relate to the origin of the display object.

		You then pass the Point instance that you created as the parameter to
		the `localToGlobal()` method. The method returns a new Point
		object with _x_ and _y_ values that relate to the origin of the
		Stage instead of the origin of the display object.

		@param point The name or identifier of a point created with the Point
					 class, specifying the _x_ and _y_ coordinates as
					 properties.
		@return A Point object with coordinates relative to the Stage.
	**/
	public function localToGlobal(point:Point):Point
	{
		return __getRenderTransform().transformPoint(point);
	}

	// @:noCompletion @:dox(hide) @:require(flash10) public function local3DToGlobal (point3d:Vector3D):Point;

	@SuppressWarnings("checkstyle:Dynamic")
	public override function removeEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false):Void
	{
		super.removeEventListener(type, listener, useCapture);

		switch (type)
		{
			case Event.ACTIVATE, Event.DEACTIVATE, Event.ENTER_FRAME, Event.EXIT_FRAME, Event.FRAME_CONSTRUCTED, Event.RENDER:
				if (!hasEventListener(type))
				{
					if (__broadcastEvents.exists(type))
					{
						__broadcastEvents.get(type).remove(this);
					}
				}

			case RenderEvent.CLEAR_DOM, RenderEvent.RENDER_CAIRO, RenderEvent.RENDER_CANVAS, RenderEvent.RENDER_DOM, RenderEvent.RENDER_OPENGL:
				if (!hasEventListener(RenderEvent.CLEAR_DOM)
					&& !hasEventListener(RenderEvent.RENDER_CAIRO)
					&& !hasEventListener(RenderEvent.RENDER_CANVAS)
					&& !hasEventListener(RenderEvent.RENDER_DOM)
					&& !hasEventListener(RenderEvent.RENDER_OPENGL))
				{
					__customRenderEvent = null;
				}

			default:
		}
	}

	@:noCompletion private static inline function __calculateAbsoluteTransform(local:Matrix, parentTransform:Matrix, target:Matrix):Void
	{
		target.a = local.a * parentTransform.a + local.b * parentTransform.c;
		target.b = local.a * parentTransform.b + local.b * parentTransform.d;
		target.c = local.c * parentTransform.a + local.d * parentTransform.c;
		target.d = local.c * parentTransform.b + local.d * parentTransform.d;
		target.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
		target.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
	}

	@:noCompletion private function __cleanup():Void
	{
		__cairo = null;

		#if (js && html5)
		__canvas = null;
		__context = null;
		#end

		if (__graphics != null)
		{
			__graphics.__cleanup();
		}

		if (__cacheBitmap != null)
		{
			__cacheBitmap.__cleanup();
			__cacheBitmap = null;
		}

		if (__cacheBitmapData != null)
		{
			__cacheBitmapData.dispose();
			__cacheBitmapData = null;
		}
	}

	@:noCompletion private function __dispatch(event:Event):Bool
	{
		if (__eventMap != null && hasEventListener(event.type))
		{
			var result = super.__dispatchEvent(event);

			if (event.__isCanceled)
			{
				return true;
			}

			return result;
		}

		return true;
	}

	@:noCompletion private function __dispatchChildren(event:Event):Void {}

	@:noCompletion private override function __dispatchEvent(event:Event):Bool
	{
		var parent = event.bubbles ? this.parent : null;
		var result = super.__dispatchEvent(event);

		if (event.__isCanceled)
		{
			return true;
		}

		if (parent != null && parent != this)
		{
			event.eventPhase = EventPhase.BUBBLING_PHASE;

			if (event.target == null)
			{
				event.target = this;
			}

			parent.__dispatchEvent(event);
		}

		return result;
	}

	@:noCompletion private function __dispatchWithCapture(event:Event):Bool
	{
		if (event.target == null)
		{
			event.target = this;
		}

		if (parent != null)
		{
			event.eventPhase = CAPTURING_PHASE;

			if (parent == stage)
			{
				parent.__dispatch(event);
			}
			else
			{
				var stack = __tempStack.get();
				var parent = parent;
				var i = 0;

				while (parent != null)
				{
					stack[i] = parent;
					parent = parent.parent;
					i++;
				}

				for (j in 0...i)
				{
					stack[i - j - 1].__dispatch(event);
				}

				__tempStack.release(stack);
			}
		}

		event.eventPhase = AT_TARGET;

		return __dispatchEvent(event);
	}

	@:noCompletion private function __enterFrame(deltaTime:Int):Void {}

	@:noCompletion private function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		if (__graphics != null)
		{
			__graphics.__getBounds(rect, matrix);
		}
	}

	@:noCompletion private function __getCursor():MouseCursor
	{
		return null;
	}

	@:noCompletion private function __getFilterBounds(rect:Rectangle, matrix:Matrix):Void
	{
		__getRenderBounds(rect, matrix);

		if (__filters != null)
		{
			var extension = Rectangle.__pool.get();

			for (filter in __filters)
			{
				extension.__expand(-filter.__leftExtension,
					-filter.__topExtension, filter.__leftExtension
					+ filter.__rightExtension,
					filter.__topExtension
					+ filter.__bottomExtension);
			}

			rect.width += extension.width;
			rect.height += extension.height;
			rect.x += extension.x;
			rect.y += extension.y;

			Rectangle.__pool.release(extension);
		}
	}

	@:noCompletion private function __getInteractive(stack:Array<DisplayObject>):Bool
	{
		return false;
	}

	@:noCompletion private function __getLocalBounds(rect:Rectangle):Void
	{
		// var cacheX = __transform.tx;
		// var cacheY = __transform.ty;
		// __transform.tx = __transform.ty = 0;

		__getBounds(rect, __transform);

		// __transform.tx = cacheX;
		// __transform.ty = cacheY;

		rect.x -= __transform.tx;
		rect.y -= __transform.ty;
	}

	@:noCompletion private function __getRenderBounds(rect:Rectangle, matrix:Matrix):Void
	{
		if (__scrollRect == null)
		{
			__getBounds(rect, matrix);
		}
		else
		{
			// TODO: Should we have smaller bounds if scrollRect is larger than content?

			var r = Rectangle.__pool.get();
			r.copyFrom(__scrollRect);
			r.__transform(r, matrix);
			rect.__expand(r.x, r.y, r.width, r.height);
			Rectangle.__pool.release(r);
		}
	}

	@:noCompletion private function __getRenderTransform():Matrix
	{
		__getWorldTransform();
		return __renderTransform;
	}

	@:noCompletion private function __getWorldTransform():Matrix
	{
		var transformDirty = __transformDirty || __worldTransformInvalid;

		if (transformDirty)
		{
			var list = [];
			var current = this;

			if (parent == null)
			{
				__update(true, false);
			}
			else
			{
				while (current != stage)
				{
					list.push(current);
					current = current.parent;

					if (current == null) break;
				}
			}

			var i = list.length;
			while (--i >= 0)
			{
				current = list[i];
				current.__update(true, false);
			}
		}

		return __worldTransform;
	}

	@:noCompletion private function __globalToLocal(global:Point, local:Point):Point
	{
		__getRenderTransform();

		if (global == local)
		{
			__renderTransform.__transformInversePoint(global);
		}
		else
		{
			local.x = __renderTransform.__transformInverseX(global.x, global.y);
			local.y = __renderTransform.__transformInverseY(global.x, global.y);
		}

		return local;
	}

	@:noCompletion private function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool
	{
		if (__graphics != null)
		{
			if (!hitObject.__visible || __isMask) return false;
			if (mask != null && !mask.__hitTestMask(x, y)) return false;

			if (__graphics.__hitTest(x, y, shapeFlag, __getRenderTransform()))
			{
				if (stack != null && !interactiveOnly)
				{
					stack.push(hitObject);
				}

				return true;
			}
		}

		return false;
	}

	@:noCompletion private function __hitTestMask(x:Float, y:Float):Bool
	{
		if (__graphics != null)
		{
			if (__graphics.__hitTest(x, y, true, __getRenderTransform()))
			{
				return true;
			}
		}

		return false;
	}

	@:noCompletion private function __readGraphicsData(graphicsData:Vector<IGraphicsData>, recurse:Bool):Void
	{
		if (__graphics != null)
		{
			__graphics.__readGraphicsData(graphicsData);
		}
	}

	@:noCompletion private function __setParentRenderDirty():Void
	{
		var renderParent = __renderParent != null ? __renderParent : parent;
		if (renderParent != null && !renderParent.__renderDirty)
		{
			renderParent.__renderDirty = true;
			renderParent.__setParentRenderDirty();
		}
	}

	@:noCompletion private inline function __setRenderDirty():Void
	{
		if (!__renderDirty)
		{
			__renderDirty = true;
			__setParentRenderDirty();
		}
	}

	@:noCompletion private function __setStageReference(stage:Stage):Void
	{
		this.stage = stage;
	}

	@:noCompletion private function __setTransformDirty():Void
	{
		if (!__transformDirty)
		{
			__transformDirty = true;

			__setWorldTransformInvalid();
			__setParentRenderDirty();
		}
	}

	@:noCompletion private function __setWorldTransformInvalid():Void
	{
		__worldTransformInvalid = true;
	}

	@:noCompletion private function __stopAllMovieClips():Void {}

	@:noCompletion private function __update(transformOnly:Bool, updateChildren:Bool):Void
	{
		var renderParent = __renderParent != null ? __renderParent : parent;
		if (__isMask && renderParent == null) renderParent = __maskTarget;
		__renderable = (__visible && __scaleX != 0 && __scaleY != 0 && !__isMask && (renderParent == null || !renderParent.__isMask));
		__updateTransforms();

		// if (updateChildren && __transformDirty) {

		__transformDirty = false;

		// }

		__worldTransformInvalid = false;

		if (!transformOnly)
		{
			if (__supportDOM)
			{
				__renderTransformChanged = !__renderTransform.equals(__renderTransformCache);

				if (__renderTransformCache == null)
				{
					__renderTransformCache = __renderTransform.clone();
				}
				else
				{
					__renderTransformCache.copyFrom(__renderTransform);
				}
			}

			if (renderParent != null)
			{
				if (__supportDOM)
				{
					var worldVisible = (renderParent.__worldVisible && __visible);
					__worldVisibleChanged = (__worldVisible != worldVisible);
					__worldVisible = worldVisible;

					var worldAlpha = alpha * renderParent.__worldAlpha;
					__worldAlphaChanged = (__worldAlpha != worldAlpha);
					__worldAlpha = worldAlpha;
				}
				else
				{
					__worldAlpha = alpha * renderParent.__worldAlpha;
				}

				if (__objectTransform != null)
				{
					__worldColorTransform.__copyFrom(__objectTransform.__colorTransform);
					__worldColorTransform.__combine(renderParent.__worldColorTransform);
				}
				else
				{
					__worldColorTransform.__copyFrom(renderParent.__worldColorTransform);
				}

				if (__blendMode == null || __blendMode == NORMAL)
				{
					// TODO: Handle multiple blend modes better
					__worldBlendMode = renderParent.__worldBlendMode;
				}
				else
				{
					__worldBlendMode = __blendMode;
				}

				if (__shader == null)
				{
					__worldShader = renderParent.__shader;
				}
				else
				{
					__worldShader = __shader;
				}

				if (__scale9Grid == null)
				{
					__worldScale9Grid = renderParent.__scale9Grid;
				}
				else
				{
					__worldScale9Grid = __scale9Grid;
				}
			}
			else
			{
				__worldAlpha = alpha;

				if (__supportDOM)
				{
					__worldVisibleChanged = (__worldVisible != __visible);
					__worldVisible = __visible;

					__worldAlphaChanged = (__worldAlpha != alpha);
				}

				if (__objectTransform != null)
				{
					__worldColorTransform.__copyFrom(__objectTransform.__colorTransform);
				}
				else
				{
					__worldColorTransform.__identity();
				}

				__worldBlendMode = __blendMode;
				__worldShader = __shader;
				__worldScale9Grid = __scale9Grid;
			}

			// if (updateChildren && __renderDirty) {

			// __renderDirty = false;

			// }
		}

		if (updateChildren && mask != null)
		{
			mask.__update(transformOnly, true);
		}
	}

	@:noCompletion private function __updateTransforms(overrideTransform:Matrix = null):Void
	{
		var overrided = overrideTransform != null;
		var local = overrided ? overrideTransform : __transform;

		if (__worldTransform == null)
		{
			__worldTransform = new Matrix();
		}

		if (__renderTransform == null)
		{
			__renderTransform = new Matrix();
		}

		var renderParent = __renderParent != null ? __renderParent : parent;

		if (!overrided && parent != null)
		{
			__calculateAbsoluteTransform(local, parent.__worldTransform, __worldTransform);
		}
		else
		{
			__worldTransform.copyFrom(local);
		}

		if (!overrided && renderParent != null)
		{
			__calculateAbsoluteTransform(local, renderParent.__renderTransform, __renderTransform);
		}
		else
		{
			__renderTransform.copyFrom(local);
		}

		if (__scrollRect != null)
		{
			__renderTransform.__translateTransformed(-__scrollRect.x, -__scrollRect.y);
		}
	}

	// Get & Set Methods
	@:keep @:noCompletion private function get_alpha():Float
	{
		return __alpha;
	}

	@:keep @:noCompletion private function set_alpha(value:Float):Float
	{
		if (value > 1.0) value = 1.0;
		if (value < 0.0) value = 0.0;

		if (value != __alpha && !cacheAsBitmap) __setRenderDirty();
		return __alpha = value;
	}

	@:noCompletion private function get_blendMode():BlendMode
	{
		return __blendMode;
	}

	@:noCompletion private function set_blendMode(value:BlendMode):BlendMode
	{
		if (value == null) value = NORMAL;

		if (value != __blendMode) __setRenderDirty();
		return __blendMode = value;
	}

	@:noCompletion private function get_cacheAsBitmap():Bool
	{
		return (__filters == null ? __cacheAsBitmap : true);
	}

	@:noCompletion private function set_cacheAsBitmap(value:Bool):Bool
	{
		if (value != __cacheAsBitmap)
		{
			__setRenderDirty();
		}

		return __cacheAsBitmap = value;
	}

	@:noCompletion private function get_cacheAsBitmapMatrix():Matrix
	{
		return __cacheAsBitmapMatrix;
	}

	@:noCompletion private function set_cacheAsBitmapMatrix(value:Matrix):Matrix
	{
		__setRenderDirty();
		return __cacheAsBitmapMatrix = (value != null ? value.clone() : value);
	}

	@:noCompletion private function get_filters():Array<BitmapFilter>
	{
		if (__filters == null)
		{
			return new Array();
		}
		else
		{
			return __filters.copy();
		}
	}

	@:noCompletion private function set_filters(value:Array<BitmapFilter>):Array<BitmapFilter>
	{
		if (value != null && value.length > 0)
		{
			var clonedFilters:Array<BitmapFilter> = [];
			
			for (filter in value){
				var clonedFilter:BitmapFilter = filter.clone();
				
				clonedFilter.__renderDirty = true;
				clonedFilters.push(clonedFilter);				
			}
			
			__filters = clonedFilters;
			// __updateFilters = true;
			__setRenderDirty();
		}
		else if (__filters != null)
		{
			__filters = null;
			// __updateFilters = false;
			__setRenderDirty();
		}
		
		return value;
	}

	@:keep @:noCompletion private function get_height():Float
	{
		var rect = Rectangle.__pool.get();
		__getLocalBounds(rect);
		var height = rect.height;
		Rectangle.__pool.release(rect);
		return height;
	}

	@:keep @:noCompletion private function set_height(value:Float):Float
	{
		var rect = Rectangle.__pool.get();
		var matrix = Matrix.__pool.get();
		matrix.identity();

		__getBounds(rect, matrix);

		if (value != rect.height)
		{
			scaleY = value / rect.height;
		}
		else
		{
			scaleY = 1;
		}

		Rectangle.__pool.release(rect);
		Matrix.__pool.release(matrix);

		return value;
	}

	@:noCompletion private function get_loaderInfo():LoaderInfo
	{
		if (stage != null)
		{
			return Lib.current.__loaderInfo;
		}

		return null;
	}

	@:noCompletion private function get_mask():DisplayObject
	{
		return __mask;
	}

	@:noCompletion private function set_mask(value:DisplayObject):DisplayObject
	{
		if (value == __mask)
		{
			return value;
		}

		if (value != __mask)
		{
			__setTransformDirty();
			__setRenderDirty();
		}

		if (__mask != null)
		{
			__mask.__isMask = false;
			__mask.__maskTarget = null;
			__mask.__setTransformDirty();
			__mask.__setRenderDirty();
		}

		if (value != null)
		{
			value.__isMask = true;
			value.__maskTarget = this;
			value.__setWorldTransformInvalid();
		}

		if (__cacheBitmap != null && __cacheBitmap.mask != value)
		{
			__cacheBitmap.mask = value;
		}

		return __mask = value;
	}

	@:noCompletion private function get_mouseX():Float
	{
		var mouseX = (stage != null ? stage.__mouseX : Lib.current.stage.__mouseX);
		var mouseY = (stage != null ? stage.__mouseY : Lib.current.stage.__mouseY);

		return __getRenderTransform().__transformInverseX(mouseX, mouseY);
	}

	@:noCompletion private function get_mouseY():Float
	{
		var mouseX = (stage != null ? stage.__mouseX : Lib.current.stage.__mouseX);
		var mouseY = (stage != null ? stage.__mouseY : Lib.current.stage.__mouseY);

		return __getRenderTransform().__transformInverseY(mouseX, mouseY);
	}

	@:noCompletion private function get_name():String
	{
		return __name;
	}

	@:noCompletion private function set_name(value:String):String
	{
		return __name = value;
	}

	@:noCompletion private function get_root():DisplayObject
	{
		if (stage != null)
		{
			return Lib.current;
		}

		return null;
	}

	@:keep @:noCompletion private function get_rotation():Float
	{
		return __rotation;
	}

	@:keep @:noCompletion private function set_rotation(value:Float):Float
	{
		if (value != __rotation)
		{
			__rotation = value;
			var radians = __rotation * (Math.PI / 180);
			__rotationSine = Math.sin(radians);
			__rotationCosine = Math.cos(radians);

			__transform.a = __rotationCosine * __scaleX;
			__transform.b = __rotationSine * __scaleX;
			__transform.c = -__rotationSine * __scaleY;
			__transform.d = __rotationCosine * __scaleY;

			__setTransformDirty();
		}

		return value;
	}

	@:noCompletion private function get_scale9Grid():Rectangle
	{
		if (__scale9Grid == null)
		{
			return null;
		}

		return __scale9Grid.clone();
	}

	@:noCompletion private function set_scale9Grid(value:Rectangle):Rectangle
	{
		if (value == null && __scale9Grid == null) return value;
		if (value != null && __scale9Grid != null && __scale9Grid.equals(value)) return value;

		if (value != null)
		{
			if (__scale9Grid == null) __scale9Grid = new Rectangle();
			__scale9Grid.copyFrom(value);
		}
		else
		{
			__scale9Grid = null;
		}

		__setRenderDirty();

		return value;
	}

	@:keep @:noCompletion private function get_scaleX():Float
	{
		return __scaleX;
	}

	@:keep @:noCompletion private function set_scaleX(value:Float):Float
	{
		if (value != __scaleX)
		{
			__scaleX = value;

			if (__transform.b == 0)
			{
				if (value != __transform.a) __setTransformDirty();
				__transform.a = value;
			}
			else
			{
				var a = __rotationCosine * value;
				var b = __rotationSine * value;

				if (__transform.a != a || __transform.b != b)
				{
					__setTransformDirty();
				}

				__transform.a = a;
				__transform.b = b;
			}
		}

		return value;
	}

	@:keep @:noCompletion private function get_scaleY():Float
	{
		return __scaleY;
	}

	@:keep @:noCompletion private function set_scaleY(value:Float):Float
	{
		if (value != __scaleY)
		{
			__scaleY = value;

			if (__transform.c == 0)
			{
				if (value != __transform.d) __setTransformDirty();
				__transform.d = value;
			}
			else
			{
				var c = -__rotationSine * value;
				var d = __rotationCosine * value;

				if (__transform.d != d || __transform.c != c)
				{
					__setTransformDirty();
				}

				__transform.c = c;
				__transform.d = d;
			}
		}

		return value;
	}

	@:noCompletion private function get_scrollRect():Rectangle
	{
		if (__scrollRect == null)
		{
			return null;
		}

		return __scrollRect.clone();
	}

	@:noCompletion private function set_scrollRect(value:Rectangle):Rectangle
	{
		if (value == null && __scrollRect == null) return value;
		if (value != null && __scrollRect != null && __scrollRect.equals(value)) return value;

		if (value != null)
		{
			if (__scrollRect == null) __scrollRect = new Rectangle();
			__scrollRect.copyFrom(value);
		}
		else
		{
			__scrollRect = null;
		}

		__setTransformDirty();

		if (__supportDOM)
		{
			__setRenderDirty();
		}

		return value;
	}

	@:noCompletion private function get_shader():Shader
	{
		return __shader;
	}

	@:noCompletion private function set_shader(value:Shader):Shader
	{
		__shader = value;
		__setRenderDirty();
		return value;
	}

	@:keep @:noCompletion private function get_transform():Transform
	{
		if (__objectTransform == null)
		{
			__objectTransform = new Transform(this);
		}

		return __objectTransform;
	}

	@:keep @:noCompletion private function set_transform(value:Transform):Transform
	{
		if (value == null)
		{
			throw new TypeError("Parameter transform must be non-null.");
		}

		if (__objectTransform == null)
		{
			__objectTransform = new Transform(this);
		}

		__setTransformDirty();
		__objectTransform.matrix = value.matrix;

		if (!__objectTransform.__colorTransform.__equals(value.__colorTransform, true)
			|| (!cacheAsBitmap && __objectTransform.__colorTransform.alphaMultiplier != value.__colorTransform.alphaMultiplier))
		{
			__objectTransform.__colorTransform.__copyFrom(value.colorTransform);
			__setRenderDirty();
		}

		return __objectTransform;
	}

	@:noCompletion private function get_visible():Bool
	{
		return __visible;
	}

	@:noCompletion private function set_visible(value:Bool):Bool
	{
		if (value != __visible) __setRenderDirty();
		return __visible = value;
	}

	@:keep @:noCompletion private function get_width():Float
	{
		var rect = Rectangle.__pool.get();
		__getLocalBounds(rect);
		var width = rect.width;
		Rectangle.__pool.release(rect);
		return width;
	}

	@:keep @:noCompletion private function set_width(value:Float):Float
	{
		var rect = Rectangle.__pool.get();
		var matrix = Matrix.__pool.get();
		matrix.identity();

		__getBounds(rect, matrix);

		if (value != rect.width)
		{
			scaleX = value / rect.width;
		}
		else
		{
			scaleX = 1;
		}

		Rectangle.__pool.release(rect);
		Matrix.__pool.release(matrix);

		return value;
	}

	@:keep @:noCompletion private function get_x():Float
	{
		return __transform.tx;
	}

	@:keep @:noCompletion private function set_x(value:Float):Float
	{
		if (value != __transform.tx) __setTransformDirty();
		return __transform.tx = value;
	}

	@:keep @:noCompletion private function get_y():Float
	{
		return __transform.ty;
	}

	@:keep @:noCompletion private function set_y(value:Float):Float
	{
		if (value != __transform.ty) __setTransformDirty();
		return __transform.ty = value;
	}
}
#else
typedef DisplayObject = flash.display.DisplayObject;
#end
