import DisplayObjectRenderData from "../_internal/renderer/DisplayObjectRenderData";
import DisplayObjectType from "../_internal/renderer/DisplayObjectType";
import DisplayObjectIterator from "../_internal/utils/DisplayObjectIterator";
import * as internal from "../_internal/utils/InternalAccess";
import ObjectPool from "../_internal/utils/ObjectPool";
import Lib from "../_internal/Lib";
import BlendMode from "../display/BlendMode";
import DisplayObjectContainer from "../display/DisplayObjectContainer";
import Graphics from "../display/Graphics";
import IBitmapDrawable from "../display/IBitmapDrawable";
import IGraphicsData from "../display/IGraphicsData";
import LoaderInfo from "../display/LoaderInfo";
import Shader from "../display/Shader";
import SimpleButton from "../display/SimpleButton";
import Stage from "../display/Stage";
import TypeError from "../errors/TypeError";
import Event from "../events/Event";
import EventDispatcher from "../events/EventDispatcher";
import EventPhase from "../events/EventPhase";
import EventType from "../events/EventType";
import MouseEvent from "../events/MouseEvent";
import RenderEvent from "../events/RenderEvent";
import TouchEvent from "../events/TouchEvent";
import BitmapFilter from "../filters/BitmapFilter";
import ColorTransform from "../geom/ColorTransform";
import Matrix from "../geom/Matrix";
import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";
import Transform from "../geom/Transform";
import MouseCursor from "../ui/MouseCursor";
import Vector from "../Vector";

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
export default class DisplayObject extends EventDispatcher implements IBitmapDrawable
{
	private static __broadcastEvents: Map<string, Array<DisplayObject>> = new Map();
	private static __initStage: Stage;
	private static __instanceCount: number = 0;
	private static __supportDOM: boolean;
	private static __tempStack: ObjectPool<Vector<DisplayObject>> = new ObjectPool<Vector<DisplayObject>>(() =>
		new Vector<DisplayObject>(), (stack) => stack.length = 0);

	/**
		The current accessibility options for this display object. If you modify the `accessibilityProperties`
		property or any of the fields within `accessibilityProperties`, you must call the
		`Accessibility.updateProperties()` method to make your changes take effect.

		**Note:** For an object created in the Flash authoring environment, the value of `accessibilityProperties`
		is prepopulated with any information you entered in the Accessibility panel for that object.
	**/
	// /** @hidden */ @:dox(hide) public accessibilityProperties:openfl.accessibility.AccessibilityProperties;

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
	// /** @hidden */ @:dox(hide) @:require(flash10) public blendShader(null, default):Shader;

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
	public opaqueBackground?: number;

	/**
		Indicates the x-axis rotation of the DisplayObject instance, in degrees, from its original orientation
		relative to the 3D parent container. Values from 0 to 180 represent clockwise rotation; values from 0 to
		-180 represent counterclockwise rotation. Values outside this range are added to or subtracted from 360 to
		obtain a value within the range.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10) public rotationX:Float;

	/**
		Indicates the y-axis rotation of the DisplayObject instance, in degrees, from its original orientation
		relative to the 3D parent container. Values from 0 to 180 represent clockwise rotation; values from 0 to
		-180 represent counterclockwise rotation. Values outside this range are added to or subtracted from 360 to
		obtain a value within the range.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10) public rotationY:Float;

	/**
		Indicates the z-axis rotation of the DisplayObject instance, in degrees, from its original orientation
		relative to the 3D parent container. Values from 0 to 180 represent clockwise rotation; values from 0 to
		-180 represent counterclockwise rotation. Values outside this range are added to or subtracted from 360 to
		obtain a value within the range.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10) public rotationZ:Float;

	/**
		Indicates the depth scale (percentage) of an object as applied from the registration point of the object.
		The default registration point is (0,0). 1.0 is 100% scale.

		Scaling the local coordinate system changes the `x`, `y` and `z` property values, which are defined in whole
		pixels.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10) public scaleZ:Float;

	protected static __childIterators: ObjectPool<DisplayObjectIterator> = new ObjectPool<DisplayObjectIterator>(() => new DisplayObjectIterator());

	// /** @hidden */ @:dox(hide) @:require(flash10) z:Float;
	protected __alpha: number;
	protected __blendMode: BlendMode;
	protected __cacheAsBitmap: boolean;
	protected __cacheAsBitmapMatrix: Matrix;
	protected __childTransformDirty: boolean;
	protected __customRenderClear: boolean;
	protected __customRenderEvent: RenderEvent;
	protected __filters: Array<BitmapFilter>;
	protected __firstChild: DisplayObject;
	protected __graphics: Graphics;
	protected __interactive: boolean;
	protected __isMask: boolean;
	protected __lastChild: DisplayObject;
	protected __loaderInfo: LoaderInfo;
	protected __localBounds: Rectangle;
	protected __localBoundsDirty: boolean;
	protected __mask: DisplayObject;
	protected __maskTarget: DisplayObject;
	protected __name: string;
	protected __nextSibling: DisplayObject;
	protected __objectTransform: Transform;
	protected __parent: DisplayObjectContainer;
	protected __previousSibling: DisplayObject;
	protected __renderable: boolean;
	protected __renderData: DisplayObjectRenderData;
	protected __renderDirty: boolean;
	protected __renderParent: DisplayObject;
	protected __renderTransform: Matrix;
	protected __renderTransformCache: Matrix;
	protected __renderTransformChanged: boolean;
	protected __rotation: number;
	protected __rotationCosine: number;
	protected __rotationSine: number;
	protected __scale9Grid: Rectangle;
	protected __scaleX: number;
	protected __scaleY: number;
	protected __scrollRect: Rectangle;
	protected __shader: Shader;
	protected __stage: Stage;
	protected __tempPoint: Point;
	protected __transform: Matrix;
	protected __transformDirty: boolean;
	protected __type: DisplayObjectType;
	protected __visible: boolean;
	protected __worldAlpha: number;
	protected __worldAlphaChanged: boolean;
	protected __worldBlendMode: BlendMode;
	protected __worldClip: Rectangle;
	protected __worldClipChanged: boolean;
	protected __worldColorTransform: ColorTransform;
	protected __worldShader: Shader;
	protected __worldScale9Grid: Rectangle;
	protected __worldTransform: Matrix;
	protected __worldVisible: boolean;
	protected __worldVisibleChanged: boolean;
	protected __worldZ: number;

