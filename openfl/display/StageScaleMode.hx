package openfl.display; #if (!display && !flash)


enum StageScaleMode {
	
	SHOW_ALL;
	NO_SCALE;
	NO_BORDER;
	EXACT_FIT;
	
}


#else


/**
 * The StageScaleMode class provides values for the
 * <code>Stage.scaleMode</code> property.
 */
@:fakeEnum(String) extern enum StageScaleMode {
	
	SHOW_ALL;
	NO_SCALE;
	NO_BORDER;
	EXACT_FIT;
	
}


#end