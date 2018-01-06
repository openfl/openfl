package flash.events; #if (!display && flash)


extern class EventDispatcher implements IEventDispatcher {
	
	
	public function new (target:IEventDispatcher = null):Void;
	public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	public function dispatchEvent (event:Event):Bool;
	public function hasEventListener (type:String):Bool;
	public function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void;
	public function toString ():String;
	public function willTrigger (type:String):Bool;
	
	
}


#else
typedef EventDispatcher = openfl.events.EventDispatcher;
#end