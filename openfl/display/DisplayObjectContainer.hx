package openfl.display; #if !flash #if (display || next || js)


import openfl._internal.renderer.RenderSession;
import openfl.display.Stage;
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;


@:access(openfl.events.Event)
class DisplayObjectContainer extends InteractiveObject {
	
	
	public var mouseChildren:Bool;
	public var numChildren (get, null):Int;
	public var tabChildren:Bool;
	
	private var __children:Array<DisplayObject>;
	private var __removedChildren:Array<DisplayObject>;
	
	
	public function new () {
		
		super ();
		
		mouseChildren = true;
		
		__children = new Array<DisplayObject> ();
		__removedChildren = new Array<DisplayObject> ();
		
	}
	
	
	public function addChild (child:DisplayObject):DisplayObject {
		
		if (child != null) {
			
			if (child.parent != null) {
				
				child.parent.removeChild (child);
				
			}
			
			__children.push (child);
			child.parent = this;
			
			if (stage != null) {
				
				child.__setStageReference (stage);
				
			}
			
			child.__setTransformDirty ();
			child.__setRenderDirty ();
			child.dispatchEvent (new Event (Event.ADDED, true));
			
		}
		
		return child;
		
	}
	
	
	public function addChildAt (child:DisplayObject, index:Int):DisplayObject {
		
		if (index > __children.length || index < 0) {
			
			throw "Invalid index position " + index;
			
		}
		
		if (child.parent == this) {
			
			__children.remove (child);
			
		} else {
			
			if (child.parent != null) {
				
				child.parent.removeChild (child);
				
			}
			
			child.parent = this;
			
			if (stage != null) {
				
				child.__setStageReference (stage);
				
			}
			
			child.__setTransformDirty ();
			child.__setRenderDirty ();
			child.dispatchEvent (new Event (Event.ADDED, true));
			
		}
		
		__children.insert (index, child);
		
		return child;
		
	}
	
	
	public function areInaccessibleObjectsUnderPoint (point:Point):Bool {
		
		return false;
		
	}
	
	
	public function contains (child:DisplayObject):Bool {
		
		#if (haxe_ver > 3.100)
		
		return __children.indexOf (child) > -1;
		
		#else
		
		for (i in __children) {
			
			if (i == child) return true;
			
		}
		
		return false;
		
		#end
		
	}
	
	
	public function getChildAt (index:Int):DisplayObject {
		
		if (index >= 0 && index < __children.length) {
			
			return __children[index];
			
		}
		
		return null;
		
	}
	
	
	public function getChildByName (name:String):DisplayObject {
		
		for (child in __children) {
			
			if (child.name == name) return child;
			
		}
		
		return null;
		
	}
	
	
	public function getChildIndex (child:DisplayObject):Int {
		
		for (i in 0...__children.length) {
			
			if (__children[i] == child) return i;
			
		}
		
		return -1;
		
	}
	
	
	public function getObjectsUnderPoint (point:Point):Array<DisplayObject> {
		
		point = localToGlobal (point);
		var stack = new Array<DisplayObject> ();
		__hitTest (point.x, point.y, false, stack, false);
		stack.shift ();
		return stack;
		
	}
	
	
	public function removeChild (child:DisplayObject):DisplayObject {
		
		if (child != null && child.parent == this) {
			
			if (stage != null) {
				
				child.__setStageReference (null);
				
			}
			
			child.parent = null;
			__children.remove (child);
			__removedChildren.push (child);
			child.__setTransformDirty ();
			child.__setRenderDirty ();
			child.dispatchEvent (new Event (Event.REMOVED, true));
			
		}
		
		return child;
		
	}
	
	
	public function removeChildAt (index:Int):DisplayObject {
		
		if (index >= 0 && index < __children.length) {
			
			return removeChild (__children[index]);
			
		}
		
		return null;
		
	}
	
	
	public function removeChildren (beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void {
		
		if (endIndex == 0x7FFFFFFF) { 
			
			endIndex = __children.length - 1;
			
			if (endIndex < 0) {
				
				return;
				
			}
			
		}
		
		if (beginIndex > __children.length - 1) {
			
			return;
			
		} else if (endIndex < beginIndex || beginIndex < 0 || endIndex > __children.length) {
			
			throw new RangeError ("The supplied index is out of bounds.");
			
		}
		
		var numRemovals = endIndex - beginIndex;
		while (numRemovals >= 0) {
			
			removeChildAt (beginIndex);
			numRemovals--;
			
		}
		
	}
	
	
	public function setChildIndex (child:DisplayObject, index:Int) {
		
		if (index >= 0 && index <= __children.length && child.parent == this) {
			
			__children.remove (child);
			__children.insert (index, child);
			
		}
		
	}
	
	
	public function swapChildren (child1:DisplayObject, child2:DisplayObject):Void {
		
		if (child1.parent == this && child2.parent == this) {
			
			#if (haxe_ver > 3.100)
			
			var index1 = __children.indexOf (child1);
			var index2 = __children.indexOf (child2);
			
			#else
			
			var index1 = -1;
			var index2 = -1;
			
			for (i in 0...__children.length) {
				
				if (__children[i] == child1) {
					
					index1 = i;
					
				} else if (__children[i] == child2) {
					
					index2 = i;
					
				}
				
			}
			
			#end
			
			__children[index1] = child2;
			__children[index2] = child1;
			
		}
		
	}
	
	
	public function swapChildrenAt (child1:Int, child2:Int):Void {
		
		var swap:DisplayObject = __children[child1];
		__children[child1] = __children[child2];
		__children[child2] = swap;
		swap = null;
		
	}
	
	
	private override function __broadcast (event:Event, notifyChilden:Bool):Bool {
		
		if (event.target == null) {
			
			event.target = this;
			
		}
		
		if (notifyChilden) {
			
			for (child in __children) {
				
				child.__broadcast (event, true);
				
				if (event.__isCancelled) {
					
					return true;
					
				}
				
			}
			
		}
		
		return super.__broadcast (event, notifyChilden);
		
	}
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__children.length == 0) return;
		
