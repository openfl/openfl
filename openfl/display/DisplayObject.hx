package openfl.display;


import lime.graphics.cairo.Cairo;
import lime.ui.MouseCursor;
import openfl._internal.renderer.cairo.CairoDisplayObject;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasDisplayObject;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.dom.DOMDisplayObject;
import openfl._internal.renderer.opengl.GLDisplayObject;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Stage;
import openfl.errors.TypeError;
import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.Lib;
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

@:access(openfl.events.Event)
@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class DisplayObject extends EventDispatcher implements IBitmapDrawable #if openfl_dynamic implements Dynamic<DisplayObject> #end {
	
	
	private static var __broadcastEvents = new Map<String, Array<DisplayObject>> ();
	private static var __instanceCount = 0;
	private static var __worldRenderDirty = 0;
	private static var __worldTransformDirty = 0;
	
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
	public var opaqueBackground:Null <Int>;
	public var parent (default, null):DisplayObjectContainer;
	public var root (get, never):DisplayObject;
	@:keep public var rotation (get, set):Float;
	public var scale9Grid:Rectangle;
	@:keep public var scaleX (get, set):Float;
	@:keep public var scaleY (get, set):Float;
	public var scrollRect (get, set):Rectangle;
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
	private var __cairo:Cairo;
	private var __children:Array<DisplayObject>;
	private var __filters:Array<BitmapFilter>;
	private var __forceCacheAsBitmap:Bool;
	private var __graphics:Graphics;
	private var __interactive:Bool;
	private var __isMask:Bool;
	private var __loaderInfo:LoaderInfo;
	private var __mask:DisplayObject;
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
	private var __transform:Matrix;
	private var __transformDirty:Bool;
	private var __visible:Bool;
	private var __worldAlpha:Float;
	private var __worldAlphaChanged:Bool;
	private var __worldClip:Rectangle;
	private var __worldClipChanged:Bool;
	private var __worldColorTransform:ColorTransform;
	private var __worldTransform:Matrix;
	private var __worldVisible:Bool;
	private var __worldVisibleChanged:Bool;
	private var __worldZ:Int;
	
	#if (js && html5)
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	private var __style:CSSStyleDeclaration;
	#end
	
	
	private function new () {
		
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
		__worldTransform = new Matrix ();
		__worldColorTransform = new ColorTransform ();
		__renderTransform = new Matrix ();
		
		#if dom
		__worldVisible = true;
		#end
		
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
		
		return super.dispatchEvent (event);
		
	}
	
	
	public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle {
		
		var matrix;
		
		if (targetCoordinateSpace != null) {
			
			matrix = __getWorldTransform ().clone ();
			matrix.concat (targetCoordinateSpace.__getWorldTransform ().clone ().invert ());
			
		} else {
			
			matrix = Matrix.__temp;
			matrix.identity ();
			
		}
		
		var bounds = new Rectangle ();
		__getBounds (bounds, matrix);
		
		return bounds;
		
	}
	
	
	public function getRect (targetCoordinateSpace:DisplayObject):Rectangle {
		
		// should not account for stroke widths, but is that possible?
		return getBounds (targetCoordinateSpace);
		
	}
	
	
	public function globalToLocal (pos:Point):Point {
		
		pos = pos.clone ();
		__getRenderTransform ().__transformInversePoint (pos);
		return pos;
		
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
			
			default:
			
		}
		
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
	
	
	private function __dispatchChildren (event:Event):Bool {
		
		return __dispatchEvent (event);
		
	}
	
	
	private override function __dispatchEvent (event:Event):Bool {
		
		var result = super.__dispatchEvent (event);
		
		if (event.__isCanceled) {
			
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
	
	
	private function __getInteractive (stack:Array<DisplayObject>):Bool {
		
		return false;
		
	}
	
	
	private inline function __getLocalBounds (rect:Rectangle):Void {
		
		__getBounds (rect, __transform);
		
	}
	
	
	private function __getRenderBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__scrollRect == null) {
			
			__getBounds (rect, matrix);
			
		} else {
			
			var r = openfl.geom.Rectangle.__temp;
			r.copyFrom (__scrollRect);
			r.__transform (r, matrix);
			rect.__expand (matrix.tx, matrix.ty, r.width, r.height);
			
		}
		
	}
	
	
	private function __getRenderTransform ():Matrix {
		
		__getWorldTransform ();
		return __renderTransform;
		
	}
	
	
	private function __getWorldTransform ():Matrix {
		
		if (__transformDirty || __worldTransformDirty > 0) {
			
			var list = [];
			var current = this;
			var transformDirty = __transformDirty;
			
			if (parent == null) {
				
				if (transformDirty) __update (true, false);
				
			} else {
				
				while (current != stage) {
					
					list.push (current);
					current = current.parent;
					
					if (current == null) break;
					
					if (current != stage && current.__transformDirty) {
						
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
	
	
	private function __renderCairo (renderSession:RenderSession):Void {
		
		#if lime_cairo
		CairoDisplayObject.render (this, renderSession);
		#end
		
	}
	
	
	private function __renderCairoMask (renderSession:RenderSession):Void {
		
		#if lime_cairo
		if (__graphics != null) {
			
			CairoGraphics.renderMask (__graphics, renderSession);
			
		}
		#end
		
	}
	
	
	private function __renderCanvas (renderSession:RenderSession):Void {
		
		if (mask == null || (mask.width > 0 && mask.height > 0)) {
			
			CanvasDisplayObject.render (this, renderSession);
			
		}
		
	}
	
	
	private function __renderCanvasMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CanvasGraphics.renderMask (__graphics, renderSession);
			
		}
		
	}
	
	
	private function __renderDOM (renderSession:RenderSession):Void {
		
		#if dom
		DOMDisplayObject.render (this, renderSession);
		#end
		
	}
	
	
	private function __renderGL (renderSession:RenderSession):Void {
		
		GLDisplayObject.render (this, renderSession);
		
	}
	
	
	private inline function __setRenderDirty ():Void {
		
		if (!__renderDirty) {
			
			__renderDirty = true;
			__worldRenderDirty++;
			
		}
		
	}
	
	
	private function __setStageReference (stage:Stage):Void {
		
		this.stage = stage;
		
	}
	
	
	private inline function __setTransformDirty ():Void {
		
		if (!__transformDirty) {
			
			__transformDirty = true;
			__worldTransformDirty++;
			
		}
		
	}
	
	
	private function __stopAllMovieClips ():Void {
		
		
		
	}
	
	
	public function __update (transformOnly:Bool, updateChildren:Bool, ?maskGraphics:Graphics = null):Void {
		
		__renderable = (visible && __scaleX != 0 && __scaleY != 0 && !__isMask && (parent == null || !parent.__isMask));
		__updateTransforms ();
		
		if (updateChildren && __transformDirty) {
			
			__transformDirty = false;
			__worldTransformDirty--;
			
		}
		
		if (maskGraphics != null) {
			
			__updateMask (maskGraphics);
			
		}
		
		if (!transformOnly) {
			
			#if dom
			__renderTransformChanged = !__renderTransform.equals (__renderTransformCache);
			
			if (__renderTransformCache == null) {
				
				__renderTransformCache = __renderTransform.clone ();
				
			} else {
				
				__renderTransformCache.copyFrom (__renderTransform);
				
			}
			#end
			
			if (!__worldColorTransform.__equals (transform.colorTransform)) {
				
				__worldColorTransform = transform.colorTransform.__clone ();
				
			}
			
			var __parent = (parent != null) ? parent : __renderParent;
			
			if (__parent != null) {
				
				#if !dom
				
				__worldAlpha = alpha * __parent.__worldAlpha;
				__worldColorTransform.__combine (__parent.__worldColorTransform);
				
				if ((blendMode == null || blendMode == NORMAL)) {
					
					__blendMode = __parent.__blendMode;
					
				}
				
				#else
				
				var worldVisible = (__parent.__worldVisible && visible);
				__worldVisibleChanged = (__worldVisible != worldVisible);
				__worldVisible = worldVisible;
				
				var worldAlpha = alpha * __parent.__worldAlpha;
				__worldAlphaChanged = (__worldAlpha != worldAlpha);
				__worldAlpha = worldAlpha;
				
				#end
				
			} else {
				
				__worldAlpha = alpha;
				
				#if dom
				
				__worldVisibleChanged = (__worldVisible != visible);
				__worldVisible = visible;
				
				__worldAlphaChanged = (__worldAlpha != alpha);
				
				#end
				
			}
			
			if (updateChildren && __renderDirty) {
				
				__renderDirty = false;
				
			}
			
		}
		
	}
	
	
	public function __updateChildren (transformOnly:Bool):Void {
		
		__renderable = (visible && __scaleX != 0 && __scaleY != 0 && !__isMask && (parent == null || !parent.__isMask));
		__worldAlpha = alpha;
		
		if (__transformDirty) {
			
			__transformDirty = false;
			__worldTransformDirty--;
			
		}
		
	}
	
	
	public function __updateMask (maskGraphics:Graphics):Void {
		
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
	
	
	public function __updateTransforms (overrideTransform:Matrix = null):Void {
		
		var overrided = overrideTransform != null;
		var local = overrided ? overrideTransform : __transform;
		
		if (__worldTransform == null) {
			
			__worldTransform = new Matrix ();
			
		}
		
		if (__renderTransform == null) {
			
			__renderTransform = new Matrix ();
			
		}
		
		if (!overrided && parent != null) {
			
			var parentTransform = parent.__worldTransform;
			
			__worldTransform.a = local.a * parentTransform.a + local.b * parentTransform.c;
			__worldTransform.b = local.a * parentTransform.b + local.b * parentTransform.d;
			__worldTransform.c = local.c * parentTransform.a + local.d * parentTransform.c;
			__worldTransform.d = local.c * parentTransform.b + local.d * parentTransform.d;
			__worldTransform.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
			__worldTransform.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
			
			parentTransform = parent.__renderTransform;
			
			__renderTransform.a = local.a * parentTransform.a + local.b * parentTransform.c;
			__renderTransform.b = local.a * parentTransform.b + local.b * parentTransform.d;
			__renderTransform.c = local.c * parentTransform.a + local.d * parentTransform.c;
			__renderTransform.d = local.c * parentTransform.b + local.d * parentTransform.d;
			__renderTransform.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
			__renderTransform.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
			
		} else {
			
			__worldTransform.copyFrom (local);
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
		return __cacheAsBitmapMatrix = value.clone ();
		
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
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		return bounds.height;
		
	}
	
	
	private function set_height (value:Float):Float {
		
		var bounds = new Rectangle ();
		
		var matrix = Matrix.__temp;
		matrix.identity ();
		
		__getBounds (bounds, matrix);
		
		if (value != bounds.height) {
			
			scaleY = value / bounds.height;
			
		} else {
			
			scaleY = 1;
			
		}
		
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
		
		if (value != __mask) {
			
			__setTransformDirty ();
			__setRenderDirty ();
			
		}
		
		if (__mask != null) {
			
			__mask.__isMask = false;
			__mask.__setTransformDirty ();
			__mask.__setRenderDirty ();
			
		}
		
		if (value != null) {
			
			value.__isMask = true;
			
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
			#if dom __setRenderDirty (); #end
			
		}
		
		return __scrollRect = value;
		
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
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		return bounds.width;
		
	}
	
	
	private function set_width (value:Float):Float {
		
		var bounds = new Rectangle ();
		
		var matrix = Matrix.__temp;
		matrix.identity ();
		
		__getBounds (bounds, matrix);
		
		if (value != bounds.width) {
			
			scaleX = value / bounds.width;
			
		} else {
			
			scaleX = 1;
			
		}
		
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