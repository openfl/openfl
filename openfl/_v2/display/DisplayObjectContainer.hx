package openfl._v2.display; #if lime_legacy


import openfl.errors.ArgumentError;
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.Lib;


class DisplayObjectContainer extends InteractiveObject {
	
	
	public var mouseChildren (get, set):Bool;
	public var numChildren (get, null):Int;
	public var tabChildren (get, set):Bool;
	
	@:noCompletion private var __children:Array<DisplayObject>;
	
	
	private function new (handle:Dynamic, type:String) {
		
		super (handle, type);
		__children = [];
		
	}
	
	
	public function addChild (child:DisplayObject):DisplayObject {
		
		__addChild (child);
		return child;
		
	}
	
	
	public function addChildAt (child:DisplayObject, index:Int):DisplayObject {
		
		__addChild (child);
		__setChildIndex (child, index);
		return child;
		
	}
	
	
	public function areInaccessibleObjectsUnderPoint (point:Point):Bool {
		
		return false;
		
	}
	
	
	public function contains (child:DisplayObject):Bool {
		
		return __contains (child);
		
	}
	
	
	public function getChildAt (index:Int):DisplayObject {
		
		if (index >= 0 && index < __children.length) {
			
			return __children[index];
			
		}
		
		throw new RangeError ("getChildAt : index out of bounds " + index + "/" + __children.length);
		return null;
		
	}
	
	
	public function getChildByName (name:String):DisplayObject {
		
		for (child in __children) {
			
			if (name == child.name) {
				
				return child;
				
			}
			
		}
		
		return null;
		
	}
	
	
	public function getChildIndex (child:DisplayObject):Int {
		
		return __getChildIndex (child);
		
	}
	
	
	public function getObjectsUnderPoint (point:Point):Array<DisplayObject> {
		
		// The backend currently requires objecfts to be on the stage to pass a hit test
		var onStage = (stage != null);
		var cacheVisible = visible;
		
		if (!onStage) {
			
			visible = false;
			Lib.stage.addChild (this);
			
		}
		
		var result = new Array<DisplayObject> ();
		__getObjectsUnderPoint (point, result);
		
		if (!onStage) {
			
			Lib.stage.removeChild (this);
			visible = cacheVisible;
			
		}
		
		return result;
		
	}
	
	
	public function removeChild (child:DisplayObject):DisplayObject {
		
		var index = __getChildIndex (child);
		
		if (index >= 0) {
			
			child.__setParent (null);
			return child;
			
		}
		
		return null;
		
	}
	
	
	public function removeChildAt (index:Int):DisplayObject {
		
		if (index >= 0 && index < __children.length) {
			
			var result = __children[index];
			result.__setParent (null);
			return result;
			
		}
		
		throw new ArgumentError ("The supplied DisplayObject must be a child of the caller.");
		
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
	
	
	public function setChildIndex (child:DisplayObject, index:Int):Void {
		
		__setChildIndex (child, index);
		
	}
	
	
	public function swapChildren (child1:DisplayObject, child2:DisplayObject):Void {
		
		var index1 = __getChildIndex (child1);
		var index2 = __getChildIndex (child2);
		
		if (index1 < 0 || index2 < 0) {
			
			throw "swapChildren:Could not find children";
			
		}
		
		__swapChildrenAt (index1, index2);
		
	}
	
	
	public function swapChildrenAt (index1:Int, index2:Int):Void {
		
		__swapChildrenAt (index1, index2);
		
	}
	
	
	@:noCompletion private inline function __addChild (child:DisplayObject):Void {
		
		if (child == this) {
			
			throw "Adding to self";
			
		}
		
		if (child.__parent == this) {
			
			setChildIndex (child, __children.length - 1);
			
		} else {
			
			child.__setParent (this);
			__children.push (child);
			lime_doc_add_child (__handle, child.__handle);
			
		}
		
	}
	
	
	@:noCompletion override public function __broadcast (event:Event):Void {
		
		var i = 0;
		
		if (__children.length > 0) {
			
			var child;
			
			while (true) {
				
				child = __children[i];
				child.__broadcast (event);
				
				if (i >= __children.length) {
					
					break;
					
				}
				
				if (__children[i] == child) {
					
					i++;
					
					if (i >= __children.length) {
						
						break;
						
					}
					
				}
				
			}
			
		}
		
		super.__broadcast (event);
		
	}
	
	
	@:noCompletion public override function __contains (child:DisplayObject):Bool {
		
		if (child == null) {
			
			return false;
			
		}
		
		if (this == child) {
			
			return true;
			
		}
		
		for (c in __children) {
			
			if (c == child || c.__contains (child)) {
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion override private function __findByID (id:Int):DisplayObject {
		
		if (__id == id) {
			
			return this;
			
		}
		
		var found;
		
		for (child in __children) {
			
			found = child.__findByID (id);
			
			if (found != null) {
				
				return found;
				
			}
			
		}
		
		return super.__findByID (id);
		
	}
	
	
	@:noCompletion private function __getChildIndex (child:DisplayObject):Int {
		
		for (i in 0...__children.length) {
			
			if (__children[i] == child) {
				
				return i;
				
			}
			
		}
		
		return -1;
		
	}
	
	
	@:noCompletion public override function __getObjectsUnderPoint (point:Point, result:Array<DisplayObject>):Void {
		
		super.__getObjectsUnderPoint (point, result);
		
		for (child in __children) {
			
			child.__getObjectsUnderPoint (point, result);
			
		}
		
	}
	
	
	@:noCompletion override private function __onAdded (object:DisplayObject, isOnStage:Bool):Void {
		
		super.__onAdded (object, isOnStage);
		
		for (child in __children) {
			
			child.__onAdded (object, isOnStage);
			
		}
		
	}
	
	
	@:noCompletion override private function __onRemoved (object:DisplayObject, wasOnStage:Bool):Void {
		
		super.__onRemoved (object, wasOnStage);
		
		for (child in __children) {
			
			child.__onRemoved (object, wasOnStage);
			
		}
		
	}
	
	
	@:noCompletion public function __removeChildFromArray (child:DisplayObject):Void {
		
		var i = __getChildIndex (child);
		
		if (i >= 0) {
			
			lime_doc_remove_child (__handle, i);
			__children.splice (i, 1);
			
		}
		
	}
	
	
	@:noCompletion private inline function __setChildIndex (child:DisplayObject, index:Int):Void {
		
		if (index > __children.length) {
			
			throw "Invalid index position " + index;
			
		}
		
		var firstIndex = __getChildIndex (child);
		
		if (firstIndex < 0) {
			
			var msg = "setChildIndex : object " + child.toString () + " not found.";
			
			if (child.__parent == this) {
				
				var actualIndex = -1;
				
				for (i in 0...__children.length) {
					
					if (__children[i] == child) {
						
						actualIndex = i;
						break;
						
					}
					
				}
				
				if (actualIndex != -1) {
					
					msg += "Internal error: Real child index was " + Std.string (actualIndex);
					
				} else {
					
					msg += "Internal error: Child was not in __children array!";
					
				}
				
			}
			
			throw msg;
			
		}
		
		lime_doc_set_child_index (__handle, child.__handle, index);
		
		if (index < firstIndex) {
			
			var i = firstIndex;
			
			while (i > index) {
				
				__children[i] = __children[i - 1];
				i--;
				
			}
			
			__children[index] = child;
			
		} else if (firstIndex < index) {
			
			var i = firstIndex;
			
			while (i < index) {
				
				__children[i] = __children[i + 1];
				i++;
				
			}
			
			__children[index] = child;
			
		}
		
	}
	
	
	@:noCompletion private inline function __swapChildrenAt (index1:Int, index2:Int):Void {
		
		if (index1 < 0 || index2 < 0 || index1 > __children.length || index2 > __children.length) {
			
			throw new RangeError ("swapChildrenAt : index out of bounds");
			
		}
		
		if (index1 != index2) {
			
			var temp = __children[index1];
			__children[index1] = __children[index2];
			__children[index2] = temp;
			lime_doc_swap_children (__handle, index1, index2);
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_mouseChildren ():Bool { return lime_doc_get_mouse_children (__handle); }
	private function set_mouseChildren (value:Bool):Bool {
		
		lime_doc_set_mouse_children (__handle, value);
		return value;
		
	}
	
	
	private function get_numChildren ():Int { return __children.length; }
	private function get_tabChildren () { return false; }
	private function set_tabChildren (value:Bool) { return false; }
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_create_display_object_container = Lib.load ("lime", "lime_create_display_object_container", 0);
	private static var lime_doc_add_child = Lib.load ("lime", "lime_doc_add_child", 2);
	private static var lime_doc_remove_child = Lib.load ("lime", "lime_doc_remove_child", 2);
	private static var lime_doc_set_child_index = Lib.load ("lime", "lime_doc_set_child_index", 3);
	private static var lime_doc_get_mouse_children = Lib.load ("lime", "lime_doc_get_mouse_children", 1);
	private static var lime_doc_set_mouse_children = Lib.load ("lime", "lime_doc_set_mouse_children", 2);
	private static var lime_doc_swap_children = Lib.load ("lime", "lime_doc_swap_children", 3);
	
	
}


#end