		var matrixCache = null;
		
		if (matrix != null) {
			
			matrixCache = __worldTransform;
			__worldTransform = matrix;
			__updateChildren (true);
			
		}
		
		for (child in __children) {
			
			if (!child.__renderable) continue;
			child.__getBounds (rect, null);
			
		}
			
		if (matrix != null) {
			
			__worldTransform = matrixCache;
			__updateChildren (true);
			
		}
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (!visible || (interactiveOnly && !mouseEnabled)) return false;
		
		var i = __children.length;
		
		if (interactiveOnly && (stack == null || !mouseChildren)) {
			
			while (--i >= 0) {
				
				if (__children[i].__hitTest (x, y, shapeFlag, null, interactiveOnly)) {
					
					if (stack != null) {
						
						stack.push (this);
						
					}
					
					return true;
					
				}
				
			}
			
		} else if (stack != null) {
			
			var length = stack.length;
			
			while (--i >= 0) {
				
				if (__children[i].__hitTest (x, y, shapeFlag, stack, interactiveOnly)) {
					
					stack.insert (length, this);
					
					return true;
					
				}
				
			}
			
		}
		
		return false;
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (scrollRect != null) {
			
			//renderSession.maskManager.pushRect (scrollRect, __worldTransform);
			
		}
		
		if (__mask != null) {
			
			//renderSession.maskManager.pushMask (__mask);
			
		}
		
		for (child in __children) {
			
			child.__renderCanvas (renderSession);
			
		}
		
		__removedChildren = [];
		
		if (__mask != null) {
			
			//renderSession.maskManager.popMask ();
			
		}
		
		if (scrollRect != null) {
			
			//renderSession.maskManager.popMask ();
			
		}
		
	}
	
	
	public override function __renderDOM (renderSession:RenderSession):Void {
		
		//if (!__renderable) return;
		
		//if (__mask != null) {
			
			//renderSession.maskManager.pushMask (__mask);
			
		//}
		
		// TODO: scrollRect
		
		for (child in __children) {
			
			child.__renderDOM (renderSession);
			
		}
		
		for (orphan in __removedChildren) {
			
			if (orphan.stage == null) {
				
				orphan.__renderDOM (renderSession);
				
			}
			
		}
		
		__removedChildren = [];
		
		//if (__mask != null) {
			
			//renderSession.maskManager.popMask ();
			
		//}
		
	}
	
	
	public override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		for (child in __children) {
			
			child.__renderGL (renderSession);
			
		}
		
		__removedChildren = [];
		
	}
	
	
	public override function __renderMask (renderSession:RenderSession):Void {
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		renderSession.context.rect (0, 0, bounds.width, bounds.height);	
		
	}
	
	
	private override function __setStageReference (stage:Stage):Void {
		
		if (this.stage != stage) {
			
			if (this.stage != null) {
				
				dispatchEvent (new Event (Event.REMOVED_FROM_STAGE, false, false));
				
			}
			
			this.stage = stage;
			
			if (stage != null) {
				
				dispatchEvent (new Event (Event.ADDED_TO_STAGE, false, false));
				
			}
			
			for (child in __children) {
				
				child.__setStageReference (stage);
				
			}
			
		}
		
	}
	
	
	public override function __update (transformOnly:Bool, updateChildren:Bool):Void {
		
		super.__update (transformOnly, updateChildren);
		
		if (!__renderable #if dom && !__worldAlphaChanged && !__worldClipChanged && !__worldTransformChanged && !__worldVisibleChanged #end) {
			
			return;
			
		}
		
		//if (!__renderable) return;
		
		if (updateChildren) {
			
			for (child in __children) {
				
				child.__update (transformOnly, true);
				
			}
			
		}
		
	}
	
	
	public override function __updateChildren (transformOnly:Bool):Void {
		
		super.__updateChildren (transformOnly);
		
		for (child in __children) {
			
			child.__update (transformOnly, true);
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_numChildren ():Int {
		
		return __children.length;
		
	}
	
	
}


#else
typedef DisplayObjectContainer = openfl._v2.display.DisplayObjectContainer;
#end
#else
typedef DisplayObjectContainer = flash.display.DisplayObjectContainer;
#end