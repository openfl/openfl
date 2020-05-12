package openfl.display;

import openfl._internal.renderer.DisplayObjectRenderData;
import openfl._internal.renderer.DisplayObjectType;
import openfl._internal.utils.DisplayObjectIterator;
import openfl._internal.utils.ObjectPool;
import openfl._internal.Lib;
import openfl.errors.TypeError;
import openfl.events.Event;
import openfl.events._Event;
import openfl.events._EventDispatcher;
import openfl.events.EventPhase;
import openfl.events.EventType;
import openfl.events.MouseEvent;
import openfl.events.RenderEvent;
import openfl.events.TouchEvent;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
import openfl.geom.Transform;
import openfl.ui.MouseCursor;
import openfl.Vector;
#if openfl_html5
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
#end

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
@:access(openfl.display.SimpleButton)
@:access(openfl.display.Stage)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:noCompletion
class _DisplayObject extends _EventDispatcher
{
	public static var __broadcastEvents:Map<String, Array<DisplayObject>> = new Map();
	public static var __initStage:Stage;
	public static var __instanceCount:Int = 0;

	public static #if !js inline #end var __supportDOM:Bool #if !js = false #end;

	public static var __tempStack:ObjectPool<Vector<DisplayObject>> = new ObjectPool<Vector<DisplayObject>>(function() return
		new Vector<DisplayObject>(), function(stack) stack.length = 0);

	@:keep public var alpha(get, set):Float;
	public var blendMode(get, set):BlendMode;
	public var cacheAsBitmap(get, set):Bool;
	public var cacheAsBitmapMatrix(get, set):Matrix;
	public var filters(get, set):Array<BitmapFilter>;
	@:keep public var height(get, set):Float;
	public var loaderInfo(get, never):LoaderInfo;
	public var mask(get, set):DisplayObject;
	public var mouseX(get, never):Float;
	public var mouseY(get, never):Float;
	public var name(get, set):String;
	public var opaqueBackground:Null<Int>;
	public var parent:DisplayObjectContainer;
	public var root(get, never):DisplayObject;
	@:keep public var rotation(get, set):Float;
	public var scale9Grid(get, set):Rectangle;
	@:keep public var scaleX(get, set):Float;
	@:keep public var scaleY(get, set):Float;
	public var scrollRect(get, set):Rectangle;
	@:beta public var shader(get, set):Shader;
	public var stage:Stage;
	@:keep public var transform(get, set):Transform;
	public var visible(get, set):Bool;
	@:keep public var width(get, set):Float;
	@:keep public var x(get, set):Float;
	@:keep public var y(get, set):Float;

	public static var __childIterators:ObjectPool<DisplayObjectIterator> = new ObjectPool<DisplayObjectIterator>(function() { return new DisplayObjectIterator(); });

	// @:noCompletion @:dox(hide) @:require(flash10) var z:Float;
	public var __alpha:Float;
	public var __blendMode:BlendMode;
	public var __cacheAsBitmap:Bool;
	public var __cacheAsBitmapMatrix:Matrix;
	#if openfl_validate_children
	public var __children:Array<DisplayObject> = new Array<DisplayObject>();
	#end
	public var __childTransformDirty:Bool;
	public var __customRenderClear:Bool;
	public var __customRenderEvent:RenderEvent;
	public var __filters:Array<BitmapFilter>;
	public var __firstChild:DisplayObject;
	public var __graphics:Graphics;
	public var __interactive:Bool;
	public var __isMask:Bool;
	public var __lastChild:DisplayObject;
	public var __loaderInfo:LoaderInfo;
	public var __localBounds:Rectangle;
	public var __localBoundsDirty:Bool;
	public var __mask:DisplayObject;
	public var __maskTarget:DisplayObject;
	public var __name:String;
	public var __nextSibling:DisplayObject;
	public var __objectTransform:Transform;
	public var __previousSibling:DisplayObject;
	public var __renderable:Bool;
	public var __renderData:DisplayObjectRenderData;
	public var __renderDirty:Bool;
	public var __renderParent:DisplayObject;
	public var __renderTransform:Matrix;
	public var __renderTransformCache:Matrix;
	public var __renderTransformChanged:Bool;
	public var __rotation:Float;
	public var __rotationCosine:Float;
	public var __rotationSine:Float;
	public var __scale9Grid:Rectangle;
	public var __scaleX:Float;
	public var __scaleY:Float;
	public var __scrollRect:Rectangle;
	public var __shader:Shader;
	public var __tempPoint:Point;
	public var __transform:Matrix;
	public var __transformDirty:Bool;
	public var __type:DisplayObjectType;
	public var __visible:Bool;
	public var __worldAlpha:Float;
	public var __worldAlphaChanged:Bool;
	public var __worldBlendMode:BlendMode;
	public var __worldClip:Rectangle;
	public var __worldClipChanged:Bool;
	public var __worldColorTransform:ColorTransform;
	public var __worldShader:Shader;
	public var __worldScale9Grid:Rectangle;
	public var __worldTransform:Matrix;
	public var __worldVisible:Bool;
	public var __worldVisibleChanged:Bool;
	public var __worldZ:Int;

