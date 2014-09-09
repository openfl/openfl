package openfl.events; #if !flash


enum EventPhase {
	
	CAPTURING_PHASE;
	AT_TARGET;
	BUBBLING_PHASE;
	
}


#else
typedef EventPhase = flash.events.EventPhase;
#end