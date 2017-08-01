package openfl.display;


import lime.graphics.cairo.Cairo;
import lime.ui.MouseCursor;
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
@:access(openfl.display.DisplayObjectContainer)
@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class DisplayObject extends EventDispatcher implements IBitmapDrawable #if openfl_dynamic implements Dynamic<DisplayObject> #end {
	
	
	private static var __broadcastEvents = new Map<String, Array<DisplayObject>> ();
	private static var __instanceCount = 0;
	
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
	private var __cacheBitmap:Bitmap;
	private var __cacheBitmapBackground:Int;
	private var __cacheBitmapColorTransform:ColorTransform;
	private var __cacheBitmapData:BitmapData;
	private var __cacheBitmapRender:Bool;
	private var __cairo:Cairo;
	private var __children:Array<DisplayObject>;
	private var __filters:Array<BitmapFilter>;
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
	private var __worldBlendMode:BlendMode;
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
		__worldBlendMode = NORMAL;
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
		var usingTemp = false;
		
		if (targetCoordinateSpace != null) {
			
			matrix = __getWorldTransform ().clone ();
			matrix.concat (targetCoordinateSpace.__getWorldTransform ().clone ().invert ());
			
		} else {
			
			usingTemp = true;
			matrix = Matrix.__pool.get ();
			matrix.identity ();
			
		}
		
		var bounds = new Rectangle ();
		__getBounds (bounds, matrix);
		
		if (usingTemp) {
			
			Matrix.__pool.release (matrix);
			
		}
		
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
	
	
	private function __dispatchChildren (event:Event, stack:Vector<DisplayObject>):Bool {
		
		event.target = this;
		
		if (parent != null) {
			
			event.eventPhase = CAPTURING_PHASE;
			
			if (parent == stage) {
				
				parent.__dispatchEvent (event);
				
			} else {
				
				var parent = parent;
				var i = 0;
				
				while (parent != null) {
					
					stack[i] = parent;
					parent = parent.parent;
					i++;
					
				}
				
				for (j in 0...i) {
					
					stack[i - j - 1].__dispatchEvent (event);
					
				}
				
			}
			
		}
		
		event.eventPhase = AT_TARGET;
		
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
	
	
	private function __dispatchStack (event:Event, stack:Array<DisplayObject>):Void {
		
		var target:DisplayObject;
		var length = stack.length;
		
		if (length == 0) {
			
			event.eventPhase = EventPhase.AT_TARGET;
			target = cast event.target;
			target.__dispatch (event);
			
		} else {
			
			event.eventPhase = EventPhase.CAPTURING_PHASE;
			event.target = stack[stack.length - 1];
			
			for (i in 0...length - 1) {
				
				stack[i].__dispatch (event);
				
				if (event.__isCanceled) {
					
					return;
					
				}
				
			}
			
			event.eventPhase = EventPhase.AT_TARGET;
			target = cast event.target;
			target.__dispatch (event);
			
			if (event.__isCanceled) {
				
				return;
				
			}
			
			if (event.bubbles) {
				
				event.eventPhase = EventPhase.BUBBLING_PHASE;
				var i = length - 2;
				
				while (i >= 0) {
					
					stack[i].__dispatch (event);
					
					if (event.__isCanceled) {
						
						return;
						
					}
					
					i--;
					
				}
				
			}
			
		}
		
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
		
		if (__transformDirty) {
			
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
	
	
	private function __renderCairo (renderSession:RenderSession):Void {
		
		#if lime_cairo
		__updateCacheBitmap (renderSession, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			CairoBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			CairoDisplayObject.render (this, renderSession);
			
		}
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
			
			__updateCacheBitmap (renderSession, !__worldColorTransform.__isDefault ());
			
			if (__cacheBitmap != null && !__cacheBitmapRender) {
				
				CanvasBitmap.render (__cacheBitmap, renderSession);
				
			} else {
				
				CanvasDisplayObject.render (this, renderSession);
				
			}
			
		}
		
	}
	
	
	private function __renderCanvasMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CanvasGraphics.renderMask (__graphics, renderSession);
			
		}
		
	}
	
	
	private function __renderDOM (renderSession:RenderSession):Void {
		
		#if dom
		__updateCacheBitmap (renderSession, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			__renderDOMClear (renderSession);
			__cacheBitmap.stage = stage;
			
			DOMBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			DOMDisplayObject.render (this, renderSession);
			
		}
		#end
		
	}
	
	
	private function __renderDOMClear (renderSession:RenderSession):Void {
		
		#if dom
		DOMDisplayObject.clear (this, renderSession);
		#end
		
	}
	
	
	private function __renderGL (renderSession:RenderSession):Void {
		
		__updateCacheBitmap (renderSession, false);
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			GLBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			GLDisplayObject.render (this, renderSession);
			
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
			__setParentRenderDirty ();
			
		}
		
	}
	
	
	private function __stopAllMovieClips ():Void {
		
		
		
	}
	
	
	public function __update (transformOnly:Bool, updateChildren:Bool, ?maskGraphics:Graphics = null):Void {
		
		var renderParent = __renderParent != null ? __renderParent : parent;
		__renderable = (visible && __scaleX != 0 && __scaleY != 0 && !__isMask && (renderParent == null || !renderParent.__isMask));
		__updateTransforms ();
		
		//if (updateChildren && __transformDirty) {
			
			__transformDirty = false;
			
		//}
		
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
			
			if (renderParent != null) {
				
				#if !dom
				
				__worldAlpha = alpha * renderParent.__worldAlpha;
				__worldColorTransform.__combine (renderParent.__worldColorTransform);
				
				if (__blendMode == null || __blendMode == NORMAL) {
					
					// TODO: Handle multiple blend modes better
					__worldBlendMode = renderParent.__blendMode;
					
				} else {
					
					__worldBlendMode = __blendMode;
					
				}
				
				#else
				
				var worldVisible = (renderParent.__worldVisible && visible);
				__worldVisibleChanged = (__worldVisible != worldVisible);
				__worldVisible = worldVisible;
				
				var worldAlpha = alpha * renderParent.__worldAlpha;
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
			
			//if (updateChildren && __renderDirty) {
				
				//__renderDirty = false;
				
			//}
			
		}
		
	}
	
	
	private function __updateCacheBitmap (renderSession:RenderSession, force:Bool):Void {
		
		if (__cacheBitmapRender) return;
		
		if (cacheAsBitmap) {
			
			var matrix = null, rect = null;
			
			__getWorldTransform ();
			__update (false, true);
			
			var needRender = (__cacheBitmap == null || (__renderDirty && (force || (__children != null && __children.length > 0))) || opaqueBackground != __cacheBitmapBackground || !__cacheBitmapColorTransform.__equals (__worldColorTransform));
			var updateTransform = (needRender || (!__cacheBitmap.__worldTransform.equals (__worldTransform)));
			
			if (updateTransform) {
				
				matrix = Matrix.__pool.get ();
				rect = Rectangle.__pool.get ();
				matrix.identity ();
				
				__getBounds (rect, matrix);
				
			}
			
			// TODO: Update rect size based on filter dimensions
			
			if (needRender) {
				
				__cacheBitmapBackground = opaqueBackground;
				var color = opaqueBackground != null ? (0xFF << 24) | opaqueBackground : 0;
				
				if (rect.width >= 0.5 && rect.height >= 0.5) {
					
					if (__cacheBitmap == null || rect.width != __cacheBitmap.width || rect.height != __cacheBitmap.height) {
						
						__cacheBitmapData = new BitmapData (Math.ceil (rect.width), Math.ceil (rect.height), true, color);
						//__cacheBitmapData.disposeImage ();
						
						if (__cacheBitmap == null) __cacheBitmap = new Bitmap ();
						__cacheBitmap.bitmapData = __cacheBitmapData;
						
					} else {
						
						__cacheBitmapData.fillRect (__cacheBitmapData.rect, color);
						
					}
					
				}
				
			}
			
			if (updateTransform) {
				
				__cacheBitmap.__worldTransform.copyFrom (__worldTransform);
				
				matrix.tx = Math.round (rect.x);
				matrix.ty = Math.round (rect.y);
				
				__cacheBitmap.__renderTransform.copyFrom (matrix);
				__cacheBitmap.__renderTransform.concat (__renderTransform);
				
				matrix.tx *= -1;
				matrix.ty *= -1;
				
			}
			
			__cacheBitmap.smoothing = renderSession.allowSmoothing;
			__cacheBitmap.__renderable = __renderable;
			__cacheBitmap.__worldAlpha = __worldAlpha;
			__cacheBitmap.__worldBlendMode = __worldBlendMode;
			__cacheBitmap.__scrollRect = __scrollRect;
			__cacheBitmap.filters = filters;
			
			if (needRender) {
				
				__cacheBitmapRender = true;
				
				@:privateAccess __cacheBitmapData.__draw (this, matrix, null, null, null, renderSession.allowSmoothing);
				
				if (__filters != null && __filters.length > 0) {
					
					var bitmapData = __cacheBitmapData;
					var bitmapData2 = new BitmapData (bitmapData.width, bitmapData.height, true, 0);
					var cacheBitmap;
					
					var sourceRect = bitmapData.rect;
					var destPoint = new Point (); // TODO: ObjectPool
					
					for (filter in __filters) {
						
						bitmapData2.applyFilter (bitmapData, sourceRect, destPoint, filter);
						
						cacheBitmap = bitmapData;
						bitmapData = bitmapData2;
						bitmapData2 = cacheBitmap;
						
					}
					
					__cacheBitmap.bitmapData = bitmapData;
					
				}
				
				__cacheBitmapRender = false;
				
				if (__cacheBitmapColorTransform == null) __cacheBitmapColorTransform = new ColorTransform ();
				__cacheBitmapColorTransform.__copyFrom (__worldColorTransform);
				
				if (!__cacheBitmapColorTransform.__isDefault ()) {
					
					__cacheBitmapData.colorTransform (__cacheBitmapData.rect, __cacheBitmapColorTransform);
					
				}
				
			}
			
			if (updateTransform) {
				
				__update (false, true);
				
				Matrix.__pool.release (matrix);
				Rectangle.__pool.release (rect);
				
			}
			
		} else if (__cacheBitmap != null) {
			
			#if dom
			__cacheBitmap.__renderDOMClear (renderSession);
			#end
			
			__cacheBitmap = null;
			__cacheBitmapData = null;
			__cacheBitmapColorTransform = null;
			
		}
		
	}
	
	
	public function __updateChildren (transformOnly:Bool):Void {
		
		var renderParent = __renderParent != null ? __renderParent : parent;
		__renderable = (visible && __scaleX != 0 && __scaleY != 0 && !__isMask && (renderParent == null || !renderParent.__isMask));
		__worldAlpha = alpha;
		__worldBlendMode = blendMode;
		
		if (__transformDirty) {
			
			__transformDirty = false;
			
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
		
		var renderParent = __renderParent != null ? __renderParent : parent;
		var parentTransform;
		
		if (!overrided && parent != null) {
			
			parentTransform = parent.__worldTransform;
			
			__worldTransform.a = local.a * parentTransform.a + local.b * parentTransform.c;
			__worldTransform.b = local.a * parentTransform.b + local.b * parentTransform.d;
			__worldTransform.c = local.c * parentTransform.a + local.d * parentTransform.c;
			__worldTransform.d = local.c * parentTransform.b + local.d * parentTransform.d;
			__worldTransform.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
			__worldTransform.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
			
		} else {
			
			__worldTransform.copyFrom (local);
			
		}
		
		if (!overrided && renderParent != null) {
			
			parentTransform = renderParent.__renderTransform;
			
			__renderTransform.a = local.a * parentTransform.a + local.b * parentTransform.c;
			__renderTransform.b = local.a * parentTransform.b + local.b * parentTransform.d;
			__renderTransform.c = local.c * parentTransform.a + local.d * parentTransform.c;
			__renderTransform.d = local.c * parentTransform.b + local.d * parentTransform.d;
			__renderTransform.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
			__renderTransform.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
			
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