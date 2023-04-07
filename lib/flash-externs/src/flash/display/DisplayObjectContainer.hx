package flash.display;

#if flash
import openfl.geom.Point;

extern class DisplayObjectContainer extends InteractiveObject
{
	#if (haxe_ver < 4.3)
	public var mouseChildren:Bool;
	public var numChildren(default, never):Int;
	public var tabChildren:Bool;
	public var textSnapshot(default, never):flash.text.TextSnapshot;
	#else
	@:flash.property var mouseChildren(get, set):Bool;
	@:flash.property var numChildren(get, never):Int;
	@:flash.property var tabChildren(get, set):Bool;
	@:flash.property var textSnapshot(get, never):flash.text.TextSnapshot;
	#end

	private function new();
	public function addChild(child:DisplayObject):DisplayObject;
	public function addChildAt(child:DisplayObject, index:Int):DisplayObject;
	public function areInaccessibleObjectsUnderPoint(point:Point):Bool;
	public function contains(child:DisplayObject):Bool;
	public function getChildAt(index:Int):DisplayObject;
	public function getChildByName(name:String):DisplayObject;
	public function getChildIndex(child:DisplayObject):Int;
	public function getObjectsUnderPoint(point:Point):Array<DisplayObject>;
	public function removeChild(child:DisplayObject):DisplayObject;
	public function removeChildAt(index:Int):DisplayObject;
	@:require(flash11) public function removeChildren(beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void;
	public function setChildIndex(child:DisplayObject, index:Int):Void;
	@:require(flash11_8) public function stopAllMovieClips():Void;
	public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void;
	public function swapChildrenAt(index1:Int, index2:Int):Void;

	#if (haxe_ver >= 4.3)
	private function get_mouseChildren():Bool;
	private function get_numChildren():Int;
	private function get_tabChildren():Bool;
	private function get_textSnapshot():flash.text.TextSnapshot;
	private function set_mouseChildren(value:Bool):Bool;
	private function set_tabChildren(value:Bool):Bool;
	#end
}
#else
typedef DisplayObjectContainer = openfl.display.DisplayObjectContainer;
#end
