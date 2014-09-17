package openfl.display; #if !flash #if (next || js)


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

#if js
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
import js.html.Element;
#end


@:access(openfl.events.Event)
@:access(openfl.display.Stage)
class DisplayObject extends EventDispatcher implements IBitmapDrawable {
	
	
	private static var __instanceCount = 0;
	private static var __worldRenderDirty = 0;
	private static var __worldTransformDirty = 0;
	
	public var alpha (get, set):Float;
	public var blendMode:BlendMode;
	public var cacheAsBitmap:Bool;
	public var filters (get, set):Array<BitmapFilter>;
	public var height (get, set):Float;
	public var loaderInfo:LoaderInfo;
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
	public var stage (default, null):Stage;
	public var transform (get, set):Transform;
	public var visible (get, set):Bool;
	public var width (get, set):Float;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	public var __worldTransform:Matrix;
	
	private var __alpha:Float;
	private var __filters:Array<BitmapFilter>;
	private var __graphics:Graphics;
	private var __interactive:Bool;
	private var __isMask:Bool;
	private var __mask:DisplayObject;
	private var __name:String;
	private var __renderable:Bool;
	private var __renderDirty:Bool;
	private var __rotation:Float;
	private var __rotationCache:Float;
	private var __rotationCosine:Float;
	private var __rotationSine:Float;
	private var __scaleX:Float;
	private var __scaleY:Float;
	private var __scrollRect:Rectangle;
	private var __transform:Transform;
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
	private var __x:Float;
	private var __y:Float;
	
