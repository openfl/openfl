package openfl.display; #if !flash


/**
 * The StageScaleMode class provides values for the
 * <code>Stage.scaleMode</code> property.
 */
enum StageScaleMode {
	
	SHOW_ALL;
	NO_SCALE;
	NO_BORDER;
	EXACT_FIT;
	
}


#else
typedef StageScaleMode = flash.display.StageScaleMode;
#end