	private var this_displayObject:DisplayObject;

	public function new(displayObject:DisplayObject)
	{
		this_displayObject = displayObject;

		super(displayObject);

		__type = DISPLAY_OBJECT;

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
		__transformDirty = true;

		__renderData = new DisplayObjectRenderData();

		name = "instance" + (++__instanceCount);

		if (__initStage != null)
		{
			this_displayObject.stage = __initStage;
			__initStage = null;
			this_displayObject.stage.addChild(this_displayObject);
		}
	}

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

				if (dispatchers.indexOf(this_displayObject) == -1)
				{
					dispatchers.push(this_displayObject);
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
		if (Std.is(event, MouseEvent))
		{
			var mouseEvent:MouseEvent = cast event;
			mouseEvent.stageX = __getRenderTransform()._.__transformX(mouseEvent.localX, mouseEvent.localY);
			mouseEvent.stageY = __getRenderTransform()._.__transformY(mouseEvent.localX, mouseEvent.localY);
		}
		else if (Std.is(event, TouchEvent))
		{
			var touchEvent:TouchEvent = cast event;
			touchEvent.stageX = __getRenderTransform()._.__transformX(touchEvent.localX, touchEvent.localY);
			touchEvent.stageY = __getRenderTransform()._.__transformY(touchEvent.localX, touchEvent.localY);
		}

		event.target = this_displayObject;

		return __dispatchWithCapture(event);
	}

	public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
	{
		var matrix = _Matrix.__pool.get();

		if (targetCoordinateSpace != null && targetCoordinateSpace != this_displayObject)
		{
			matrix.copyFrom(__getWorldTransform());

			var targetMatrix = _Matrix.__pool.get();

			targetMatrix.copyFrom((targetCoordinateSpace._:_DisplayObject).__getWorldTransform());
			targetMatrix.invert();

			matrix.concat(targetMatrix);

			_Matrix.__pool.release(targetMatrix);
		}
		else
		{
			matrix.identity();
		}

		var bounds = new Rectangle();
		__getBounds(bounds, matrix);

		_Matrix.__pool.release(matrix);

		return bounds;
	}

	public function getRect(targetCoordinateSpace:DisplayObject):Rectangle
	{
		// should not account for stroke widths, but is that possible?
		return getBounds(targetCoordinateSpace);
	}

	public function globalToLocal(pos:Point):Point
	{
		return __globalToLocal(pos, new Point());
	}

	public function hitTestObject(obj:DisplayObject):Bool
	{
		if (obj != null && obj.parent != null && parent != null)
		{
			var currentBounds = getBounds(this_displayObject);
			var targetBounds = obj.getBounds(this_displayObject);

			return currentBounds.intersects(targetBounds);
		}

		return false;
	}

	public function hitTestPoint(x:Float, y:Float, shapeFlag:Bool = false):Bool
	{
		if (stage != null)
		{
			return __hitTest(x, y, shapeFlag, null, false, this_displayObject);
		}
		else
		{
			return false;
		}
	}

	public function invalidate():Void
	{
		__setRenderDirty();
	}

	public function localToGlobal(point:Point):Point
	{
		return __getRenderTransform().transformPoint(point);
	}

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
						__broadcastEvents.get(type).remove(this_displayObject);
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

	public function __childIterator(childrenOnly:Bool = true):DisplayObjectIterator
	{
		var iterator = __childIterators.get();
		iterator.init(this_displayObject, childrenOnly);
		return iterator;
	}

