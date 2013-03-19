package flash.events;
#if (flash || display)


extern class SystemEvent extends Event {

	var data(default, null) : Int;
	
	function new(type : String, bubbles : Bool = false, cancelable : Bool = false, data : Int = 0) : Void;

	static var SYSTEM : String;
}


#elseif (cpp || neko)
typedef SystemEvent = nme.events.SystemEvent;
#end