	protected constructor()
	{
		super();

		this.__type = DisplayObjectType.DISPLAY_OBJECT;

		this.__alpha = 1;
		this.__blendMode = BlendMode.NORMAL;
		this.__cacheAsBitmap = false;
		this.__transform = new Matrix();
		this.__visible = true;

		this.__rotation = 0;
		this.__rotationSine = 0;
		this.__rotationCosine = 1;
		this.__scaleX = 1;
		this.__scaleY = 1;

		this.__worldAlpha = 1;
		this.__worldBlendMode = BlendMode.NORMAL;
		this.__worldTransform = new Matrix();
		this.__worldColorTransform = new ColorTransform();
		this.__renderTransform = new Matrix();
		this.__worldVisible = true;
		this.__transformDirty = true;

		this.__renderData = new DisplayObjectRenderData();

		this.name = "instance" + (++DisplayObject.__instanceCount);

		if (DisplayObject.__initStage != null)
		{
			this.__stage = DisplayObject.__initStage;
			DisplayObject.__initStage = null;
			this.stage.addChild(this);
		}
	}

	public addEventListener<T>(type: EventType<T>, listener: (event: T) => void, useCapture: boolean = false, priority: number = 0,
		useWeakReference: boolean = false): void
	{
		switch (type)
		{
			case Event.ACTIVATE:
			case Event.DEACTIVATE:
			case Event.ENTER_FRAME:
			case Event.EXIT_FRAME:
			case Event.FRAME_CONSTRUCTED:
			case Event.RENDER:
				if (!DisplayObject.__broadcastEvents.has(type))
				{
					DisplayObject.__broadcastEvents.set(type, []);
				}

				var dispatchers = DisplayObject.__broadcastEvents.get(type);

				if (dispatchers.indexOf(this) == -1)
				{
					dispatchers.push(this);
				}
				break;

			case RenderEvent.CLEAR_DOM:
			case RenderEvent.RENDER_CAIRO:
			case RenderEvent.RENDER_CANVAS:
			case RenderEvent.RENDER_DOM:
			case RenderEvent.RENDER_OPENGL:
				if (this.__customRenderEvent == null)
				{
					this.__customRenderEvent = new RenderEvent(null);
					this.__customRenderEvent.objectColorTransform = new ColorTransform();
					this.__customRenderEvent.objectMatrix = new Matrix();
					this.__customRenderClear = true;
				}
				break;

			default:
		}

		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	public dispatchEvent(event: Event): boolean
	{
		if (event instanceof MouseEvent)
		{
			var mouseEvent: MouseEvent = event as MouseEvent;
			mouseEvent.stageX = (<internal.Matrix><any>this.__getRenderTransform()).__transformX(mouseEvent.localX, mouseEvent.localY);
			mouseEvent.stageY = (<internal.Matrix><any>this.__getRenderTransform()).__transformY(mouseEvent.localX, mouseEvent.localY);
		}
		else if (event instanceof TouchEvent)
		{
			var touchEvent: TouchEvent = event as TouchEvent;
			touchEvent.stageX = (<internal.Matrix><any>this.__getRenderTransform()).__transformX(touchEvent.localX, touchEvent.localY);
			touchEvent.stageY = (<internal.Matrix><any>this.__getRenderTransform()).__transformY(touchEvent.localX, touchEvent.localY);
		}

		(<internal.Event><any>event).__target = this;

		return this.__dispatchWithCapture(event);
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
	public getBounds(targetCoordinateSpace: DisplayObject): Rectangle
	{
		var matrix = (<internal.Matrix><any>Matrix).__pool.get();

		if (targetCoordinateSpace != null && targetCoordinateSpace != this)
		{
			matrix.copyFrom(this.__getWorldTransform());

			var targetMatrix = (<internal.Matrix><any>Matrix).__pool.get();

			targetMatrix.copyFrom(targetCoordinateSpace.__getWorldTransform());
			targetMatrix.invert();

			matrix.concat(targetMatrix);

			(<internal.Matrix><any>Matrix).__pool.release(targetMatrix);
		}
		else
		{
			matrix.identity();
		}

		var bounds = new Rectangle();
		this.__getBounds(bounds, matrix);

		(<internal.Matrix><any>Matrix).__pool.release(matrix);

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
	public getRect(targetCoordinateSpace: DisplayObject): Rectangle
	{
		// should not account for stroke widths, but is that possible?
		return this.getBounds(targetCoordinateSpace);
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
	public globalToLocal(pos: Point): Point
	{
		return this.__globalToLocal(pos, new Point());
	}

	// /** @hidden */ @:dox(hide) @:require(flash10) public globalToLocal3D (point:Point):Vector3D;

	/**
		Evaluates the bounding box of the display object to see if it overlaps or
		intersects with the bounding box of the `obj` display object.

		@param obj The display object to test against.
		@return `true` if the bounding boxes of the display objects
				intersect; `false` if not.
	**/
	public hitTestObject(obj: DisplayObject): boolean
	{
		if (obj != null && obj.parent != null && parent != null)
		{
			var currentBounds = this.getBounds(this);
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
	public hitTestPoint(x: number, y: number, shapeFlag: boolean = false): boolean
	{
		if (this.stage != null)
		{
			return this.__hitTest(x, y, shapeFlag, null, false, this);
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
	public invalidate(): void
	{
		this.__setRenderDirty();
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
	public localToGlobal(point: Point): Point
	{
		return this.__getRenderTransform().transformPoint(point);
	}

	// /** @hidden */ @:dox(hide) @:require(flash10) public local3DToGlobal (point3d:Vector3D):Point;

	public removeEventListener<T>(type: EventType<T>, listener: (event: T) => void, useCapture: boolean = false): void
	{
		super.removeEventListener(type, listener, useCapture);

		switch (type)
		{
			case Event.ACTIVATE:
			case Event.DEACTIVATE:
			case Event.ENTER_FRAME:
			case Event.EXIT_FRAME:
			case Event.FRAME_CONSTRUCTED:
			case Event.RENDER:
				if (!this.hasEventListener(type))
				{
					if (DisplayObject.__broadcastEvents.has(type))
					{
						var list = DisplayObject.__broadcastEvents.get(type);
						var index = list.indexOf(this);
						if (index > -1) list.splice(index, 1);
					}
				}
				break;

			case RenderEvent.CLEAR_DOM:
			case RenderEvent.RENDER_CAIRO:
			case RenderEvent.RENDER_CANVAS:
			case RenderEvent.RENDER_DOM:
			case RenderEvent.RENDER_OPENGL:
				if (!this.hasEventListener(RenderEvent.CLEAR_DOM)
					&& !this.hasEventListener(RenderEvent.RENDER_CAIRO)
					&& !this.hasEventListener(RenderEvent.RENDER_CANVAS)
					&& !this.hasEventListener(RenderEvent.RENDER_DOM)
					&& !this.hasEventListener(RenderEvent.RENDER_OPENGL))
				{
					this.__customRenderEvent = null;
				}
				break;

			default:
		}
	}

	protected __childIterator(childrenOnly: boolean = true): DisplayObjectIterator
	{
		var iterator = DisplayObject.__childIterators.get();
		iterator.init(this, childrenOnly);
		return iterator;
	}

	protected static __calculateAbsoluteTransform(local: Matrix, parentTransform: Matrix, target: Matrix): void
	{
		target.a = local.a * parentTransform.a + local.b * parentTransform.c;
		target.b = local.a * parentTransform.b + local.b * parentTransform.d;
		target.c = local.c * parentTransform.a + local.d * parentTransform.c;
		target.d = local.c * parentTransform.b + local.d * parentTransform.d;
		target.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
		target.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
	}

	protected __cleanup(): void
	{
		for (let child of this.__childIterator(false))
		{
			child.__renderData.dispose();

			if (child.__graphics != null)
			{
				(<internal.Graphics><any>child.__graphics).__cleanup();
			}

			switch (child.__type)
			{
				case DisplayObjectType.DISPLAY_OBJECT_CONTAINER:
				case DisplayObjectType.MOVIE_CLIP:
					var displayObjectContainer: DisplayObjectContainer = child as DisplayObjectContainer;
					(<internal.DisplayObjectContainer><any>displayObjectContainer).__cleanupRemovedChildren();
					break;
				default:
			}
		}
	}

	protected __dispatch(event: Event): boolean
	{
		if (this.__eventMap != null && this.hasEventListener(event.type))
		{
			var result = super.__dispatchEvent(event);

			if ((<internal.Event><any>event).__isCanceled)
			{
				return true;
			}

			return result;
		}

		return true;
	}

	protected __dispatchChildren(event: Event): void
	{
		if (this.__type != null)
		{
			switch (this.__type)
			{
				case DisplayObjectType.DISPLAY_OBJECT_CONTAINER:
				case DisplayObjectType.MOVIE_CLIP:
					var displayObjectContainer: DisplayObjectContainer = <any>this as DisplayObjectContainer;
					if (displayObjectContainer.numChildren > 0)
					{
						for (let child of this.__childIterator())
						{
							(<internal.Event><any>event).__target = child;

							if (!child.__dispatchWithCapture(event))
							{
								break;
							}
						}
					}
				default:
			}
		}
	}

	protected __dispatchEvent(event: Event): boolean
	{
		var parent: DisplayObject = event.bubbles ? this.parent : null;
		var result = super.__dispatchEvent(event);

		if ((<internal.Event><any>event).__isCanceled)
		{
			return true;
		}

		if (parent != null && parent != this)
		{
			(<internal.Event><any>event).__eventPhase = EventPhase.BUBBLING_PHASE;

			if ((<internal.Event><any>event).__target == null)
			{
				(<internal.Event><any>event).__target = this;
			}

			parent.__dispatchEvent(event);
		}

		return result;
	}

	protected __dispatchWithCapture(event: Event): boolean
	{
		if ((<internal.Event><any>event).__target == null)
		{
			(<internal.Event><any>event).__target = this;
		}

		if (parent != null)
		{
			(<internal.Event><any>event).__eventPhase = EventPhase.CAPTURING_PHASE;

			if (parent == this.stage)
			{
				parent.__dispatch(event);
			}
			else
			{
				var stack = DisplayObject.__tempStack.get();
				var parent = parent;
				var i = 0;

				while (parent != null)
				{
					stack[i] = parent;
					parent = parent.parent;
					i++;
				}

				for (let j = 0; j < i; j++)
				{
					stack[i - j - 1].__dispatch(event);
				}

				DisplayObject.__tempStack.release(stack);
			}
		}

		(<internal.Event><any>event).__eventPhase = EventPhase.AT_TARGET;

		return this.__dispatchEvent(event);
	}

	protected __getBounds(rect: Rectangle, matrix: Matrix): void
	{
		if (this.__graphics != null)
		{
			(<internal.Graphics><any>this.__graphics).__getBounds(rect, matrix);
		}
	}

	protected __getCursor(): MouseCursor
	{
		return null;
	}

	protected __getFilterBounds(rect: Rectangle, matrix: Matrix): void
	{
		this.__getRenderBounds(rect, matrix);

		if (this.__filters != null)
		{
			var extension = (<internal.Rectangle><any>Rectangle).__pool.get();

			for (let filter of this.__filters)
			{
				(<internal.Rectangle><any>extension).__expand(-(<internal.BitmapFilter><any>filter).__leftExtension,
					-(<internal.BitmapFilter><any>filter).__topExtension, (<internal.BitmapFilter><any>filter).__leftExtension
				+ (<internal.BitmapFilter><any>filter).__rightExtension,
					(<internal.BitmapFilter><any>filter).__topExtension
					+ (<internal.BitmapFilter><any>filter).__bottomExtension);
			}

			rect.width += extension.width;
			rect.height += extension.height;
			rect.x += extension.x;
			rect.y += extension.y;

			(<internal.Rectangle><any>Rectangle).__pool.release(extension);
		}
	}

	protected __getInteractive(stack: Array<DisplayObject>): boolean
	{
		return false;
	}

	protected __getLocalBounds(): Rectangle
	{
		if (this.__localBounds == null)
		{
			this.__localBounds = new Rectangle();
			this.__localBoundsDirty = true;
		}

		if (this.__localBoundsDirty)
		{
			this.__localBounds.x = 0;
			this.__localBounds.y = 0;
			this.__localBounds.width = 0;
			this.__localBounds.height = 0;

			this.__getBounds(this.__localBounds, this.__transform);

			this.__localBounds.x -= this.__transform.tx;
			this.__localBounds.y -= this.__transform.ty;
			this.__localBoundsDirty = false;
		}

		return this.__localBounds;
	}

	protected __getRenderBounds(rect: Rectangle, matrix: Matrix): void
	{
		if (this.__scrollRect == null)
		{
			this.__getBounds(rect, matrix);
		}
		else
		{
			// TODO: Should we have smaller bounds if scrollRect is larger than content?

			var r = (<internal.Rectangle><any>Rectangle).__pool.get();
			r.copyFrom(this.__scrollRect);
			(<internal.Rectangle><any>r).__transform(r, matrix);
			(<internal.Rectangle><any>rect).__expand(r.x, r.y, r.width, r.height);
			(<internal.Rectangle><any>Rectangle).__pool.release(r);
		}
	}

	protected __getRenderTransform(): Matrix
	{
		this.__getWorldTransform();
		return this.__renderTransform;
	}

	protected __getWorldTransform(): Matrix
	{
		if (this.__transformDirty)
		{
			var renderParent = this.__renderParent != null ? this.__renderParent : parent;
			if (this.__isMask && renderParent == null) renderParent = this.__maskTarget;

			if (parent == null || (!(<internal.DisplayObject><any>parent).__transformDirty && !(<internal.DisplayObject><any>renderParent).__transformDirty))
			{
				this.__update(true, false);
			}
			else
			{
				var list = [];
				var current: DisplayObject = this;

				while (current != this.stage && current.__transformDirty)
				{
					list.push(current);
					current = current.parent;

					if (current == null) break;
				}

				var i = list.length;
				while (--i >= 0)
				{
					current = list[i];
					current.__update(true, false);
				}
			}
		}

		return this.__worldTransform;
	}

	protected __globalToLocal(global: Point, local: Point): Point
	{
		this.__getRenderTransform();

		if (global == local)
		{
			(<internal.Matrix><any>this.__renderTransform).__transformInversePoint(global);
		}
		else
		{
			local.x = (<internal.Matrix><any>this.__renderTransform).__transformInverseX(global.x, global.y);
			local.y = (<internal.Matrix><any>this.__renderTransform).__transformInverseY(global.x, global.y);
		}

		return local;
	}

	protected __hitTest(x: number, y: number, shapeFlag: boolean, stack: Array<DisplayObject>, interactiveOnly: boolean, hitObject: DisplayObject): boolean
	{
		var hitTest = false;

		if (this.__graphics != null)
		{
			if (!hitObject.__visible || this.__isMask || (this.mask != null && !this.mask.__hitTestMask(x, y)))
			{
				hitTest = false;
			}
			else if ((<internal.Graphics><any>this.__graphics).__hitTest(x, y, shapeFlag, this.__getRenderTransform()))
			{
				if (stack != null && !interactiveOnly)
				{
					stack.push(hitObject);
				}

				hitTest = true;
			}
		}

		return hitTest;
	}

	protected __hitTestMask(x: number, y: number): boolean
	{
		return (this.__graphics != null && (<internal.Graphics><any>this.__graphics).__hitTest(x, y, true, this.__getRenderTransform()));
	}

	protected __readGraphicsData(graphicsData: Vector<IGraphicsData>, recurse: boolean): void
	{
		if (this.__graphics != null)
		{
			(<internal.Graphics><any>this.__graphics).__readGraphicsData(graphicsData);
		}
	}

	protected __setParentRenderDirty(): void
	{
		var renderParent = this.__renderParent != null ? this.__renderParent : parent;
		if (renderParent != null && !(<internal.DisplayObject><any>renderParent).__renderDirty)
		{
			// TODO: Use separate method? Based on transform, not render change
			(<internal.DisplayObject><any>renderParent).__localBoundsDirty = true;

			(<internal.DisplayObject><any>renderParent).__renderDirty = true;
			(<internal.DisplayObject><any>renderParent).__setParentRenderDirty();
		}
	}

	protected __setRenderDirty(): void
	{
		if (!this.__renderDirty)
		{
			this.__renderDirty = true;
			this.__setParentRenderDirty();
		}
	}

	protected __setStageReferences(stage: Stage): void
	{
		this.__stage = stage;

		if (this.__firstChild != null)
		{
			for (let child of this.__childIterator())
			{
				child.__stage = stage;
				if (child.__type == DisplayObjectType.SIMPLE_BUTTON)
				{
					var button: SimpleButton = child as SimpleButton;
					if ((<internal.SimpleButton><any>button).__currentState != null)
					{
						(<internal.SimpleButton><any>button).__currentState.__setStageReferences(stage);
					}
					if (button.hitTestState != null && button.hitTestState != (<internal.SimpleButton><any>button).__currentState)
					{
						button.hitTestState.__setStageReferences(stage);
					}
				}
			}
		}
	}

	protected __setTransformDirty(force: boolean = false): void
	{
		this.__transformDirty = true;
	}

	protected __stopAllMovieClips(): void { }

	protected __update(transformOnly: boolean, updateChildren: boolean): void
	{
		this.__updateSingle(transformOnly, updateChildren);
	}

	protected __updateSingle(transformOnly: boolean, updateChildren: boolean): void
	{
		var renderParent = this.__renderParent != null ? this.__renderParent : parent;
		if (this.__isMask && renderParent == null) renderParent = this.__maskTarget;
		this.__renderable = (this.__visible && this.__scaleX != 0 && this.__scaleY != 0 && !this.__isMask && (renderParent == null || !(<internal.DisplayObject><any>renderParent).__isMask));

		if (this.__transformDirty)
		{
			if (this.__worldTransform == null)
			{
				this.__worldTransform = new Matrix();
			}

			if (this.__renderTransform == null)
			{
				this.__renderTransform = new Matrix();
			}

			if (parent != null)
			{
				DisplayObject.__calculateAbsoluteTransform(this.__transform, (<internal.DisplayObject><any>parent).__worldTransform, this.__worldTransform);
			}
			else
			{
				this.__worldTransform.copyFrom(this.__transform);
			}

			if (renderParent != null)
			{
				DisplayObject.__calculateAbsoluteTransform(this.__transform, (<internal.DisplayObject><any>renderParent).__renderTransform, this.__renderTransform);
			}
			else
			{
				this.__renderTransform.copyFrom(this.__transform);
			}

			if (this.__scrollRect != null)
			{
				(<internal.Matrix><any>this.__renderTransform).__translateTransformed(-this.__scrollRect.x, -this.__scrollRect.y);
			}

			this.__transformDirty = false;
		}

		if (!transformOnly)
		{
			if (DisplayObject.__supportDOM)
			{
				this.__renderTransformChanged = !this.__renderTransform.equals(this.__renderTransformCache);

				if (this.__renderTransformCache == null)
				{
					this.__renderTransformCache = this.__renderTransform.clone();
				}
				else
				{
					this.__renderTransformCache.copyFrom(this.__renderTransform);
				}
			}

			if (renderParent != null)
			{
				if (DisplayObject.__supportDOM)
				{
					var worldVisible = ((<internal.DisplayObject><any>renderParent).__worldVisible && this.__visible);
					this.__worldVisibleChanged = (this.__worldVisible != worldVisible);
					this.__worldVisible = worldVisible;

					var worldAlpha = this.alpha * (<internal.DisplayObject><any>renderParent).__worldAlpha;
					this.__worldAlphaChanged = (this.__worldAlpha != worldAlpha);
					this.__worldAlpha = worldAlpha;
				}
				else
				{
					this.__worldAlpha = this.alpha * (<internal.DisplayObject><any>renderParent).__worldAlpha;
				}

				if (this.__objectTransform != null)
				{
					(<internal.ColorTransform><any>this.__worldColorTransform).__copyFrom(this.__objectTransform.colorTransform);
					(<internal.ColorTransform><any>this.__worldColorTransform).__combine((<internal.DisplayObject><any>renderParent).__worldColorTransform);
				}
				else
				{
					(<internal.ColorTransform><any>this.__worldColorTransform).__copyFrom((<internal.DisplayObject><any>renderParent).__worldColorTransform);
				}

				if (this.__blendMode == null || this.__blendMode == BlendMode.NORMAL)
				{
					// TODO: Handle multiple blend modes better
					this.__worldBlendMode = (<internal.DisplayObject><any>renderParent).__worldBlendMode;
				}
				else
				{
					this.__worldBlendMode = this.__blendMode;
				}

				if (this.__shader == null)
				{
					this.__worldShader = (<internal.DisplayObject><any>renderParent).__shader;
				}
				else
				{
					this.__worldShader = this.__shader;
				}

				if (this.__scale9Grid == null)
				{
					this.__worldScale9Grid = (<internal.DisplayObject><any>renderParent).__scale9Grid;
				}
				else
				{
					this.__worldScale9Grid = this.__scale9Grid;
				}
			}
			else
			{
				this.__worldAlpha = this.alpha;

				if (DisplayObject.__supportDOM)
				{
					this.__worldVisibleChanged = (this.__worldVisible != this.__visible);
					this.__worldVisible = this.__visible;

					this.__worldAlphaChanged = (this.__worldAlpha != this.alpha);
				}

				if (this.__objectTransform != null)
				{
					(<internal.ColorTransform><any>this.__worldColorTransform).__copyFrom(this.__objectTransform.colorTransform);
				}
				else
				{
					(<internal.ColorTransform><any>this.__worldColorTransform).__identity();
				}

				this.__worldBlendMode = this.__blendMode;
				this.__worldShader = this.__shader;
				this.__worldScale9Grid = this.__scale9Grid;
			}
		}

		// TODO: Flatten
		if (updateChildren && this.mask != null)
		{
			this.mask.__update(transformOnly, true);
		}
	}

	// Get & Set Methods

	/**
		Indicates the alpha transparency value of the object specified. Valid
		values are 0 (fully transparent) to 1 (fully opaque). The default value is 1.
		Display objects with `alpha` set to 0 _are_ active, even though they are invisible.
	**/
	public get alpha(): number
	{
		return this.__alpha;
	}

	public set alpha(value: number)
	{
		if (value > 1.0) value = 1.0;
		if (value < 0.0) value = 0.0;

		if (value != this.__alpha && !this.cacheAsBitmap) this.__setRenderDirty();
		this.__alpha = value;
	}

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
		| `BlendMode.NORMAL` | ![blend mode NORMAL](/images/blendMode-1.jpg) | The display object appears in front of the background. Pixel values of the display objectthose of the background. Where the display object is transparent, the background is visible. |
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
	public get blendMode(): BlendMode
	{
		return this.__blendMode;
	}

	public set blendMode(value: BlendMode)
	{
		if (value == null) value = BlendMode.NORMAL;

		if (value != this.__blendMode) this.__setRenderDirty();
		this.__blendMode = value;
	}


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
	public get cacheAsBitmap(): boolean
	{
		return (this.__filters == null ? this.__cacheAsBitmap : true);
	}

	public set cacheAsBitmap(value: boolean)
	{
		if (value != this.__cacheAsBitmap)
		{
			this.__setRenderDirty();
		}

		this.__cacheAsBitmap = value;
	}

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
	public get cacheAsBitmapMatrix(): Matrix
	{
		return this.__cacheAsBitmapMatrix;
	}

	public set cacheAsBitmapMatrix(value: Matrix)
	{
		this.__setRenderDirty();
		this.__cacheAsBitmapMatrix = (value != null ? value.clone() : value);
	}

	/**
		An indexed array that contains each filter object currently associated
		with the display object. The openfl.filters namespace contains several
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

		The openfl.filters namespace includes classes for filters. For example, to
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
	public get filters(): Array<BitmapFilter>
	{
		if (this.__filters == null)
		{
			return new Array();
		}
		else
		{
			return this.__filters.slice();
		}
	}

	public set filters(value: Array<BitmapFilter>)
	{
		if (value != null && value.length > 0)
		{
			// TODO: Copy incoming array values

			this.__filters = value;
			// __updateFilters = true;
			this.__setRenderDirty();
		}
		else if (this.__filters != null)
		{
			this.__filters = null;
			// __updateFilters = false;
			this.__setRenderDirty();
		}
	}

	/**
		Indicates the height of the display object, in pixels. The height is
		calculated based on the bounds of the content of the display object. When
		you set the `height` property, the `scaleY` property
		is adjusted accordingly, as shown in the following code:

		Except for TextField and Video objects, a display object with no
		content(such as an empty sprite) has a height of 0, even if you try to
		set `height` to a different value.
	**/
	public get height(): number
	{
		return this.__getLocalBounds().height;
	}

	public set height(value: number)
	{
		var rect = (<internal.Rectangle><any>Rectangle).__pool.get();
		var matrix = (<internal.Matrix><any>Matrix).__pool.get();
		matrix.identity();

		this.__getBounds(rect, matrix);

		if (value != rect.height)
		{
			this.scaleY = value / rect.height;
		}
		else
		{
			this.scaleY = 1;
		}

		(<internal.Rectangle><any>Rectangle).__pool.release(rect);
		(<internal.Matrix><any>Matrix).__pool.release(matrix);
	}

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
	public get loaderInfo(): LoaderInfo
	{
		if (this.stage != null)
		{
			return (<internal.DisplayObject><any>Lib.current).__loaderInfo;
		}

		return null;
	}


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
	public get mask(): DisplayObject
	{
		return this.__mask;
	}

	public set mask(value: DisplayObject)
	{
		if (value == this.__mask)
		{
			return;
		}

		if (value != this.__mask)
		{
			this.__setTransformDirty();
			this.__setParentRenderDirty();
			this.__setRenderDirty();
		}

		if (this.__mask != null)
		{
			this.__mask.__isMask = false;
			this.__mask.__maskTarget = null;
			this.__mask.__setTransformDirty(true);
			this.__mask.__setParentRenderDirty();
			this.__mask.__setRenderDirty();
		}

		if (value != null)
		{
			if (!value.__isMask)
			{
				value.__setParentRenderDirty();
			}

			value.__isMask = true;
			value.__maskTarget = this;
			value.__setTransformDirty(true);
		}

		// TODO: Handle in renderer
		if (this.__renderData.cacheBitmap != null && this.__renderData.cacheBitmap.mask != value)
		{
			this.__renderData.cacheBitmap.mask = value;
		}

		this.__mask = value;
	}

	/**
		Indicates the x coordinate of the mouse or user input device position, in
		pixels.

		**Note**: For a DisplayObject that has been rotated, the returned x
		coordinate will reflect the non-rotated object.
	**/
	public get mouseX(): number
	{
		var mouseX = (this.stage != null ? (<internal.Stage><any>this.stage).__mouseX : (<internal.Stage><any>Lib.current.stage).__mouseX);
		var mouseY = (this.stage != null ? (<internal.Stage><any>this.stage).__mouseY : (<internal.Stage><any>Lib.current.stage).__mouseY);

		return (<internal.Matrix><any>this.__getRenderTransform()).__transformInverseX(mouseX, mouseY);
	}

	/**
		Indicates the y coordinate of the mouse or user input device position, in
		pixels.

		**Note**: For a DisplayObject that has been rotated, the returned y
		coordinate will reflect the non-rotated object.
	**/
	public get mouseY(): number
	{
		var mouseX = (this.stage != null ? (<internal.Stage><any>this.stage).__mouseX : (<internal.Stage><any>Lib.current.stage).__mouseX);
		var mouseY = (this.stage != null ? (<internal.Stage><any>this.stage).__mouseY : (<internal.Stage><any>Lib.current.stage).__mouseY);

		return (<internal.Matrix><any>this.__getRenderTransform()).__transformInverseY(mouseX, mouseY);
	}

	/**
		Indicates the instance name of the DisplayObject. The object can be
		identified in the child list of its parent display object container by
		calling the `getChildByName()` method of the display object
		container.

		@throws IllegalOperationError If you are attempting to set this property
									on an object that was placed on the timeline
									in the Flash authoring tool.
	**/
	public get name(): string
	{
		return this.__name;
	}

	public set name(value: string)
	{
		this.__name = value;
	}

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
	public get parent(): DisplayObjectContainer
	{
		return this.__parent;
	}

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
	public get root(): DisplayObject
	{
		if (this.stage != null)
		{
			return Lib.current;
		}

		return null;
	}

	/**
		Indicates the rotation of the DisplayObject instance, in degrees, from its
		original orientation. Values from 0 to 180 represent clockwise rotation;
		values from 0 to -180 represent counterclockwise rotation. Values outside
		this range are added to or subtracted from 360 to obtain a value within
		the range. For example, the statement `my_video.rotation = 450`
		is the same as ` my_video.rotation = 90`.
	**/
	public get rotation(): number
	{
		return this.__rotation;
	}

	public set rotation(value: number)
	{
		if (value != this.__rotation)
		{
			this.__rotation = value;
			var radians = this.__rotation * (Math.PI / 180);
			this.__rotationSine = Math.sin(radians);
			this.__rotationCosine = Math.cos(radians);

			this.__transform.a = this.__rotationCosine * this.__scaleX;
			this.__transform.b = this.__rotationSine * this.__scaleX;
			this.__transform.c = -this.__rotationSine * this.__scaleY;
			this.__transform.d = this.__rotationCosine * this.__scaleY;

			this.__localBoundsDirty = true;
			this.__setTransformDirty();
			this.__setParentRenderDirty();
		}
	}

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
	public get scale9Grid(): Rectangle
	{
		if (this.__scale9Grid == null)
		{
			return null;
		}

		return this.__scale9Grid.clone();
	}

	public set scale9Grid(value: Rectangle)
	{
		if (value == null && this.__scale9Grid == null) return;
		if (value != null && this.__scale9Grid != null && this.__scale9Grid.equals(value)) return;

		if (value != null)
		{
			if (this.__scale9Grid == null) this.__scale9Grid = new Rectangle();
			this.__scale9Grid.copyFrom(value);
		}
		else
		{
			this.__scale9Grid = null;
		}

		this.__setRenderDirty();
	}

	/**
		Indicates the horizontal scale (percentage) of the object as applied from
		the registration point. The default registration point is (0,0). 1.0
		equals 100% scale.

		Scaling the local coordinate system changes the `x` and
		`y` property values, which are defined in whole pixels.
	**/
	public get scaleX(): number
	{
		return this.__scaleX;
	}

	public set scaleX(value: number)
	{
		if (value != this.__scaleX)
		{
			this.__scaleX = value;

			if (this.__transform.b == 0)
			{
				if (value != this.__transform.a)
				{
					this.__localBoundsDirty = true;
					this.__setTransformDirty();
					this.__setParentRenderDirty();
				}

				this.__transform.a = value;
			}
			else
			{
				var a = this.__rotationCosine * value;
				var b = this.__rotationSine * value;

				if (this.__transform.a != a || this.__transform.b != b)
				{
					this.__localBoundsDirty = true;
					this.__setTransformDirty();
					this.__setParentRenderDirty();
				}

				this.__transform.a = a;
				this.__transform.b = b;
			}
		}
	}

	/**
		Indicates the vertical scale (percentage) of an object as applied from the
		registration point of the object. The default registration point is (0,0).
		1.0 is 100% scale.

		Scaling the local coordinate system changes the `x` and
		`y` property values, which are defined in whole pixels.
	**/
	public get scaleY(): number
	{
		return this.__scaleY;
	}

	public set scaleY(value: number)
	{
		if (value != this.__scaleY)
		{
			this.__scaleY = value;

			if (this.__transform.c == 0)
			{
				if (value != this.__transform.d)
				{
					this.__localBoundsDirty = true;
					this.__setTransformDirty();
					this.__setParentRenderDirty();
				}

				this.__transform.d = value;
			}
			else
			{
				var c = -this.__rotationSine * value;
				var d = this.__rotationCosine * value;

				if (this.__transform.d != d || this.__transform.c != c)
				{
					this.__localBoundsDirty = true;
					this.__setTransformDirty();
					this.__setParentRenderDirty();
				}

				this.__transform.c = c;
				this.__transform.d = d;
			}
		}
	}

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
		90° and you scroll it left and right, the display object actually scrolls
		up and down.
	**/
	public get scrollRect(): Rectangle
	{
		if (this.__scrollRect == null)
		{
			return null;
		}

		return this.__scrollRect.clone();
	}

	public set scrollRect(value: Rectangle)
	{
		if (value == null && this.__scrollRect == null) return;
		if (value != null && this.__scrollRect != null && this.__scrollRect.equals(value)) return;

		if (value != null)
		{
			if (this.__scrollRect == null) this.__scrollRect = new Rectangle();
			this.__scrollRect.copyFrom(value);
		}
		else
		{
			this.__scrollRect = null;
		}

		this.__setTransformDirty();
		this.__setParentRenderDirty();

		if (DisplayObject.__supportDOM)
		{
			this.__setRenderDirty();
		}
	}

	/**
		**BETA**

		Applies a custom Shader object to use when rendering this display object (or its children) when using
		hardware rendering. This occurs as a single-pass render on this object only, if visible. In order to
		apply a post-process effect to multiple display objects at once, enable `cacheAsBitmap` or use the
		`filters` property with a ShaderFilter
	**/
	public get shader(): Shader
	{
		return this.__shader;
	}

	public set shader(value: Shader)
	{
		this.__shader = value;
		this.__setRenderDirty();
	}

	/**
		The Stage of the display object. A Flash runtime application has only one
		Stage object. For example, you can create and load multiple display
		objects into the display list, and the `stage` property of each
		display object refers to the same Stage object(even if the display object
		belongs to a loaded SWF file).

		If a display object is not added to the display list, its
		`stage` property is set to `null`.
	**/
	public get stage(): Stage
	{
		return this.__stage;
	}

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
		` myMatrix:Matrix =
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
	public get transform(): Transform
	{
		if (this.__objectTransform == null)
		{
			this.__objectTransform = new Transform(this);
		}

		return this.__objectTransform;
	}

	public set transform(value: Transform)
	{
		if (value == null)
		{
			throw new TypeError("Parameter transform must be non-null.");
		}

		if (this.__objectTransform == null)
		{
			this.__objectTransform = new Transform(this);
		}

		this.__objectTransform.matrix = value.matrix;

		if (!(<internal.ColorTransform><any>this.__objectTransform.colorTransform).__equals(value.colorTransform, true)
			|| (!this.cacheAsBitmap && this.__objectTransform.colorTransform.alphaMultiplier != value.colorTransform.alphaMultiplier))
		{
			(<internal.ColorTransform><any>this.__objectTransform.colorTransform).__copyFrom(value.colorTransform);
			this.__setRenderDirty();
		}
	}

	/**
		Whether or not the display object is visible. Display objects that are not
		visible are disabled. For example, if `visible=false` for an
		InteractiveObject instance, it cannot be clicked.
	**/
	public get visible(): boolean
	{
		return this.__visible;
	}

	public set visible(value: boolean)
	{
		if (value != this.__visible) this.__setRenderDirty();
		this.__visible = value;
	}

	/**
		Indicates the width of the display object, in pixels. The width is
		calculated based on the bounds of the content of the display object. When
		you set the `width` property, the `scaleX` property
		is adjusted accordingly, as shown in the following code:

		Except for TextField and Video objects, a display object with no
		content(such as an empty sprite) has a width of 0, even if you try to set
		`width` to a different value.
	**/
	public get width(): number
	{
		return this.__getLocalBounds().width;
	}

	public set width(value: number)
	{
		var rect = (<internal.Rectangle><any>Rectangle).__pool.get();
		var matrix = (<internal.Matrix><any>Matrix).__pool.get();
		matrix.identity();

		this.__getBounds(rect, matrix);

		if (value != rect.width)
		{
			this.scaleX = value / rect.width;
		}
		else
		{
			this.scaleX = 1;
		}

		(<internal.Rectangle><any>Rectangle).__pool.release(rect);
		(<internal.Matrix><any>Matrix).__pool.release(matrix);
	}

	/**
		Indicates the _x_ coordinate of the DisplayObject instance relative
		to the local coordinates of the parent DisplayObjectContainer. If the
		object is inside a DisplayObjectContainer that has transformations, it is
		in the local coordinate system of the enclosing DisplayObjectContainer.
		Thus, for a DisplayObjectContainer rotated 90° counterclockwise, the
		DisplayObjectContainer's children inherit a coordinate system that is
		rotated 90° counterclockwise. The object's coordinates refer to the
		registration point position.
	**/
	public get x(): number
	{
		return this.__transform.tx;
	}

	public set x(value: number)
	{
		if (value != this.__transform.tx)
		{
			this.__setTransformDirty();
			this.__setParentRenderDirty();
		}

		this.__transform.tx = value;
	}

	/**
		Indicates the _y_ coordinate of the DisplayObject instance relative
		to the local coordinates of the parent DisplayObjectContainer. If the
		object is inside a DisplayObjectContainer that has transformations, it is
		in the local coordinate system of the enclosing DisplayObjectContainer.
		Thus, for a DisplayObjectContainer rotated 90° counterclockwise, the
		DisplayObjectContainer's children inherit a coordinate system that is
		rotated 90° counterclockwise. The object's coordinates refer to the
		registration point position.
	**/
	public get y(): number
	{
		return this.__transform.ty;
	}

	public set y(value: number)
	{
		if (value != this.__transform.ty)
		{
			this.__setTransformDirty();
			this.__setParentRenderDirty();
		}

		this.__transform.ty = value;
	}
}
