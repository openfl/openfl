package openfl._v2.events; #if lime_legacy


interface IEventDispatcher {
	
	
	public function addEventListener (type:String, listener:Function, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	public function dispatchEvent (event:Event):Bool;
	public function hasEventListener (type:String):Bool;
	public function removeEventListener (type:String, listener:Function, useCapture:Bool = false):Void;
	public function willTrigger (type:String):Bool;
	
	
}

typedef Function = Dynamic -> Void;


#end