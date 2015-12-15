package openfl.events; #if !openfl_legacy


interface IEventDispatcher {
	
	public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	public function dispatchEvent (event:Event):Bool;
	public function hasEventListener (type:String):Bool;
	public function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void;
	public function willTrigger (type:String):Bool;
	
}


#else
typedef IEventDispatcher = openfl._legacy.events.IEventDispatcher;
#end