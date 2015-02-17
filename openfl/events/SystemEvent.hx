package openfl.events;
#if display


import openfl.events.Event;


extern class SystemEvent extends Event {

	var data(default, null) : Int;
	
	function new(type : String, bubbles : Bool = false, cancelable : Bool = false, data : Int = 0) : Void;

	static var SYSTEM : String;
}


#elseif lime_legacy
typedef SystemEvent = openfl._v2.events.SystemEvent;
#end