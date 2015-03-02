package openfl.events; #if !flash #if !lime_legacy


import openfl.events.Event;


interface IEventDispatcher {

	public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	public function dispatchEvent (event:Event):Bool;
	public function hasEventListener (type:String):Bool;
	public function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void;
	public function willTrigger (type:String):Bool;
	
}


#else
typedef IEventDispatcher = openfl._v2.events.IEventDispatcher;
#end
#else
typedef IEventDispatcher = flash.events.IEventDispatcher;
#end