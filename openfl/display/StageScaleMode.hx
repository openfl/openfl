/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.display;
#if display


/**
 * The StageScaleMode class provides values for the
 * <code>Stage.scaleMode</code> property.
 */
@:fakeEnum(String) extern enum StageScaleMode {
	EXACT_FIT;
	NO_BORDER;
	NO_SCALE;
	SHOW_ALL;
}


#end