	public static inline function __calculateAbsoluteTransform(local:Matrix, parentTransform:Matrix, target:Matrix):Void
	{
		target.a = local.a * parentTransform.a + local.b * parentTransform.c;
		target.b = local.a * parentTransform.b + local.b * parentTransform.d;
		target.c = local.c * parentTransform.a + local.d * parentTransform.c;
		target.d = local.c * parentTransform.b + local.d * parentTransform.d;
		target.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
		target.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
	}

	public #if haxe4 final #end function __cleanup():Void
	{
		for (child in __childIterator(false))
		{
			var _child:_DisplayObject = cast child._;
			_child.__renderData.dispose();

			if (_child.__graphics != null)
			{
				(_child.__graphics._:_Graphics).__cleanup();
			}

			switch (_child.__type)
			{
				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
					var displayObjectContainer:DisplayObjectContainer = cast child;
					(displayObjectContainer._:_DisplayObjectContainer).__cleanupRemovedChildren();
				default:
			}
		}
	}

	public function __dispatch(event:Event):Bool
	{
		if (__eventMap != null && hasEventListener(event.type))
		{
			var result = super.__dispatchEvent(event);

			if (event._.__isCanceled)
			{
				return true;
			}

			return result;
		}

		return true;
	}

	public #if haxe4 final #end function __dispatchChildren(event:Event):Void
	{
		if (__type != null)
		{
			switch (__type)
			{
				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
					var displayObjectContainer:DisplayObjectContainer = cast this_displayObject;
					if (displayObjectContainer.numChildren > 0)
					{
						for (child in __childIterator())
						{
							(event._:_Event).target = child;

							if (!(child._:_DisplayObject).__dispatchWithCapture(event))
							{
								break;
							}
						}
					}
				default:
			}
		}
	}

	public override function __dispatchEvent(event:Event):Bool
	{
		var parent = event.bubbles ? this_displayObject.parent : null;
		var result = super._.__dispatchEvent(event);

		if (event._.__isCanceled)
		{
			return true;
		}

		if (parent != null && parent != this_displayObject)
		{
			event.eventPhase = EventPhase.BUBBLING_PHASE;

			if (event.target == null)
			{
				event.target = this_displayObject;
			}

			parent._.__dispatchEvent(event);
		}

		return result;
	}

	public function __dispatchWithCapture(event:Event):Bool
	{
		if (event.target == null)
		{
			event.target = this_displayObject;
		}

		if (parent != null)
		{
			event.eventPhase = CAPTURING_PHASE;

			if (parent == stage)
			{
				parent._.__dispatch(event);
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
					stack[i - j - 1]._.__dispatch(event);
				}

				__tempStack.release(stack);
			}
		}

		event.eventPhase = AT_TARGET;

