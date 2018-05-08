package openfl.display;


import lime.graphics.cairo.Cairo;
import lime.graphics.utils.ImageCanvasUtil;
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

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
import js.html.Element;
#end

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


class DisplayObject extends EventDispatcher implements IBitmapDrawable #if openfl_dynamic implements Dynamic<DisplayObject> #end {
	
	
	private static var __broadcastEvents = new Map<String, Array<DisplayObject>> ();
	private static var __initStage:Stage;
	private static var __instanceCount = 0;
	private static #if !js inline #end var __supportDOM:Bool #if !js = false #end;
	private static var __tempColorTransform = new ColorTransform ();
	private static var __tempStack = new ObjectPool<Vector<DisplayObject>> (function () { return new Vector<DisplayObject> (); }, function (stack) { stack.length = 0; });
	
	@:keep public var alpha (get, set):Float;
	public var blendMode (get, set):BlendMode;
	public var cacheAsBitmap (get, set):Bool;
	public var cacheAsBitmapMatrix (get, set):Matrix;
	public var filters (get, set):Array<BitmapFilter>;
	@:keep public var height (get, set):Float;
	public var loaderInfo (get, never):LoaderInfo;
	public var mask (get, set):DisplayObject;
	public var mouseX (get, never):Float;
	public var mouseY (get, never):Float;
	public var name (get, set):String;
	public var opaqueBackground:Null<Int>;
	public var parent (default, null):DisplayObjectContainer;
	public var root (get, never):DisplayObject;
	@:keep public var rotation (get, set):Float;
	public var scale9Grid:Rectangle;
	@:keep public var scaleX (get, set):Float;
	@:keep public var scaleY (get, set):Float;
	public var scrollRect (get, set):Rectangle;
	@:beta public var shader (get, set):Shader;
	public var stage (default, null):Stage;
	@:keep public var transform (get, set):Transform;
	public var visible (get, set):Bool;
	@:keep public var width (get, set):Float;
	@:keep public var x (get, set):Float;
	@:keep public var y (get, set):Float;
	
	private var __alpha:Float;
	private var __blendMode:BlendMode;
	private var __cacheAsBitmap:Bool;
	private var __cacheAsBitmapMatrix:Matrix;
	private var __cacheBitmap:Bitmap;
	private var __cacheBitmapBackground:Null<Int>;
	private var __cacheBitmapColorTransform:ColorTransform;
	private var __cacheBitmapData:BitmapData;
	private var __cacheBitmapData2:BitmapData;
	private var __cacheBitmapData3:BitmapData;
	private var __cacheBitmapMatrix:Matrix;
	private var __cacheBitmapRenderer:DisplayObjectRenderer;
	private var __cairo:Cairo;
	private var __children:Array<DisplayObject>;
	private var __customRenderClear:Bool;
	private var __customRenderEvent:RenderEvent;
	private var __filters:Array<BitmapFilter>;
	private var __graphics:Graphics;
	private var __interactive:Bool;
	private var __isCacheBitmapRender:Bool;
	private var __isMask:Bool;
	private var __loaderInfo:LoaderInfo;
	private var __mask:DisplayObject;
	private var __maskTarget:DisplayObject;
	private var __name:String;
	private var __objectTransform:Transform;
	private var __renderable:Bool;
	private var __renderDirty:Bool;
	private var __renderParent:DisplayObject;
	private var __renderTransform:Matrix;
	private var __renderTransformCache:Matrix;
	private var __renderTransformChanged:Bool;
	private var __rotation:Float;
	private var __rotationCosine:Float;
	private var __rotationSine:Float;
	private var __scaleX:Float;
	private var __scaleY:Float;
	private var __scrollRect:Rectangle;
	private var __shader:Shader;
	private var __tempPoint:Point;
	private var __transform:Matrix;
	private var __transformDirty:Bool;
	private var __visible:Bool;
	private var __worldAlpha:Float;
	private var __worldAlphaChanged:Bool;
	private var __worldBlendMode:BlendMode;
	private var __worldClip:Rectangle;
	private var __worldClipChanged:Bool;
	private var __worldColorTransform:ColorTransform;
	private var __worldShader:Shader;
	private var __worldTransform:Matrix;
	private var __worldVisible:Bool;
	private var __worldVisibleChanged:Bool;
	private var __worldTransformInvalid:Bool;
	private var __worldZ:Int;
	
	#if (js && html5)
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	private var __style:CSSStyleDeclaration;
	#end
	
	
	#if openfljs
	private static function __init__ () {
		
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
	
	
	private function new () {
		
		super ();
		
		if (__initStage != null) {
			
			this.stage = __initStage;
			__initStage = null;
			
		}
		
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
	
	
	public function getRect (targetCoordinateSpace:DisplayObject):Rectangle {
		
		// should not account for stroke widths, but is that possible?
		return getBounds (targetCoordinateSpace);
		
	}
	
	
	public function globalToLocal (pos:Point):Point {
		
		return __globalToLocal (pos, new Point ());
		
	}
	
	
	public function hitTestObject (obj:DisplayObject):Bool {
		
		if (obj != null && obj.parent != null && parent != null) {
			
			var currentBounds = getBounds (this);
			var targetBounds = obj.getBounds (this);
			
			return currentBounds.intersects (targetBounds);
			
		}
		
		return false;
		
	}
	
	
	public function hitTestPoint (x:Float, y:Float, shapeFlag:Bool = false):Bool {
		
		if (stage != null) {
			
			return __hitTest (x, y, shapeFlag, null, true, this);
			
		} else {
			
			return false;
			
		}
		
	}
	
	
	public function invalidate ():Void {
		
		__setRenderDirty ();
		
	}
	
	
	public function localToGlobal (point:Point):Point {
		
		return __getRenderTransform ().transformPoint (point);
		
	}
	
	
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
	
	
	private static inline function __calculateAbsoluteTransform (local:Matrix, parentTransform:Matrix, target:Matrix):Void {
		
		target.a = local.a * parentTransform.a + local.b * parentTransform.c;
		target.b = local.a * parentTransform.b + local.b * parentTransform.d;
		target.c = local.c * parentTransform.a + local.d * parentTransform.c;
		target.d = local.c * parentTransform.b + local.d * parentTransform.d;
		target.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
		target.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
		
	}
	
	
	private function __cleanup ():Void {
		
		__cairo = null;
		
		#if (js && html5)
		__canvas = null;
		__context = null;
		#end
		
		if (__graphics != null) {
			
			__graphics.__cleanup ();
			
		}
		
	}
	
	
	private function __dispatch (event:Event):Bool {
		
		if (__eventMap != null && hasEventListener (event.type)) {
			
			var result = super.__dispatchEvent (event);
			
			if (event.__isCanceled) {
				
				return true;
				
			}
			
			return result;
			
		}
		
		return true;
		
	}
	
	
	private function __dispatchChildren (event:Event):Void {
		
		
		
	}
	
	
	private override function __dispatchEvent (event:Event):Bool {
		
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
	
	
	private function __dispatchWithCapture (event:Event):Bool {
		
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
	
	
	private function __enterFrame (deltaTime:Int):Void {
		
		
		
	}
	
	
	private function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__graphics != null) {
			
			__graphics.__getBounds (rect, matrix);
			
		}
		
	}
	
	
	private function __getCursor ():MouseCursor {
		
		return null;
		
	}
	
	
	private function __getFilterBounds (rect:Rectangle, matrix:Matrix):Void {
		
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
	
	
	private function __getInteractive (stack:Array<DisplayObject>):Bool {
		
		return false;
		
	}
	
	
	private function __getLocalBounds (rect:Rectangle):Void {
		
		//var cacheX = __transform.tx;
		//var cacheY = __transform.ty;
		//__transform.tx = __transform.ty = 0;
		
		__getBounds (rect, __transform);
		
		//__transform.tx = cacheX;
		//__transform.ty = cacheY;
		
		rect.x -= __transform.tx;
		rect.y -= __transform.ty;
		
	}
	
	
	private function __getRenderBounds (rect:Rectangle, matrix:Matrix):Void {
		
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
	
	
	private function __getRenderTransform ():Matrix {
		
		__getWorldTransform ();
		return __renderTransform;
		
	}
	
	
	private function __getWorldTransform ():Matrix {
		
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
	
	
	private function __globalToLocal (global:Point, local:Point):Point {
		
		__getRenderTransform ();
		
		if (global == local) {
			
			__renderTransform.__transformInversePoint (global);
			
		} else {
			
			local.x = __renderTransform.__transformInverseX (global.x, global.y);
			local.y = __renderTransform.__transformInverseY (global.x, global.y);
			
		}
		
		return local;
		
	}
	
	
	private function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (__graphics != null) {
			
			if (!hitObject.visible || __isMask) return false;
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
	
	
	private function __hitTestMask (x:Float, y:Float):Bool {
		
		if (__graphics != null) {
			
			if (__graphics.__hitTest (x, y, true, __getRenderTransform ())) {
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	private function __readGraphicsData (graphicsData:Vector<IGraphicsData>, recurse:Bool):Void {
		
		if (__graphics != null) {
			
			__graphics.__readGraphicsData (graphicsData);
			
		}
		
	}
	
	
	private function __renderCairo (renderer:CairoRenderer):Void {
		
		#if lime_cairo
		__updateCacheBitmap (renderer, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			CairoBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			CairoDisplayObject.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		#end
		
	}
	
	
	private function __renderCairoMask (renderer:CairoRenderer):Void {
		
		#if lime_cairo
		if (__graphics != null) {
			
			CairoGraphics.renderMask (__graphics, renderer);
			
		}
		#end
		
	}
	
	
	private function __renderCanvas (renderer:CanvasRenderer):Void {
		
		if (mask == null || (mask.width > 0 && mask.height > 0)) {
			
			__updateCacheBitmap (renderer, !__worldColorTransform.__isDefault ());
			
			if (__cacheBitmap != null && !__isCacheBitmapRender) {
				
				CanvasBitmap.render (__cacheBitmap, renderer);
				
			} else {
				
				CanvasDisplayObject.render (this, renderer);
				
			}
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	private function __renderCanvasMask (renderer:CanvasRenderer):Void {
		
		if (__graphics != null) {
			
			CanvasGraphics.renderMask (__graphics, renderer);
			
		}
		
	}
	
	
	private function __renderDOM (renderer:DOMRenderer):Void {
		
		__updateCacheBitmap (renderer, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			__renderDOMClear (renderer);
			__cacheBitmap.stage = stage;
			
			DOMBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			DOMDisplayObject.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	private function __renderDOMClear (renderer:DOMRenderer):Void {
		
		DOMDisplayObject.clear (this, renderer);
		
	}
	
	
	private function __renderEvent (renderer:DisplayObjectRenderer):Void {
		
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
	
	
	private function __renderGL (renderer:OpenGLRenderer):Void {
		
		__updateCacheBitmap (renderer, false);
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			GLBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			GLDisplayObject.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	private function __renderGLMask (renderer:OpenGLRenderer):Void {
		
		if (__graphics != null) {
			
			//GLGraphics.renderMask (__graphics, renderer);
			GLShape.renderMask (this, renderer);
			
		}
		
	}
	
	
	private function __setParentRenderDirty ():Void {
		
		var renderParent = __renderParent != null ? __renderParent : parent;
		if (renderParent != null && !renderParent.__renderDirty) {
			
			renderParent.__renderDirty = true;
			renderParent.__setParentRenderDirty ();
			
		}
		
	}
	
	
	private inline function __setRenderDirty ():Void {
		
		if (!__renderDirty) {
			
			__renderDirty = true;
			__setParentRenderDirty ();
			
		}
		
	}
	
	
	private function __setStageReference (stage:Stage):Void {
		
		this.stage = stage;
		
	}
	
	
	private function __setTransformDirty ():Void {
		
		if (!__transformDirty) {
			
			__transformDirty = true;
			
			__setWorldTransformInvalid ();
			__setParentRenderDirty ();
			
		}
		
	}
	
	
	private function __setWorldTransformInvalid ():Void {
		
		__worldTransformInvalid = true;
		
	}
	
	
	private function __shouldCacheHardware (value:Null<Bool>):Null<Bool> {
		
		if (value == true || __filters != null) return true;
		
		if (value == false || (__graphics != null && !GLGraphics.isCompatible (__graphics))) {
			
			return false;
			
		}
		
		return null;
		
	}
	
	
	private function __stopAllMovieClips ():Void {
		
		
		
	}
	
	
	private function __update (transformOnly:Bool, updateChildren:Bool):Void {
		
		var renderParent = __renderParent != null ? __renderParent : parent;
		if (__isMask && renderParent == null) renderParent = __maskTarget;
		__renderable = (visible && __scaleX != 0 && __scaleY != 0 && !__isMask && (renderParent == null || !renderParent.__isMask));
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
			
			if (__objectTransform != null) {
				
				__worldColorTransform.__copyFrom (__objectTransform.colorTransform);
				
			}
			
			if (renderParent != null) {
				
				if (__supportDOM) {
					
					var worldVisible = (renderParent.__worldVisible && visible);
					__worldVisibleChanged = (__worldVisible != worldVisible);
					__worldVisible = worldVisible;
					
					var worldAlpha = alpha * renderParent.__worldAlpha;
					__worldAlphaChanged = (__worldAlpha != worldAlpha);
					__worldAlpha = worldAlpha;
					
				} else {
					
					__worldAlpha = alpha * renderParent.__worldAlpha;
					
				}
				
				__worldColorTransform.__combine (renderParent.__worldColorTransform);
				
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
					
					__worldVisibleChanged = (__worldVisible != visible);
					__worldVisible = visible;
					
					__worldAlphaChanged = (__worldAlpha != alpha);
					
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
	
	
	private function __updateCacheBitmap (renderer:DisplayObjectRenderer, force:Bool):Bool {
		
		if (__isCacheBitmapRender) return false;
		
		if (cacheAsBitmap || (renderer.__type != OPENGL && !__worldColorTransform.__isDefault ())) {
			
			var matrix = null, rect = null;
			
			__update (false, true);
			
			var needRender = (__cacheBitmap == null || (__renderDirty && (force || (__children != null && __children.length > 0) || (__graphics != null && __graphics.__dirty))) || opaqueBackground != __cacheBitmapBackground || !__cacheBitmapColorTransform.__equals (__worldColorTransform));
			var updateTransform = (needRender || (!__cacheBitmap.__worldTransform.equals (__worldTransform)));
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
				var color = opaqueBackground != null ? (0xFF << 24) | opaqueBackground : 0;
				
				if (filterWidth >= 0.5 && filterHeight >= 0.5) {
					
					if (__cacheBitmapData == null || bitmapWidth > __cacheBitmapData.width || bitmapHeight > __cacheBitmapData.height) {
						
						__cacheBitmapData = new BitmapData (bitmapWidth, bitmapHeight, true, color);
						
						if (__cacheBitmap == null) __cacheBitmap = new Bitmap ();
						__cacheBitmap.__bitmapData = __cacheBitmapData;
						__cacheBitmapRenderer = null;
						
					} else {
						
						__cacheBitmapData.__fillRect (__cacheBitmapData.rect, color, renderer.__type == OPENGL);
						
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
						
						__cacheBitmapRenderer = new OpenGLRenderer (cast (renderer, OpenGLRenderer).__gl, __cacheBitmapData);
						
					} else {
						
						if (__cacheBitmapData.image == null) {
							
							var color = opaqueBackground != null ? (0xFF << 24) | opaqueBackground : 0;
							__cacheBitmapData = new BitmapData (bitmapWidth, bitmapHeight, true, color);
							
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
				
				__cacheBitmapRenderer.__stage = stage;
				
				__cacheBitmapRenderer.__allowSmoothing = renderer.__allowSmoothing;
				__cacheBitmapRenderer.__setBlendMode (NORMAL);
				__cacheBitmapRenderer.__worldAlpha = 1 / __worldAlpha;
				
				__cacheBitmapRenderer.__worldTransform.copyFrom (__renderTransform);
				__cacheBitmapRenderer.__worldTransform.invert ();
				__cacheBitmapRenderer.__worldTransform.concat (__cacheBitmapMatrix);
				__cacheBitmapRenderer.__worldTransform.tx -= offsetX;
				__cacheBitmapRenderer.__worldTransform.ty -= offsetY;
				
				__cacheBitmapRenderer.__worldColorTransform.__copyFrom (__worldColorTransform);
				__cacheBitmapRenderer.__worldColorTransform.__invert ();
				
				__isCacheBitmapRender = true;
				
				if (__cacheBitmapRenderer.__type == OPENGL) {
					
					var parentRenderer:OpenGLRenderer = cast renderer;
					var childRenderer:OpenGLRenderer = cast __cacheBitmapRenderer;
					
					var cacheBlendMode = parentRenderer.__blendMode;
					parentRenderer.__suspendClipAndMask ();
					childRenderer.__copyShader (parentRenderer);
					
					__cacheBitmapData.__setUVRect (childRenderer.__gl, 0, 0, filterWidth, filterHeight);
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
							__cacheBitmapData2.__setUVRect (childRenderer.__gl, 0, 0, filterWidth, filterHeight);
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
							__cacheBitmapData3.__setUVRect (childRenderer.__gl, 0, 0, filterWidth, filterHeight);
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
					parentRenderer.__resumeClipAndMask ();
					parentRenderer.setViewport ();
					
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
						
						Rectangle.__pool.release (sourceRect);
						__cacheBitmap.__bitmapData = bitmap;
						__cacheBitmap.__imageVersion = bitmap.__textureVersion;
						
					}
					
				}
				
				__isCacheBitmapRender = false;
				
				if (__cacheBitmapColorTransform == null) __cacheBitmapColorTransform = new ColorTransform ();
				__cacheBitmapColorTransform.__copyFrom (__worldColorTransform);
				
				if (!__cacheBitmapColorTransform.__isDefault ()) {
					
					__cacheBitmapData.colorTransform (__cacheBitmapData.rect, __cacheBitmapColorTransform);
					
				}
				
			}
			
			if (updateTransform) {
				
				__update (false, true);
				
				Rectangle.__pool.release (rect);
				
				return true;
				
			} else {
				
				return false;
				
			}
			
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
	
	
	private function __updateChildren (transformOnly:Bool):Void {
		
		var renderParent = __renderParent != null ? __renderParent : parent;
		__renderable = (visible && __scaleX != 0 && __scaleY != 0 && !__isMask && (renderParent == null || !renderParent.__isMask));
		__worldAlpha = __alpha;
		__worldBlendMode = __blendMode;
		__worldShader = __shader;
		
		if (__transformDirty) {
			
			__transformDirty = false;
			
		}
		
	}
	
	
	private function __updateMask (maskGraphics:Graphics):Void {
		
		if (__graphics != null) {
			
			maskGraphics.__commands.overrideMatrix (this.__worldTransform);
			maskGraphics.__commands.append (__graphics.__commands);
			maskGraphics.__dirty = true;
			maskGraphics.__visible = true;
			
			if (maskGraphics.__bounds == null) {
				
				maskGraphics.__bounds = new Rectangle();
				
			}
			
			__graphics.__getBounds (maskGraphics.__bounds, @:privateAccess Matrix.__identity);
			
		}
		
	}
	
	
	private function __updateTransforms (overrideTransform:Matrix = null):Void {
		
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
	
	
	
	
	private function get_alpha ():Float {
		
		return __alpha;
		
	}
	
	
	private function set_alpha (value:Float):Float {
		
		if (value > 1.0) value = 1.0;
		if (value != __alpha) __setRenderDirty ();
		return __alpha = value;
		
	}
	
	
	private function get_blendMode ():BlendMode {
		
		return __blendMode;
		
	}
	
	
	private function set_blendMode (value:BlendMode):BlendMode {
		
		if (value == null) value = NORMAL;
		if (value != __blendMode) __setRenderDirty ();
		return __blendMode = value;
		
	}
	
	
	private function get_cacheAsBitmap ():Bool {
		
		return (__filters == null ? __cacheAsBitmap : true);
		
	}
	
	
	private function set_cacheAsBitmap (value:Bool):Bool {
		
		__setRenderDirty ();
		return __cacheAsBitmap = value;
		
	}
	
	
	private function get_cacheAsBitmapMatrix ():Matrix {
		
		return __cacheAsBitmapMatrix;
		
	}
	
	
	private function set_cacheAsBitmapMatrix (value:Matrix):Matrix {
		
		__setRenderDirty ();
		return __cacheAsBitmapMatrix = (value != null ? value.clone () : value);
		
	}
	
	
	private function get_filters ():Array<BitmapFilter> {
		
		if (__filters == null) {
			
			return new Array ();
			
		} else {
			
			return __filters.copy ();
			
		}
		
	}
	
	
	private function set_filters (value:Array<BitmapFilter>):Array<BitmapFilter> {
		
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
	
	
	private function get_height ():Float {
		
		var rect = Rectangle.__pool.get ();
		__getLocalBounds (rect);
		var height = rect.height;
		Rectangle.__pool.release (rect);
		return height;
		
	}
	
	
	private function set_height (value:Float):Float {
		
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
	
	
	private function get_loaderInfo ():LoaderInfo {
		
		if (stage != null) {
			
			return Lib.current.__loaderInfo;
			
		}
		
		return null;
		
	}
	
	
	private function get_mask ():DisplayObject {
		
		return __mask;
		
	}
	
	
	private function set_mask (value:DisplayObject):DisplayObject {
		
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
	
	
	private function get_mouseX ():Float {
		
		var mouseX = (stage != null ? stage.__mouseX : Lib.current.stage.__mouseX);
		var mouseY = (stage != null ? stage.__mouseY : Lib.current.stage.__mouseY);
		
		return __getRenderTransform ().__transformInverseX (mouseX, mouseY);
		
	}
	
	
	private function get_mouseY ():Float {
		
		var mouseX = (stage != null ? stage.__mouseX : Lib.current.stage.__mouseX);
		var mouseY = (stage != null ? stage.__mouseY : Lib.current.stage.__mouseY);
		
		return __getRenderTransform ().__transformInverseY (mouseX, mouseY);
		
	}
	
	
	private function get_name ():String {
		
		return __name;
		
	}
	
	
	private function set_name (value:String):String {
		
		return __name = value;
		
	}
	
	
	private function get_root ():DisplayObject {
		
		if (stage != null) {
			
			return Lib.current;
			
		}
		
		return null;
		
	}
	
	
	private function get_rotation ():Float {
		
		return __rotation;
		
	}
	
	
	private function set_rotation (value:Float):Float {
		
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
	
	
	private function get_scrollRect ():Rectangle {
		
		if (__scrollRect == null) {
			
			return null;
			
		}
		
		return __scrollRect.clone();
		
	}
	
	
	private function set_scrollRect (value:Rectangle):Rectangle {
		
		if (value != __scrollRect) {
			
			__setTransformDirty ();
			
			if (__supportDOM) {
				
				__setRenderDirty ();
				
			}
			
		}
		
		return __scrollRect = value;
		
	}
	
	
	private function get_shader ():Shader {
		
		return __shader;
		
	}
	
	
	private function set_shader (value:Shader):Shader {
		
		__shader = value;
		__setRenderDirty ();
		return value;
		
	}
	
	
	private function get_transform ():Transform {
		
		if (__objectTransform == null) {
			
			__objectTransform = new Transform (this);
			
		}
		
		return __objectTransform;
		
	}
	
	
	private function set_transform (value:Transform):Transform {
		
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
	
	
	private function get_visible ():Bool {
		
		return __visible;
		
	}
	
	
	private function set_visible (value:Bool):Bool {
		
		if (value != __visible) __setRenderDirty ();
		return __visible = value;
		
	}
	
	
	private function get_width ():Float {
		
		var rect = Rectangle.__pool.get ();
		__getLocalBounds (rect);
		var width = rect.width;
		Rectangle.__pool.release (rect);
		return width;
		
	}
	
	
	private function set_width (value:Float):Float {
		
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
	
	
	private function get_x ():Float {
		
		return __transform.tx;
		
	}
	
	
	private function set_x (value:Float):Float {
		
		if (value != __transform.tx) __setTransformDirty ();
		return __transform.tx = value;
		
	}
	
	
	private function get_y ():Float {
		
		return __transform.ty;
		
	}
	
	
	private function set_y (value:Float):Float {
		
		if (value != __transform.ty) __setTransformDirty ();
		return __transform.ty = value;
		
	}
	
	
}