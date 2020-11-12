package openfl.display;

#if !flash
import openfl.display._internal.IBitmapDrawableType;
import openfl._internal.utils.ObjectPool;
import openfl._internal.Lib;
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
	// @:noCompletion @:dox(hide) public var accessibilityProperties:openfl.accessibility.AccessibilityProperties;
	#end
	@:keep public var alpha(get, set):Float;
	public var blendMode(get, set):BlendMode;

	#if false
	// @:noCompletion @:dox(hide) @:require(flash10) public var blendShader(null, default):Shader;
	#end
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
	public var parent(default, null):DisplayObjectContainer;
	public var root(get, never):DisplayObject;
	@:keep public var rotation(get, set):Float;
	#if false
	// @:noCompletion @:dox(hide) @:require(flash10) public var rotationX:Float;
	#end
	#if false
	// @:noCompletion @:dox(hide) @:require(flash10) public var rotationY:Float;
	#end
	#if false
	// @:noCompletion @:dox(hide) @:require(flash10) public var rotationZ:Float;
	#end
	public var scale9Grid(get, set):Rectangle;
	@:keep public var scaleX(get, set):Float;
	@:keep public var scaleY(get, set):Float;
	#if false
	// @:noCompletion @:dox(hide) @:require(flash10) public var scaleZ:Float;
	#end
	public var scrollRect(get, set):Rectangle;
	@:beta public var shader(get, set):Shader;
	public var stage(default, null):Stage;
	@:keep public var transform(get, set):Transform;
	public var visible(get, set):Bool;
	@:keep public var width(get, set):Float;
	@:keep public var x(get, set):Float;
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

	public function getRect(targetCoordinateSpace:DisplayObject):Rectangle
	{
		// should not account for stroke widths, but is that possible?
		return getBounds(targetCoordinateSpace);
	}

	public function globalToLocal(pos:Point):Point
	{
		return __globalToLocal(pos, new Point());
	}

	// @:noCompletion @:dox(hide) @:require(flash10) public function globalToLocal3D (point:Point):Vector3D;

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

	public function invalidate():Void
	{
		__setRenderDirty();
	}

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
					__worldColorTransform.__copyFrom(__objectTransform.colorTransform);
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
					__worldColorTransform.__copyFrom(__objectTransform.colorTransform);
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

		if (!__objectTransform.colorTransform.__equals(value.colorTransform, true)
			|| (!cacheAsBitmap && __objectTransform.colorTransform.alphaMultiplier != value.colorTransform.alphaMultiplier))
		{
			__objectTransform.colorTransform.__copyFrom(value.colorTransform);
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
