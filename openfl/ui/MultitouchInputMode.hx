package openfl.ui; #if !flash


enum MultitouchInputMode {
	
	NONE;
	TOUCH_POINT;
	GESTURE;
	
}


#else
typedef MultitouchInputMode = flash.ui.MultitouchInputMode;
#end