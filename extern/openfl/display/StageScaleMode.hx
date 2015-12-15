package openfl.display;


/**
 * The StageScaleMode class provides values for the
 * <code>Stage.scaleMode</code> property.
 */

#if flash
@:native("flash.display.StageScaleMode")
#end


@:fakeEnum(String) extern enum StageScaleMode {
	
	SHOW_ALL;
	NO_SCALE;
	NO_BORDER;
	EXACT_FIT;
	
}