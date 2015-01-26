package openfl._v2.display; #if lime_legacy


import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.EventPhase;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.Lib;


@:keep class DisplayObject extends EventDispatcher implements IBitmapDrawable {

	
	public var alpha (get, set):Float;
	public var blendMode (get, set):BlendMode;
	public var cacheAsBitmap (get, set):Bool;
	public var filters (get, set):Array<BitmapFilter>;
	public var graphics (get, null):Graphics;
	public var height (get, set):Float;
	public var loaderInfo:LoaderInfo;
	public var mask (default, set):DisplayObject;
	public var mouseX (get, null):Float;
	public var mouseY (get, null):Float;
	public var name (get, set):String;
	public var opaqueBackground (get, set):Null <Int>;
	public var parent (get, null):DisplayObjectContainer;
	public var pedanticBitmapCaching (get, set):Bool;
	public var root (get, null):DisplayObject;
	public var rotation (get, set):Float;
	public var scale9Grid (get, set):Rectangle;
	public var scaleX (get, set):Float;
	public var scaleY (get, set):Float;
	public var scrollRect (get, set):Rectangle;
	public var stage (get, null):Stage;
	public var transform (get, set):Transform;
	public var visible (get, set):Bool;
	public var width (get, set):Float;
	public var x (get, set):Float;
	public var y (get, set):Float;
	public var z (get, set):Float;
	
	@:noCompletion public var __handle:Dynamic;
	@:noCompletion private var __filters:Array<Dynamic>;
	@:noCompletion private var __graphicsCache:Graphics;
	@:noCompletion private var __id:Int;
	@:noCompletion private var __parent:DisplayObjectContainer;
	@:noCompletion private var __scale9Grid:Rectangle;
	@:noCompletion private var __scrollRect:Rectangle;
	
	
	public function new (handle:Dynamic, type:String) {
		
		super (this);
		
		__parent = null;
		__handle = handle;
		__id = lime_display_object_get_id (__handle);
		this.name = type + " " + __id;
		
	}
	
	
	override public function dispatchEvent (event:Event):Bool {
		
		var result = __dispatchEvent (event);
		
		if (event.__getIsCancelled ())
			return true;
		
		if (event.bubbles && parent != null && parent != this) {
			
			parent.dispatchEvent (event);
			
		}
		
		return result;
		
	}
	
	
	public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle {
		
		var result = new Rectangle ();
		lime_display_object_get_bounds (__handle, targetCoordinateSpace != null ? targetCoordinateSpace.__handle : null, result, true);
		return result;
		
	}
	
	
	public function getRect (targetCoordinateSpace:DisplayObject):Rectangle {
		
		var result = new Rectangle ();
		lime_display_object_get_bounds (__handle, targetCoordinateSpace.__handle, result, false);
		return result;
		
	}
	
	
	public function globalToLocal (point:Point):Point {
		
		var result = point.clone ();
		lime_display_object_global_to_local (__handle, result);
		return result;
		
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
		
		return lime_display_object_hit_test_point (__handle, x, y, shapeFlag, true);
		
	}
	
	
	public function localToGlobal (point:Point):Point {
		
		var result = point.clone ();
		lime_display_object_local_to_global (__handle, result);
		return result;
		
	}
	
	
	public override function toString ():String {
		
		return name;
		
	}
	
	
	@:noCompletion private function __asInteractiveObject ():InteractiveObject {
		
		return null;
		
	}
	
	
	@:noCompletion public function __broadcast (event:Event):Void {
		
		__dispatchEvent (event);
		
	}
	
	
	@:noCompletion public function __contains (child:DisplayObject):Bool {
		
		return false;
		
	}
	
	
	@:noCompletion public function __dispatchEvent (event:Event):Bool {
		
		if (event.target == null) {
			
			event.target = this;
			
		}
		
		event.currentTarget = this;
		return super.dispatchEvent (event);
		
	}
	
	
	@:noCompletion public function __drawToSurface (surface:Dynamic, matrix:Matrix, colorTransform:ColorTransform, blendMode:String, clipRect:Rectangle, smoothing:Bool):Void {
		
		lime_display_object_draw_to_surface (__handle, surface, matrix, colorTransform, blendMode, clipRect);
		
	}
	
	
	@:noCompletion private function __findByID (id:Int):DisplayObject {
		
		// TODO: Make this global, instead of walking the display list
		
		if (__id == id) {
			
			return this;
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function __fireEvent (event:Event):Void {
		
		var stack:Array<InteractiveObject> = [];
		
		if (__parent != null) {
			
			__parent.__getInteractiveObjectStack (stack);
			
		}
		
		var length = stack.length;
		
		if (stack.length > 0) {
			
			event.__setPhase (EventPhase.CAPTURING_PHASE);
			event.target = this;
			var i = length - 1;
			
			while (i >= 0) {
				
				stack[i].__dispatchEvent (event);
				
				if (event.__getIsCancelled ()) {
					
					return;
					
				}
				
				i--;
				
			}
			
		}
			
		event.__setPhase (EventPhase.AT_TARGET);
		__dispatchEvent (event);
		
		if (event.__getIsCancelled ()) {
			
			return;
			
		}
		
		if (event.bubbles) {
			
			event.__setPhase (EventPhase.BUBBLING_PHASE);
			
			for (i in 0...length) {
				
				stack[i].__dispatchEvent (event);
				
				if (event.__getIsCancelled ()) {
					
					return;
					
				}
				
			}
			
		}
		
	}
	
	
	@:noCompletion public function __getColorTransform ():ColorTransform {
		
		var colorTransform = new ColorTransform ();
		lime_display_object_get_color_transform (__handle, colorTransform, false);
		return colorTransform;
		
	}
	
	
	@:noCompletion public function __getConcatenatedColorTransform ():ColorTransform {
		
		var colorTransform = new ColorTransform();
		lime_display_object_get_color_transform (__handle, colorTransform, true);
		return colorTransform;
		
	}
	
	
	@:noCompletion public function __getConcatenatedMatrix ():Matrix {
		
		var matrix = new Matrix();
		lime_display_object_get_matrix (__handle, matrix, true);
		return matrix;
		
	}
	
	
	@:noCompletion public function __getInteractiveObjectStack (stack:Array<InteractiveObject>):Void {
		
		var interactive = __asInteractiveObject ();
		
		if (interactive != null) {
			
			stack.push (interactive);
			
		}
		
		if (__parent != null) {
			
			__parent.__getInteractiveObjectStack (stack);
			
		}
		
	}
	
	
	@:noCompletion public function __getMatrix ():Matrix {
		
		var matrix = new Matrix ();
		lime_display_object_get_matrix (__handle, matrix, false);
		return matrix;
		
	}
	
	
	@:noCompletion public function __getObjectsUnderPoint (point:Point, result:Array<DisplayObject>):Void {
		
		if (lime_display_object_hit_test_point (__handle, point.x, point.y, true, false)) {
			
			result.push (this);
			
		}
		
	}
	
	
	@:noCompletion public function __getPixelBounds ():Rectangle {
		
		var bounds = new Rectangle();
		lime_display_object_get_pixel_bounds (__handle, bounds);
		return bounds;
		
	}
	
	
	@:noCompletion private function __onAdded (object:DisplayObject, isOnStage:Bool):Void {
		
		if (object == this) {
			
			var event = new Event (Event.ADDED, true, false);
			event.target = this;
			dispatchEvent (event);
			
		}
		
		if (isOnStage) {
			
			var event = new Event (Event.ADDED_TO_STAGE, false, false);
			event.target = this;
			dispatchEvent (event);
			
		}
		
	}
	
	
	@:noCompletion private function __onRemoved (object:DisplayObject, wasOnStage:Bool):Void {
		
		if (object == this) {
			
			var event = new Event (Event.REMOVED, true, false);
			event.target = this;
			dispatchEvent (event);
			
		}
		
		if (wasOnStage) {
			
			var event = new Event (Event.REMOVED_FROM_STAGE, false, false);
			event.target = this;
			dispatchEvent (event);
			
		}
		
	}
	
	
	@:noCompletion public function __setColorTransform (colorTransform:ColorTransform):Void {
		
		lime_display_object_set_color_transform (__handle, colorTransform);
		
	}
	
	
	@:noCompletion public function __setMatrix (matrix:Matrix):Void {
		
		lime_display_object_set_matrix (__handle, matrix);
		
	}
	
	
	@:noCompletion public function __setParent (parent:DisplayObjectContainer):DisplayObjectContainer {
		
		if (parent == __parent) {
			
			return parent;
			
		}
		
		if (__parent != null) {
			
			__parent.__removeChildFromArray (this);
			__onRemoved (this, (stage != null));
			
		}
		
		__parent = parent;
		
		if (parent != null) {
			
			__onAdded (this, (stage != null));
			
		}
		
		return parent;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_alpha ():Float { return lime_display_object_get_alpha (__handle); }
	private function set_alpha (value:Float):Float {
		
		lime_display_object_set_alpha (__handle, value);
		return value;
		
	}
	
	
	private function get_opaqueBackground ():Null<Int> {
		
		var i:Int = lime_display_object_get_bg (__handle);
		
		if ((i & 0x01000000) == 0) {
			
			return null;
			
		}
		
		return i & 0xffffff;
		
	}
	
	
	private function set_opaqueBackground (value:Null<Int>):Null<Int> {
		
		if (value == null) {
			
			lime_display_object_set_bg (__handle, 0);
			
		} else {
			
			lime_display_object_set_bg (__handle, value);
			
		}
		
		return value;
		
	}
	
	
	private function get_blendMode ():BlendMode {
		
		var i:Int = lime_display_object_get_blend_mode (__handle);
		return Type.createEnumIndex (BlendMode, i);
		
	}
	
	
	private function set_blendMode (value:BlendMode):BlendMode {
		
		lime_display_object_set_blend_mode (__handle, Type.enumIndex (value));
		return value;
		
	}
	
	
	private function get_cacheAsBitmap ():Bool { return lime_display_object_get_cache_as_bitmap (__handle); }
	private function set_cacheAsBitmap (value:Bool):Bool {
		
		lime_display_object_set_cache_as_bitmap (__handle, value);
		return value;
		
	}
	
	
	private function get_pedanticBitmapCaching ():Bool { return lime_display_object_get_pedantic_bitmap_caching (__handle); }
	private function set_pedanticBitmapCaching (value:Bool):Bool {
		
		lime_display_object_set_pedantic_bitmap_caching (__handle, value);
		return value;
		
	}
	
	
	private function get_filters ():Array<BitmapFilter> {
		
		if (__filters == null) return [];
		var result = new Array<BitmapFilter> ();
		
		for (filter in __filters) {
			
			result.push (filter.clone ());
			
		}
		
		return result;
		
	}
	
	
	private function set_filters<T:BitmapFilter> (value:Array<T>):Array<BitmapFilter> {
		
		if (filters == null || value == null) {
			
			__filters = null;
			
		} else {
			
			__filters = new Array<BitmapFilter> ();
			
			for (filter in value) {
				
				if (filter != null) {
					
					__filters.push (filter.clone ());
					
				}
				
			}
			
		}
		
		lime_display_object_set_filters (__handle, __filters);
		return filters;
		
	}
	
	
	private function get_graphics ():Graphics {
		
		if (__graphicsCache == null) {
			
			__graphicsCache = new Graphics (lime_display_object_get_graphics (__handle));
			
		}
		
		return __graphicsCache;
		
	}
	
	
	private function get_height ():Float { return lime_display_object_get_height (__handle); }
	private function set_height (value:Float):Float {
		
		lime_display_object_set_height (__handle, value);
		return value;
		
	}
	
	
	private function set_mask (value:DisplayObject):DisplayObject {
		
		mask = value;
		lime_display_object_set_mask (__handle, value == null ? null : value.__handle);
		return value;
		
	}
	
	
	private function get_mouseX ():Float { return lime_display_object_get_mouse_x (__handle); }
	private function get_mouseY ():Float { return lime_display_object_get_mouse_y (__handle); }
	
	
	private function get_name ():String { return lime_display_object_get_name (__handle); }
	private function set_name (value:String):String {
		
		lime_display_object_set_name (__handle, value);
		return value;
		
	}
	
	
	private function get_parent ():DisplayObjectContainer { return __parent; }
	
	
	private function get_root ():DisplayObject {
		
		if (stage != null) {
			
			return Lib.current;
			
		}
		
		return null;
		
	}
	
	
	private function get_rotation ():Float { return lime_display_object_get_rotation (__handle); }
	private function set_rotation (value:Float):Float {
		
		lime_display_object_set_rotation (__handle, value);
		return value;
		
	}
	
	
	private function get_scale9Grid ():Rectangle { return (__scale9Grid == null) ? null : __scale9Grid.clone (); }
	private function set_scale9Grid (value:Rectangle):Rectangle {
		
		__scale9Grid = (value == null) ? null : value.clone ();
		lime_display_object_set_scale9_grid (__handle, __scale9Grid);
		return value;
		
	}
	
	
	private function get_scaleX ():Float { return lime_display_object_get_scale_x (__handle); }
	private function set_scaleX (value:Float):Float {
		
		lime_display_object_set_scale_x (__handle, value);
		return value;
		
	}
	
	
	private function get_scaleY ():Float { return lime_display_object_get_scale_y (__handle); }
	private function set_scaleY (value:Float):Float {
		
		lime_display_object_set_scale_y (__handle, value);
		return value;
		
	}
	
	
	private function get_scrollRect ():Rectangle { return (__scrollRect == null) ? null : __scrollRect.clone (); }
	private function set_scrollRect (value:Rectangle):Rectangle {
		
		__scrollRect = (value == null) ? null : value.clone ();
		lime_display_object_set_scroll_rect (__handle, __scrollRect);
		return value;
		
	}
	
	
	private function get_stage ():Stage {
		
		if (__parent != null) {
			
			return __parent.stage;
			
		}
		
		return null;
		
	}
	
	
	private function get_transform ():Transform { return new Transform (this); }
	private function set_transform (value:Transform):Transform {
		
		__setMatrix (value.matrix);
		__setColorTransform (value.colorTransform);
		return value;
		
	}
	
	
	private function get_visible ():Bool { return lime_display_object_get_visible (__handle);	}
	private function set_visible (value:Bool):Bool {
		
		lime_display_object_set_visible (__handle, value);
		return value;
		
	}
	
	
	private function get_width ():Float { return lime_display_object_get_width (__handle); }
	private function set_width (value:Float):Float {
		
		lime_display_object_set_width (__handle, value);
		return value;
		
	}
	
	
	private function get_x ():Float { return lime_display_object_get_x (__handle); }
	private function set_x (value:Float):Float {
		
		lime_display_object_set_x (__handle, value);
		return value;
		
	}
	
	
	private function get_y ():Float { return lime_display_object_get_y (__handle); }
	private function set_y (value:Float):Float {
		
		lime_display_object_set_y (__handle, value);
		return value;
		
	}
	

	private function get_z ():Float { return lime_display_object_get_z (__handle); }
	private function set_z (value:Float):Float {
		
		lime_display_object_set_z (__handle, value);
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_create_display_object = Lib.load ("lime", "lime_create_display_object", 0);
	private static var lime_display_object_get_graphics = Lib.load ("lime", "lime_display_object_get_graphics", 1);
	private static var lime_display_object_draw_to_surface = Lib.load ("lime", "lime_display_object_draw_to_surface", -1);
	private static var lime_display_object_get_id = Lib.load ("lime", "lime_display_object_get_id", 1);
	private static var lime_display_object_get_x = Lib.load ("lime", "lime_display_object_get_x", 1);
	private static var lime_display_object_set_x = Lib.load ("lime", "lime_display_object_set_x", 2);
	private static var lime_display_object_get_y = Lib.load ("lime", "lime_display_object_get_y", 1);
	private static var lime_display_object_set_y = Lib.load ("lime", "lime_display_object_set_y", 2);
	private static var lime_display_object_get_z = Lib.load ("lime", "lime_display_object_get_z", 1);
	private static var lime_display_object_set_z = Lib.load ("lime", "lime_display_object_set_z", 2);
	private static var lime_display_object_get_scale_x = Lib.load ("lime", "lime_display_object_get_scale_x", 1);
	private static var lime_display_object_set_scale_x = Lib.load ("lime", "lime_display_object_set_scale_x", 2);
	private static var lime_display_object_get_scale_y = Lib.load ("lime", "lime_display_object_get_scale_y", 1);
	private static var lime_display_object_set_scale_y = Lib.load ("lime", "lime_display_object_set_scale_y", 2);
	private static var lime_display_object_get_mouse_x = Lib.load ("lime", "lime_display_object_get_mouse_x", 1);
	private static var lime_display_object_get_mouse_y = Lib.load ("lime", "lime_display_object_get_mouse_y", 1);
	private static var lime_display_object_get_rotation = Lib.load ("lime", "lime_display_object_get_rotation", 1);
	private static var lime_display_object_set_rotation = Lib.load ("lime", "lime_display_object_set_rotation", 2);
	private static var lime_display_object_get_bg = Lib.load ("lime", "lime_display_object_get_bg", 1);
	private static var lime_display_object_set_bg = Lib.load ("lime", "lime_display_object_set_bg", 2);
	private static var lime_display_object_get_name = Lib.load ("lime", "lime_display_object_get_name", 1);
	private static var lime_display_object_set_name = Lib.load ("lime", "lime_display_object_set_name", 2);
	private static var lime_display_object_get_width = Lib.load ("lime", "lime_display_object_get_width", 1);
	private static var lime_display_object_set_width = Lib.load ("lime", "lime_display_object_set_width", 2);
	private static var lime_display_object_get_height = Lib.load ("lime", "lime_display_object_get_height", 1);
	private static var lime_display_object_set_height = Lib.load ("lime", "lime_display_object_set_height", 2);
	private static var lime_display_object_get_alpha = Lib.load ("lime", "lime_display_object_get_alpha", 1);
	private static var lime_display_object_set_alpha = Lib.load ("lime", "lime_display_object_set_alpha", 2);
	private static var lime_display_object_get_blend_mode = Lib.load ("lime", "lime_display_object_get_blend_mode", 1);
	private static var lime_display_object_set_blend_mode = Lib.load ("lime", "lime_display_object_set_blend_mode", 2);
	private static var lime_display_object_get_cache_as_bitmap = Lib.load ("lime", "lime_display_object_get_cache_as_bitmap", 1);
	private static var lime_display_object_set_cache_as_bitmap = Lib.load ("lime", "lime_display_object_set_cache_as_bitmap", 2);
	private static var lime_display_object_get_pedantic_bitmap_caching = Lib.load ("lime", "lime_display_object_get_pedantic_bitmap_caching", 1);
	private static var lime_display_object_set_pedantic_bitmap_caching = Lib.load ("lime", "lime_display_object_set_pedantic_bitmap_caching", 2);
	private static var lime_display_object_get_visible = Lib.load ("lime", "lime_display_object_get_visible", 1);
	private static var lime_display_object_set_visible = Lib.load ("lime", "lime_display_object_set_visible", 2);
	private static var lime_display_object_set_filters = Lib.load ("lime", "lime_display_object_set_filters", 2);
	private static var lime_display_object_global_to_local = Lib.load ("lime", "lime_display_object_global_to_local", 2);
	private static var lime_display_object_local_to_global = Lib.load ("lime", "lime_display_object_local_to_global", 2);
	private static var lime_display_object_set_scale9_grid = Lib.load ("lime", "lime_display_object_set_scale9_grid", 2);
	private static var lime_display_object_set_scroll_rect = Lib.load ("lime", "lime_display_object_set_scroll_rect", 2);
	private static var lime_display_object_set_mask = Lib.load ("lime", "lime_display_object_set_mask", 2);
	private static var lime_display_object_set_matrix = Lib.load ("lime", "lime_display_object_set_matrix", 2);
	private static var lime_display_object_get_matrix = Lib.load ("lime", "lime_display_object_get_matrix", 3);
	private static var lime_display_object_get_color_transform = Lib.load ("lime", "lime_display_object_get_color_transform", 3);
	private static var lime_display_object_set_color_transform = Lib.load ("lime", "lime_display_object_set_color_transform", 2);
	private static var lime_display_object_get_pixel_bounds = Lib.load ("lime", "lime_display_object_get_pixel_bounds", 2);
	private static var lime_display_object_get_bounds = Lib.load ("lime", "lime_display_object_get_bounds", 4);
	private static var lime_display_object_hit_test_point = Lib.load ("lime", "lime_display_object_hit_test_point", 5);
	
	
}


#end