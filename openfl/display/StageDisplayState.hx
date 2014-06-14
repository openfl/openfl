package openfl.display; #if !flash


enum StageDisplayState {
	
	NORMAL;
	FULL_SCREEN;
	FULL_SCREEN_INTERACTIVE;
	
}


#else
typedef StageDisplayState = flash.display.StageDisplayState;
#end