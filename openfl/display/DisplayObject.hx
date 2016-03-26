package openfl.display; #if !openfl_legacy


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


@:access(openfl.events.Event)
@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class DisplayObject extends EventDispatcher implements IBitmapDrawable implements Dynamic<DisplayObject> {
	
	
	private static var __instanceCount = 0;
	private static var __worldRenderDirty = 0;
	private static var __worldTransformDirty = 0;
	
	private static var __cacheAsBitmapMode = false;
	
	public var alpha (get, set):Float;
	public var blendMode (default, set):BlendMode;
	public var cacheAsBitmap (get, set):Bool;
	public var cacheAsBitmapMatrix (get, set):Matrix;
	public var cacheAsBitmapSmooth (get, set):Bool;
	public var cacheAsBitmapBounds:Rectangle;
	public var filters (get, set):Array<BitmapFilter>;
	public var height (get, set):Float;
	public var loaderInfo (default, null):LoaderInfo;
	public var mask (get, set):DisplayObject;
	public var mouseX (get, null):Float;
	public var mouseY (get, null):Float;
	public var name (get, set):String;
	public var opaqueBackground:Null <Int>;
	public var parent (default, null):DisplayObjectContainer;
	public var root (get, null):DisplayObject;
	public var rotation (get, set):Float;
	public var scale9Grid:Rectangle;
	public var scaleX (get, set):Float;
	public var scaleY (get, set):Float;
	public var scrollRect (get, set):Rectangle;
	public var shader (default, set):Shader;
	public var stage (default, null):Stage;
	public var transform (get, set):Transform;
	public var visible (get, set):Bool;
	public var width (get, set):Float;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	public var __renderTransform:Matrix;
	public var __worldColorTransform:ColorTransform;
	public var __worldOffset:Point;
	public var __worldTransform:Matrix;
	
	private var __alpha:Float;
	private var __blendMode:BlendMode;
	private var __cairo:Cairo;
	private var __children:Array<DisplayObject>;
	private var __filters:Array<BitmapFilter>;
	private var __graphics:Graphics;
	private var __interactive:Bool;
	private var __isMask:Bool;
	private var __mask:DisplayObject;
	private var __maskGraphics:Graphics;
	private var __maskCached:Bool = false;
	private var __name:String;
	private var __objectTransform:Transform;
	private var __offset:Point;
	private var __renderable:Bool;
	private var __renderDirty:Bool;
	private var __rotation:Float;
	private var __rotationCosine:Float;
	private var __rotationSine:Float;
	private var __scrollRect:Rectangle;
	private var __shader:Shader;
	private var __transform:Matrix;
	private var __transformDirty:Bool;
	private var __visible:Bool;
	private var __worldAlpha:Float;
	private var __worldAlphaChanged:Bool;
	private var __worldClip:Rectangle;
	private var __worldClipChanged:Bool;
	private var __worldTransformCache:Matrix;
	private var __worldTransformChanged:Bool;
	private var __worldVisible:Bool;
	private var __worldVisibleChanged:Bool;
	private var __worldZ:Int;
	private var __cacheAsBitmap:Bool = false;
	private var __cacheAsBitmapMatrix:Matrix;
	private var __cacheAsBitmapSmooth:Bool = true;
	private var __forceCacheAsBitmap:Bool;
	private var __updateCachedBitmap:Bool;
	private var __cachedBitmap:BitmapData;
	private var __cachedBitmapBounds:Rectangle;
	private var __cachedFilterBounds:Rectangle;
	private var __cacheGLMatrix:Matrix;
	private var __updateFilters:Bool;
	
	#if (js && html5)
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	private var __style:CSSStyleDeclaration;
	#end
	
	
	private function new () {
		
		super ();
		
		__alpha = 1;
		__transform = new Matrix ();
		__visible = true;
		
		__rotation = 0;
		__rotationSine = 0;
		__rotationCosine = 1;
		
		__renderTransform = new Matrix ();
		
		__offset = new Point ();
		__worldOffset = new Point ();
		
		__worldAlpha = 1;
		__worldTransform = new Matrix ();
		__worldColorTransform = new ColorTransform ();
		
		#if dom
		__worldVisible = true;
		#end
		
		name = "instance" + (++__instanceCount);
		
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
		__getWorldTransform ().__transformInversePoint (pos);
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
		
		if (parent != null) {
			
			var bounds = new Rectangle ();
			__getBounds (bounds, __getWorldTransform ());
			
			return bounds.containsPoint (new Point (x, y));
			
		}
		
		return false;
		
	}
	
	
	public function localToGlobal (point:Point):Point {
		
		return __getWorldTransform ().transformPoint (point);
		
	}
	
	
	private function __broadcast (event:Event, notifyChilden:Bool):Bool {
		
		if (__eventMap != null && hasEventListener (event.type)) {
			
			var result = super.__dispatchEvent (event);
			
			if (event.__isCanceled) {
				
				return true;
				
			}
			
			return result;
			
		}
		
		return false;
		
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
	
	
	private function __getWorldTransform ():Matrix {
		
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
	
	
	private function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (__graphics != null) {
			
			if (!hitObject.visible || __isMask) return false;
			if (mask != null && !mask.__hitTestMask (x, y)) return false;
			
			if (__graphics.__hitTest (x, y, shapeFlag, __getWorldTransform ())) {
				
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
			
			if (__graphics.__hitTest (x, y, true, __getWorldTransform ())) {
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	public function __renderCairo (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CairoShape.render (this, renderSession);
			
		}
		
	}
	
	
	public function __renderCairoMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CairoGraphics.renderMask (__graphics, renderSession);
			
		}
		
	}
	
	
	public function __renderCanvas (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CanvasShape.render (this, renderSession);
			
		}
		
	}
	
	
	public function __renderCanvasMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CanvasGraphics.renderMask (__graphics, renderSession);
			
		}
		
	}
	
	
	public function __renderDOM (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			DOMShape.render (this, renderSession);
			
		}
		
	}
	
	
	public function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (__cacheAsBitmap) {
			__cacheGL(renderSession);
			return;
		}
		
		__preRenderGL (renderSession);
		__drawGraphicsGL (renderSession);
		__postRenderGL (renderSession);
		
	}
	
	public inline function __drawGraphicsGL (renderSession:RenderSession):Void {
		
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
	
	public inline function __preRenderGL (renderSession:RenderSession):Void {
		
		if (__scrollRect != null) {
			
			renderSession.maskManager.pushRect (__scrollRect, __renderTransform);
			
		}
		
		if (__mask != null && __maskGraphics != null && __maskGraphics.__commands.length > 0) {
			
			renderSession.maskManager.pushMask (this);
			
		}
		
	}
	
	
	public inline function __postRenderGL (renderSession:RenderSession):Void {
		
		if (__mask != null && __maskGraphics != null && __maskGraphics.__commands.length > 0) {
			
			renderSession.maskManager.popMask ();
			
		}
		
		if (__scrollRect != null) {
			
			renderSession.maskManager.popRect ();
			
		}
		
	}
	
	
	public inline function __cacheGL (renderSession:RenderSession):Void {
		
		var hasCacheMatrix = __cacheAsBitmapMatrix != null;
		var x = __cachedBitmapBounds.x;
		var y = __cachedBitmapBounds.y;
		var w = __cachedBitmapBounds.width;
		var h = __cachedBitmapBounds.height;
		
		// can't use Matrix.__temp here, it's not safe
		if (__cacheGLMatrix == null) __cacheGLMatrix = new Matrix();
		
		if (hasCacheMatrix) {
			
			// Transform the bounds
			var bmpBounds = openfl.geom.Rectangle.__temp;
			__cachedBitmapBounds.__transform(bmpBounds, __cacheAsBitmapMatrix);
			x = bmpBounds.x;
			y = bmpBounds.y;
			w = bmpBounds.width;
			h = bmpBounds.height;
			
			__cacheGLMatrix = __cacheAsBitmapMatrix.clone();
			
		} else {
			
			__cacheGLMatrix.identity();
			
		}
		
		if (w <= 0 && h <= 0) {
			
			//throw 'Error creating a cached bitmap. The texture size is ${w}x${h}';
			return;
			
		}
		
		if (__updateCachedBitmap || __updateFilters) {
			
			if (__cachedFilterBounds != null) {
				w += Math.abs(__cachedFilterBounds.x) + Math.abs(__cachedFilterBounds.width);
				h += Math.abs(__cachedFilterBounds.y) + Math.abs(__cachedFilterBounds.height);
			}

			if (__cachedBitmap == null) {
				__cachedBitmap = @:privateAccess BitmapData.__asRenderTexture ();
			}
			@:privateAccess __cachedBitmap.__resize(Math.ceil(w), Math.ceil(h));
			
			// we need to position the drawing origin to 0,0 in the texture
			var m = __cacheGLMatrix.clone();
			m.translate( -x, -y);
			// we disable the container shader, it will be applied to the final texture
			var shader = __shader;
			this.__shader = null;
			@:privateAccess __cachedBitmap.__drawGL(renderSession, this, m, true, false, true);
			this.__shader = shader;
			
			__updateCachedBitmap = false;
		}
		
		if (__updateFilters) {
			@:privateAccess BitmapFilter.__applyFilters(__filters, renderSession, __cachedBitmap, __cachedBitmap, null, null);
			__updateFilters = false;
		}
		
		// Calculate the correct position
		__cacheGLMatrix.invert();
		__cacheGLMatrix.__translateTransformed(x, y);
		__cacheGLMatrix.concat(__renderTransform);
		__cacheGLMatrix.translate ( __offset.x, __offset.y);
		
		renderSession.spriteBatch.renderBitmapData(__cachedBitmap, __cacheAsBitmapSmooth, __cacheGLMatrix, __worldColorTransform, __worldAlpha, blendMode, __shader, ALWAYS);
	}
	
	
	private function __setStageReference (stage:Stage):Void {
		
		if (this.stage != stage) {
			
			if (this.stage != null) {
				
				if (this.stage.focus == this) {
					
					this.stage.focus = null;
					
				}
				
				dispatchEvent (new Event (Event.REMOVED_FROM_STAGE, false, false));
				
			}
			
			this.stage = stage;
			
			if (stage != null) {
				
				dispatchEvent (new Event (Event.ADDED_TO_STAGE, false, false));
				
			}
			
		}
		
	}
	
	
	private inline function __setRenderDirty ():Void {
		
		if (!__renderDirty) {
			
			__updateCachedBitmap = true;
			__updateFilters = filters != null && filters.length > 0;
			__renderDirty = true;
			__worldRenderDirty++;
			
		}
		
	}
	
	
	private inline function __setTransformDirty ():Void {
		
		if (!__transformDirty) {
			
			__transformDirty = true;
			__worldTransformDirty++;
			
		}
		
	}
	
	
	public function __update (transformOnly:Bool, updateChildren:Bool, ?maskGraphics:Graphics = null):Void {
		
		__renderable = (visible && scaleX != 0 && scaleY != 0 && !__isMask);
		
		__updateTransforms ();
		
		// TODO this?
		if (parent != null && __isMask) {
			
			__maskCached = false;
			
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
		
		if (!transformOnly && __cacheAsBitmap) {
			
			// we need to update the bounds
			if (__updateCachedBitmap || __updateFilters) {
				
				if (__cachedBitmapBounds == null) {
					__cachedBitmapBounds = new Rectangle();
				}
				
				if(cacheAsBitmapBounds != null) {
					__cachedBitmapBounds.copyFrom(cacheAsBitmapBounds);
				} else {
					
					__cachedBitmapBounds.setEmpty();
					__getRenderBounds(__cachedBitmapBounds, @:privateAccess Matrix.__identity);
					
				}
				
				
				if (__filters != null) {
					
					if (__cachedFilterBounds == null) {
						__cachedFilterBounds = new Rectangle();
					}
					__cachedFilterBounds.setEmpty();
					@:privateAccess BitmapFilter.__expandBounds (__filters, __cachedFilterBounds, @:privateAccess Matrix.__identity);
					
					__cachedBitmapBounds.x += __cachedFilterBounds.x;
					__cachedBitmapBounds.y += __cachedFilterBounds.y;
					
				}
				
			}
			
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
				
				if (shader == null) {
					__shader = parent.__shader;
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
	
	
	public function __updateChildren (transformOnly:Bool):Void {
		
		__renderable = (visible && scaleX != 0 && scaleY != 0 && !__isMask);
		if (!__renderable && !__isMask) return;
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
		var local = overrided ? overrideTransform.clone () : __transform;
		
		if (__worldTransform == null) {
			
			__worldTransform = new Matrix ();
			
		}
		
		if (!overrided && parent != null) {
			
			var parentTransform = parent.__worldTransform;
			
			__worldTransform.a = local.a * parentTransform.a + local.b * parentTransform.c;
			__worldTransform.b = local.a * parentTransform.b + local.b * parentTransform.d;
			__worldTransform.c = local.c * parentTransform.a + local.d * parentTransform.c;
			__worldTransform.d = local.c * parentTransform.b + local.d * parentTransform.d;
			__worldTransform.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
			__worldTransform.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
			
			__worldOffset.copyFrom (parent.__worldOffset);
			
		} else {
			
			__worldTransform.copyFrom (local);
			__worldOffset.setTo (0, 0);
			
		}
		
		if (__scrollRect != null) {
			
			__offset = __worldTransform.deltaTransformPoint (__scrollRect.topLeft);
			__worldOffset.offset (__offset.x, __offset.y);
			
		} else {
			
			__offset.setTo (0, 0);
			
		}
		
		__renderTransform.copyFrom (__worldTransform);
		__renderTransform.translate ( -__worldOffset.x, -__worldOffset.y);
		
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
	
	
	private function set_blendMode (value:BlendMode):BlendMode {
		
		__blendMode = value;
		return blendMode = value;
		
	}
	
	private function set_shader (value:Shader):Shader {
		
		__shader = value;
		return shader = value;
		
	}
	
	
	private function get_cacheAsBitmap ():Bool {
		
		return __cacheAsBitmap;
		
	}
	
	
	private function set_cacheAsBitmap (value:Bool):Bool {
		
		__setRenderDirty ();
		return __cacheAsBitmap = __forceCacheAsBitmap ? true : value;
		
	}
	
	
	private function get_cacheAsBitmapMatrix ():Matrix {
		
		return __cacheAsBitmapMatrix;
		
	}
	
	
	private function set_cacheAsBitmapMatrix (value:Matrix):Matrix {
		
		__setRenderDirty ();
		return __cacheAsBitmapMatrix = value.clone();
		
	}
	
	
	private function get_cacheAsBitmapSmooth ():Bool {
		
		return __cacheAsBitmapSmooth;
		
	}
	
	
	private function set_cacheAsBitmapSmooth (value:Bool):Bool {
		
		return __cacheAsBitmapSmooth = value;
		
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
			__forceCacheAsBitmap = true;
			__cacheAsBitmap = true;
			__updateFilters = true;
			
		} else {
			
			__filters = null;
			__forceCacheAsBitmap = false;
			__cacheAsBitmap = false;
			__updateFilters = false;
			
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
			__mask.__maskCached = false;
			__mask.__setTransformDirty();
			__mask.__setRenderDirty();
			__maskGraphics = null;
		}
		if (value != null) value.__isMask = true;
		return __mask = value;
		
	}
	
	
	private function get_mouseX ():Float {
		
		var mouseX = (stage != null ? stage.__mouseX : Lib.current.stage.__mouseX);
		var mouseY = (stage != null ? stage.__mouseY : Lib.current.stage.__mouseY);
		
		return __getWorldTransform ().__transformInverseX (mouseX, mouseY);
		
	}
	
	
	private function get_mouseY ():Float {
		
		var mouseX = (stage != null ? stage.__mouseX : Lib.current.stage.__mouseX);
		var mouseY = (stage != null ? stage.__mouseY : Lib.current.stage.__mouseY);
		
		return __getWorldTransform ().__transformInverseY (mouseX, mouseY);
		
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
	
	
	private function get_scaleX ():Float {
		
		if (__transform.b == 0) {
			
			return __transform.a;
			
		} else {
			
			return Math.sqrt (__transform.a * __transform.a + __transform.b * __transform.b);
			
		}
		
	}
	
	
	private function set_scaleX (value:Float):Float {
		
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
	
	
	private function get_scaleY ():Float {
		
		if (__transform.c == 0) {
			
			return __transform.d;
			
		} else {
			
			return Math.sqrt (__transform.c * __transform.c + __transform.d * __transform.d);
			
		}
		
	}
	
	
	private function set_scaleY (value:Float):Float {
		
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
	
	
	private function get_scrollRect ():Rectangle {
		
		if ( __scrollRect == null ) return null;
		
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


#else
typedef DisplayObject = openfl._legacy.display.DisplayObject;
#end