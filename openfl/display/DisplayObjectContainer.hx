package openfl.display;


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
import openfl.Vector;

@:access(openfl.events.Event)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)


class DisplayObjectContainer extends InteractiveObject {
	
	
	public var mouseChildren:Bool;
	public var numChildren (get, never):Int;
	public var tabChildren:Bool;
	
	private var __removedChildren:Array<DisplayObject>;
	
	
	private function new () {
		
		super ();
		
		mouseChildren = true;
		
		__children = new Array<DisplayObject> ();
		__removedChildren = new Array<DisplayObject> ();
		
	}
	
	
	public function addChild (child:DisplayObject):DisplayObject {
		
		return addChildAt (child, numChildren);
		
	}
	
	
	public function addChildAt (child:DisplayObject, index:Int):DisplayObject {
		
		if (index > __children.length || index < 0) {
			
			throw "Invalid index position " + index;
			
		}
		
		if (child.parent == this) {
			
			__children.remove (child);
			__children.insert (index, child);
			
		} else {
			
			if (child.parent != null) {
				
				child.parent.removeChild (child);
				
			}
			
			__children.insert (index, child);
			child.parent = this;
			
			var addedToStage = (stage != null && child.stage == null);
			
			if (addedToStage) {
				
				this.__setStageReference (stage);
				
			}
			
			child.__setTransformDirty ();
			child.__setRenderDirty ();
			__setRenderDirty();
			
			var event = new Event (Event.ADDED, true);
			event.target = child;
			child.__dispatchEvent (event);
			
			if (addedToStage) {
				
				child.__dispatchChildren (new Event (Event.ADDED_TO_STAGE, false, false));
				
			}
			
		}
		
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
			
			child.__setTransformDirty ();
			child.__setRenderDirty ();
			__setRenderDirty();
			
			child.__dispatchEvent (new Event (Event.REMOVED, true));
			
			if (stage != null) {
				
				if (child.stage != null && stage.focus == child) {
					
					stage.focus = null;
					
				}
				
				child.__dispatchChildren (new Event (Event.REMOVED_FROM_STAGE, false, false));
				child.__setStageReference (null);
				
			}
			
			child.parent = null;
			__children.remove (child);
			__removedChildren.push (child);
			child.__setTransformDirty ();
			
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
	
	
	public function stopAllMovieClips ():Void {
		
		__stopAllMovieClips ();
		
	}
	
	
	public function swapChildren (child1:DisplayObject, child2:DisplayObject):Void {
		
		if (child1.parent == this && child2.parent == this) {
			
			#if (haxe_ver > 3.1)
			
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
	
	
	private override function __dispatchChildren (event:Event):Bool {
		
		var success = __dispatchEvent (event);
		
		if (success) {
			
			for (child in __children) {
				
				event.target = child;
				
				if (!child.__dispatchChildren (event)) {
					
					return false;
					
				}
				
			}
			
		}
		
		return success;
		
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
		
		if (__scrollRect != null) {
			
			var point = Point.__temp;
			point.setTo (x, y);
			__getRenderTransform ().__transformInversePoint (point);
			
			if (!__scrollRect.containsPoint (point)) {
				
				return false;
				
			}
			
		}
		
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
	
	
	private override function __readGraphicsData (graphicsData:Vector<IGraphicsData>, recurse:Bool):Void {
		
		super.__readGraphicsData (graphicsData, recurse);
		
		if (recurse) {
			
			for (child in __children) {
				
				child.__readGraphicsData (graphicsData, recurse);
				
			}
			
		}
		
	}
	
	
	public override function __renderCairo (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		super.__renderCairo (renderSession);
		
		renderSession.maskManager.pushObject (this);
		
		for (child in __children) {
			
			child.__renderCairo (renderSession);
			
		}
		
		for (orphan in __removedChildren) {
			
			if (orphan.stage == null) {
				
				orphan.__cleanup ();
				
			}
			
		}
		
		if (__removedChildren.length > 0) {
			
			__removedChildren.splice (0, __removedChildren.length);
			
		}
		
		renderSession.maskManager.popObject (this);
		
	}
	
	
	public override function __renderCairoMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CairoGraphics.renderMask (__graphics, renderSession);
			
		}
		
		for (child in __children) {
			
			child.__renderCairoMask (renderSession);
			
		}
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		#if !neko
		
		super.__renderCanvas (renderSession);
		
		renderSession.maskManager.pushObject (this);
		
		for (child in __children) {
			
			child.__renderCanvas (renderSession);
			
		}
		
		for (orphan in __removedChildren) {
			
			if (orphan.stage == null) {
				
				orphan.__cleanup ();
				
			}
			
		}
		
		if (__removedChildren.length > 0) {
			
			__removedChildren.splice (0, __removedChildren.length);
			
		}
		
		renderSession.maskManager.popObject (this);
		
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
		
		super.__renderDOM (renderSession);
		
		renderSession.maskManager.pushObject (this);
		
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
		
		renderSession.maskManager.popObject (this);
		
		#end
		
	}
	
	
	public override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		super.__renderGL (renderSession);
		
		renderSession.maskManager.pushObject (this);
		
		for (child in __children) {
			
			child.__renderGL (renderSession);
			
		}
		
		for (orphan in __removedChildren) {
			
			if (orphan.stage == null) {
				
				orphan.__cleanup ();
				
			}
			
		}
		
		if (__removedChildren.length > 0) {
			
			__removedChildren.splice (0, __removedChildren.length);
			
		}
		
		renderSession.maskManager.popObject (this);
		
	}
	
	
	private override function __setStageReference (stage:Stage):Void {
		
		super.__setStageReference (stage);
		
		if (__children != null) {
			
			for (child in __children) {
				
				child.__setStageReference (stage);
				
			}
			
		}
		
	}


	private override function __stopAllMovieClips ():Void {
		
		for (child in __children) {
			
			child.__stopAllMovieClips ();
			
		}
		
	}
	
	
	public override function __update (transformOnly:Bool, updateChildren:Bool, ?maskGraphics:Graphics = null):Void {
		
		super.__update (transformOnly, updateChildren, maskGraphics);
		
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