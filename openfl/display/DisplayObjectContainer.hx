package openfl.display; #if !openfl_legacy


import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.cairo.CairoRenderer;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.RenderSession;
import openfl.display.Stage;
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.events.Event)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Rectangle)


class DisplayObjectContainer extends InteractiveObject {
	
	
	public var mouseChildren:Bool;
	public var numChildren (get, null):Int;
	public var tabChildren:Bool;
	
	private var __removedChildren:Array<DisplayObject>;
	
	
	private function new () {
		
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
				
				// TODO: Dispatch ADDED_TO_STAGE after ADDED (but parent and stage must be set)
				
				child.__setStageReference (stage);
				
			}
			
			child.__setTransformDirty ();
			child.__setRenderDirty ();
			__setRenderDirty();
			
			var event = new Event (Event.ADDED, true);
			event.target = child;
			child.__dispatchEvent (event);
			
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
				
				// TODO: Dispatch ADDED_TO_STAGE after ADDED (but parent and stage must be set)
				
				child.__setStageReference (stage);
				
			}
			
			child.__setTransformDirty ();
			child.__setRenderDirty ();
			__setRenderDirty();
			
			var event = new Event (Event.ADDED, true);
			event.target = child;
			child.__dispatchEvent (event);
			
		}
		
		__children.insert (index, child);
		
		return child;
		
	}
	
	
	public function areInaccessibleObjectsUnderPoint (point:Point):Bool {
		
		return false;
		
	}
	
	
	public function contains (child:DisplayObject):Bool {
		
		while (child != this && child != null) {
			
			child = child.parent;
			
		}
		
		return child == this;
		
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
		
		var stack = new Array<DisplayObject> ();
		__hitTest (point.x, point.y, false, stack, false, this);
		stack.reverse ();
		return stack;
		
	}
	
	
	public function removeChild (child:DisplayObject):DisplayObject {
		
		if (child != null && child.parent == this) {
			
			child.__dispatchEvent (new Event (Event.REMOVED, true));
			
			if (stage != null) {
				
				child.__setStageReference (null);
				
			}
			
			child.parent = null;
			__children.remove (child);
			__removedChildren.push (child);
			child.__setTransformDirty ();
			child.__setRenderDirty ();
			__setRenderDirty();
			
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
	
	
	private function resolve (fieldName:String):DisplayObject {
		
		if (__children == null) return null;
		
		for (child in __children) {
			
			if (child.name == fieldName) {
				
				return child;
				
			}
			
		}
		
		return null;
		
	}
	
	
	public function setChildIndex (child:DisplayObject, index:Int):Void {
		
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
	
	
	public function swapChildrenAt (index1:Int, index2:Int):Void {
		
		var swap:DisplayObject = __children[index1];
		__children[index1] = __children[index2];
		__children[index2] = swap;
		swap = null;
		
	}
	
	
	private override function __broadcast (event:Event, notifyChilden:Bool):Bool {
		
		if (event.target == null) {
			
			event.target = this;
			
		}
		
		var result = super.__broadcast (event, notifyChilden);
		
		if (!event.__isCanceled && notifyChilden) {
			
			for (child in __children) {
				
				child.__broadcast (event, true);
				
				if (event.__isCanceled) {
					
					return true;
					
				}
				
			}
			
		}
		
		return result;
		
	}
	
	
	private override function __enterFrame (deltaTime:Int):Void {
		
		for (child in __children) {
			
			child.__enterFrame (deltaTime);
			
		}
		
	}
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		super.__getBounds (rect, matrix);
		
		if (__children.length == 0) return;
		
		if (matrix != null) {
			
			__updateTransforms (matrix);
			__updateChildren (true);
			
		}
		
		for (child in __children) {
			
			if (child.scaleX == 0 || child.scaleY == 0) continue;
			child.__getBounds (rect, child.__worldTransform);
			
		}
		
		if (matrix != null) {
			
			__updateTransforms ();
			__updateChildren (true);
			
		}
		
	}
	
	
	private override function __getRenderBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__scrollRect != null) {
			
			super.__getRenderBounds (rect, matrix);
			return;
			
		} else {
			
			super.__getBounds (rect, matrix);
			
		}
		
		if (__children.length == 0) return;
		
		if (matrix != null) {
			
			__updateTransforms (matrix);
			__updateChildren (true);
			
		}
		
		for (child in __children) {
			
			if (child.scaleX == 0 || child.scaleY == 0 || child.__isMask) continue;
			child.__getRenderBounds (rect, child.__worldTransform);
			
		}
		
		if (matrix != null) {
			
			__updateTransforms ();
			__updateChildren (true);
			
		}
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled && !mouseChildren)) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		if (scrollRect != null && !scrollRect.containsPoint (globalToLocal (new Point (x, y)))) return false;
		
		var i = __children.length;
		if (interactiveOnly) {
			
			if (stack == null || !mouseChildren) {
				
				while (--i >= 0) {
					
					if (__children[i].__hitTest (x, y, shapeFlag, null, true, cast __children[i])) {
						
						if (stack != null) {
							
							stack.push (hitObject);
							
						}
						
						return true;
						
					}
					
				}
				
			} else if (stack != null) {
				
				var length = stack.length;
				
				var interactive = false;
				var hitTest = false;
				
				while (--i >= 0) {
					
					interactive = __children[i].__getInteractive (null);
					
					if (interactive || (mouseEnabled && !hitTest)) {
						
						if (__children[i].__hitTest (x, y, shapeFlag, stack, true, cast __children[i])) {
							
							hitTest = true;
							
							if (interactive) {
								
								break;
								
							}
							
						}
						
					}
					
				}
				
				if (hitTest) {
					
					stack.insert (length, hitObject);
					return true;
					
				}
				
			}
			
		} else {
			
			while (--i >= 0) {
				
				__children[i].__hitTest (x, y, shapeFlag, stack, false, cast __children[i]);
				
			}
			
		}
		
		return false;
		
	}
	
	
	private override function __hitTestMask (x:Float, y:Float):Bool {
		
		var i = __children.length;
		
		while (--i >= 0) {
			
			if (__children[i].__hitTestMask (x, y)) {
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	public override function __renderCairo (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		super.__renderCairo (renderSession);
		
		if (scrollRect != null) {
			
			renderSession.maskManager.pushRect (scrollRect, __worldTransform);
			
		}
		
		if (__mask != null) {
			
			renderSession.maskManager.pushMask (__mask);
			
		}
		
		for (child in __children) {
			
			child.__renderCairo (renderSession);
			
		}
		
		if (__removedChildren.length > 0) {
			
			__removedChildren.splice (0, __removedChildren.length);
			
		}
		
		if (__mask != null) {
			
			renderSession.maskManager.popMask ();
			
		}
		
		if (scrollRect != null) {
			
			renderSession.maskManager.popRect ();
			
		}
		
	}
	
	
	public override function __renderCairoMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CairoGraphics.renderMask (__graphics, renderSession);
			
		}
		
		//var bounds = new Rectangle ();
		//__getLocalBounds (bounds);
		//
		//renderSession.cairo.rectangle (0, 0, bounds.width, bounds.height);
		
		for (child in __children) {
			
			child.__renderCairoMask (renderSession);
			
		}
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		#if !neko
		
		super.__renderCanvas (renderSession);
		
		if (scrollRect != null) {
			
			renderSession.maskManager.pushRect (scrollRect, __worldTransform);
			
		}
		
		if (__mask != null) {
			
			renderSession.maskManager.pushMask (__mask);
			
		}
		
		for (child in __children) {
			
			child.__renderCanvas (renderSession);
			
		}
		
		if (__removedChildren.length > 0) {
			
			__removedChildren.splice (0, __removedChildren.length);
			
		}
		
		if (__mask != null) {
			
			renderSession.maskManager.popMask ();
			
		}
		
		if (scrollRect != null) {
			
			renderSession.maskManager.popRect ();
			
		}
		
		#end
		
	}
	
	
	public override function __renderCanvasMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CanvasGraphics.renderMask (__graphics, renderSession);
			
		}
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		renderSession.context.rect (0, 0, bounds.width, bounds.height);
		
		/*for (child in __children) {
			
			child.__renderMask (renderSession);
			
		}*/
		
	}
	
	
	public override function __renderDOM (renderSession:RenderSession):Void {
		
		#if !neko
		
		//if (!__renderable) return;
		
		super.__renderDOM (renderSession);
		
		if (__mask != null) {
			
			renderSession.maskManager.pushMask (__mask);
			
		}
		
		// TODO: scrollRect
		
		for (child in __children) {
			
			child.__renderDOM (renderSession);
			
		}
		
		for (orphan in __removedChildren) {
			
			if (orphan.stage == null) {
				
				orphan.__renderDOM (renderSession);
				
			}
			
		}
		
		if (__removedChildren.length > 0) {
			
			__removedChildren.splice (0, __removedChildren.length);
			
		}
		
		if (__mask != null) {
			
			renderSession.maskManager.popMask ();
			
		}
		
		#end
		
	}
	
	
	public override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (__cacheAsBitmap) {
			__cacheGL(renderSession);
			return;
		}
		
		__preRenderGL (renderSession);
		__drawGraphicsGL (renderSession);
		
		for (child in __children) {
			
			child.__renderGL (renderSession);
			
		}
		
		__postRenderGL (renderSession);
		
		if (__removedChildren.length > 0) {
			
			__removedChildren.splice (0, __removedChildren.length);
			
		}
		
	}
	
	
	private override function __setStageReference (stage:Stage):Void {
		
		if (this.stage != stage) {
			
			if (this.stage != null) {
				
				__dispatchEvent (new Event (Event.REMOVED_FROM_STAGE, false, false));
				
			}
			
			this.stage = stage;
			
			if (stage != null) {
				
				__dispatchEvent (new Event (Event.ADDED_TO_STAGE, false, false));
				
			}
			
			if (__children != null) {
				
				for (child in __children) {
					
					child.__setStageReference (stage);
					
				}
				
			}
			
		}
		
	}
	
	
	public override function __update (transformOnly:Bool, updateChildren:Bool, ?maskGraphics:Graphics = null):Void {
		
		super.__update (transformOnly, updateChildren, maskGraphics);
		
		// nested objects into a mask are non renderables but are part of the mask
		if (!__renderable && !__isMask #if dom && !__worldAlphaChanged && !__worldClipChanged && !__worldTransformChanged && !__worldVisibleChanged #end) {
			
			return;
			
		}
		
		//if (!__renderable) return;
		
		if (updateChildren) {
			
			for (child in __children) {
				
				child.__update (transformOnly, true, maskGraphics);
				
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
typedef DisplayObjectContainer = openfl._legacy.display.DisplayObjectContainer;
#end