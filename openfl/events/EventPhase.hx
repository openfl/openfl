package openfl.events;


#if (haxe_ver > 3.100)

@:enum abstract EventPhase(Int) {
	
	var CAPTURING_PHASE = 0;
	var AT_TARGET = 1;
	var BUBBLING_PHASE = 2;
	
}

#else

enum EventPhase {
	
	CAPTURING_PHASE;
	AT_TARGET;
	BUBBLING_PHASE;
	
}

#end