		return __dispatchEvent(event);
	}

	public function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		if (__graphics != null)
		{
			__graphics._.__getBounds(rect, matrix);
		}
	}

	public function __getCursor():MouseCursor
	{
		return null;
	}

	public function __getFilterBounds(rect:Rectangle, matrix:Matrix):Void
	{
		__getRenderBounds(rect, matrix);

		if (__filters != null)
		{
			var extension = _Rectangle.__pool.get();

			for (filter in __filters)
			{
				extension._.__expand(-filter._.__leftExtension,
					-filter._.__topExtension, filter._.__leftExtension
					+ filter._.__rightExtension,
					filter._.__topExtension
					+ filter._.__bottomExtension);
			}

			rect.width += extension.width;
			rect.height += extension.height;
			rect.x += extension.x;
			rect.y += extension.y;

			_Rectangle.__pool.release(extension);
		}
	}

	public function __getInteractive(stack:Array<DisplayObject>):Bool
	{
		return false;
	}

	public function __getLocalBounds():Rectangle
	{
		if (__localBounds == null)
		{
			__localBounds = new Rectangle();
			__localBoundsDirty = true;
		}

		if (__localBoundsDirty)
		{
			__localBounds.x = 0;
			__localBounds.y = 0;
			__localBounds.width = 0;
			__localBounds.height = 0;

			__getBounds(__localBounds, __transform);

			__localBounds.x -= __transform.tx;
			__localBounds.y -= __transform.ty;
			__localBoundsDirty = false;
		}

		return __localBounds;
	}

	public function __getRenderBounds(rect:Rectangle, matrix:Matrix):Void
	{
		if (__scrollRect == null)
		{
			__getBounds(rect, matrix);
		}
		else
		{
			// TODO: Should we have smaller bounds if scrollRect is larger than content?

			var r = _Rectangle.__pool.get();
			r.copyFrom(__scrollRect);
			r._.__transform(r, matrix);
			rect._.__expand(r.x, r.y, r.width, r.height);
			_Rectangle.__pool.release(r);
		}
	}

	public function __getRenderTransform():Matrix
	{
		__getWorldTransform();
		return __renderTransform;
	}

	public function __getWorldTransform():Matrix
	{
		if (__transformDirty)
		{
			var renderParent = __renderParent != null ? __renderParent : parent;
			if (__isMask && renderParent == null) renderParent = __maskTarget;

			if (parent == null || (!parent._.__transformDirty && !renderParent._.__transformDirty))
			{
				__update(true, false);
			}
			else
			{
				var list = [];
				var current = this_displayObject;

				while (current != stage && current._.__transformDirty)
				{
					list.push(current);
					current = current.parent;

					if (current == null) break;
				}

				var i = list.length;
				while (--i >= 0)
				{
					current = list[i];
					current._.__update(true, false);
				}
			}
		}

		return __worldTransform;
	}

	public function __globalToLocal(global:Point, local:Point):Point
	{
		__getRenderTransform();

		if (global == local)
		{
			__renderTransform._.__transformInversePoint(global);
		}
		else
		{
			local.x = __renderTransform._.__transformInverseX(global.x, global.y);
			local.y = __renderTransform._.__transformInverseY(global.x, global.y);
		}

		return local;
	}

	public function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool
	{
		var hitTest = false;

		if (__graphics != null)
		{
			if (!hitObject._.__visible || __isMask || (mask != null && !mask._.__hitTestMask(x, y)))
			{
				hitTest = false;
			}
			else if (__graphics._.__hitTest(x, y, shapeFlag, __getRenderTransform()))
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

	public function __hitTestMask(x:Float, y:Float):Bool
	{
		return (__graphics != null && __graphics._.__hitTest(x, y, true, __getRenderTransform()));
	}

	public function __readGraphicsData(graphicsData:Vector<IGraphicsData>, recurse:Bool):Void
	{
		if (__graphics != null)
		{
			__graphics._.__readGraphicsData(graphicsData);
		}
	}

	public function __setParentRenderDirty():Void
	{
		var renderParent = __renderParent != null ? __renderParent : parent;
		if (renderParent != null && !renderParent._.__renderDirty)
		{
			// TODO: Use separate method? Based on transform, not render change
			renderParent._.__localBoundsDirty = true;

			renderParent._.__renderDirty = true;
			renderParent._.__setParentRenderDirty();
		}
	}

	public inline function __setRenderDirty():Void
	{
		if (!__renderDirty)
		{
			__renderDirty = true;
			__setParentRenderDirty();
		}
	}

	public function __setStageReferences(stage:Stage):Void
	{
		(this_displayObject._:_DisplayObject).stage = stage;

		if (__firstChild != null)
		{
			for (child in __childIterator())
			{
				(child._:_DisplayObject).stage = stage;
				if ((child._:_DisplayObject).__type == SIMPLE_BUTTON)
				{
					var button:SimpleButton = cast child;
					var _button:_SimpleButton = cast button._;
					if (_button.__currentState != null)
					{
						(_button.__currentState._:_DisplayObject).__setStageReferences(stage);
					}
					if (button.hitTestState != null && button.hitTestState != _button.__currentState)
					{
						(button.hitTestState._:_DisplayObject).__setStageReferences(stage);
					}
				}
			}
		}
	}

	public function __setTransformDirty(force:Bool = false):Void
	{
		__transformDirty = true;
	}

	public function __stopAllMovieClips():Void {}

	public function __update(transformOnly:Bool, updateChildren:Bool):Void
	{
		__updateSingle(transformOnly, updateChildren);
	}

	public inline function __updateSingle(transformOnly:Bool, updateChildren:Bool):Void
	{
		var renderParent = __renderParent != null ? __renderParent : parent;
		if (__isMask && renderParent == null) renderParent = __maskTarget;
		__renderable = (__visible && __scaleX != 0 && __scaleY != 0 && !__isMask && (renderParent == null || !renderParent._.__isMask));

		#if openfl_validate_update
		if (!__transformDirty)
		{
			if (parent != null)
			{
				var mat = new Matrix();
				__calculateAbsoluteTransform(__transform, parent._.__worldTransform, mat);
				if (!__worldTransform.equals(mat))
				{
					trace("[" + Type.getClassName(Type.getClass(this_displayObject)) + "] worldTransform cache miss detected");
					trace(__worldTransform);
					trace(mat);
				}
			}
			else
			{
				if (!__worldTransform.equals(__transform))
				{
					trace("[" + Type.getClassName(Type.getClass(this_displayObject)) + "] worldTransform cache miss detected");
					trace(__worldTransform);
					trace(__transform);
				}
			}

			if (renderParent != null)
			{
				var mat = new Matrix();
				__calculateAbsoluteTransform(__transform, renderParent._.__renderTransform, mat);
				if (Std.is(this_displayObject, openfl.text.TextField))
				{
					mat._.__translateTransformed(@:privateAccess cast(this_displayObject, openfl.text.TextField)._.__offsetX, @:privateAccess cast(this_displayObject, openfl.text.TextField)
						._.__offsetY);
				}
				if (!__renderTransform.equals(mat))
				{
					trace("[" + Type.getClassName(Type.getClass(this_displayObject)) + "] renderTransform cache miss detected");
					trace(__renderTransform);
					trace(mat);
				}
			}
			else
			{
				var mat = new Matrix();
				mat.copyFrom(__transform);
				if (Std.is(this_displayObject, openfl.text.TextField))
				{
					mat._.__translateTransformed(@:privateAccess cast(this_displayObject, openfl.text.TextField)._.__offsetX, @:privateAccess cast(this_displayObject, openfl.text.TextField)
						._.__offsetY);
				}
				if (!__renderTransform.equals(mat))
				{
					trace("[" + Type.getClassName(Type.getClass(this_displayObject)) + "] renderTransform cache miss detected");
					trace(__renderTransform);
					trace(mat);
				}
			}
		}
		#end

		if (__transformDirty)
		{
			if (__worldTransform == null)
			{
				__worldTransform = new Matrix();
			}

			if (__renderTransform == null)
			{
				__renderTransform = new Matrix();
			}

			if (parent != null)
			{
				__calculateAbsoluteTransform(__transform, parent._.__worldTransform, __worldTransform);
			}
			else
			{
				__worldTransform.copyFrom(__transform);
			}

			if (renderParent != null)
			{
				__calculateAbsoluteTransform(__transform, renderParent._.__renderTransform, __renderTransform);
			}
			else
			{
				__renderTransform.copyFrom(__transform);
			}

			if (__scrollRect != null)
			{
				__renderTransform._.__translateTransformed(-__scrollRect.x, -__scrollRect.y);
			}

			__transformDirty = false;
		}

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
					var worldVisible = (renderParent._.__worldVisible && __visible);
					__worldVisibleChanged = (__worldVisible != worldVisible);
					__worldVisible = worldVisible;

					var worldAlpha = alpha * renderParent._.__worldAlpha;
					__worldAlphaChanged = (__worldAlpha != worldAlpha);
					__worldAlpha = worldAlpha;
				}
				else
				{
					__worldAlpha = alpha * renderParent._.__worldAlpha;
				}

				if (__objectTransform != null)
				{
					__worldColorTransform._.__copyFrom(__objectTransform.colorTransform);
					__worldColorTransform._.__combine(renderParent._.__worldColorTransform);
				}
				else
				{
					__worldColorTransform._.__copyFrom(renderParent._.__worldColorTransform);
				}

				if (__blendMode == null || __blendMode == NORMAL)
				{
					// TODO: Handle multiple blend modes better
					__worldBlendMode = renderParent._.__worldBlendMode;
				}
				else
				{
					__worldBlendMode = __blendMode;
				}

				if (__shader == null)
				{
					__worldShader = renderParent._.__shader;
				}
				else
				{
					__worldShader = __shader;
				}

				if (__scale9Grid == null)
				{
					__worldScale9Grid = renderParent._.__scale9Grid;
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
					__worldColorTransform._.__copyFrom(__objectTransform.colorTransform);
				}
				else
				{
					__worldColorTransform._.__identity();
				}

				__worldBlendMode = __blendMode;
				__worldShader = __shader;
				__worldScale9Grid = __scale9Grid;
			}
		}

		// TODO: Flatten
		if (updateChildren && mask != null)
		{
			mask._.__update(transformOnly, true);
		}
	}

	// Get & Set Methods

	@:keep private function get_alpha():Float
	{
		return __alpha;
	}

	@:keep private function set_alpha(value:Float):Float
	{
		if (value > 1.0) value = 1.0;
		if (value < 0.0) value = 0.0;

		if (value != __alpha && !cacheAsBitmap) __setRenderDirty();
		return __alpha = value;
	}

	private function get_blendMode():BlendMode
	{
		return __blendMode;
	}

	private function set_blendMode(value:BlendMode):BlendMode
	{
		if (value == null) value = NORMAL;

		if (value != __blendMode) __setRenderDirty();
		return __blendMode = value;
	}

	private function get_cacheAsBitmap():Bool
	{
		return (__filters == null ? __cacheAsBitmap : true);
	}

	private function set_cacheAsBitmap(value:Bool):Bool
	{
		if (value != __cacheAsBitmap)
		{
			__setRenderDirty();
		}

		return __cacheAsBitmap = value;
	}

	private function get_cacheAsBitmapMatrix():Matrix
	{
		return __cacheAsBitmapMatrix;
	}

	private function set_cacheAsBitmapMatrix(value:Matrix):Matrix
	{
		__setRenderDirty();
		return __cacheAsBitmapMatrix = (value != null ? value.clone() : value);
	}

	private function get_filters():Array<BitmapFilter>
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

	private function set_filters(value:Array<BitmapFilter>):Array<BitmapFilter>
	{
		if (value != null && value.length > 0)
		{
			// TODO: Copy incoming array values

			__filters = value;
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

	@:keep private function get_height():Float
	{
		return __getLocalBounds().height;
	}

	@:keep private function set_height(value:Float):Float
	{
		var rect = _Rectangle.__pool.get();
		var matrix = _Matrix.__pool.get();
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

		_Rectangle.__pool.release(rect);
		_Matrix.__pool.release(matrix);

		return value;
	}

	private function get_loaderInfo():LoaderInfo
	{
		if (stage != null)
		{
			return Lib.current._.__loaderInfo;
		}

		return null;
	}

	private function get_mask():DisplayObject
	{
		return __mask;
	}

	private function set_mask(value:DisplayObject):DisplayObject
	{
		if (value == __mask)
		{
			return value;
		}

		if (value != __mask)
		{
			__setTransformDirty();
			__setParentRenderDirty();
			__setRenderDirty();
		}

		if (__mask != null)
		{
			__mask._.__isMask = false;
			__mask._.__maskTarget = null;
			__mask._.__setTransformDirty(true);
			__mask._.__setParentRenderDirty();
			__mask._.__setRenderDirty();
		}

		if (value != null)
		{
			if (!value._.__isMask)
			{
				value._.__setParentRenderDirty();
			}

			value._.__isMask = true;
			value._.__maskTarget = this_displayObject;
			value._.__setTransformDirty(true);
		}

		// TODO: Handle in renderer
		if (__renderData.cacheBitmap != null && __renderData.cacheBitmap.mask != value)
		{
			__renderData.cacheBitmap.mask = value;
		}

		return __mask = value;
	}

	private function get_mouseX():Float
	{
		var mouseX = (stage != null ? stage._.__mouseX : Lib.current.stage._.__mouseX);
		var mouseY = (stage != null ? stage._.__mouseY : Lib.current.stage._.__mouseY);

		return __getRenderTransform()._.__transformInverseX(mouseX, mouseY);
	}

	private function get_mouseY():Float
	{
		var mouseX = (stage != null ? stage._.__mouseX : Lib.current.stage._.__mouseX);
		var mouseY = (stage != null ? stage._.__mouseY : Lib.current.stage._.__mouseY);

		return __getRenderTransform()._.__transformInverseY(mouseX, mouseY);
	}

	private function get_name():String
	{
		return __name;
	}

	private function set_name(value:String):String
	{
		return __name = value;
	}

	private function get_root():DisplayObject
	{
		if (stage != null)
		{
			return Lib.current;
		}

		return null;
	}

	@:keep private function get_rotation():Float
	{
		return __rotation;
	}

	@:keep private function set_rotation(value:Float):Float
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

			__localBoundsDirty = true;
			__setTransformDirty();
			__setParentRenderDirty();
		}

		return value;
	}

	private function get_scale9Grid():Rectangle
	{
		if (__scale9Grid == null)
		{
			return null;
		}

		return __scale9Grid.clone();
	}

	private function set_scale9Grid(value:Rectangle):Rectangle
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

	@:keep private function get_scaleX():Float
	{
		return __scaleX;
	}

	@:keep private function set_scaleX(value:Float):Float
	{
		if (value != __scaleX)
		{
			__scaleX = value;

			if (__transform.b == 0)
			{
				if (value != __transform.a)
				{
					__localBoundsDirty = true;
					__setTransformDirty();
					__setParentRenderDirty();
				}

				__transform.a = value;
			}
			else
			{
				var a = __rotationCosine * value;
				var b = __rotationSine * value;

				if (__transform.a != a || __transform.b != b)
				{
					__localBoundsDirty = true;
					__setTransformDirty();
					__setParentRenderDirty();
				}

				__transform.a = a;
				__transform.b = b;
			}
		}

		return value;
	}

	@:keep private function get_scaleY():Float
	{
		return __scaleY;
	}

	@:keep private function set_scaleY(value:Float):Float
	{
		if (value != __scaleY)
		{
			__scaleY = value;

			if (__transform.c == 0)
			{
				if (value != __transform.d)
				{
					__localBoundsDirty = true;
					__setTransformDirty();
					__setParentRenderDirty();
				}

				__transform.d = value;
			}
			else
			{
				var c = -__rotationSine * value;
				var d = __rotationCosine * value;

				if (__transform.d != d || __transform.c != c)
				{
					__localBoundsDirty = true;
					__setTransformDirty();
					__setParentRenderDirty();
				}

				__transform.c = c;
				__transform.d = d;
			}
		}

		return value;
	}

	private function get_scrollRect():Rectangle
	{
		if (__scrollRect == null)
		{
			return null;
		}

		return __scrollRect.clone();
	}

	private function set_scrollRect(value:Rectangle):Rectangle
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
		__setParentRenderDirty();

		if (__supportDOM)
		{
			__setRenderDirty();
		}

		return value;
	}

	private function get_shader():Shader
	{
		return __shader;
	}

	private function set_shader(value:Shader):Shader
	{
		__shader = value;
		__setRenderDirty();
		return value;
	}

	@:keep private function get_transform():Transform
	{
		if (__objectTransform == null)
		{
			__objectTransform = new Transform(this_displayObject);
		}

		return __objectTransform;
	}

	@:keep private function set_transform(value:Transform):Transform
	{
		if (value == null)
		{
			throw new TypeError("Parameter transform must be non-null.");
		}

		if (__objectTransform == null)
		{
			__objectTransform = new Transform(this_displayObject);
		}

		__objectTransform.matrix = value.matrix;

		if (!__objectTransform.colorTransform._.__equals(value.colorTransform, true)
			|| (!cacheAsBitmap && __objectTransform.colorTransform.alphaMultiplier != value.colorTransform.alphaMultiplier))
		{
			__objectTransform.colorTransform._.__copyFrom(value.colorTransform);
			__setRenderDirty();
		}

		return __objectTransform;
	}

	private function get_visible():Bool
	{
		return __visible;
	}

	private function set_visible(value:Bool):Bool
	{
		if (value != __visible) __setRenderDirty();
		return __visible = value;
	}

	@:keep private function get_width():Float
	{
		return __getLocalBounds().width;
	}

	@:keep private function set_width(value:Float):Float
	{
		var rect = _Rectangle.__pool.get();
		var matrix = _Matrix.__pool.get();
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

		_Rectangle.__pool.release(rect);
		_Matrix.__pool.release(matrix);

		return value;
	}

	@:keep private function get_x():Float
	{
		return __transform.tx;
	}

	@:keep private function set_x(value:Float):Float
	{
		if (value != __transform.tx)
		{
			__setTransformDirty();
			__setParentRenderDirty();
		}

		return __transform.tx = value;
	}

	@:keep private function get_y():Float
	{
		return __transform.ty;
	}

	@:keep private function set_y(value:Float):Float
	{
		if (value != __transform.ty)
		{
			__setTransformDirty();
			__setParentRenderDirty();
		}

		return __transform.ty = value;
	}
}