	#if js
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	private var __style:CSSStyleDeclaration;
	#end
	
	
	private function new () {
		
		super ();
		
		alpha = 1;
		rotation = 0;
		scaleX = 1;
		scaleY = 1;
		visible = true;
		x = 0;
		y = 0;
		
		__worldAlpha = 1;
		__worldTransform = new Matrix ();
		__rotationCache = 0;
		__rotationSine = 0;
		__rotationCosine = 1;
		
		#if dom
		__worldVisible = true;
		#end
		
		name = "instance" + (++__instanceCount);
		
	}
	
	
	public override function dispatchEvent (event:Event):Bool {
		
		var result = super.dispatchEvent (event);
		
		if (event.__isCancelled) {
			
			return true;
			
		}
		
		if (event.bubbles && parent != null && parent != this) {
			
			event.eventPhase = EventPhase.BUBBLING_PHASE;
			parent.dispatchEvent (event);
			
		}
		
		return result;
		
	}
	
	
	public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle {
		
		var matrix = __getTransform ();
		
		if (targetCoordinateSpace != null) {
			
			matrix = matrix.clone ();
			matrix.concat (targetCoordinateSpace.__worldTransform.clone ().invert ());
			
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
		
		return __getTransform ().clone ().invert ().transformPoint (pos);
		
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
			
			var currentBounds = getBounds (this);
			return currentBounds.containsPoint (new Point (x, y));
			
		}
		
		return false;
		
	}
	
	
	public function localToGlobal (point:Point):Point {
		
		return __getTransform ().transformPoint (point);
		
	}
	
	
	private function __broadcast (event:Event, notifyChilden:Bool):Bool {
		
		if (__eventMap != null && hasEventListener (event.type)) {
			
			var result = super.dispatchEvent (event);
			
			if (event.__isCancelled) {
				
				return true;
				
			}
			
			return result;
			
		}
		
		return false;
		
	}
	
	
	private function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		
		
	}
	
	
	private function __getInteractive (stack:Array<DisplayObject>):Void {
		
		
		
	}
	
	
	private inline function __getLocalBounds (rect:Rectangle):Void {
		
		__getTransform ();
		__getBounds (rect, new Matrix ());
		
	}
	
	
	private function __getTransform ():Matrix {
		
		if (__worldTransformDirty > 0) {
			
			var list = [];
			var current = this;
			var transformDirty = __transformDirty;
			
			while (current.parent != null) {
				
				list.push (current);
				current = current.parent;
				
				if (current.__transformDirty) {
					
					transformDirty = true;
					
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
	
	
	private function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		return false;
		
	}
	
	
	public function __renderCanvas (renderSession:RenderSession):Void {
		
		
		
	}
	
	
	public function __renderDOM (renderSession:RenderSession):Void {
		
		
		
	}
	
	
	public function __renderGL (renderSession:RenderSession):Void {
		
		
		
	}
	
	
	public function __renderMask (renderSession:RenderSession):Void {
		
		
		
	}
	
	
	private function __setStageReference (stage:Stage):Void {
		
		if (this.stage != stage) {
			
			if (this.stage != null) {
				
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
	
	
	public function __update (transformOnly:Bool, updateChildren:Bool):Void {
		
		__renderable = (visible && scaleX != 0 && scaleY != 0 && !__isMask);
		//if (!__renderable && !__isMask) return;
		
		if (rotation != __rotationCache) {
			
			__rotationCache = rotation;
			var radians = rotation * (Math.PI / 180);
			__rotationSine = Math.sin (radians);
			__rotationCosine = Math.cos (radians);
			
		}
		
		if (parent != null) {
			
			var parentTransform = parent.__worldTransform;
			
			var a00 = __rotationCosine * scaleX,
			a01 = __rotationSine * scaleX,
			a10 = -__rotationSine * scaleY,
			a11 = __rotationCosine * scaleY,
			b00 = parentTransform.a, b01 = parentTransform.b,
			b10 = parentTransform.c, b11 = parentTransform.d;
			
			__worldTransform.a = a00 * b00 + a01 * b10;
			__worldTransform.b = a00 * b01 + a01 * b11;
			__worldTransform.c = a10 * b00 + a11 * b10;
			__worldTransform.d = a10 * b01 + a11 * b11;
			
			if (scrollRect == null) {
				
				__worldTransform.tx = x * b00 + y * b10 + parentTransform.tx;
				__worldTransform.ty = x * b01 + y * b11 + parentTransform.ty;
				
			} else {
				
				__worldTransform.tx = (x - scrollRect.x) * b00 + (y - scrollRect.y) * b10 + parentTransform.tx;
				__worldTransform.ty = (x - scrollRect.x) * b01 + (y - scrollRect.y) * b11 + parentTransform.ty;
				
			}
			
		} else {
			
			__worldTransform.a = __rotationCosine * scaleX;
			__worldTransform.c = -__rotationSine * scaleY;
			__worldTransform.b = __rotationSine * scaleX;
			__worldTransform.d = __rotationCosine * scaleY;
			
			if (scrollRect == null) {
				
				__worldTransform.tx = x;
				__worldTransform.ty = y;
				
			} else {
				
				__worldTransform.tx = y - scrollRect.x;
				__worldTransform.ty = y - scrollRect.y;
				
			}
			
		}
		
		if (updateChildren && __transformDirty) {
			
			__transformDirty = false;
			__worldTransformDirty--;
			
		}
		
		if (!transformOnly) {
			
			#if dom
			__worldTransformChanged = !__worldTransform.equals (__worldTransformCache);
			__worldTransformCache = __worldTransform.clone ();
			
			var worldClip:Rectangle = null;
			#end
			
			if (parent != null) {
				
				#if !dom
				
				__worldAlpha = alpha * parent.__worldAlpha;
				
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
					bounds = bounds.transform (__worldTransform);
					
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
					
					worldClip = scrollRect.clone ().transform (__worldTransform);
					
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
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_alpha ():Float {
		
		return __alpha;
		
	}
	
	
	private function set_alpha (value:Float):Float {
		
		if (value != __alpha) __setRenderDirty ();
		return __alpha = value;
		
	}
	
	
	private function get_filters ():Array<BitmapFilter> {
		
		if (__filters == null) {
			
			return new Array ();
			
		} else {
			
			return __filters.copy ();
			
		}
		
	}
	
	
	private function set_filters (value:Array<BitmapFilter>):Array<BitmapFilter> {
		
		// set
		
		return value;
		
	}
	
	
	private function get_height ():Float {
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		return bounds.height * scaleY;
		
	}
	
	
	private function set_height (value:Float):Float {
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
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
		
		if (value != __mask) __setRenderDirty ();
		if (__mask != null) __mask.__isMask = false;
		if (value != null) value.__isMask = true;
		return __mask = value;
		
	}
	
	
	private function get_mouseX ():Float {
		
		if (stage != null) {
			
			return globalToLocal (new Point (stage.__mouseX, 0)).x;
			
		}
		
		return 0;
		
	}
	
	
	private function get_mouseY ():Float {
		
		if (stage != null) {
			
			return globalToLocal (new Point (0, stage.__mouseY)).y;
			
		}
		
		return 0;
		
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
		
		if (value != __rotation) __setTransformDirty ();
		return __rotation = value;
		
	}
	
	
	private function get_scaleX ():Float {
		
		return __scaleX;
		
	}
	
	
	private function set_scaleX (value:Float):Float {
		
		if (value != __scaleX) __setTransformDirty ();
		return __scaleX = value;
		
	}
	
	
	private function get_scaleY ():Float {
		
		return __scaleY;
		
	}
	
	
	private function set_scaleY (value:Float):Float {
		
		if (__scaleY != value) __setTransformDirty ();
		return __scaleY = value;
		
	}
	
	
	private function get_scrollRect ():Rectangle {
		
		return __scrollRect;
		
	}
	
	
	private function set_scrollRect (value:Rectangle):Rectangle {
		
		if (value != __scrollRect) {
			
			__setTransformDirty ();
			#if dom __setRenderDirty (); #end
			
		}
		
		return __scrollRect = value;
		
	}
	
	
	private function get_transform ():Transform {
		
		if (__transform == null) {
			
			__transform = new Transform (this);
			
		}
		
		return __transform;
		
	}
	
	
	private function set_transform (value:Transform):Transform {
		
		if (value == null) {
			
			throw new TypeError ("Parameter transform must be non-null.");
			
		}
		
		if (__transform == null) {
			
			__transform = new Transform (this);
			
		}
		
		__setTransformDirty ();
		__transform.matrix = value.matrix.clone ();
		__transform.colorTransform = new ColorTransform (value.colorTransform.redMultiplier, value.colorTransform.greenMultiplier, value.colorTransform.blueMultiplier, value.colorTransform.alphaMultiplier, value.colorTransform.redOffset, value.colorTransform.greenOffset, value.colorTransform.blueOffset, value.colorTransform.alphaOffset);
		
		return __transform;
		
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
		
		return bounds.width * scaleX;
		
	}
	
	
	private function set_width (value:Float):Float {
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		if (value != bounds.width) {
			
			scaleX = value / bounds.width;
			
		} else {
			
			scaleX = 1;
			
		}
		
		return value;
		
	}
	
	
	private function get_x ():Float {
		
		return __x;
		
	}
	
	
	private function set_x (value:Float):Float {
		
		if (value != __x) __setTransformDirty ();
		return __x = value;
		
	}
	
	
	private function get_y ():Float {
		
		return __y;
		
	}
	
	
	private function set_y (value:Float):Float {
		
		if (value != __y) __setTransformDirty ();
		return __y = value;
		
	}
	
	
}


#else
typedef DisplayObject = openfl._v2.display.DisplayObject;
#end
#else
typedef DisplayObject = flash.display.DisplayObject;
#end