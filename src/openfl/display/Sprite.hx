package openfl.display;


import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.canvas.CanvasShape;
import openfl._internal.renderer.dom.DOMShape;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if (lime >= "7.0.0")
import lime.ui.Cursor;
#else
import lime.ui.MouseCursor in Cursor;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.geom.Point)


class Sprite extends DisplayObjectContainer {
	
	
	public var buttonMode (get, set):Bool;
	public var dropTarget (default, null):DisplayObject;
	public var graphics (get, never):Graphics;
	public var hitArea:Sprite;
	public var useHandCursor:Bool;
	
	private var __buttonMode:Bool;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (Sprite.prototype, {
			"buttonMode": { get: untyped __js__ ("function () { return this.get_buttonMode (); }"), set: untyped __js__ ("function (v) { return this.set_buttonMode (v); }") },
			"graphics": { get: untyped __js__ ("function () { return this.get_graphics (); }") },
		});
		
	}
	#end
	
	
	public function new () {
		
		super ();
		
		__buttonMode = false;
		useHandCursor = true;
		
	}
	
	
	public function startDrag (lockCenter:Bool = false, bounds:Rectangle = null):Void {
		
		if (stage != null) {
			
			stage.__startDrag (this, lockCenter, bounds);
			
		}
		
	}
	
	
	public function stopDrag ():Void {
		
		if (stage != null) {
			
			stage.__stopDrag (this);
			
		}
		
	}
	
	
	private override function __getCursor ():Cursor {
		
		return (__buttonMode && useHandCursor) ? POINTER : null;
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (interactiveOnly && !mouseEnabled && !mouseChildren) return false;
		if (!hitObject.visible || __isMask) return __hitTestHitArea (x, y, shapeFlag, stack, interactiveOnly, hitObject);
		if (mask != null && !mask.__hitTestMask (x, y)) return __hitTestHitArea (x, y, shapeFlag, stack, interactiveOnly, hitObject);
		
		if (__scrollRect != null) {
			
			var point = Point.__pool.get ();
			point.setTo (x, y);
			__getRenderTransform ().__transformInversePoint (point);
			
			if (!__scrollRect.containsPoint (point)) {
				
				Point.__pool.release (point);
				return __hitTestHitArea (x, y, shapeFlag, stack, true, hitObject);
				
			}
			
			Point.__pool.release (point);
			
		}
		
		if (super.__hitTest (x, y, shapeFlag, stack, interactiveOnly, hitObject)) {
			
			return interactiveOnly;
			
		} else if (hitArea == null && __graphics != null && __graphics.__hitTest (x, y, shapeFlag, __getRenderTransform ())) {
			
			if (stack != null && (!interactiveOnly || mouseEnabled)) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return __hitTestHitArea (x, y, shapeFlag, stack, interactiveOnly, hitObject);
		
	}
	
	
	private function __hitTestHitArea (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (hitArea != null) {
			
			if (!hitArea.mouseEnabled) {
				
				hitArea.mouseEnabled = true;
				var hitTest = hitArea.__hitTest (x, y, shapeFlag, null, true, hitObject);
				hitArea.mouseEnabled = false;
				
				if (stack != null && hitTest) {
					
					stack[stack.length] = hitObject;
					
				}
				
				return hitTest;
				
			}
			
		} 
		
		return false;
		
	}
	
	
	private override function __hitTestMask (x:Float, y:Float):Bool {
		
		if (super.__hitTestMask (x, y)) {
			
			return true;
			
		} else if (__graphics != null && __graphics.__hitTest (x, y, true, __getRenderTransform ())) {
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_graphics ():Graphics {
		
		if (__graphics == null) {
			
			__graphics = new Graphics (this);
			
		}
		
		return __graphics;
		
	}
	
	
	private override function get_tabEnabled ():Bool {
		
		return (__tabEnabled == null ? __buttonMode : __tabEnabled);
		
	}
	
	
	private function get_buttonMode ():Bool {
		
		return __buttonMode;
		
	}
	
	
	private function set_buttonMode (value:Bool):Bool {
		
		return __buttonMode = value;
		
	}
	
	
}